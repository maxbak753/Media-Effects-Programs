% AUDIO NOISE CREATOR
% 10/5/2022
% Max Bakalos

clear % clear previous values

% ********************
% PARAMETERS ************
% ***************************

% Total Time (SECONDS)
time_total = 22;
% Noise Time (SECONDS)
time_noise = 22;

% Sample Rate (Hz = 1/second)
samp_r8 = 44100;

% Check dimensions are correct
if (time_total < time_noise)
    fprintf("\nERROR: Total horizonal distance is less than noise image horizontal distance!\n")
end
% Added Dimensions (blank space on each side)
time_pad = time_total - time_noise;

% Blank space color values (sine wave) ~~~~~~~~~~~~~~~~~~

% Amplitude (Amp < 0.5)
Amp = 0.33;
% frequency (Hz)
freq = 300;

% Noise Types - - - - - - - - - - - -
% 0 -> uniform, 1 -> gaussian
type = 0;

% Mean & Variance (gaussian noise) (range is from -1 to 1)
mean = 0;
var = 0.1;
% - - - - - - - - - - - - - - - - - -

% Saturation: 0 -> none, 1 -> full
saturated = 1;

% ***************************
% PARAMETERS ************
% ********************

% Amount of Samples
samp_amt_noise = samp_r8 * time_noise;
samp_amt_pad = samp_r8 * time_pad;
% Time Axis (Discrete)
time_pad = (1:(samp_amt_pad/2)) / samp_r8;

% Sine Wave Creation (Padding)
sine_pad = transpose(Amp * sin(2*pi*freq*time_pad));


% Dimensions vector (audio file runs vertically)
dim = [samp_amt_noise, 1];

% Create Audio
if (type == 0)
    % Uniform Noise
    audio_noise = (2 * rand(dim)) - 1;
elseif (type == 1)
    % Gaussian Noise
    audio_noise = (sqrt(var) .* randn(dim)) + mean;
end

% Saturate
if (saturated == 1)
    audio_noise = round(audio_noise);
    sat_str = '--sat';
else
    sat_str = '';
end

% Title Creation - - -
% Uniform or Gaussian
if (type == 0)
    type_name = 'uniform';
elseif (type == 1)
    type_name ='gaussian';
end
% put name together
audio_filename = strcat('AUDIO--', type_name, '_noise--', 'mean', num2str(mean), '_var', num2str(var), '--', num2str(time_total), 'secs', sat_str, '.wav');
% print name
fprintf(strcat(audio_filename,'\n\n'))


% Final volume adjustment (|volume| <= 1)
volume = 0.1;

% Create final padded audio file


audio = volume * [sine_pad ; audio_noise ; sine_pad];


% Write Audio
audiowrite(audio_filename, audio, samp_r8);

