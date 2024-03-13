%% ��ʼ��
clc;
clear;
close all;

%% ��Ҫ�޸ĵĵط�
M2 = [];
M4 = [];
M16 = [1:38];
M64 = [39:52];
SNR = 20; %���������
N_frm = 1000; % ÿ��������µķ���֡��

%% �����ŵ�
% Definitions of Channel Delay
Channel_Tau = [0 100 200 300 500 700]; % ns
Channel_Gain = [0 -3.6 -7.2 -10.8 -18 -25.2]; % dB
Channel_Tau = Channel_Tau * 1e-9; % second
Sampling_Rate = 20 * 1e6; % Points/second. Definition of your simulation sampling rate
Sample_Length = 1 / Sampling_Rate; % second. Get the sample duration in the simulation.
Channel_Tau_Index = round (Channel_Tau / Sample_Length) + 1; % Get discrete Index, from 1st. You should get the index of 1,7,15,23,36,51 with this model

% Definitions and calculations of distance and wavelength
Moving_Speed = 5; % km/h
Moving_Speed = Moving_Speed * 1000/3600; % m/s
TDD_Interval = 1e-3; % second. Alice and Bob mutually transmit message with a time interval
Moving_Distance = Moving_Speed * TDD_Interval; % m. The position change of Alice when Bob send back the signal
Carrier_Frequency = 2400 * 1e6; % Hz
Transmission_Speed = 3 * 1e8; % m/s
Wavelength = Transmission_Speed / Carrier_Frequency; % meter
Nearby_Distance = 0.12; % meter. The distance of Eavesdropper (Eve) and Bob
Channel_Seed = 1; % Fix the randomness of phase at each multi-path for Alice and Bob. (They should have very similar phase at each multi-path, NOT random phase at each multi-path. You can choose a number. Then you can change the number and observe the result changes)

rng(Channel_Seed, 'twister');

for n = 1:512
    Channel_CIR(n) = 0i;
end

for n = 1:6
    phi(n) = 2 * pi * ((Channel_Tau(n) * Transmission_Speed) / Wavelength + 2 * (rand - 0.5));
    c(n) = 10^(Channel_Gain(n) / 10) * exp(-1i * phi(n)); % Must retain complex value
    Channel_CIR(Channel_Tau_Index(n)) = c(n);
end

%% ��������

N_sc = 52; %ϵͳ���ز�����������ֱ���ز�����number of subcarrier
N_fft = 64; % FFT ����
N_cp = 16; % ѭ��ǰ׺���ȡ�Cyclic prefix
N_symbo = N_fft + N_cp; % 1������OFDM���ų���
N_c = 53; % ����ֱ���ز����ܵ����ز�����number of carriers
P_f_inter = 6; %��Ƶ���
data_station = []; %��Ƶλ��
L = 7; %�����Լ������
tblen = 6 * L; %Viterbi�������������
stage = 3; % m���еĽ���
ptap1 = [1 3]; % m���еļĴ������ӷ�ʽ
regi1 = [1 1 1]; % m���еļĴ�����ʼֵ
L = [1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 0 1 -1 -1 1 1 -1 1 -1 1 -1 -1 -1 -1 -1 1 1 -1 -1 1 -1 1 -1 1 1 1 1];
Nd = length(M2) + (length(M4)*2) + (length(M16)*4) + (length(M64)*6); % ÿ֡������OFDM������

%% �����������ݲ���
P_data = randi([0 1], 1, N_sc * Nd * N_frm);

%% ����
code_data = reshape(P_data, (length(M2) + (length(M4)*2) + (length(M16)*4) + (length(M64)*6)), []);

cnt = 1;

for e = M2
    M = 2;
    data_temp1 = reshape(code_data(cnt, :), log2(M), [])'; %��ÿ��2���ؽ��з��飬M=4
    cnt = cnt + 1;
    data_temp2 = bi2de(data_temp1); %������ת��Ϊʮ����
    modu_data(e, :) = pskmod(data_temp2, M, pi / M); % 4PSK����
    %modu_data(e,:)=qammod(data_temp2,M);
end

