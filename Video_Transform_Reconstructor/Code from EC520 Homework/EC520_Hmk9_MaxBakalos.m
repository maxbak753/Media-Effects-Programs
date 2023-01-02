% EC520 Homework Assignment #9
% Max Bakalos
% 4/12/2022
% MAIN MODULE

tic % timer start

%-------------------------------------------------------------------------
%    PROBELM 1 - DCT and DWT Basis Restriction Error
%-------------------------------------------------------------------------

% (a) DCT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Read Image
barb = double(imread('barbara.tif'));   % 0 - 255 (original)
range_barb = 255;
barb_n = barb / range_barb;       % 0 to 1 (n = normalized) (u[k,l])
height = size(barb,1);          % # of rows in image
width = size(barb,2);           % # of columns in image

% i) Apply 2-D DCT (dct2) to the complete image (not block-by-block) ~ ~ ~
barb_dct = dct2(barb);
%imshow(idct2(barb_dct), [0,255])

% iv) & v)
% iv -  compute the mean-squared error (MSE) between 
%       the original & approximate images
%    -  Also, express the MSE as PSNR (defined for pixel values 0-255)
% v  -  Perform steps (ii-iv) for p = 10, 20, ..., 90%

%figure()

% values to calculate
barb_aprx_p_DCT = zeros(height,width,9);    % approximate images
barb_dct_p = zeros(height,width,9); % DCTs for approximate images
barb_MSE_dct = zeros(1,9);          % MSEs between approximates & original
barb_PSNR_dct = zeros(1,9);         % PSNRs between approximates & original

% calculate above values
for p = 0.1:0.1:0.9
    p_ind = round(p*10);    % p index
    % calculate approximate image
    [barb_aprx_p_DCT(:,:,p_ind), barb_dct_p(:,:,p_ind)] = Discrete_Cosine_Tranform('barbara.tif', p);
    % calculate error
    barb_MSE_dct(1,p_ind) = immse(barb, barb_aprx_p_DCT(:,:,p_ind));
    barb_PSNR_dct(1,p_ind) = 10 * log10( (255^2) / barb_MSE_dct(1,p_ind) );
    %{
    % plot
    subplot(3,3,p_ind)
    imshow(barb_aprx_p_DCT(:,:,p_ind), [0,255])
    %}
end


% (b) DWT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%{
i. Apply 2-D, two-level “Haar” DWT (dwt2) to the image using the so-called
periodization mode “per” (to handle the filters’ boundary conditions). A two-
level DWT means that after you have computed the four half-sized images (LL,
HL, LH, HH), you apply the same procedure to the LL image 
%}

% iv) & v)
% iv -  compute the mean-squared error (MSE) between 
%       the original & approximate images
%    -  Also, express the MSE as PSNR (defined for pixel values 0-255)
% v  -  Perform steps (ii-iv) for p = 10, 20, ..., 90%

%figure()

% values to calculate
barb_aprx_p_DWT = zeros(height,width,9);    % approximate images
barb_dwt_p = zeros(height,width,9); % DWTs for approximate images
barb_MSE_dwt = zeros(1,9);          % MSEs between approximates & original
barb_PSNR_dwt = zeros(1,9);         % PSNRs between approximates & original

% calculate above values
for p = 0.1:0.1:0.9
    p_ind = round(p*10);    % p index
    % calculate approximate image
    [barb_aprx_p_DWT(:,:,p_ind), barb_dwt_p(:,:,p_ind)] = dwt_2LVL(barb_n, p, 'haar');
    % calculate error
    barb_MSE_dwt(1,p_ind) = immse(barb, barb_aprx_p_DWT(:,:,p_ind));
    barb_PSNR_dwt(1,p_ind) = 10 * log10( (255^2) / barb_MSE_dwt(1,p_ind) );
    %{
    % plot
    subplot(3,3,p_ind)
    imshow(barb_aprx_p_DWT(:,:,p_ind))
    %}
end


% (c) DWT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%{
Repeat the experiment from part (b) for DWT using 
the Daubechies filter “db4”.
%}

% iv) & v)
% iv -  compute the mean-squared error (MSE) between 
%       the original & approximate images
%    -  Also, express the MSE as PSNR (defined for pixel values 0-255)
% v  -  Perform steps (ii-iv) for p = 10, 20, ..., 90%

