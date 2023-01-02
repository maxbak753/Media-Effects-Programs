% ~ ~ ~ ~ ~ ~ ~ ~ ~
% COLOR TO GRAYSCALE VIDEO CONVERTER
%                   ~ ~ ~ ~ ~ ~ ~ ~ ~

% Select original video file
[vid_name,path] = uigetfile('*.*');

[lst_ind,~] = listdlg('PromptString', {'Select a video file profile', '(Recommended: MPEG-4 or ','Uncompressed AVI):'}, ...
                      'SelectionMode', 'single', 'InitialValue', 4, ...
                      'ListSize',[150,100], ...
                      'ListString', profiles);

% Video Profile (File Type)
selected_profile = profiles{lst_ind};

fprintf(strcat("-----\nConverting \n", BW_vid_name, "\nto Grayscale \nin the ", selected_profile, " format . . .\n"))

BW_vid_name = strcat('BW__', vid_name);

% Create objects to read and write the video
v_reader1 = VideoReader(strcat(path, vid_name));
v_writer1 = VideoWriter(BW_vid_name, selected_profile);
% Make frame rates equal
v_writer1.FrameRate = v_reader1.FrameRate;
% Open the file for writing
open(v_writer1);

% Read RGB video file
vid_rgb = read(v_reader1);


% CONVERT to Black & White

% Preallocate
vid_BW = zeros(size(vid_rgb,1),size(vid_rgb,2),1,size(vid_rgb,4));

for i = 1:get(v_reader1, 'NumFrames')
    vid_BW(:,:,:,i) = rgb2gray(vid_rgb(:,:,:,i));
end

% Create File to write to
v_writer2 = VideoWriter(BW_vid_name, selected_profile);

% Open File
open(v_writer2)

% Write to file
writeVideo(v_writer2, vid_BW/255);
% Close file 
close(v_writer2)

fprintf("Done\n")