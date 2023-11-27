% Hmmm...

clear;

% perc_start = 1*(10^(-100));
perc_start = 1*(10^(-10));
perc_end = 1;
frames_trans = 24*30;

video_fileName = "beepboop2";
selected_profile = 'MPEG-4';
% create the video object & open for writing
video_w = VideoWriter(video_fileName, selected_profile);
open(video_w);

% Select original photo files
% [pic1_name,path1] = uigetfile('*.*');
% [pic2_name,path2] = uigetfile('*.*');



pic1_name = 'lava52.jpg';
path1 = 'C:\Users\maxba\Pictures\Imaginary Space\';

pic2_name = 'cloudpinkish.jpg';
path2 = 'C:\Users\maxba\Pictures\Imaginary Space\';




% pic1_name = 'IMG_5042.JPG'; %'IMG_4129.JPG';
% path1 = 'C:\Users\maxba\Pictures\iPhone 6s Photos 3-20-2023\';
% 
% pic2_name = 'IMG_4605.JPG'; %'IMG_3981.JPG';
% path2 = 'C:\Users\maxba\Pictures\iPhone 6s Photos 3-20-2023\';

% Read Images  - - - - - - - - - - - - - - - - - 
im1 = imread(strcat(path1, pic1_name));   % 0 - 255 (original)
im2 = imread(strcat(path2, pic2_name));   % 0 - 255 (original)

% im1 = imresize(im1,0.125);
% im2 = imresize(im2,0.125);

im1 = imresize(im1, [266,190]);

im1_oo = im1;
im1 = im2;
im2 = im1_oo;

% Check if they are the same size
s_im1 = size(im1); s_im2 = size(im2);
if s_im1 ~= s_im2
    fprintf("The two images msut be the same size!!!\n" + ...
            "size(im1) = [%d,%d,%d], size(im2) = [%d,%d,%d]\n", ...
            s_im1(1),s_im1(2),s_im1(3), s_im2(1),s_im2(2),s_im2(3));
else
    
    
    % i) Apply 2-D DCT (dct2) to the complete image (not block-by-block) ~
    
    im1dct(:,:,1) = dct2(im1(:,:,1));
    im1dct(:,:,2) = dct2(im1(:,:,2));
    im1dct(:,:,3) = dct2(im1(:,:,3));
    
    im2dct(:,:,1) = dct2(im2(:,:,1));
    im2dct(:,:,2) = dct2(im2(:,:,2));
    im2dct(:,:,3) = dct2(im2(:,:,3));

    a1(:,:,1) = idct2(im1dct(:,:,1));
    a1(:,:,2) = idct2(im1dct(:,:,2));
    a1(:,:,3) = idct2(im1dct(:,:,3));
    a1 = rescale(a1);

    a2(:,:,1) = idct2(im2dct(:,:,1));
    a2(:,:,2) = idct2(im2dct(:,:,2));
    a2(:,:,3) = idct2(im2dct(:,:,3));
    a2 = rescale(a2);
    
    % reshape 2D array of squared coefficients into 1-D vector
    % & order the coefficients
    im1dct_sqr = im1dct(:,:,1) .^ 2;
    im1dct_reshaped = reshape(im1dct_sqr, 1, []);
    [im1dct_v, sort1i] = sort( im1dct_reshaped ,  'descend' );
    
    im2dct_sqr = im2dct(:,:,1) .^ 2;
    [im2dct_v, sort2i] = sort( reshape(im2dct_sqr, 1, []) ,  'descend' );
    
    im1to2_reformed = zeros(s_im1);
    

    % create partial coef vector combination
