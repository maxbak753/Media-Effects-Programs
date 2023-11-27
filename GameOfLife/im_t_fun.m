% Image Tests Fun

frames = 100;
n = 30;
pause_period = 0.01;

im = rand(n);

% imshow(im);

% filt = [1,0,0;
%         0,1,0;
%         0,0,1];

n_filt = 10;
n_filt_h = round(n_filt/2);
X = meshgrid(-n_filt_h:n_filt_h);
Y = X';

XY = sqrt((X.^2) + (Y.^2)); % radial coordinates

a = 1; % height of curve's peak
b = 0; % position of the center of the peak
c = 2; % standard deviation (width of "bell")
G = a * exp( - ((XY - b).^2) / (2 * (c^2)) );

filt = filt / sum(filt,"all");
extra = floor(size(filt,2) / 2);

f1 = figure(); ax1 = axes(f1);

im_filt(:,:,1) = im;
for i = 1:frames-1
    im_conv = conv2(filt, im_filt(:,:,i));
    im_filt(:,:,i+1) = im_conv(extra+1:extra+n, extra+1:extra+n);
end

for i = 1:frames
    imshow(im_filt(:,:,i), 'Parent',ax1);
    pause(pause_period);
end
    
