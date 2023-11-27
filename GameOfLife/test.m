set(0,'DefaultFigureWindowStyle','normal')

h1 = figure; 
plot(rand(1, 10)); 
% Make figure fit in upper left quadrant..
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.5, 0.5, 0.5]);
h2 = figure; 
plot(rand(1, 10)); 
% Make figure fit in upper right quadrant..
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.5, 0.5, 0.5, 0.5]);
h3 = figure; 
plot(rand(1, 10)); 
% Make figure fit in lower left quadrant..
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 0.5, 0.5]);
h4 = figure; 
plot(rand(1, 10)); 
% Make figure fit in lower left quadrant..
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.5, 0, 0.5, 0.5]);