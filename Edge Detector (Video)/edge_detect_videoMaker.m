% EDGE DETECTION Video Creator
% Max Bakalos
% 6/1/2022

tic % timer start

% Dialog Box for Input Parameters
dlg_title = "EDGE DETECTION Video Creator Parameters";
prompt = {'\bfBlack & White or Color?: \rm0 \rightarrow B&W, 1 \rightarrow RGB'};
dlg_dims = [1,70];
definput = {'1'};
opts.Interpreter = 'tex'; opts.Resize = 'on';
input_params = inputdlg(prompt,dlg_title,dlg_dims,definput,opts);

% Dialog Box for Video Profile (file type)
profiles = {'Archival','Motion JPEG AVI','Motion JPEG 2000','MPEG-4', ...
            'Uncompressed AVI','Indexed AVI','Grayscale AVI'};
[lst_ind,~] = listdlg('PromptString', {'Select a Video File Format', '(Recommended: MPEG-4 or ','Uncompressed AVI):'}, ...
                      'SelectionMode', 'single', 'InitialValue', 4, ...
                      'ListSize',[150,100], ...
                      'ListString', profiles);

% Video Profile (File Type)
selected_profile = profiles{lst_ind};

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% CHOOSE: Black & White or Color? ~ ~ ~ ~ ~
% 0 -> b&w, 1 -> rgb
bw_color = str2double(input_params{1});

if (bw_color == 0)
    bw_color_str = 'bw_';
elseif (bw_color == 1)
    bw_color_str = 'rgb_';
end
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

% Select original video file
[vid_name,path] = uigetfile('*.*');
% Create name for new video file
new_vid_name = strcat('edgeDetected_',bw_color_str, vid_name);

% Create objects to read and write the video
reader = VideoReader(strcat(path, vid_name));
writer = VideoWriter(new_vid_name, selected_profile);
% Make frame rates equal
writer.FrameRate = reader.FrameRate;
% Open the AVI file for writing
open(writer);

% Read and write each frame.
while hasFrame(reader)
    frame = readFrame(reader);  % get current frame

    % Black & White
    if (bw_color == 0)%( size(size(frame),2) == 3 )
        frame = rgb2gray(frame);    % convert to black & white
        frame = double(edge(frame));% edge detect frame
    % Color
    elseif (bw_color == 1)
        % Edge detect frame for each color:
        % Red
        frame(:,:,1) = double(edge(frame(:,:,1)));
        % Green
        frame(:,:,2) = double(edge(frame(:,:,2)));
        % Blue
        frame(:,:,3) = double(edge(frame(:,:,3)));
    end

    % Write new frame to new video
    writeVideo(writer,double(frame));
end
% close new video
close(writer);

toc % timer end 