% Max Bakalos
% 8/5/2023
% MAIN MODULE

% Buidling Video from transform coefficients

clear;  % clear previous variables

tic % timer start

% -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
% SET PARAMETERS -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
% -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_

% Select original photo files
[pic1_name,path1] = uigetfile('*.*');
[pic2_name,path2] = uigetfile('*.*');


% Dialog Box for Input Parameters
dlg_title = 'Video Transform Reconstructor Input Parameters';
prompt = {'# of frames (30 frames per second):', ...
          'Fraction of Total Quality at the Last Frame:', ...
          '# of Frames of Total Quality after the Last Frame: ', ...
          'Type of Frame Distribution (1 -> Linear, 2 -> Logarithmic):' ...
          'Type of Transform: 0 -> DCT, 1-45 -> DWT'};
dlg_dims = [1,60];
definput = {'150','1','0','2','0'};
opts.Resize = 'on';
input_params = inputdlg(prompt,dlg_title,dlg_dims,definput,opts);

% Dialog Box for Video Profile (file type)
profiles = {'Archival','Motion JPEG AVI','Motion JPEG 2000','MPEG-4', ...
            'Uncompressed AVI','Indexed AVI','Grayscale AVI'};
[lst_ind,~] = listdlg('PromptString', {'Select a Video File Format', '(Recommended: MPEG-4 or ','Uncompressed AVI):'}, ...
                      'SelectionMode', 'single', 'InitialValue', 4, ...
                      'ListSize',[150,100], ...
                      'ListString', profiles);


% # of frames (30 frames per second):
frames_amt = round(str2double(input_params{1}));

% Fraction of Total Quality at the Last Frame:
p_max = str2double(input_params{2});

% # of Frames of Total Quality after the Last Frame:
full_quality_end_frames = round(str2double(input_params{3}));

% Type of Frame Distribution (1 -> Linear, 2 -> Exponential):
vid_type = str2double(input_params{4});

% Type of Transform: 0 -> DCT, 1-45 -> DWT
trans_type = str2double(input_params{5});

% Video Profile (File Type)
selected_profile = profiles{lst_ind};

% -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
% -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-


% Read Images  - - - - - - - - - - - - - - - - - 
im1 = imread(strcat(path1, pic1_name));   % 0 - 255 (original)
im2 = imread(strcat(path2, pic2_name));   % 0 - 255 (original)

% File Name
% Create name for new video file
if (vid_type == 1)
    vid_type_str = 'lin_';
elseif (vid_type == 2)
    vid_type_str = 'log_';
end
p_max_str = strcat(num2str(p_max), 'p_');
trans_type_str = strcat(num2str(trans_type), 't_');
video_fileName = strcat(pic1_name, '__TransformEffect_', vid_type_str, p_max_str, trans_type_str);
fprintf(strcat("-----\nCreating \n", video_fileName, "\nin the ", selected_profile, " format . . ."))

% Color Variable: Black & White -> 0, Color -> 1
if ( size(size(im1),2) == 3 )
    rgb_bw = 1;
elseif ( size(size(im1),2) == 2 )
    rgb_bw = 0;
end

% Convert from uint8 -> double
im1 = double(im1);
% Normalizd image with ranges from 0 -255 --> 0 - 1
im_n = im1 / 255;
range_im = 1;

% # of pixels in image
num_elem = size(im1,1) * size(im1,2);

% Minimum Percent
p_min = 1/num_elem;

% calculate all possible even divisors for num_elem
range_elem = 1:num_elem;
divisors = range_elem(rem(num_elem,range_elem)==0);

% create the video object & open for writing
video_w = VideoWriter(video_fileName, selected_profile); 
open(video_w);

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% Incremental Image Transformation Video Creation
increment_im_trans(rgb_bw, video_w, vid_type, trans_type, im1, im_n, p_min, p_max, frames_amt)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


% If specified: Add Full-Quality End Frames
if (full_quality_end_frames > 0)
    % Create Matrix of Image Replicas
    im_repmat = repmat(im_n, 1, 1, 1, full_quality_end_frames);
    % Append Images to Video
    writeVideo(video_w, im_repmat);
end


close(video_w); % close the video file

fprintf("\n~^~ DONE ~^~\n")

toc % timer end