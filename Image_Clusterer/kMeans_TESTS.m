% kMeans Clustering Tests

clstr_pts = 30;

mu1 = [1,2];
mu2 = [24,5];
mu3 = [13,39];

v1 = 0.2;
v2 = 0.5;
v3 = 0.7;

[data123, labels] = gaussData(clstr_pts, mu1, mu2, mu3, v1, v2, v3);

subplot(2,2,1)
gscatter(data123(:,1), data123(:,2), labels)
title("3 Gaussian Clusters of 2D Data")


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS

k = 3;  % # of clusters
q = 2;  % distance metric Lq
convergence_threshold = 100;

means_initial = zeros(k, size(data123,2)); % preallocate
% For each cluster . . .
for ik = 1:k
    % Choose a random pixel as an initial mean
    means_initial(ik,:) = data123(randi([1,size(data123,1)]), :);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% MATLAB's Function
[idx,C] = kmeans(data123, k);

subplot(2,2,2)
gscatter(data123(:,1), data123(:,2), idx)
title("Predicted Clusters: kmeans() MATLAB")


% My Function
[means_current, cluster_labels, ~,~] = kMeans(k, q, convergence_threshold, data123, means_initial);

subplot(2,2,3)
gscatter(data123(:,1), data123(:,2), cluster_labels)
title("Predicted Clusters: kmeans() MATLAB")