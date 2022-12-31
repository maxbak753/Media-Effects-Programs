% EC520
% Homework Assignment #9
% Function Module

function [im_new, im_dct_new] = Discrete_Cosine_Tranform_NoName(im, p)
    
    arguments
        im  (:,:)   double
        p   (1,1)   double
    end

    % (a) DCT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % Read Image - - - - - - - - - - - - - - - - -
    height = size(im,1);          % # of rows in image
    width = size(im,2);           % # of columns in image
    
    % i) Apply 2-D DCT (dct2) to the complete image (not block-by-block) ~
    im_dct = dct2(im);
    

    % ii) Keep p% of the largest-energy coefficients (squared value) ~ ~ ~
    % unchanged & set the remaining ones to zero

    % reshape 2D array of squared coefficients into 1-D vector
    % & order the coefficients
    im_dct_sqr = im_dct .^ 2;
    im_dct_v = sort( reshape(im_dct_sqr, 1, []) ,  'descend' );

    % # of dct coefficients
    coef_amt = size(im_dct_v,2);
    % # of dct coefficients to keep
    coef_keep_amt = p * coef_amt;

    threshold = im_dct_v(1, ceil(coef_keep_amt));

    %preallocate
    im_dct_new = im_dct;
    % set im_dct_new to 0 when coefficient isnt't within the threshold
    for r = 1:height
        for c = 1:width
            if (im_dct_sqr(r,c) < threshold)
                im_dct_new(r,c) = 0;
            end
        end
    end

    % iii) Apply 2-D inverse DCT (idct2) to the partially-zeroed ~ ~ ~ ~ ~
    % coefficient array. This results in an approximate image

    im_new = rescale( idct2(im_dct_new) );
    
end