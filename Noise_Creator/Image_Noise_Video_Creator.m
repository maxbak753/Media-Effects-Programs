% VISUAL NOISE VIDEO CREATOR
% 9/16/2022
% Max Bakalos

clear % clear previous values

% ********************
% PARAMETERS ************
% ***************************

% Video frame amount
frames = 24*20;

% Total Video Frame Dimensions
horiz_total = 160;
verti_total = 90;
% Noise Dimensions
horiz = 160;
verti = 90;

% Check Dimensions & Fix If Incorrect
if (horiz_total <= horiz)
    fprintf("FIXING ERROR: Total horizonal distance is less than noise image horizontal distance!")
    [horiz, horiz_total] = deal(horiz_total, horiz);    % swap variables
end
if (verti_total <= verti)
    fprintf("FIXING ERROR: Total vertical distance is less than noise image vertical distance!")
    [verti, verti_total] = deal(verti_total, verti);    % swap variables
end

% Blank Space Dimensions (blank space on each side) (must be even)
horiz_pad = horiz_total - horiz;
verti_pad = verti_total - verti;

% Check Blank Space Dimensions & Fix If Incorrect
if ( rem(horiz_pad,2) )
    fprintf("FIXING ERROR: Padded horizonal distance is not an even number!")
    horiz_pad = horiz_pad + 1;  % set to nearest even #
end
if ( rem(verti_pad,2) )
    fprintf("FIXING ERROR: Padded vertical distance is not an even number!")
    verti_pad = verti_pad + 1;  % set to nearest even #
end

% Blank space color value;
r_pad = 1;  % red
g_pad = 1;  % green
b_pad = 1;  % blue

% Black & White (0) or Color (1)
bw_rgb = 1;

% Noise Types - - - - - - - - - - - -
% 0 -> uniform, 1 -> gaussian
type = 1;

% Color balance (1 = uniform)
r = 1;  % red
g = 1;  % green
b = 1;  % blue

% Mean & Variance (gaussian noise)
mean = 0.6;
var = 0.1;
% - - - - - - - - - - - - - - - - - -

% Saturation: 0 -> none, 1 -> full
saturated = 0;

% ***************************
% PARAMETERS ************
% ********************

% Title - - -
% BW or RGB
if (bw_rgb == 0)
    bw_rgb_name = 'bw';
elseif (bw_rgb == 1)
    bw_rgb_name = 'rgb';
end
% Uniform or Gaussian
if (type == 0)
    type_name = 'uniform';
elseif (type == 1)
    type_name ='gaussian';
end
% put name together
pic_name = strcat(type_name, '_noise_', bw_rgb_name, '_mean', num2str(mean), '_var', num2str(var), '_', num2str(horiz_total), 'x', num2str(verti_total), '_Noise', num2str(horiz), 'x', num2str(verti));
% print name
fprintf(strcat(pic_name,'\n'))

% Create objects to write the video
v_writer = VideoWriter(pic_name, 'Uncompressed AVI');
% Assign frame rate
v_writer.FrameRate = 24;
% Assign video Quality
%v_writer.Quality = 100;
% Open the AVI file for writing
open(v_writer);
% Update Video Frame Dimensions
v_horiz = horiz + horiz_pad;
v_verti = verti + verti_pad;


% Dimensions vector
dim = [verti, horiz];
% Preallocate image
if (bw_rgb == 0)
    im = zeros(verti, horiz);

    bw_pad = rgb2gray([r_pad,g_pad,b_pad]);
    im_pad = bw_pad(1,1) * ones(v_verti, v_horiz);
elseif (bw_rgb == 1)
    im = zeros(verti, horiz, 3);
    blank_image = ones(v_verti, v_horiz);
    im_pad(:,:,1) = (r_pad * blank_image); 
    im_pad(:,:,2) = (g_pad * blank_image); 
    im_pad(:,:,3) = (b_pad * blank_image);
end






for f = 1:frames
    
    % Reset image
    im = zeros(verti, horiz, 3);

    % Create Image
    if (type == 0)
        % Uniform Noise
        if (bw_rgb == 0)
            im = rand(dim);
        elseif (bw_rgb == 1)
            im(:,:,1) = r * rand(dim);
            im(:,:,2) = g * rand(dim);
            im(:,:,3) = b * rand(dim);
        end
    elseif (type == 1)
        % Gaussian Noise
        if (bw_rgb == 0)
            im = imnoise(im,'gaussian', mean, var);
        elseif (bw_rgb == 1)
            im(:,:,1) = r * imnoise(im(:,:,1),'gaussian', mean, var);
            im(:,:,2) = g * imnoise(im(:,:,2),'gaussian', mean, var);
            im(:,:,3) = b * imnoise(im(:,:,3),'gaussian', mean, var);
        end
    end
    
    % Saturate
    if (saturated == 1)
        im = round(im);
    end

    verti_pad_half = verti_pad / 2;
    horiz_pad_half = horiz_pad / 2;

    % Create final padded image frame
    im_final = im_pad;  % set entire frame to blank background pad
    % set middle region to noise image
    if (bw_rgb == 0)
        im_final((verti_pad_half+1):(verti_pad_half+verti), ...
                 (horiz_pad_half+1):(horiz_pad_half+horiz)) = im(:,:);
    elseif (bw_rgb == 1)
        im_final((verti_pad_half+1):(verti_pad_half+verti), ...
                 (horiz_pad_half+1):(horiz_pad_half+horiz), 1) = im(:,:,1);
        im_final((verti_pad_half+1):(verti_pad_half+verti), ...
                 (horiz_pad_half+1):(horiz_pad_half+horiz), 2) = im(:,:,2);
        im_final((verti_pad_half+1):(verti_pad_half+verti), ...
                 (horiz_pad_half+1):(horiz_pad_half+horiz), 3) = im(:,:,3);
    end
    
    % write new frame to new video
    writeVideo(v_writer, im_final);

end

close(v_writer); %close the video file

% Display Last Frame
imshow(im_final, [0,1])
