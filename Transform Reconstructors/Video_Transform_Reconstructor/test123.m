

% a = [0, logspace(log10(perc_start), log10(perc_end/2), frames_trans/2)];
% 
% b = flip((perc_end/2) - a) + (perc_end/2);
% 
% subplot(2,2,1);
% plot(1:length(a), a);
% subplot(2,2,2);
% plot(1:length(b), b);
% subplot(2,2,3);
% ab = [a(1:end-1),b];
% plot(1:length(ab), ab);

% x = 1:4;
% y = [0,0.25,0.75,1];
% xx = linspace(0,5,100);
% yy = spline(x, [0, y, 0]);
% plot(xx,ppval(yy,xx));

subplot(1,2,1);
plot(0.5*cos(linspace(pi,2*pi,frames_trans)) + 0.5);

subplot(1,2,2);
x = linspace(-5,5,100);
plot(0.95*exp(-(x.^2)));

