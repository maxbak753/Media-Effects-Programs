% Max Bakalos
% 5/24/2022
% MAIN MODULE

% Buidling VIDEO from transform coefficients

clear;  % clear previous variables

tic % timer start

% -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
% SET PARAMETERS -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
% -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_

% Select original video file
[vid_name,path] = uigetfile('*.*');


% Dialog Box for Input Parameters
dlg_title = 'Video Transform Reconstructor Input Parameters';
prompt = {'Fraction of Total Quality at the Last Frame:', ...
          'Type of Frame Distribution (1 -> Linear, 2 -> Logarithmic):' ...
          'Type of Transform: 0 -> DCT, 1-45 -> DWT', ...
          'Black & White -> 0, Color -> 1'};
dlg_dims = [1,60];
definput = {'1','2','0','1'};
opts.Resize = 'on';
input_params = inputdlg(prompt,dlg_title,dlg_dims,definput,opts);

% Dialog Box for Video Profile (file type)
profiles = {'Archival','Motion JPEG AVI','Motion JPEG 2000','MPEG-4', ...
            'Uncompressed AVI','Indexed AVI','Grayscale AVI'};
[lst_ind,~] = listdlg('PromptString', {'Select a Video File Format', '(Recommended: MPEG-4 or ','Uncompressed AVI):'}, ...
                      'SelectionMode', 'single', 'InitialValue', 4, ...
                      'ListSize',[150,100], ...
                      'ListString', profiles);


% Fraction of Total Quality at the Last Frame:
p_max = str2double(input_params{1});

% Type of Frame Distribution (1 -> Linear, 2 -> Logarithmic):
vid_type = str2double(input_params{2});

% Type of Transform: 0 -> DCT, 1-45 -> DWT
trans_type = str2double(input_params{3});

% Black & White -> 0, Color -> 1
bw_rgb = str2double(input_params{4});

% Video Profile (File Type)
selected_profile = profiles{lst_ind};

% -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
% -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
% -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-


% Create name for new video file
if (vid_type == 1)
    vid_type_str = 'lin_';
elseif (vid_type == 2)
    vid_type_str = 'log_';
end
p_max_str = strcat(num2str(p_max), 'p_');
trans_type_str = strcat(num2str(trans_type), 't_');
new_vid_name = strcat(vid_name, '__TransformEffect_', vid_type_str, p_max_str, trans_type_str);
fprintf(strcat("-----\nCreating \n", new_vid_name, "\nin the ", selected_profile, " format . . ."))

% Create objects to read and write the video
v_reader = VideoReader(strcat(path, vid_name));
v_writer = VideoWriter(new_vid_name, selected_profile);
% Make frame rates equal
v_writer.FrameRate = v_reader.FrameRate;
% Open the file for writing
open(v_writer);

% Width & Height
v_width = v_reader.Width;
v_height = v_reader.Height;

% # of pixels in image
num_elem = v_width * v_height;

% Minimum Percent
p_min = 1/num_elem;


% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Incremental Image Transformation Video Creation
increment_im_trans_VIDEO(bw_rgb, v_reader, v_writer, vid_type, trans_type, p_min, p_max)
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

close(v_writer); %close the file

fprintf("\n~*~ DONE ~*~\n")

toc % timer end