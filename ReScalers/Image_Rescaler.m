% Image Rescaler
% 11/1/2022

tic % timer start

% Select original video file
[im_name,path] = uigetfile('*.*');

% Dialog Box for Input Parameters
dlg_title = 'Image Rescaler Input Parameters';
prompt = {'Upscale Amount:', 'Image File Type Extension:'};
dlg_dims = [1 40];
definput = {'5','png'};
opts.Resize = 'on';
input_params = inputdlg(prompt,dlg_title,dlg_dims,definput,opts);

% Upscale Amount
upscale_amt = str2double(input_params{1});

% File Type
file_type = input_params{2};

% New video name
new_im_name = strcat(im_name, '__upX', num2str(upscale_amt), '.', file_type);
fprintf(strcat("\nCreating ", new_im_name, " . . .\n"))

im = imread(strcat(path,im_name));

dim = size(im);

if size(dim,2) == 3 % Color
    im_rescaled = zeros(upscale_amt*dim(1), upscale_amt*dim(2), dim(3));

    % Fill in new frame with values of old frame pixels
    for r = 1:dim(1)
        for c = 1:dim(2)
            for rgb = 1:3
                im_rescaled((((upscale_amt*(r - 1))+1):((upscale_amt*(r - 1))+upscale_amt)), ...
                               (((upscale_amt*(c - 1))+1):((upscale_amt*(c - 1))+upscale_amt)), ...
                               rgb) = im(r,c,rgb);
            end
        end
    end

elseif size(dim,2) == 2 % Grayscale
    im_rescaled = zeros(upscale_amt*dim(1), upscale_amt*dim(2));

    % Fill in new frame with values of old frame pixels
    for r = 1:dim(1)
        for c = 1:dim(2)
            im_rescaled((((upscale_amt*(r - 1))+1):((upscale_amt*(r - 1))+upscale_amt)), ...
                           (((upscale_amt*(c - 1))+1):((upscale_amt*(c - 1))+upscale_amt))) ...
                            = im(r,c);
        end
    end

end

% Convert to uint8
im_rescaled = uint8(im_rescaled);

% Display
subplot(1,2,1)
imshow(im)
subplot(1,2,2)
imshow(im_rescaled)

% Write
imwrite(im_rescaled,new_im_name)

toc % timer end
