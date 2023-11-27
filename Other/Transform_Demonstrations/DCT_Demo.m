% DCT Demonstration

% im = double(imread('C:\Users\maxba\Desktop\Mind Space Presentation\Pix\Domestic-Cat_SQUARE_346x346.jpg'));
% im = double(imread('C:\Users\maxba\Desktop\Mind Space Presentation\Pix\uniform_noise_rgb_mean0.6_var0.1_346x346.png'));
% im = double(imread('C:\Users\maxba\Desktop\Mind Space Presentation\Pix\DSC_0670 346x345.png'));
% im = double(imread('C:\Users\maxba\Desktop\Mind Space Presentation\Pix\moon.jpg'));
% im = double(imread('C:\Users\maxba\Desktop\Mind Space Presentation\Pix\DrCostanza_30x30.png'));
im = double(imread('C:\Users\maxba\Desktop\Mind Space Presentation\Pix\eyeball.jpg'));
im = imresize(im, [21,35]);

p = 1;

[im_new(:,:,1), im_dct_new(:,:,1)] = Discrete_Cosine_Tranform_NoName_JustCoeffs(im(:,:,1), p);
[im_new(:,:,2), im_dct_new(:,:,2)] = Discrete_Cosine_Tranform_NoName_JustCoeffs(im(:,:,2), p);
[im_new(:,:,3), im_dct_new(:,:,3)] = Discrete_Cosine_Tranform_NoName_JustCoeffs(im(:,:,3), p);

figure();
imshow(im_new);


% figure();
% 
% n =64;
% dim = ceil(sqrt(n));
% value = sum(im_dct_new,"all");
% i = 1;
% tiledlayout(dim,dim, "TileSpacing","none", "Padding","tight");
% for r = 1:dim
%     for c = 1:dim
%         coefs = zeros(size(im_dct_new(:,:,1)));
%         coefs(r,c) = value/700;
%         basis = idct2(coefs);
% 
% %         subplot(dim,dim,((r-1)*dim) + c);
%         nexttile;
%         imshow(basis);
% %         title(sprintf("Basis (%i, %i)", r, c));
%         disp(i); i = i + 1;
%     end
% end


n = round( 1 * (size(im,1) * size(im,2)));
dim = ceil(sqrt(n));
value = sum(im_dct_new,"all");
i = 1;
basis = zeros([size(im_dct_new), dim^2]);
basis_neg = basis; basis_pos = basis;
% tiledlayout(dim,dim, "TileSpacing","none", "Padding","tight");
% max_coef = max(im_dct_new,[],"all");
for rgb = 1:3
    for r = 1:dim
        for c = 1:dim
            max_im_dim = max(size(im,1), size(im,2));
            if (r <= size(im,1)) && (c <= size(im,2))
                coefs = zeros(size(im_dct_new(:,:,rgb)));
                coef4basis = im_dct_new(r,c,rgb);
                coefs(r,c) = coef4basis;
                basis(:,:,rgb, i) =  idct2(coefs);
    
                basis_sign = sign(coef4basis);
    
                if basis_sign < 0
                    basis_neg(:,:,rgb,i) = basis(:,:,rgb, i);
                else
                    basis_pos(:,:,rgb,i) = basis(:,:,rgb, i);
                end
                
            end
            i = i + 1;
        end
    end
    i = 1;
end
max_coef = max(basis,[],"all");
min_coef = min(basis,[],"all");

norm_basis = abs(basis)/max(abs(max_coef), abs(min_coef));
nonLinearScaled_norm_basis = real(norm_basis .^ (0.5));
% montage(log((exp(1)*(basis(:,:,:,1)/max_coef)) + 1), 'BorderSize',1, 'BackgroundColor',[1,0,0]);

figure('Name', 'DCT Basis Images')
subplot(1,2,1)
basis_pos_norm = basis_pos / max(abs(basis),[],"all");
basis_pos_norm_NLscale = real(basis_pos_norm .^ 0.5);
montage(basis_pos_norm_NLscale, 'BorderSize',1, 'BackgroundColor',[1,0,0]);
title(sprintf("Basis Images (Positive Coefficients) (1st %i)", dim^2));

subplot(1,2,2)
basis_neg_norm = basis_neg / max(abs(basis),[],"all");
basis_neg_norm_NLscale = real(basis_neg_norm .^ 0.5);
montage(basis_neg_norm_NLscale, 'BorderSize',1, 'BackgroundColor',[1,0,0]);
title(sprintf("Basis Images (Negative Coefficients) (1st %i)", dim^2));
