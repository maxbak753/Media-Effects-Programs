% Cluster Image / Video Maker

clear; close all;

dlg_title = "IMAGE or VIDEO";
prompt = {'Image or Video?: (0 -> Image, 1 -> Video)'};
dlg_dims = [1 50];
definput = {'0'};
input_params = inputdlg(prompt,dlg_title,dlg_dims,definput,"on");

% Image or Video
im_vid = str2double(input_params{1});



% Select original photo file
[pic_name,path] = uigetfile('*.*');

% Read Image  - - - - - - - - - - - - - - - - - 
im = imread(strcat(path, pic_name));   % 0 - 255 (original)

% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%~
%% PARAMETERS

dlg_title = "Image Clusterer Input Parameters ~('o')~";
prompt = {'# of Clusters to Find, k = ?:', ...
    'Distance Metric (Lq Norm Distance), q = ?: (1 or 2)', ...
    'Convergence Threshold (cluster center position change):', ...
    'Toggle: use pixel components seperately or together (color images): (0 -> seperate, 1 -> together)' ...
    "Toggle for location usage: (0 -> don't use, 1 -> use)", ...
    "Location Importance Fraction:", ...
    'Image File Type Extension:'};
dlg_dims = [1 60];
definput = {'10','2','0.025','1','1','1.5','png'};
input_params = inputdlg(prompt,dlg_title,dlg_dims,definput,"on");

% # of Clusters to Find
k = str2double(input_params{1});

% Distance Metric (Lq Norm Distance)
q = str2double(input_params{2});

% How low a change in cluster center position has to be
% to be considered converged
convergence_threshold = str2double(input_params{3});

% Toggle for Using All RGB Components Seperately or Together 
% (0 -> seperate, 1 -> together)
components_use = str2double(input_params{4});

% Toggle for location usage
% (0 -> don't use, 1 -> use)
loc_use = str2double(input_params{5});

% Location Importance Fraction
loc_importance_frac = str2double(input_params{6});

% Write Toggle
wrt_toggle = 0;

% Plot Toggle
plt_toggle = 0;

% Maximum K-Means Iterations (default is 100)
max_iter = 200;

% Image File Type Extension:
file_type = input_params{7};



% IMAGE
if (im_vid == 0)
    im_clustered = kMeans_Image(im, k, components_use, loc_use, loc_importance_frac, wrt_toggle, plt_toggle, max_iter);
    imshow(im_clustered)
    new_pic_name = strcat(pic_name, '__IMAGE__', num2str(k),'_clstrs', '_L', num2str(q), '_loc', num2str(loc_use), '_', num2str(loc_importance_frac));
    imwrite(im_clustered, strcat(new_pic_name, '.', file_type));
end

% VIDEO
if (im_vid == 1)

    dlg_title = "Image Clusterer Input Parameters ~('o')~";
    prompt = {'# Of Clusters at End of Video:', ...
              'Cluster Step: (between frames)'};
    dlg_dims = [1 50];
    definput = {'100', '2'};
    input_params = inputdlg(prompt,dlg_title,dlg_dims,definput,"on");

    %  Of Clusters at End of Video
    k_vid_final = str2double(input_params{1});
    % Cluster Step (between frames)
    step = str2double(input_params{2});

    % Dialog Box for Video Profile (file type)
    profiles = {'Archival','Motion JPEG AVI','Motion JPEG 2000','MPEG-4', ...
                'Uncompressed AVI','Indexed AVI','Grayscale AVI'};
    [lst_ind,~] = listdlg('PromptString', {'Select a Video File Format', '(Recommended: MPEG-4 or ','Uncompressed AVI):'}, ...
                          'SelectionMode', 'single', 'InitialValue', 4, ...
                          'ListSize',[150,100], ...
                          'ListString', profiles);
    
    % Video Profile (File Type)
    selected_profile = profiles{lst_ind};


    new_vid_name = strcat(pic_name, '__VIDEO__', num2str(k),'_clstrs', '_L', num2str(q), '_loc', num2str(loc_use), '_', num2str(loc_importance_frac), '_clstr', num2str(k_vid_final), '_step', num2str(step));
    

    % Create objects to write the video
    v_writer = VideoWriter(new_vid_name, selected_profile);
    % Make frame rates equal
    v_writer.FrameRate = 24;
    % Open the video file for writing
    open(v_writer);


    % Width & Height
    %v_width = v_reader.Width;
    %v_height = v_reader.Height;

    % Preallocate
    frame = zeros(size(im));    % new frame size

    % Create new video
    for fNum = [1:9, 10:step:k_vid_final]
        fprintf("\nFrame %d", fNum);

        frame = kMeans_Image(im, fNum, components_use, loc_use, loc_importance_frac, wrt_toggle, plt_toggle, max_iter);
    
        % write new frame to new video
        writeVideo(v_writer, frame);
    
    end
    
    close(v_writer); % close the new video file
    
    fprintf("\n>>> DONE <<<\n")

end
