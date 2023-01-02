% Audio Signal Synthesizer

tic % Timer On


% OPTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Amplitude
A = 0.33;
% frequency
f = 400;

% Sample Rate
samp_r8 = 200000;
% Length of Audio Clip (seconds)
audio_length = 2;
% Amount of Samples
samp_amt = samp_r8 * audio_length;
% Time Axis (Discrete)
t = (1:samp_amt) / samp_r8;

% Iterations: # of waves in sum for Fourier Expansion
iterations = 1;

% # of wave periods to display
plot_cycles = 5;

% Wave Synthesis ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Sine Wave
s = A * sin(2*pi*f*t);

% Preallocate
sq = zeros(1,samp_amt); % Square Wave Approximation
st = zeros(1,samp_amt); % Sawtooth Wave Approximation

% Fourier Series
for i = 1:iterations
    a = 2*i - 1;
    sq = sq + (sin(2*pi*a*f*t)/a);
    st = st + (((-1)^i)*(sin(2*pi*i*f*t)/i));
end

% Finish up waves
sq = A * (4/pi) * sq;
st = A * ((-2)*((1/(pi))*st));


% PLAY AUDIO (un-comment desired sound) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%sound(s, samp_r8)  % Sine
sound(sq, samp_r8) % Square
%sound(st, samp_r8) % Sawtooth


% PLOT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% # of wave samples to display
plt_smp = samp_r8 / round(f/plot_cycles);

% Title Strings
sq_str = strcat("Max: ", num2str(max(sq)), ", Min: ", num2str(min(sq)));
st_str = strcat("Max: ", num2str(max(st)), ", Min: ", num2str(min(st)));
fig_str = strcat("Approximated Square Wave (", num2str(plot_cycles), " periods)" );

% Plots
figure('Name', fig_str)
subplot(2,2,1)
plot(t(1:plt_smp),sq(1:plt_smp), 'b', 'LineWidth', 1)
title({'Square Wave', sq_str})
grid on
subplot(2,2,2)
plot(t(1:plt_smp),st(1:plt_smp), 'r', 'LineWidth', 1)
title({'Sawtooth Wave', st_str})
grid on
subplot(2,2,[3,4])
plot(t(1:plt_smp),s(1:plt_smp),'y', t(1:plt_smp),sq(1:plt_smp),'b', t(1:plt_smp),st(1:plt_smp),'r')
title('All Waveforms')
grid on

toc % Timer Off