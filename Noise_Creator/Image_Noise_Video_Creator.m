% VISUAL NOISE VIDEO CREATOR
% 9/16/2022
% Max Bakalos

clear % clear previous values


% ********************
% PARAMETERS ************
% ***************************

% Dialog Box for Input Parameters
dlg_title = "Visual Noise Video Creator Parameters";
prompt = {'1.  \bfFrame Rate:', ...
    '2.  \bf# of Video Frames:', ...
    '3.  \bfTotal Video Frame Dimensions: \rm(space seperated values) "Horizontal Vertical"', ...
    '4.  \bfNoise Dimensions: \rm(space seperated values) "Horizontal Vertical"', ...
    '5.  \bfBlank Space Color Value: \rm(0-1 range, 1 = uniform) (space seperated values) "\color{red}Red \color{green}Green \color{blue}Blue"', ...
    '6.  \bfNoise Color Dimension: \rm0 \rightarrow Black & White, 1 \rightarrow Color', ...
    '7.  \bfNoise Types: \rm0 \rightarrow uniform, 1 \rightarrow gaussian', ...
    '8.  \bfRGB Color balance: \rm(0-1 range, 1 = uniform) (space seperated values) "\color{red}Red \color{green}Green \color{blue}Blue"', ...
    '9.  \bfMean & Variance: \rm(gaussian noise) (space seperated values) "Mean Variance"', ...
    '10. \bfSaturation: \rm0 \rightarrow none, 1 \rightarrow full'};
dlg_dims = [1,90];
definput = {'24','120','160 90','64 36','1 1 1','1','1','1 1 1','0.6 0.1', '0'};
opts.Interpreter = 'tex'; opts.Resize = 'on';
input_params = inputdlg(prompt,dlg_title,dlg_dims,definput,opts);

% Dialog Box for Video Profile (file type)
profiles = {'Archival','Motion JPEG AVI','Motion JPEG 2000','MPEG-4', ...
            'Uncompressed AVI','Indexed AVI','Grayscale AVI'};
[lst_ind,~] = listdlg('PromptString', {'Select a Video File Format', '(Recommended: MPEG-4 or ','Uncompressed AVI):'}, ...
                      'SelectionMode', 'single', 'InitialValue', 4, ...
                      'ListSize',[150,100], ...
                      'ListString', profiles);

% Frame Rate
frame_r8 = str2double(input_params{1});

% # of Video Frames
frames = str2double(input_params{2});

% Total Video Frame Dimensions
dims_tot = str2num(input_params{3});
horiz_total = dims_tot(1);
verti_total = dims_tot(2);
% Noise Dimensions
dims_noi = str2num(input_params{4});
horiz = dims_noi(1);
verti = dims_noi(2);

% Blank Space Color Value;
rgb_blank = str2num(input_params{5});
r_pad = rgb_blank(1);  % red
g_pad = rgb_blank(2);  % green
b_pad = rgb_blank(3);  % blue

% Color Dimensions: 0 -> Black & White, 1 -> Color
bw_rgb = str2double(input_params{6});

% Noise Types - - - - - - - - - - - -
% 0 -> uniform, 1 -> gaussian
type = str2double(input_params{7});

% Color balance (1 = uniform)
rgb_noi = str2num(input_params{8});
r = rgb_noi(1);  % red
g = rgb_noi(2);  % green
b = rgb_noi(3);  % blue

% Mean & Variance (gaussian noise)
mean_var = str2num(input_params{9});
mean = mean_var(1);
var = mean_var(2);
% - - - - - - - - - - - - - - - - - -

% Saturation: 0 -> none, 1 -> full
saturated = str2double(input_params{10});

% Video Profile (File Type)
selected_profile = profiles{lst_ind};

% ***************************
% PARAMETERS ************
% ********************


%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT ERROR CHECKING %%%%%%%%

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%


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
v_writer = VideoWriter(pic_name, selected_profile);
% Assign frame rate
v_writer.FrameRate = frame_r8;
% Assign video Quality
%v_writer.Quality = 100;
% Open the AVI file for writing
open(v_writer);
% Update Video Frame Dimensions
v_horiz = horiz + horiz_pad;
v_verti = verti + verti_pad;


% Dimensions vector
dim = [verti, horiz];

% Check if background color is grayscale (0 -> BW, 1 -> RGB)
bckrnd_BWorRGB = not((r_pad == g_pad) & (g_pad == b_pad));

% Preallocate image
% If the background & noise are both grayscale ...
if ((bw_rgb == 0) && (bckrnd_BWorRGB == 0))
    im = zeros(dim);

    %bw_pad = rgb2gray([r_pad,g_pad,b_pad]);
    %im_pad = bw_pad(1,1) * ones(v_verti, v_horiz);
    im_pad = r_pad * ones(v_verti, v_horiz);

else % if at least one of them is color ...
    im = zeros([dim, 3]);
    blank_image = ones(v_verti, v_horiz);
    im_pad(:,:,1) = (r_pad * blank_image); 
    im_pad(:,:,2) = (g_pad * blank_image); 
    im_pad(:,:,3) = (b_pad * blank_image);
end






for f = 1:frames

    % Reset image
    if (bw_rgb == 0)
        im = zeros(dim);
    elseif (bw_rgb == 1)
        im = zeros([dim, 3]);
    end

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

    % ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `
    % Set Middle Region to Noise Image ` ` ` ` ` ` ` ` ` `

    % If the background & noise are both grayscale ...
    if ((bw_rgb == 0) && (bckrnd_BWorRGB == 0))
        im_final((verti_pad_half+1):(verti_pad_half+verti), ...
                 (horiz_pad_half+1):(horiz_pad_half+horiz)) = im(:,:);

    else % if at least one of them is color ...

        if (bw_rgb == 0) % if the noise is grayscale
            % Make the pixels in RGB & set each RGB value to the same #
            im = repmat(im,1,1,3);
        end

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
