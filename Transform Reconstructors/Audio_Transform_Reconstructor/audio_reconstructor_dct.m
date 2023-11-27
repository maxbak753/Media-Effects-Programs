% Max Bakalos
% 6/24/2022
% MAIN MODULE

% Reconstructing AUDIO from DCT coefficients

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Select original video file
[file_name,path] = uigetfile('*.*');

tic % timer start

% Fraction of Total Coefficients to Use
p = 0.0000001;
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Read original audio file
[audio,samp_r8] = audioread(strcat(path,file_name));

% Create reconstructed audio
[audio_reconstruct_1, audio_dct_reconstruct_1] = DCT_reconstruct_1D(audio(:,1), p);
[audio_reconstruct_2, audio_dct_reconstruct_2] = DCT_reconstruct_1D(audio(:,2), p);

audio_reconstruct = zeros(size(audio,1),2);     % preallocate
audio_reconstruct(:,1) = audio_reconstruct_1;   % left
audio_reconstruct(:,2) = audio_reconstruct_2;   % right

% Create filename for reconstructed audio
audio_reconstruct_name = strcat('dctReconstr_', num2str(p), '_', file_name, '.wav');

% Write reconstructed audio
audiowrite(audio_reconstruct_name, audio_reconstruct, samp_r8);

% plot
seconds = 1;
plot_len = 4410 * seconds;

subplot(2,2,1)
plot(1:plot_len,audio(1:plot_len,1))
subplot(2,2,2)
plot(1:plot_len,audio(1:plot_len,2))
subplot(2,2,3)
plot(1:plot_len,audio_reconstruct(1:plot_len,1))
subplot(2,2,4)
plot(1:plot_len,audio_reconstruct(1:plot_len,2))

toc % timer end