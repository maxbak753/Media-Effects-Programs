% VISUAL NOISE CREATOR
% 7/10/2022
% Max Bakalos

% ********************
% PARAMETERS ************
% ***************************

% Dialog Box for Input Parameters
dlg_title = "Visual Noise Image Creator Parameters";
prompt = {'\bfImage Dimensions: \rm(space seperated values) "Horizontal Vertical"', ...
    '\bfColor Dimensions: \rm0 \rightarrow Black & White, 1 \rightarrow Color', ...
    '\bfNoise Types: \rm0 \rightarrow uniform, 1 \rightarrow gaussian', ...
    '\bfRGB Color balance: \rm(0-1 range, 1 = uniform) (space seperated values) "\color{red}Red \color{green}Green \color{blue}Blue"', ...
    '\bfMean & Variance: \rm(gaussian noise) (space seperated values) "Mean Variance"', ...
    '\bfSaturation: \rm0 \rightarrow none, 1 \rightarrow full', ...
    '\bfImage File Type Extension:'};
dlg_dims = [1,85];
definput = {'40 30','1','1','1 1 1','0.6 0.1', '0', 'tiff'};
opts.Interpreter = 'tex'; opts.Resize = 'on';
input_params = inputdlg(prompt,dlg_title,dlg_dims,definput,opts);


% Image Dimensions
dims = str2num(input_params{1});
horiz = dims(1);
verti = dims(2);

% Color Dimensions: 0 -> Black & White, 1 -> Color
bw_rgb = str2double(input_params{2});

% Noise Types - - - - - - - - - - - -
% 0 -> uniform, 1 -> gaussian
type = str2double(input_params{3});

% Color balance (0-1 range, 1 = uniform)
rgb = str2num(input_params{4});
r = rgb(1);  % red
g = rgb(2);  % green
b = rgb(3);  % blue

% Mean & Variance (gaussian noise)
mean_var = str2num(input_params{5});
mean = mean_var(1);
var = mean_var(2);
% - - - - - - - - - - - - - - - - - -

% Saturation: 0 -> none, 1 -> full
saturated = str2double(input_params{6});

% Image File Type Extension
file_type = input_params{7};

% ***************************
% PARAMETERS ************
% ********************


% Title - - -
% BW or RGB
if (bw_rgb == 0)
    bw_rgb_name = 'bw';
elseif (bw_rgb == 1)
    bw_rgb_name = 'rgb';
end
% Uniform or Gaussian
if (type == 0)
    type_name = 'uniform';
elseif (type == 1)
    type_name ='gaussian';
end
% put name together
pic_name = strcat(type_name, '_noise_', bw_rgb_name, '_mean', ...
                  num2str(mean), '_var', num2str(var), '_', ...
                  num2str(horiz), 'x', num2str(verti), '.', file_type);
% print name
fprintf(strcat(pic_name,'\n'))

% Dimensions vector
dim = [verti, horiz];
% Preallocate image
if (bw_rgb == 0)
    im = zeros(verti, horiz);
elseif (bw_rgb == 1)
    im = zeros(verti, horiz, 3);
end


if (type == 0)
    % Uniform Noise
    if (bw_rgb == 0)
        im = rand(dim);
    elseif (bw_rgb == 1)
        im(:,:,1) = r * rand(dim);
        im(:,:,2) = g * rand(dim);
        im(:,:,3) = b * rand(dim);
    end
elseif (type == 1)
    % Gaussian Noise
    if (bw_rgb == 0)
        im = imnoise(im,'gaussian', mean, var);
    elseif (bw_rgb == 1)
        im(:,:,1) = r * imnoise(im(:,:,1),'gaussian', mean, var);
        im(:,:,2) = g * imnoise(im(:,:,2),'gaussian', mean, var);
        im(:,:,3) = b * imnoise(im(:,:,3),'gaussian', mean, var);
    end
end

% Saturate
if (saturated == 1)
    im = round(im);
end

% Display Image
imshow(im, [0,1])

% Write Image
imwrite(im, pic_name)
