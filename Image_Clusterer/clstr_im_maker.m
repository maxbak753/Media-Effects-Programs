

function [im_clustered, label2mean, label_inds] = clstr_im_maker(means, labels, k, im_reshape, OG_dim)
    %{
    means       = cluster means
    labels      = cluster label index
    k           = # of intended clusters
    im_reshape  = matrix: row <-> pixel, column <-> pixel value
    OG_dim      = dimsensions of original image
    %}
    
    % Create Matrix of Where each label indeces are: ~ ~ ~ ~ ~
    % Row: datapoint
    % Column: Label
    % Element: logical 0 or 1 for a label of a datapoint
    label_inds = zeros(size(labels,1), k);  % preallocate
    for i = 1:k
        label_inds(:,i) = (labels == i);
    end
    label_inds = logical(label_inds);   % Convert to logical datatype
    
    % Make a mapping of pixels to mean values
    label2mean = zeros(size(im_reshape));   % preallocate
    for i = 1:k
        label2mean(label_inds(:,i), :) = repmat(means(i,:), sum(label_inds(:,i)), 1);
    end
    
    % Create New Clustered Version of the Image
    im_clustered = reshape(label2mean, OG_dim);
end