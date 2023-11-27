% Fourier Transform Demonstration

% x = 0:0.1:30;
Ts = 1/100;
x = 0:Ts:30-Ts;

Fa = -0.4;
Fb = 1;
Fc = 3;

Aa = 5;
Ab = 3;
Ac = 1.5;

Sa = 0;
Sb = -1.5;
Sc = pi/2;

Ya = Aa * sin(Fa*(2*pi)*x + Sa);
Yb = Ab * sin((Fb*(2*pi)*x) + Sb);
Yc = Ac * sin((Fc*(2*pi)*x) + Sc);

Ca = 'r';
Cb = 'g';
Cc = 'b';
Cd = [0.7,0,1];

Yd = Ya + Yb + Yc;


lw = 2;

%% Signals

x_range = [0,5];
MAXallSigs = max(abs([Ya, Yb, Yc, Yd]));
y_range = [-(MAXallSigs + (0.05*MAXallSigs)), MAXallSigs + (0.05*MAXallSigs)];

%% Fourier Transforms

[A_yShift_FFT, A_fShift] = fourier_transform(Ya, Ts);
[B_yShift_FFT, B_fShift] = fourier_transform(Yb, Ts);
[C_yShift_FFT, C_fShift] = fourier_transform(Yc, Ts);

[D_yShift_FFT, D_fShift] = fourier_transform(Yd, Ts);

x_range_ft = [0,max([Fa,Fb,Fc])+5];
MAXallFFTs = max(abs([A_yShift_FFT, B_yShift_FFT, C_yShift_FFT, D_yShift_FFT]));
y_range_ft = [0, MAXallFFTs + (0.05*MAXallFFTs)];


%% Figure

fig = figure('Name','Fourier Transform Demonstration');
sgtitle("Signals & their Fourier Transforms (FT)")


%% Signals (A, B, C)
subplot(4,2,1);
plot(x,Ya, Ca, 'LineWidth',lw);
sig_plot_settings('A', x_range, y_range)

subplot(4,2,3);
plot(x,Yb, Cb, 'LineWidth',lw);
sig_plot_settings('B', x_range, y_range)

subplot(4,2,5);
plot(x,Yc, Cc, 'LineWidth',lw);
sig_plot_settings('C', x_range, y_range)


%% Fourier Transforms (A, B, C)

subplot(4,2,2);
plot(A_fShift, abs(A_yShift_FFT), 'Color',Ca, 'LineWidth',lw);
ft_plot_settings('A', x_range_ft, y_range_ft);

subplot(4,2,4);
plot(B_fShift, abs(B_yShift_FFT), 'Color',Cb, 'LineWidth',lw);
ft_plot_settings('B', x_range_ft, y_range_ft);

subplot(4,2,6);
plot(C_fShift, abs(C_yShift_FFT), 'Color',Cc, 'LineWidth',lw);
ft_plot_settings('C', x_range_ft, y_range_ft);


%% D = A + B + C
subplot(4,2,7);
plot(x, Yd, 'Color',Cd, 'LineWidth',lw);
sig_plot_settings('D  =  A + B + C', x_range, y_range)

subplot(4,2,8);
plot(D_fShift, abs(D_yShift_FFT), 'Color',Cd, 'LineWidth',lw);
ft_plot_settings('D', x_range_ft, y_range_ft);


%% HELPER FUNCTIONS

% Fourier Transform
function [yShift_FFT, fShift] = fourier_transform(y_final, Ts)
    y_FFT = fft(y_final);
    fs = 1/Ts;
    n = length(y_final);
    fShift = (-n/2:n/2-1)*(fs/n);
    yShift_FFT = fftshift(y_FFT);
end

function sig_plot_settings(signal_name, x_range, y_range)
    xlim(x_range); ylim(y_range);
    set(gca,'xtick',[]); set(gca,'xticklabel',[]);
    set(gca,'ytick',[]); set(gca,'yticklabel',[]);
    xlabel('Time'); ylabel('Amplitude');
    title(signal_name);
end

function ft_plot_settings(signal_name, x_range_ft, y_range_ft)
    xlim(x_range_ft);
    ylim(y_range_ft);
    set(gca,'xtick',[]); set(gca,'xticklabel',[]);
    set(gca,'ytick',[]); set(gca,'yticklabel',[]);
    xlabel('Frequency'); ylabel('Magnitude');
    title(sprintf("FT { %s }", signal_name), 'Interpreter','none');
end