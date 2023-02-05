% Function to generate 3 gaussian clusters of points in 2d space

function [data123,labels] = gaussData(clstr_pts, mu1, mu2, mu3, v1, v2, v3)
    %{
    clstr_pts = # of points per cluster
    mu1 = cluster 1 center
    mu2 = cluster 2 center
    mu3 = cluster 3 center
    %}

    % Generate Gaussian Data
    
    % Cluster 1
    cov1 = v1 * eye(2);
    data1 = mvnrnd(mu1,cov1,clstr_pts);
    
    % Cluster 2
    cov2 = v2 * eye(2);
    data2 = mvnrnd(mu2,cov2,clstr_pts);
    
    % Cluster 3
    cov3 = v3 * eye(2);
    data3 = mvnrnd(mu3,cov3,clstr_pts);
    
    % Training Data of All 3 Clusters
    data123 = [data1; data2; data3];
    
    % Training Cluster Labels
    labels = [1*ones(clstr_pts,1); 2*ones(clstr_pts,1); 3*ones(clstr_pts,1)];
    
    %{
    figure('Name', '3.2 (A): Synthetic training set generation (Training Data)')
    
    gscatter(data123(:,1), data123(:,2), y_clstr, 'rgb', 'o')
    title('Training Data (3 colored Clusters)')
    xlabel('Feature 1')
    ylabel('Feature 2')
    %}

end