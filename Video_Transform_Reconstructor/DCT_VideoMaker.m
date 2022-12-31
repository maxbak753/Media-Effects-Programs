% EC520 Homework Assignment #9
% Max Bakalos
% 4/12/2022
% MAIN MODULE

tic % timer start

% -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
% SET PARAMETERS -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
% -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_

% Photo File Name:
photo_fileName = 'dotShadowFace.jpg';

% # of frames (30 frames per second):
frames_amt = 30*5;%30*15*15;

% Fraction of Total Quality at the Last Frame:
max_percent = 0.01*15*0.4;

% Type of Frame Distribution (1=Linear, 2=Exponential):
vid_type = 1;

% -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
% -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

% (a) DCT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Read Image  - - - - - - - - - - - - - - - - - 
im = imread(photo_fileName);   % 0 - 255 (original)
% if image is not grayscale, convert it to grayscale
if (length(size(im)) ~= 2)
    im = rgb2gray(im);
end
im = double(im);
range_im = 1;
barb_n = im / range_im;       % 0 to 1 (n = normalized) (u[k,l])

% i) Apply 2-D DCT (dct2) to the complete image (not block-by-block) ~ ~ ~
im_dct = dct2(im);

% iv) & v)
% iv -  compute the mean-squared error (MSE) between 
%       the original & approximate images
%    -  Also, express the MSE as PSNR (defined for pixel values 0-255)
% v  -  Perform steps (ii-iv) for p = 10, 20, ..., 90%

% # of pixels in image, barbara.tif
num_elem = size(im,1) * size(im,2);

%im_fileName = char.empty(0,num_elem);

a = (max_percent+1)^(1/max_percent);

p_min = 1/num_elem;

% calculate all possible even divisors for num_elem
range_elem = 1:num_elem;
divisors = range_elem(rem(num_elem,range_elem)==0);

video_fileName = strcat(photo_fileName, '_Video');
video = VideoWriter(video_fileName, 'Grayscale AVI'); %create the video object
open(video); %open the file for writing

if (vid_type == 1)
    for p = linspace(p_min,max_percent,frames_amt)
        p_ind = round(p*num_elem);    % p index

        % calculate image
        [im_p, im_dct_p] = Discrete_Cosine_Tranform_NoName(im, p);
        %barb_MSE(1,p_ind) = immse(barb, barb_p(:,:,p_ind));

        %im_fileName = strcat('im_', num2str(p_ind), '.png');

        % write image to file
        %imwrite((barb_p/range_barb), im_fileName)

        % write image to video frame
        writeVideo(video, im_p/range_im);

    end
elseif (vid_type == 2)
    for p = (a.^(linspace(p_min,max_percent,frames_amt))) - 1
        p_ind = round(p*num_elem);    % p index

        % calculate image
        [im_p, im_dct_p] = Discrete_Cosine_Tranform_NoName(im, p);
        %barb_MSE(1,p_ind) = immse(barb, barb_p(:,:,p_ind));

        %im_fileName = strcat('im_', num2str(p_ind), '.png');

        % write image to file
        %imwrite((barb_p/range_barb), im_fileName)

        % write image to video frame
        writeVideo(video, im_p/range_im);

    end
end

close(video); %close the file

toc % timer start