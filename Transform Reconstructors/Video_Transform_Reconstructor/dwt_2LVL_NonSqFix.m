% EC520
% Homework Assignment #9
% Function Module

% 2-level discrete wavelet transform
function [im_dwt_reconst_LVL2, lvl2_Decomp_new] = dwt_2LVL_NonSqFix(im_n, p, wname)

    arguments
        im_n    (:,:)   double
        p       (1,1)   double
        wname   (1,:)   string
    end
    
    % DECOMPOSE IMAGE ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
    
    height = size(im_n,1);    % # of rows in image
    width = size(im_n,2);     % # of columns in image
    
    % Lowpass & Highpass to dwt
    [LoD_1,HiD_1] = wfilters(wname,'r');
    
    % 1st Level - - - - - - - - - - - - - - -
    [cA1,cH1,cV1,cD1] = dwt2(im_n, LoD_1, HiD_1, 'mode', 'per');
    % 1st level dimensions
    h_LVL1 = size(cA1,1); w_LVL1 = size(cA1,2); 
    
    % 2nd Level - - - - - - - - - - - - - - -
    [cA2,cH2,cV2,cD2] = dwt2(cA1, LoD_1, HiD_1, 'mode', 'per');
    % 2nd level dimensions
    h_LVL2 = size(cA2,1); w_LVL2 = size(cA2,2); 

    
    % Put everything into one matrix image ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
    lvl2_Decomp = zeros(h_LVL1*2, w_LVL1*2);    % preallocate

    % Top Left
    lvl2_Decomp(1:h_LVL2, 1:w_LVL2) = cA2;
    lvl2_Decomp(1:h_LVL2, w_LVL2+1:w_LVL2*2) = cH2;
    lvl2_Decomp(h_LVL2+1:h_LVL2*2, 1:w_LVL2) = cV2;
    lvl2_Decomp(h_LVL2+1:h_LVL2*2, w_LVL2+1:w_LVL2*2) = cD2;
    
    % Top Right
    lvl2_Decomp(1:h_LVL1, w_LVL1+1:w_LVL1*2) = cH1;
    
    % Bottom Left
    lvl2_Decomp(h_LVL1+1:h_LVL1*2, 1:w_LVL1) = cV1;
    
    % Bottom Right
    lvl2_Decomp(h_LVL1+1:h_LVL1*2, w_LVL1+1:w_LVL1*2) = cD1;
    

    %{
    ii. Keep p% of the largest-energy coefficients among all 7 bands 
    (not in each band separately) unchanged and set the remaining 
    ones to zero.
    %}
    
    % CALCULATE THRESHOLDED IMAGE MATRIX ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
    
    % reshape 2D array of squared coefficients into 1-D vector
    % & order the coefficients
    lvl2_Decomp_sqr = lvl2_Decomp .^ 2;
    lvl2_Decomp_v = sort( reshape(lvl2_Decomp_sqr,1,[]), 'descend');

    % # of dwt coefficients
    coef_amt = size(lvl2_Decomp_v,2);
    % # of dwt coefficients to keep
    coef_keep_amt = p * coef_amt;

    threshold = lvl2_Decomp_v(1, ceil(coef_keep_amt));

    %preallocate
    lvl2_Decomp_new = lvl2_Decomp;
    % set im_dct_new to 0 when coefficient isnt't within the threshold
    for r = 1:height
        for c = 1:width
            if (lvl2_Decomp_sqr(r,c) < threshold)
                lvl2_Decomp_new(r,c) = 0;
            end
        end
    end
    
    
    %{
    iii. Apply 2-D, two-level inverse “Haar” DWT with periodization mode 
    “per” (idwt2) to the truncated coefficient array.
    %}
    
    % Extract pieces of matrix of all images ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
    % top left
    cA2_inv = lvl2_Decomp_new(1:h_LVL2, 1:w_LVL2);
    cH2_inv = lvl2_Decomp_new(1:h_LVL2, w_LVL2+1:w_LVL2*2);
    cV2_inv = lvl2_Decomp_new(h_LVL2+1:h_LVL2*2, 1:w_LVL2);
    cD2_inv = lvl2_Decomp_new(h_LVL2+1:h_LVL2*2, w_LVL2+1:w_LVL2*2);
    
    % top right
    cH1_inv = lvl2_Decomp_new(1:h_LVL1, w_LVL1+1:w_LVL1*2);
    
    % bottom left
    cV1_inv = lvl2_Decomp_new(h_LVL1+1:h_LVL1*2, 1:w_LVL1);
    
    % bottom right
    cD1_inv = lvl2_Decomp_new(h_LVL1+1:h_LVL1*2, w_LVL1+1:w_LVL1*2);
    
    
    % RECONTRUCT IMAGE ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
    
    % Lowpass & Highpass to reconstruction
    [LoD_2,HiD_2] = wfilters(wname,'d');
    
    % 1st level inverse DWT
    cA1_inv = idwt2(cA2_inv, cH2_inv, cV2_inv, cD2_inv, ...
                                        LoD_2, HiD_2, 'mode', 'per');
    % 2nd level inverse DWT
    im_dwt_reconst_LVL2 = idwt2(cA1_inv(1:size(cH1_inv,1),1:size(cH1_inv,2)), cH1_inv, cV1_inv, cD1_inv , ...
                                        LoD_2, HiD_2, 'mode', 'per');
    

end