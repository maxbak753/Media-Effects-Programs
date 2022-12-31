% k-Means Clustering: FUNCTION
% Max Bakalos
% 10/4/2022

function [means_current, cluster_labels, WCSS, iteration] = kMeans(k, q, convergence_threshold, data, means_initial)
    %% Description
    %{

    k = # of desired clusters
    
    q = norm distance exponent value (Lq norm)
    
    convergence_threshold = the maximum movement of cluster means over an
                            iteration for it to be cinsidered converged
    
    data = matrix where each row is a datapoint & each column is a feature
    
    means_initial = the initial means for the k-means clustering algorithm,
                    where each row is a mean and each column is the x or y 
                    value of the mean (the number of rows should equal k)

    %}
    %% Initializations ----------------
    
    fprintf(strcat("\nk-Means -> k = ", num2str(k), "\n"))    % display Start

    
    iteration = 0;          % iteration counter
    summing_mat = ones(size(means_initial,2),1);    % matrix used to sum for L2 norm
    dist_Qed = zeros(size(data)); % (dist(xj,ul))^q with l columns and j rows
    
    % Cluster Means
    means_previous = means_initial;
    means_current = means_initial;
    
    % Cluster Labels
    cluster_labels = ones(length(data), 1);  % cluster label for each datapoint
    
    % Convergence Criteria
    converged = 0;

    % Algorithm
    while (converged==0)
        iteration = iteration + 1;              % update counter
        %fprintf('Iteration: %d\n',iteration)    % display iteration
    
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % Assign each data observation to the cluster with the nearest mean
    
        % For each Cluster . . .
        for i = 1:k
            % compute the (Lq norm distance)^q to each training sample
            dist_Qed(:,i) = (abs(data - means_current(i,:)).^q) * summing_mat;
        end
        
        % Find the cluster label of the smallest distance value in each row
        [~, cluster_labels] = min(dist_Qed,[],2);
    
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % Mean Updating - Update the cluster means

        % For each Cluster . . .
        for i = 1:k
            % if the cluster isn't empty
            if (sum(cluster_labels == i) >= 1)
                % Calculate new (current) cluster means
                % If L2 Euclidean distance -> use sample mean
                if (q==2)
                    means_current(i,:) = mean(data(cluster_labels==i));
                % If L1 Manhattan distance -> use median
                elseif (q==1)
                    means_current(i,:) = median(data(cluster_labels==i));
                end
            end
        end
    
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % Check for convergence 
        
        % If each mean changes by less than the convergence threshold . . .
        if ((((means_current - means_previous).^q)*summing_mat) < convergence_threshold)
            % It has converged
            converged = 1;
        end
        
        % Update previous mean to current mean for next iteration
        means_previous = means_current;
        
    end

    % Notify user if it converged
    if (converged == 1)
        fprintf(strcat("Iterations: ", num2str(iteration), "\nConverged!\n"))
    end

    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % Calculate WCSS (Within-Cluster Sum of Squares)

    % Preallocate / Initialize
    WCSS = 0;

    % For each cluster
    for i = 1:k
        % Sum all the distances from all the cluster points to the mean
        WCSS = WCSS + sum(dist_Qed(cluster_labels==i, i));
    end


end