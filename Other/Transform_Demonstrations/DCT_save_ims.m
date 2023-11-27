dimzP = size(basis_pos_norm_NLscale);
dimzN = size(basis_neg_norm_NLscale);

% im_name = "eyeball_dct";

folder = "DCTbases_21x35";
mkdir(folder);
cd(folder);
% %%
% for ip = 1:dimzP(4)
%     file_name = sprintf("%s__%i.png", im_name, ip);
%     imwrite(basis_pos_norm_NLscale(:,:,:,ip), file_name);
% end
% 
% cd("..");


%%

idn_sumAll = sum(abs(im_dct_new),3);

idnsa_vec = reshape(idn_sumAll, 1, numel(idn_sumAll));

[sort_idnsav, i_s_idnsav] = sort(idnsa_vec,'descend');

sorted_indeces_2d = reshape(i_s_idnsav, dimzP(1), dimzP(2));

X = meshgrid(1:dimzP(1), 1:dimzP(2))';
Y = meshgrid(1:dimzP(2), 1:dimzP(1));

X_vec = reshape(X, 1, numel(idn_sumAll));
Y_vec = reshape(Y, 1, numel(idn_sumAll));

X_vec_sort = X_vec(i_s_idnsav);
Y_vec_sort = Y_vec(i_s_idnsav);

file_name = "Eye_DCT";
im_recreated_check = zeros(size(im));

for i_s = 1:length(Y_vec_sort)
    c_ = Y_vec_sort(i_s);
    r_ = X_vec_sort(i_s);

    coef = im_dct_new(r_,c_);
        if coef < 0
            im_sorted = basis_neg_norm_NLscale(:,:,:,((r_-1)*dim) + c_);
            basis_4sum = basis_neg(:,:,:,((r_-1)*dim) + c_);
            sign_4sum = -1;
        else
            im_sorted = basis_pos_norm_NLscale(:,:,:,((r_-1)*dim) + c_);
            basis_4sum = basis_pos(:,:,:,((r_-1)*dim) + c_);
            sign_4sum = 1;
        end
%         sorted_index = sorted_indeces_2d(r_,c_);
        im_title = sprintf("%s__%i__(%i,%i)__%.3fcoef.png", file_name, i_s, r_,c_, coef);
        imwrite(im_sorted, im_title);


        % Create Image
        im_recreated_check = basis_4sum + im_recreated_check;
        imwrite(rescale(im_recreated_check), sprintf("[%i Bases] Recreation.png", i_s));
    
end

% 
% for c_ = 1:dim
%     for r_ = 1:dim
%         if (r_ <= size(im,1)) && (c_ <= size(im,2))
%             
%             coef = im_dct_new(r_,c_);
%             if coef < 0
%                 im_sorted = basis_neg_norm_NLscale(:,:,:,((r_-1)*dim) + c_);
%                 basis_4sum = basis_neg(:,:,:,((r_-1)*dim) + c_);
%                 sign_4sum = -1;
%             else
%                 im_sorted = basis_pos_norm_NLscale(:,:,:,((r_-1)*dim) + c_);
%                 basis_4sum = basis_pos(:,:,:,((r_-1)*dim) + c_);
%                 sign_4sum = 1;
%             end
%             sorted_index = sorted_indeces_2d(r_,c_);
%             im_title = sprintf("%s__%i__(%i,%i)__%.3fcoef.png", file_name, sorted_index, r_,c_, coef);
%             imwrite(im_sorted, im_title);
%     
%     
%             % Create Image
%             im_recreated_check = basis_4sum + im_recreated_check;
%             imwrite(rescale(im_recreated_check), sprintf("[%i Bases] Recreation.png", sorted_index));
%         end
%     end
% end

figure();
subplot(2,1,1);
imshow(rescale(idn_sumAll), 'Colormap',hot);
title("Linearly Scaled Transform Coefficient Map")
subplot(2,1,2);
imshow(real(rescale(idn_sumAll) .^ 0.35), 'Colormap',hot);
title("Non-Linearly Scaled Transform Coefficient Map")

figure();
imshow(rescale(im_recreated_check));

cd("..");