%figure()

% values to calculate
barb_aprx_p_DWT_db4 = zeros(height,width,9);    % approximate images
barb_dwt_p_db4 = zeros(height,width,9); % DWTs for approximate images
barb_MSE_dwt_db4 = zeros(1,9);          % MSEs between approximates & original
barb_PSNR_dwt_db4 = zeros(1,9);         % PSNRs between approximates & original

% calculate above values
for p = 0.1:0.1:0.9
    p_ind = round(p*10);    % p index
    % calculate approximate image
    [barb_aprx_p_DWT_db4(:,:,p_ind), barb_dwt_p_db4(:,:,p_ind)] = dwt_2LVL(barb_n, p, 'db4');
    % calculate error
    barb_MSE_dwt_db4(1,p_ind) = immse(barb, barb_aprx_p_DWT_db4(:,:,p_ind));
    barb_PSNR_dwt_db4(1,p_ind) = 10 * log10( (255^2) / barb_MSE_dwt_db4(1,p_ind) );
    %{ 
    % plot
    subplot(3,3,p_ind)
    imshow(barb_aprx_p_DWT_db4(:,:,p_ind))
    %}
end


% PLOTS ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

% Page 1
figure('Name', 'PROBELM 1 - DCT and DWT Basis Restriction Error (Page 1)')

subplot(2,2,1)
imshow(idct2(barb_dct), [0,255])
title('Original Image')
subplot(2,2,2)
imshow(barb_aprx_p_DCT(:,:,1), [0,255])
title('DCT-Based Approximation for p = 10%')
subplot(2,2,3)
imshow(barb_aprx_p_DWT(:,:,1))
title('DWT/”Haar”-Based Approximation for p = 10%')
subplot(2,2,4)
imshow(barb_aprx_p_DWT_db4(:,:,1))
title('DWT/”db4”-Based Approximation for p = 10%')

% Page 2
figure('Name', 'PROBELM 1 - DCT and DWT Basis Restriction Error (Page 2)')

p_range = 0.1:0.1:0.9;

% DCT
subplot(2,3,1)
plot(p_range, barb_MSE_dct)
title('DCT Mean Squared Error')
xlabel('p'); ylabel('MSE');
subplot(2,3,4)
plot(p_range, barb_PSNR_dct)
title('DCT Peak Signal-to-Noise Ratio')
xlabel('p'); ylabel('PSNR');
% DWT-"Haar"
subplot(2,3,2)
plot(p_range, barb_MSE_dwt)
title('DWT-"Haar" Mean Squared Error')
xlabel('p'); ylabel('MSE');
subplot(2,3,5)
plot(p_range, barb_PSNR_dwt)
title('DCT-"Haar" Peak Signal-to-Noise Ratio')
xlabel('p'); ylabel('PSNR');
% DWT-"db4"
subplot(2,3,3)
plot(p_range, barb_MSE_dwt_db4)
title('DWT-"db4" Mean Squared Error')
xlabel('p'); ylabel('MSE');
subplot(2,3,6)
plot(p_range, barb_PSNR_dwt_db4)
title('DCT-"db4" Peak Signal-to-Noise Ratio')
xlabel('p'); ylabel('PSNR');



%-------------------------------------------------------------------------
%    PROBELM 2 - Image Enhancement
%-------------------------------------------------------------------------

% 0.1 < Us, Ud ? 1.0
U = linspace(0.1, 1, 100);

Bs = 212 * log10(16.*U);

Bd = 255 * U.^(5/6);

Us = ( 10.^((255/212)*(U.^(5/6))) ) / 16;

figure('Name', 'PROBELM 2 - Image Enhancement')

subplot(1,3,1)
plot(U, Bs, 'LineWidth', 2, 'color', 'red')
title('B_s as a function of U_s')
ylabel('B_s'); xlabel('U_s');
subplot(1,3,2)
plot(U, Us, 'LineWidth', 2, 'color', 'blue')
title('U_s as a function of U_d')
ylabel('U_s'); xlabel('U_d');
subplot(1,3,3)
plot(U, Bd, 'LineWidth', 2, 'color', 'green')
title('B_d as a function of U_d')
ylabel('B_d'); xlabel('U_d');


toc % timer start