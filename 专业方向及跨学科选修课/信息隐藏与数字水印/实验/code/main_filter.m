%%
clear;
clc;
close all;

%%
watermark_img = imread('seu_60_60.png');
watermark_img = rgb2gray(watermark_img);
watermark_img = im2bw(watermark_img);
[rm, cm] = size(watermark_img);

%%
cover_image = imread('lena_640_480.bmp');
cover_image = im2gray(cover_image);

%%
before = blkproc(cover_image, [8 8], 'dct2');

%% 不同 alpha
filter_l = [0.1, 0.2, 0.3, 0.5, 0.75, 1, 1.5, 2];

for kkkk = [1:8]
    alpha = 30;

    I = watermark_img;
    k1 = randn(1, 8);
    k2 = randn(1, 8);
    after = before;

    for i = 1:rm

        for j = 1:cm
            x = (i - 1) * 8;
            y = (j - 1) * 8;

            if watermark_img(i, j) == 1
                k = k1;
            else
                k = k2;
            end

            after(x + 1, y + 8) = before(x + 1, y + 8) + alpha * k(1);
            after(x + 2, y + 7) = before(x + 2, y + 7) + alpha * k(2);
            after(x + 3, y + 6) = before(x + 3, y + 6) + alpha * k(3);
            after(x + 4, y + 5) = before(x + 4, y + 5) + alpha * k(4);
            after(x + 5, y + 4) = before(x + 5, y + 4) + alpha * k(5);
            after(x + 6, y + 3) = before(x + 6, y + 3) + alpha * k(6);
            after(x + 7, y + 2) = before(x + 7, y + 2) + alpha * k(7);
            after(x + 8, y + 1) = before(x + 8, y + 1) + alpha * k(8);
        end

    end

    result = blkproc(after, [8 8], 'idct2');
    result = uint8(result);

    result_2=result;
    H=fspecial('gaussian',[4,4],filter_l(kkkk)); 
    result_2=imfilter(result_2,H);
    withmark=result_2;

    after_2 = blkproc(withmark, [8, 8], 'dct2');
    p = zeros(1, 8);
    mark_2 = zeros(rm, cm);

    for i = 1:rm

        for j = 1:cm
            x = (i - 1) * 8; y = (j - 1) * 8;
            p(1) = after_2(x + 1, y + 8);
            p(2) = after_2(x + 2, y + 7);
            p(3) = after_2(x + 3, y + 6);
            p(4) = after_2(x + 4, y + 5);
            p(5) = after_2(x + 5, y + 4);
            p(6) = after_2(x + 6, y + 3);
            p(7) = after_2(x + 7, y + 2);
            p(8) = after_2(x + 8, y + 1);

            if corr2(p, k1) > corr2(p, k2)
                mark_2(i, j) = 1;
            else
                mark_2(i, j) = 0;
            end

        end

    end

    mark_2 = uint8(mark_2);
    NC(1, kkkk) = correlation(mark_2, watermark_img);
    %PSNR(1, kkkk) = psnr(mark_2, uint8(watermark_img));
end

%%
plot(filter_l, NC, '-*b');
xlabel('\sigma')
ylabel('NC')
title('NC 随低通滤波标准差变化曲线')

%%
%plot(filter_l, PSNR, '-*b');
%xlabel('\sigma')
%ylabel('PSNR')
%title('PSNR 随低通滤波标准差变化曲线')