%         perc1to2 = 0.0005;

    
    i_f = 1; % frame index
    for perc1to2 = [0,logspace(log10(perc_start), log10(perc_end), frames_trans)]

        fprintf("Frame #%d: ", i_f);
        
        for rgb = 1:3
            % create negative values masks & put in format of coef vectors
            neg_mask1 = im1dct(:,:,rgb) < 0;
            neg_mask2 = im2dct(:,:,rgb) < 0;
            
            neg_mask1_v_unsorted = reshape(neg_mask1, 1, []);
            
            i = 1:length(sort1i);
            neg_mask1_v = zeros(size(sort1i));
            neg_mask1_v(i) = neg_mask1_v_unsorted(sort1i(i));
            
            neg_mask2_v_unsorted = reshape(neg_mask2, 1, []);
            
            i = 1:length(sort2i);
            neg_mask2_v = zeros(size(sort2i));
            neg_mask2_v(i) = neg_mask2_v_unsorted(sort2i(i));
            
            
    %         % create partial coef vector combination
    %         perc1to2 = 0.0005;
            
            len_im1dct = length(im1dct_v);
            if len_im1dct == length(im2dct_v)
                bbb = floor(len_im1dct * perc1to2);
            end
            
            im1to2dct_v = [im1dct_v(1:bbb), im2dct_v(bbb+1:end)];
            % im1to2dct_v = im2dct_v;
            
            neg_mask1to2_v = [neg_mask1_v(1:bbb), neg_mask2_v(bbb+1:end)];
            % neg_mask1to2_v = neg_mask2_v;
            
            sort1to2i = [sort1i(1:bbb), sort2i(bbb+1:end)];
            % sort1to2i = sort2i;
            
            % iii) Apply 2-D inverse DCT (idct2) to the partially-zeroed ~ ~ ~ ~ ~
            % coefficient array. This results in an approximate image
            
            % zeroed = (rand(size(im1dctR)) < 0.999);
            % im1dctR(zeroed) = 0;
            % im1dctG(zeroed) = 0;
            % im1dctB(zeroed) = 0;
            
            
            % im1_new(:,:,1) = rescale( idct2(im1dct(:,:,1)) );
            % im1_new(:,:,2) = rescale( idct2(im1dct(:,:,2)) );
            % im1_new(:,:,3) = rescale( idct2(im1dct(:,:,3)) );
            % 
            % imshow(im1_new);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%
            % im1dct_v_unsorted = zeros(size(im1dct_v));
            % 
            % % for i = 1:length(sort1i)
            % i = 1:length(sort1i);
            % im1dct_v_unsorted(sort1i(i)) = im1dct_v(i);
            % % end
            % 
            % im1dct_unreshaped = reshape(im1dct_v_unsorted, size(im1,1), []);
            % 
            % im1dct_unsqrt = sqrt(im1dct_unreshaped);
            % 
            % neg_mask = im1dct(:,:,1) < 0;
            % im1dct_unsqrt(neg_mask) = -im1dct_unsqrt(neg_mask);
            % 
            % im1_reformed = rescale( idct2(im1dct_unsqrt) );
            % 
            % imshow(im1_reformed);
            
            
            
            % put dct back it correct format
            
            im1to2dct_v_unsorted = zeros(size(im1to2dct_v));
            i = 1:length(sort1to2i);
            im1to2dct_v_unsorted(sort1to2i(i)) = im1to2dct_v(i);
            
            im1to2dct_unreshaped = reshape(im1to2dct_v_unsorted, size(im1,1), []);
            
            im1to2dct_unsqrt = sqrt(im1to2dct_unreshaped);
            
            % put nega mask in right format
            neg_mask1to2_v_unsorted = zeros(size(neg_mask1to2_v));
            i = 1:length(sort1to2i);
            neg_mask1to2_v_unsorted(sort1to2i(i)) = neg_mask1to2_v(i);
            
            neg_mask1to2_unreshaped = logical(reshape(neg_mask1to2_v_unsorted, size(im1,1), []));
            
            % finish formatting
            % neg_mask = im1dct(:,:,1) < 0;
            im1to2dct_unsqrt(neg_mask1to2_unreshaped) = -im1to2dct_unsqrt(neg_mask1to2_unreshaped);
            
            % calculate new image
            im1to2_reformed(:,:,rgb) = rescale( idct2(im1to2dct_unsqrt) );

%             imshow(im1to2_reformed);

            fprintf("%d", rgb);

        end

        % Convert to 0-255 uint8
        im1to2_uint8 = uint8(im1to2_reformed * 255);



        % write image to video frame
        writeVideo(video_w, im1to2_uint8);

        % clear image
        im1to2_reformed = zeros(s_im1);

        % Increment frame index
        i_f = i_f + 1;


    
        
        fprintf("\n");

    end

    close(video_w); % close the video file

    fprintf("\n~^~ DONE ~^~\n")
   
end
