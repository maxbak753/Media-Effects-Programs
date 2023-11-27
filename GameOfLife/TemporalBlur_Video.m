% Temporal Blur / Reverb

fprintf("Temporal Reverb for Video\n");
start_dt = datetime;
fprintf("Start:\t%s\n", start_dt);

% Create objects to read and write the video
vid_name = 'C:\Users\maxba\Desktop\GameOfLife\jellyfish_GOL20iter.avi';
video_r = VideoReader(vid_name);
video_fileName = 'jellyfish_GOL20iter_tverb10';
video_w = VideoWriter(video_fileName, 'Uncompressed AVI'); 
% Make frame rates equal
video_w.FrameRate = video_r.FrameRate;
% Open the file for writing
open(video_w);

% Width & Height
v_width = video_r.Width;
v_height = video_r.Height;

rows = v_height; %size(im,1);
cols = v_width; %size(im,2);


i = 0;
while hasFrame(video_r)
    i = i + 1;
    
    % get current frame
    f = readFrame(video_r);
    % re-scale
%     f = double(f / max(f,[],"all"));

    % add to list of frames
    f_list(i).frame = f;

%     % write image to video frame
%     writeVideo(video_w, f);
end

%%
filt_len = 10;

x = 1:filt_len; 
x_ = x .^ 4;
coefs = flip( x_ / sum(x_) );

% coefs(1) = 1;

% coefs = flip(1:filt_len);
% coefs = coefs / sum(coefs);

for i_f = 1:i
    
    bb = min(i_f-1, filt_len-1);
    
    if bb > 0
        f_sums = coefs(1) * f_list(i_f).frame;
        for i_ff = 2:bb
            f_sums = f_sums + ( coefs(i_ff) * f_list(i_f - i_ff + 1).frame );
        end
    else
        f_sums = coefs(1) * f_list(i_f).frame;
    end

    % write image to video frame
    writeVideo(video_w, f_sums);

end



close(video_w); % close the video file

end_dt = datetime;
fprintf("End:\t%s\n", end_dt);
duration = end_dt - start_dt;
fprintf("Duration:\t%s\n", duration);
