% Hmmm...

clear;

TEST_TYPE = "random";

% perc_start = 1*(10^(-100));
perc_start = 1*(10^(-10));
perc_end = 1;
frames_trans = 24*10;

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
%     im1dct_sqr = im1dct(:,:,1) .^ 2;
    for rgb = 1:3
        im1dct_sqr(:,:,rgb) = im1dct(:,:,rgb) .^ 2;
        im1dct_reshaped(rgb,:) = reshape(im1dct_sqr(:,:,rgb), 1, []);
        [im1dct_v(rgb,:), sort1i(rgb,:)] = sort( im1dct_reshaped(rgb,:) ,  'descend' );
        
        im2dct_sqr(:,:,rgb) = im2dct(:,:,rgb) .^ 2;
        [im2dct_v(rgb,:), sort2i(rgb,:)] = sort( reshape(im2dct_sqr(:,:,rgb), 1, []) ,  'descend' );
    end
    
    im1to2_reformed = zeros(s_im1);
    

    % create partial coef vector combination
%         perc1to2 = 0.0005;

    
%     i_f = 1; % frame index
    perc1to2 = [0,logspace(log10(perc_start), log10(perc_end), frames_trans)];
%     p12 = [0,logspace(log10(perc_end), log10(perc_start), frames_trans)];
    for i_f = 1:length(perc1to2)

        fprintf("Frame #%d: ", i_f);
        
        for rgb = 1:3
            % create negative values masks & put in format of coef vectors
            neg_mask1(:,:,rgb) = im1dct(:,:,rgb) < 0;
            neg_mask2(:,:,rgb) = im2dct(:,:,rgb) < 0;
            
            neg_mask1_v_unsorted(rgb,:) = reshape(neg_mask1(:,:,rgb), 1, []);
            
            i = 1:length(sort1i(rgb,:));
            neg_mask1_v = zeros(size(sort1i(rgb,:)));
            neg_mask1_v(rgb,i) = neg_mask1_v_unsorted(rgb, sort1i(rgb,i));
            
            neg_mask2_v_unsorted(rgb,:) = reshape(neg_mask2(:,:,rgb), 1, []);
            
            i = 1:length(sort2i(rgb,:));
            neg_mask2_v = zeros(size(sort2i(rgb,:)));
            neg_mask2_v(rgb,i) = neg_mask2_v_unsorted(rgb, sort2i(rgb,i));
            
            
 
            
            if strcmpi(TEST_TYPE, "percent")
                %         % create partial coef vector combination
                %         perc1to2 = 0.0005;
                len_im1dct = length(im1dct_v(rgb,:));
                if len_im1dct == length(im2dct_v(rgb,:))
                    bbb = floor(len_im1dct * perc1to2(i_f));
                end
                
                im1to2dct_v(rgb,:) = [im1dct_v(rgb,1:bbb), im2dct_v(rgb,bbb+1:end)];
                % im1to2dct_v = im2dct_v(rgb,:);
                
                neg_mask1to2_v(rgb,:) = [neg_mask1_v(rgb,1:bbb), neg_mask2_v(rgb,bbb+1:end)];
                % neg_mask1to2_v = neg_mask2_v;
                
                sort1to2i = [sort1i(rgb,1:bbb), sort2i(rgb,bbb+1:end)];
                % sort1to2i = sort2i(rgb,:);
            elseif strcmpi(TEST_TYPE, "random")
                len_im1dct = length(im1dct_v(rgb,:));
                
                if len_im1dct == length(im2dct_v(rgb,:))
                    mask1 = logical(rand(1,len_im1dct) > perc1to2(i_f));
                    mask2 = ~mask1;
                end
                
                im1to2dct_v = zeros(3,len_im1dct);
                im1to2dct_v(rgb,mask1) = im1dct_v(rgb,mask1);
                im1to2dct_v(rgb,mask2) = im2dct_v(rgb,mask2);

                neg_mask1to2_v = zeros(3,len_im1dct);
                neg_mask1to2_v(rgb,mask1) = neg_mask1_v(rgb,mask1);
                neg_mask1to2_v(rgb,mask2) = neg_mask2_v(rgb,mask2);
                
                
                sort1to2i = zeros(1,len_im1dct);
                sort1to2i(mask1) = sort1i(rgb,mask1);
                sort1to2i(mask2) = sort2i(rgb,mask2);
            end
            
            % put dct back it correct format
            
            im1to2dct_v_unsorted(rgb,:) = zeros(size(im1to2dct_v(rgb,:)));
            i = 1:length(sort1to2i);
            im1to2dct_v_unsorted(rgb, sort1to2i(i)) = im1to2dct_v(rgb,i);
            
            im1to2dct_unreshaped(:,:,rgb) = reshape(im1to2dct_v_unsorted(rgb,:), size(im1,1), []);
            
            im1to2dct_unsqrt(:,:,rgb) = sqrt(im1to2dct_unreshaped(:,:,rgb));
            
            % put nega mask in right format
            neg_mask1to2_v_unsorted = zeros(size(neg_mask1to2_v(rgb,:)));
            i = 1:length(sort1to2i);
            neg_mask1to2_v_unsorted(sort1to2i(i)) = neg_mask1to2_v(rgb,i);
            
            neg_mask1to2_unreshaped(:,:,rgb) = logical(reshape(neg_mask1to2_v_unsorted, size(im1,1), []));
            
            % finish formatting
            % neg_mask = im1dct(:,:,1) < 0;
            im1to2dct_unsqrt_RGB = im1to2dct_unsqrt(:,:,rgb);
            im1to2dct_unsqrt_RGB(neg_mask1to2_unreshaped(:,:,rgb)) = -im1to2dct_unsqrt_RGB(neg_mask1to2_unreshaped(:,:,rgb));

            im1to2dct_unsqrt(:,:,rgb) = im1to2dct_unsqrt_RGB;
            
            % calculate new image
            im1to2_reformed(:,:,rgb) = idct2(im1to2dct_unsqrt(:,:,rgb));

%             imshow(im1to2_reformed);

            fprintf("%d", rgb);

        end

        % Convert to 0-255 uint8
        im1to2_uint8 = uint8(im1to2_reformed);



        % write image to video frame
        writeVideo(video_w, im1to2_uint8);

        % clear image
        im1to2_reformed = zeros(s_im1);

%         % Increment frame index
%         i_f = i_f + 1;


    
        
        fprintf("\n");

    end

    close(video_w); % close the video file

    fprintf("\n~^~ DONE ~^~\n")
   
end
