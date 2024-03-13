clc;clear;close all;
%BPSK 
M_bpsk=2;
k_2psk=log2(M_bpsk);
n=30000;
rng default
dataIn = randi([0 1],n,1); % ����0��1֮������������һ��n*1������
dataInMatrix_BPSK = reshape(dataIn,length(dataIn)/1,1);
dataSymbolsIn_BPSK = bi2de(dataInMatrix_BPSK);%��ÿ��ת��Ϊʮ������
dataMod_BPSK = pskmod(dataSymbolsIn_BPSK,M_bpsk);
fprintf('\n This is BPSK experiment.\n ')
for snr=0:30
    receivedSignal_BPSK = awgn(dataMod_BPSK,snr,'measured');  
    dataSymbolsOut_BPSK = pskdemod(receivedSignal_BPSK,M_bpsk);
    dataOutMatrix_BPSK = de2bi(dataSymbolsOut_BPSK,k_2psk);
    dataOut_BPSK = dataOutMatrix_BPSK(:); % Return data in column vector
    [numErrors,ber] = biterr(dataIn,dataOut_BPSK);
    fprintf('\n The SNR is %d dB.\n ',snr)
    fprintf('\nThe binary coding bit error rate is %5.2e, based on %d errors.\n', ...
    ber,numErrors)
end
%QAM
for i=2:6
M = 2^i;%����˳��(�ź���������)
k = log2(M);%ÿ���ŵı���λ��
n = 30000;%����ı�������
sps = 1;%ÿ�����ŵ�������(����������)
rng default;%ÿ�ζ�������ͬ�������
dataIn = randi([0 1],n,1); % ����0��1֮������������һ��n*1������
dataInMatrix = reshape(dataIn,length(dataIn)/k,k);
% ����dataIn��ʹ��ÿ��ֻ��4��
dataSymbolsIn = bi2de(dataInMatrix);%��ÿ��ת��Ϊʮ������
dataMod = qammod(dataSymbolsIn,M); 
fprintf('\n This is %d-QAM experiment.\n ',M)
for snr=0:30
    %snr = Ebno+10*log10(k)-10*log10(sps);
    receivedSignal = awgn(dataMod,snr,'measured');
    sPlotFig = scatterplot(receivedSignal,1,0,'g.');
    hold on
scatterplot(dataMod,1,0,'k*',sPlotFig)
dataSymbolsOut = qamdemod(receivedSignal,M);
dataOutMatrix = de2bi(dataSymbolsOut,k);
dataOut = dataOutMatrix(:); % Return data in column vector
[numErrors,ber] = biterr(dataIn,dataOut);
%�ú����Ƚ��������ݣ������ز�ͬ�ĸ����Լ�ռ��
fprintf('\n The SNR is %d dB.\n ',snr)
fprintf('\nThe binary coding bit error rate is %5.2e, based on %d errors.\n', ...
    ber,numErrors)
end
end