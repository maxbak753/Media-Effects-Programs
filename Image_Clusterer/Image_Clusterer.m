% Image Clusterer

clear; close all;

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
    'Toggle: use pixel components seperately or together (color images): (0 -> together, 1 -> seperate)' ...
    'Image File Type Extension:'};
dims = [1 60];
definput = {'3','2','0.025','1','png'};
input_params = inputdlg(prompt,dlg_title,dims,definput,"on");

% # of Clusters to Find
k = str2double(input_params{1});

% Distance Metric (Lq Norm Distance)
q = str2double(input_params{2});

% How low a change in cluster center position has to be
% to be considered converged
convergence_threshold = str2double(input_params{3});

% Toggle FOr USing all RGB components spereately or together 
% (0 -> together, 1 -> seperate)
components_use = str2double(input_params{4});

% Image File Type Extension:
file_type = input_params{5};

% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%~
%% CLUSTERING

% Adapt reshaped image based on color of grayscale original
if ( length(size(im)) ~= 2 )
    dim_im = size(im,3);
    im_reshape = double(reshape(im,[], dim_im));
else
    dim_im = 1;
    im_reshape = double(reshape(im,[], dim_im));
end

if (components_use == 0)
    dim_im = 1;
end

means_init = zeros(k,size(im_reshape,2));

for i = 1:k
    means_init(i,:) = im_reshape(randi([1,length(im_reshape)]));
end

% Preallocate
means = zeros(k, dim_im);
labels = zeros(size(im_reshape,1), dim_im);
% Calculate Clusters
for i = 1:dim_im
    [means(:,i), labels(:,i), ~, ~] = kMeans(k, q, convergence_threshold, im_reshape(:,i), means_init(:,i));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%~
%% NEW IMAGE

fprintf("\nArranging New Custered Image . . .\n")

im_clustered = zeros(size(im,1), size(im,2), dim_im);
label2mean = zeros(size(im_reshape,1), dim_im);
label_inds = logical(zeros(size(im_reshape,1), k, dim_im));

for i = 1:dim_im
    [im_clustered(:,:,i), label2mean(:,i), label_inds(:,:,i)] = clstr_im_maker(means(:,i), labels(:,i), k, im_reshape(:,i), size(im(:,:,i)));
end

im_clustered = uint8(im_clustered);

fprintf("Done\n")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%~
%% PLOTS
fprintf('\nCreating Plots & Display . . .\n')
figure('Name','Image Custering')

plot_title = strcat("k-Means Clusters, k = ", num2str(k), ", L", num2str(q), " Norm Distance");

% Plot Pixel showing cluster groups ~ ~ ~ ~ ~

if ( length(size(im)) ~= 2 ) % If it is a color image . . .
    % PRE-PLOT Calculations
    unique_labels = unique(labels);
    clstr_amt = length(unique_labels); % # of umempty clusters
    plot_colors = [hsv(k);[0,0,0]]; % Unique color for each cluster & color of means (black)

    % IF Actual # of Clusters < Input # of Clusters . . .
    if (clstr_amt < k)
        fprintf("\n{|||}! Actual # of Clusters < Input # of Clusters !{|||}\n")
        % Plot any unknown label datapoints (could be none)
        not_lbl_inds = not(sum(label_inds,2));
        scatter3(im_reshape(not_lbl_inds,1), ...
              im_reshape(not_lbl_inds,2), ...
              im_reshape(not_lbl_inds,3), '*');
    end

    % PLOT pixels by each cluster
    if (components_use == 0)
        % Plot each cluster with the mean value as its color
        subplot(2,3,[1,2,3])
        for i = 1:k
            plt_clr = repmat((means(i)/256),1,3);
            % Plot only this group:
            scatter3(im_reshape(label_inds(:,i),1), ...
              im_reshape(label_inds(:,i),2), ...
              im_reshape(label_inds(:,i),3), ...
              [],plt_clr,'o');
            hold on;
        end
        fprintf("*")
    elseif (components_use == 1)
        % Plot each cluster with the mean value as its color
        % For each component (color RGB) of the pixel value
        for c = 1:dim_im
            subplot(2,3,c)
            for i = 1:k
                plt_clr = zeros(1,3);
                plt_clr(1,c) = means(i,c)/256;
                % Plot only this group:
                scatter3(im_reshape(label_inds(:,i,c),1), ...
                  im_reshape(label_inds(:,i,c),2), ...
                  im_reshape(label_inds(:,i,c),3), ...
                  [],plt_clr,'o');
                hold on;
            end
            % PLOT cluster means
            scatter3(means(:,1), means(:,2), means(:,3), 'square', ...
                'MarkerEdgeColor','red','MarkerFaceColor',[1, 0.7, 0.7]);
            hold off;
        
            % Text (for plot)
            %legend_list = [string(num2cell(transpose(unique_labels))),"Cluster Means"];
            %legend(legend_list)
            title(plot_title)
            xlabel('Pixel Value 1 (Red)')
            ylabel('Pixel Value 2 (Green)')
            zlabel('Pixel Value 3 (Blue)')

            fprintf("*")
        end
    end
    
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
else % If it is black & white . . .
    % PLOT pixels vs cluster labels and color each point by its output
    % value
    subplot(2,3,[1,2,3])
    for i = 1:k
        plt_clr = repmat((means(i)/256),1,3);
        scatter(im_reshape(label_inds(:,i)), label2mean(label_inds(:,i)), 'MarkerEdgeColor', plt_clr, 'LineWidth', 1)
        hold on;
    end
    % PLOT cluster means
    plot(means, means, 'hexagram', 'MarkerSize',13,...
    'MarkerEdgeColor','red',...
    'MarkerFaceColor',[1, 0.7, 0.7]);
    hold off;
    % Text (for plot)
    title(plot_title)
    xlabel('Input Pixel Value')
    ylabel('Output Pixel Value')

    fprintf("*")
end

% Display Clustered Image ~ ~ ~ ~ ~
fprintf("*")
subplot(2,3,[4,5])
imshow(im_clustered)
title('Clustered Image')

% Display Original Image ~ ~ ~ ~ ~
fprintf("*")
subplot(2,3,6)
imshow(im)
title('Original Image')

% Write
clstr_im_name = strcat(pic_name, '__', num2str(k),'_clstrs', '_L', num2str(q),'.', file_type);
fprintf(strcat("\nWriting ",clstr_im_name, " to file"))
imwrite(im_clustered, clstr_im_name)

fprintf("\nDone!!!   ~('o')~\n--------------------\n")