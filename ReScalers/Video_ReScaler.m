% VIDEO RESCALER (currently only upscaling)
% Max Bakalos
% 9/16/2022

tic % timer start

%clear % clear variables

% ********************
% PARAMETERS ************
% ***************************

% Select original video file
[vid_name,path] = uigetfile('*.*');

% Dialog Box for Input Parameters
dlg_title = 'Image Rescaler Input Parameters';
prompt = {'Upscale Amount:'};
dlg_dims = [1,40];
definput = {'5'};
opts.Resize = 'on';
input_params = inputdlg(prompt,dlg_title,dlg_dims,definput,opts);

% Dialog Box for Video Profile (file type)
profiles = {'Archival','Motion JPEG AVI','Motion JPEG 2000','MPEG-4', ...
            'Uncompressed AVI','Indexed AVI','Grayscale AVI'};
[lst_ind,~] = listdlg('PromptString', {'Select a Video File Format', '(Recommended: MPEG-4 or ','Uncompressed AVI):'}, ...
                      'SelectionMode', 'single', 'InitialValue', 4, ...
                      'ListSize',[150,100], ...
                      'ListString', profiles);

% Upscale Amount
upscale_amt = str2double(input_params{1});

% Video Profile (File Type)
selected_profile = profiles{lst_ind};

% ***************************
% PARAMETERS ************
% ********************

% New video name
new_vid_name = strcat(vid_name, '__upX', num2str(upscale_amt));
fprintf(strcat("-----\nCreating \n", new_vid_name, "\nin the ", selected_profile, " format . . ."))

% Create objects to read and write the video
v_reader = VideoReader(strcat(path, vid_name));
v_writer = VideoWriter(new_vid_name, selected_profile);
% Make frame rates equal
v_writer.FrameRate = v_reader.FrameRate;
% Open the video file for writing
open(v_writer);

% Width & Height
v_width = v_reader.Width;
v_height = v_reader.Height;

% New Video Dimensions
v_width_new = v_width * upscale_amt;
v_height_new = v_height * upscale_amt;

% Preallocate new frame size
frame_rescaled = zeros(v_height_new, v_width_new, 3);

% Create rescaled video
while hasFrame(v_reader)

    % get current frame
    frame = readFrame(v_reader);

    % normalize
    frame = im2double(frame);

    % Fill in new frame with values of old frame pixels
    for r = 1:v_height
        for c = 1:v_width
            for rgb = 1:3
                frame_rescaled((((upscale_amt*(r - 1))+1):((upscale_amt*(r - 1))+upscale_amt)), ...
                               (((upscale_amt*(c - 1))+1):((upscale_amt*(c - 1))+upscale_amt)), ...
                               rgb) = frame(r,c,rgb);
            end
        end
    end

    % write new frame to new video
    writeVideo(v_writer, frame_rescaled);

end

close(v_writer); % close the rescaled video file

fprintf("\n>>> DONE <<<\n")

toc % timer end