% K-MEANS IMAGE GENERATOR FUNCTION


function im_clustered = kMeans_Image(im, k, components_use, loc_use, loc_importance_frac, wrt_toggle, plt_toggle, max_iter)

    % >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%~
    %% CLUSTERING
    
    % Set reshaped image dimensions based on color of grayscale original
    % color
    if ( length(size(im)) ~= 2 )
        dim_im_color = size(im,3);
    % grayscale
    else
        dim_im_color = 1;
    end
    
    % If Pixel Location is Being Used for Clustering
    if (loc_use == 1)
        % Create coordiante grids for pixel location values
        [X,Y] = meshgrid(1:size(im,2),1:size(im,1));

        % Adjust Scale of Coordinates 
        % (based on location importance fraction parameter)
        X = X * loc_importance_frac;
        Y = Y * loc_importance_frac;
    
        % Concatenate X & Y values to each pixel
        im_mod = cat(3,double(im),X,Y);
        % Update pixel dimension
        dim_im_pxl = dim_im_color + 2;
    else
        im_mod = double(im);
        dim_im_pxl = dim_im_color;
    end
    
    % Reshape Image: 
    % pixels -> rows, color brightness value(s) -> column(s)
    im_reshape = double(reshape(im_mod,[], dim_im_pxl));
    
    
    % Initialize Means ~~~~~~
    means_init = zeros(k,size(im_reshape,2)); % preallocate
    % For each cluster . . .
    for ik = 1:k
        % Choose a random pixel as an initial mean
        means_init(ik,:) = im_reshape(randi([1,length(im_reshape)]), :);
    end
    
    
    % Preallocate
    means = zeros(k, dim_im_color);
    labels = zeros(size(im_reshape,1), dim_im_color);
    
    % If color components are used seperately AND locations are not used. . .
    if ((components_use == 0) && (loc_use == 0))
        % For each component of color . . .
        for i = 1:dim_im_color
            % Calculate Clusters
            [labels(:,i), means(:,i)] = kmeans(im_reshape(:,i), k, 'MaxIter', max_iter);
        end
    %~
    % If all color components are used together AND locations are not used . . .
    elseif ((components_use == 1) && (loc_use == 0))
        % Calculate Clusters
        [labels, means] = kmeans(im_reshape, k, 'MaxIter', max_iter);
        labels = repmat(labels,1,3);
    %~
    % If all color components are used seperately AND locations are used . . .
    elseif ((components_use == 0) && (loc_use == 1))
        % For each component of color . . .
        for i = 1:dim_im_color
            % i color index, x index, y index
            i_xy = [i,dim_im_pxl-1,dim_im_pxl];
            % Calculate Clusters
            [la, me] = kmeans(im_reshape(:,i_xy), k, 'MaxIter', max_iter);
            means(:,i) = me(:,1);
            labels(:,i) = la;
        end
    %~
    % If all color components are used together AND locations are used . . .
    elseif ((components_use == 1) && (loc_use == 1))
        % Calculate Clusters
        [la, me] = kmeans(im_reshape, k, 'MaxIter', max_iter);
        means = me(:, 1:dim_im_color);
        labels = repmat(la,1,3);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%~
    %% NEW IMAGE
    
    %fprintf("\nArranging New Custered Image . . .\n")
    
    im_clustered = zeros(size(im,1), size(im,2), dim_im_color);
    label2mean = zeros(size(im_reshape,1), dim_im_color);
    label_inds = logical(zeros(size(im_reshape,1), k, dim_im_color));
    
    % Create Clustered Image
    for i = 1:dim_im_color
        [im_clustered(:,:,i), label2mean(:,i), label_inds(:,:,i)] = clstr_im_maker(means(:,i), labels(:,i), k, im_reshape(:,i), size(im(:,:,i)));
    end
    
    im_clustered = uint8(im_clustered);
    
    %fprintf("Done\n")
    

    if (wrt_toggle == 1)
        % Write
        clstr_im_name = strcat(pic_name, '__', num2str(k),'_clstrs', '_L', num2str(q), '_loc', num2str(loc_use),'.', file_type);
        fprintf(strcat("\nWriting ",clstr_im_name, " to file"))
        imwrite(im_clustered, clstr_im_name)
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%~
    %% PLOTS
    
    if (plt_toggle == 1) % if you choose to plot . . .
    
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
            if (components_use == 1)
                plt_clr = means / 255;
                % Plot each cluster with the mean value as its color
                subplot(2,3,[1,2,3])
                for i = 1:k
                     %repmat((means(i)/256),1,3);
                    % Plot only this group:
                    scatter3(im_reshape(label_inds(:,i),1), ...
                      im_reshape(label_inds(:,i),2), ...
                      im_reshape(label_inds(:,i),3), ...
                      [],plt_clr(i,:),'o');
                    hold on;
                end
                fprintf("*")
            elseif (components_use == 0)
                % Plot each cluster with the mean value as its color
                % For each component (color RGB) of the pixel value
                for c = 1:dim_im_color
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
    
    end
    
    
    
    %fprintf("\nDone!!!   ~('o')~\n--------------------\n")
end