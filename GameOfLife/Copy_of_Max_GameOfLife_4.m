%% START

im = imresize(imread('Test_Media/moon.jpg'), [300, 300]);

% % Create objects to read and write the video
% vid_name = 'Test_Media/glassBall_sunset_480p.mp4';
% video_r = VideoReader(vid_name);
video_fileName = 'moon_temporal12_14';
video_w = VideoWriter(video_fileName, 'Uncompressed AVI'); 
% Make frame rates equal
video_w.FrameRate = 15;
% Open the file for writing
open(video_w);

rows = size(im,1);
cols = size(im,2);


% GAME_MODE = 'Max6';
ITERATIONS = 300;
% cmap = gray;%turbo;

pause_period = 0.01;

% n = 1024;
% nh = round(n/2);
% stbx = round(n/12); % size of half the start box
% 
% im = zeros(n);

% moon = imread('mid_shot.jpg');
% im = double(imresize(moon, [n,n]));
% im = im / max(im,[],"all");

% % Show og image at beginning
% for abcdefg = 1:24
%     writeVideo(video_w, im);
% end

% for color = 1:3
%     im(:,:,color) = rand(n);
% end

% USE_RGB = 1;
% if USE_RGB 
%     for color = 1:3
%         im(nh-stbx:nh+stbx, nh-stbx:nh+stbx, color) = round(rand((2*stbx)+1));
%     end
% else
%     im(nh-stbx:nh+stbx, nh-stbx:nh+stbx) = round(rand((2*stbx)+1));
% end



% Create Kernel
n_k = 10; % (this * 2) + 1 = kernel height & width
k_sz = (n_k * 2) + 1; % kernel size
X = meshgrid(-n_k:n_k);
Y = X';
XY = sqrt((X.^2) + (Y.^2)); % radial coordinate

kernel = gauss_func(XY,1,0,3) - gauss_func(XY,1,0,1);
kernel = kernel / sum(kernel,"all"); % normalize

min_bound = 0.211; %0.2;
max_bound = 0.24; %0.45;
bound_diff = max_bound - min_bound;

shx = min_bound; shy = 0.5; scale = 0.5;

set(0,'DefaultFigureWindowStyle','normal')

fig1 = figure('Name', 'Parameters');
sgtitle(sprintf("%i Total Iterations \n" + ...
    "%f Pause\n" + ...
    "%ix%i Kernel \n" , ...
    ITERATIONS, pause_period, k_sz,k_sz));
subplot(2,3,1);
imshow(kernel); title("Kernel (Raw)");
subplot(2,3,2);
imshow(kernel,[]); title("Kernel (Range Normalized)");
subplot(2,3,3);
mesh(kernel, 'FaceColor','flat', 'FaceAlpha',0.3);
title("Kernel")
subplot(2,3,[4,5,6]);
x = 0:0.01:1;
y = ( ( -cos((1/(bound_diff*2))*2*pi*(x - shx)) ) * scale ) + shy;
y(x < min_bound) = 0;
plot(x, y, 'g','LineWidth',1.5);
xline(min_bound, 'r', 'A');
xline(max_bound, 'b', 'B');
title("Decision Function"); xlabel("Kernel Sum"); ylabel("Pixel Output")

%%
% Create Figure
fig2 = figure('Name', sprintf("Max's Game of Life (%i Total Iterations)", ITERATIONS));
ax1 = axes(fig2, 'Units','normalized');
% imshow(im, 'Parent',ax1);
title(ax1, "Starting in 3 seconds ...");
ax1_pos = get(ax1, 'Position');

set(fig1, 'Units', 'Normalized', 'Position', [0, 0, 1-ax1_pos(3), 0.91]);
set(fig2, 'Units', 'Normalized', 'Position', [1-ax1_pos(3), 0, ax1_pos(3), 0.91]);
pause(2);
title(ax1, "BEGIN");
pause(1);

% im_disp = im;
im_n = zeros(rows, cols, 3);



%% LOOP

sims_per_timeUnit = 10;
t_step = 1 / sims_per_timeUnit;
other_perc = 1 - t_step;

% while hasFrame(video_r)
% get current frame
% im_disp = readFrame(video_r);
im_disp = im;
im_disp = double(im_disp);
im_disp = double(im_disp / max(im_disp,[],"all"));
for i_frame = 1:ITERATIONS
    if ishghandle(fig2)
        for rgb = 1:3
            for i_sim = 1:sims_per_timeUnit
                im_sim_step = im_disp;
                for r = n_k+1:rows-n_k
                    for c = n_k+1:cols-n_k
                        nbhd = im_disp(r-n_k:r+n_k, c-n_k:c+n_k,rgb);
                        nbhd(n_k+1,n_k+1) = 0; % point-in-question not counted
                        
                        x = sum(nbhd .* kernel, "all");
                        
                        if (x < min_bound)
%                             im_n(r,c,rgb) = 0;
                            A = 0;
                        else
                            y = ( ( -cos((1/(bound_diff*2))*2*pi*(x - shx)) ) * scale ) + shy;
%                             im_n(r,c,rgb) = y;
                            A = y;
                        end

%                         im_disp(r,c,rgb) = im_disp(r,c,rgb) + (t_step * A);
                        im_sim_step(r,c,rgb) = (other_perc * im_sim_step(r,c,rgb)) + (t_step * A);

                        % Clamp to range [0,1]
                        if im_sim_step(r,c,rgb) > 1
                            im_sim_step(r,c,rgb) = 1;
                        elseif im_sim_step(r,c,rgb) < 0
                            im_sim_step(r,c,rgb) = 0;
                        end

%                         im_disp = im_n;

                    end
                    
                end

                im_disp = im_sim_step;
            
            end
    
%             im_disp(:,:,rgb) = im_n(:,:,rgb);
    
        
        end
    
%             % Show New Turn
%             imshow(im_disp, 'Parent',ax1);
%             title(ax1, sprintf("Frame #%i", i));
%             % write image to video frame
%             writeVideo(video_w, im_disp);
%             pause(pause_period);
    else
        fprintf("[*]> Closed Figure at %i Iteratons\n", i_frame);
        break;
    end


    % Show New Frame
    imshow(im_disp, 'Parent',ax1);
    title(ax1, sprintf("Frame #%i", i_frame));
    % write image to video frame
    writeVideo(video_w, im_disp);
    pause(pause_period);

end

%     % Show New Frame
%     imshow(im_disp, 'Parent',ax1);
%     title(ax1, sprintf("Frame #%i", i_frame));
%     % write image to video frame
%     writeVideo(video_w, im_disp);
% %     pause(pause_period);
% end

close(video_w); % close the video file

fprintf("[*]> Done\n");