for e = M4
    M = 4;
    data_temp1 = reshape(reshape(code_data(cnt:cnt + 1, :)', [], 1), log2(M), [])';
    cnt = cnt + 2;
    data_temp2 = bi2de(data_temp1); %������ת��Ϊʮ����
    modu_data(e, :) = pskmod(data_temp2, M, pi / M); % 4PSK����
    %modu_data(e,:)=qammod(data_temp2,M);
end

for e = M16
    M = 16;
    data_temp1 = reshape(reshape(code_data(cnt:cnt + 3, :)', [], 1), log2(M), [])';
    cnt = cnt + 4;
    data_temp2 = bi2de(data_temp1); %������ת��Ϊʮ����
    modu_data(e, :) = qammod(data_temp2, M); % 4PSK����
    %modu_data(e,:)=qammod(data_temp2,M);
end

for e = M64
    M = 64;
    data_temp1 = reshape(reshape(code_data(cnt:cnt + 5, :)', [], 1), log2(M), [])';
    cnt = cnt + 6;
    data_temp2 = bi2de(data_temp1); %������ת��Ϊʮ����
    modu_data(e, :) = qammod(data_temp2, M); % 4PSK����
    %modu_data(e,:)=qammod(data_temp2,M);
end

%% ��Ƶ
code = mseq(stage, ptap1, regi1, N_sc); % ��Ƶ�������
code = code * 2 - 1; %��1��0�任Ϊ1��-1

spread_data = spread(modu_data, code); % ��Ƶ
spread_data = reshape(spread_data, [], 1);

%% ���뵼Ƶ
P_f = 3 + 3 * 1i; %Pilot frequency
P_f_station = [1:P_f_inter:N_fft]; %��Ƶλ��
pilot_num = length(P_f_station); %��Ƶ����

for img = 1:N_fft %����λ��

    if mod(img, P_f_inter) ~= 1 %mod(a,b)���������a����b������
        data_station = [data_station, img];
    end

end

data_row = length(data_station);
data_col = ceil(length(spread_data) / data_row);

pilot_seq = ones(pilot_num, data_col) * P_f; %����Ƶ�������
data = zeros(N_fft, data_col); %Ԥ����������
data(P_f_station(1:end), :) = pilot_seq; %��pilot_seq����ȡ

if data_row * data_col > length(spread_data)
    data2 = [spread_data; zeros(data_row * data_col - length(spread_data), 1)]; %�����ݾ����룬��0������Ƶ~
end

%% ����ת��
data_seq = reshape(data2, data_row, data_col);
data(data_station(1:end), :) = data_seq; %����Ƶ�����ݺϲ�

%% IFFT
ifft_data = ifft(data);

%% ���뱣�������ѭ��ǰ׺
Tx_cd = [ifft_data(N_fft - N_cp + 1:end, :); ifft_data];

%% ����ת��
Tx_data = reshape(Tx_cd, [], 1);

Tx_data = [L'; L'; L'; L'; L'; L'; L'; L'; L'; L'; Tx_data];

%% �ŵ�
Ber = zeros(1, length(SNR));
Ber2 = zeros(1, length(SNR));

for jj = 1:length(SNR)
    Tx_data_mul = filter(Channel_CIR, 1, Tx_data);
    rx_channel = awgn(Tx_data_mul, SNR(jj), 'measured'); %��Ӹ�˹������

    rx_channel = rx_channel(531:end, 1);

    %% ����ת��
    Rx_data1 = reshape(rx_channel, N_fft + N_cp, []);

    %% ȥ�����������ѭ��ǰ׺
    Rx_data2 = Rx_data1(N_cp + 1:end, :);

    %% FFT
    fft_data = fft(Rx_data2);

    %% �ŵ��������ֵ�����⣩
    data3 = fft_data(1:N_fft, :);
    Rx_pilot = data3(P_f_station(1:end), :); %���յ��ĵ�Ƶ
    h = Rx_pilot ./ pilot_seq;
    H = interp1(P_f_station(1:end)', h, data_station(1:end)', 'linear', 'extrap');

    %% �ŵ�У��
    data_aftereq = data3(data_station(1:end), :) ./ H;
    %% ����ת��
    data_aftereq = reshape(data_aftereq, [], 1);
    data_aftereq = data_aftereq(1:length(spread_data));
    data_aftereq = reshape(data_aftereq, N_sc, length(data_aftereq) / N_sc);

    %% ����
    demspread_data = despread(data_aftereq, code);

    %% ���
    prod = N_sc * Nd * N_frm / (length(M2) + (length(M4)*2) + (length(M16)*4) + (length(M64)*6));
    De_Bit = [];

    cnt = 1;

    for e = M2
        M = 2;
        demodulation_data = pskdemod(demspread_data(e, :), M, pi / M);
        De_data1 = reshape(demodulation_data, [], 1);
        De_data2 = de2bi(De_data1, log2(M));
        tmp = reshape(De_data2', 1, []);
        De_Bit(cnt, :) = reshape(tmp, prod, [])';
        cnt = cnt + 1;
    end

    for e = M4
        M = 4;
        demodulation_data = pskdemod(demspread_data(e, :), M, pi / M);
        De_data1 = reshape(demodulation_data, [], 1);
        De_data2 = de2bi(De_data1, log2(M));
        tmp = reshape(De_data2', 1, []);
        De_Bit(cnt:cnt + 1, :) = reshape(tmp, prod, [])';
        cnt = cnt + 2;
    end

    for e = M16
        M = 16;
        demodulation_data = qamdemod(demspread_data(e, :), M);
        De_data1 = reshape(demodulation_data, [], 1);
        De_data2 = de2bi(De_data1, log2(M));
        tmp = reshape(De_data2', 1, []);
        De_Bit(cnt:cnt + 3, :) = reshape(tmp, prod, [])';
        cnt = cnt + 4;
    end
    
    for e = M64
        M = 64;
        demodulation_data = qamdemod(demspread_data(e, :), M);
        De_data1 = reshape(demodulation_data, [], 1);
        De_data2 = de2bi(De_data1, log2(M));
        tmp = reshape(De_data2', 1, []);
        De_Bit(cnt:cnt + 5, :) = reshape(tmp, prod, [])';
        cnt = cnt + 6;
    end

    De_Bit = reshape(De_Bit, 1, []);

    %% ����������
    [err, Ber2(jj)] = biterr(De_Bit, P_data); %������������

end

%figure(1);
%semilogy(SNR, Ber2, 'b-s');
%hold on;
%xlabel('SNR');
%ylabel('BER');
%title('�����������');

for i=1:length(SNR)
   fprintf('\nSNR: %d dB   BER = %5.2e\n',SNR(i),Ber2(i));
end
