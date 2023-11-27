%% START

GAME_MODE = 'Max6';%'RandomMotion_directed';
ITERATIONS = 500;
cmap = gray;%turbo;

pause_period = 0.01;

n = 128;

im = zeros(n);

nh = round(n/2);

stbx = round(n/12); % size of half the start box

% im(nh-2:nh+2, nh-2:nh+2) = [0,0,1,1,0;
%                             1,1,0,1,0;
%                             0,0,0,1,0;
%                             0,1,0,1,1;
%                             0,0,1,0,1];

% im(nh-2:nh+2, nh-2:nh+2) = [1,1,0,0,0;
%                             1,1,0,0,0;
%                             0,0,0,0,0;
%                             0,0,0,0,1;
%                             0,0,0,1,1];

USE_RGB = 1;
if USE_RGB 
    for color = 1:3
        im(nh-stbx:nh+stbx, nh-stbx:nh+stbx, color) = round(rand((2*stbx)+1));
    end
else
    im(nh-stbx:nh+stbx, nh-stbx:nh+stbx) = round(rand((2*stbx)+1));
end

rows = size(im,1);
cols = size(im,2);

% Create Figure
fig1 = figure('Name', "Conway's Game of Life", 'WindowState','maximized');
ax1 = axes(fig1);
imshow(im, 'Parent',ax1);
title(ax1, "Starting in 3 seconds ...");
pause(2);
title(ax1, "BEGIN");
pause(1);

%% LOOP

if strcmpi(GAME_MODE, 'Conway')
    % Conway's Game of Life
    for i = 1:ITERATIONS
        im_n = im;
        for r = 2:rows-1
	        for c = 2:cols-1
		        nbhd = im(r-1:r+1, c-1:c+1);
                nbhd(2,2) = 0;
		        if im(r,c) == 1
			        if ~((nnz(nbhd) == 2) || (nnz(nbhd) == 3))
				        im_n(r,c) = 0;
                    end
		        elseif im(r,c) == 0
			        if nnz(nbhd) == 3
				        im_n(r,c) = 1;
                    end
                end
	        end
        end
        im = im_n;
    
        % Show New Turn
        imshow(im, 'Parent',ax1);
        title(sprintf("Frame #%i", i));
        pause(pause_period);
    end


elseif strcmpi(GAME_MODE, 'Max1')
    % Max's Test

    im_n = im;
    for i = 1:ITERATIONS
        for r = 2:rows-1
	        for c = 2:cols-1
		        nbhd = im(r-1:r+1, c-1:c+1);
                nbhd(2,2) = 0;
                s = sum(nbhd,"all");
                nz = nnz(nbhd);
                if im(r,c) == 0
                    if nz > 2
                        if rand > 0.5
		                    im_n(r,c) = 0.2 + (0.1*s);
                        end
                    end
                elseif (im(r,c) <= 1) && (im(r,c) >= 0.7)
                    if s < 3.5
                        im_n(r,c) = 0;
                    end
                elseif (im(r,c) > 0.45) && (im(r,c) <= 0.65)
                    im_n(r,c) = 1;
                    
                end
	        end
        end
        im = im_n;
        % Show New Turn
        imshow(im, 'Parent',ax1, 'Colormap',cmap);
        title(sprintf("Frame #%i", i));
        pause(pause_period);
    end

elseif strcmpi(GAME_MODE, 'Max2')
    % Max's Test

    im_n = im;
    s1 = sign(rand-0.5); s2 = sign(rand-0.5);
    s3 = sign(rand-0.5); s4 = sign(rand-0.5);
    s5 = sign(rand-0.5); s6 = sign(rand-0.5);
    for i = 1:ITERATIONS
        for r = 2:rows-1
	        for c = 2:cols-1
		        nbhd = im(r-1:r+1, c-1:c+1);
                nbhd(2,2) = 0;
                s = sum(nbhd,"all");
                nz = nnz(nbhd);
                
                if im(r,c) < 1
                    if round(rand)
                        if round(rand)
                            a = round(rand);
                            s3 = sign(rand-0.5) * a;
                            s4 = sign(rand-0.5) * (~a);
                        else
                            s3 = sign(rand-0.5);
                            s4 = sign(rand-0.5);
                        end
                    end
                    im_n(r+s3,c+s4) = im_n(r+s3,c+s4)*1.1;
                    % clip
                    if im_n(r+s1,c+s2) > 1
                        im_n(r+s1,c+s2) = 1;
                    end
                elseif im(r,c) == 1
                    if round(rand)
                        if round(rand)
                            a = round(rand);
                            s5 = sign(rand-0.5) * a;
                            s6 = sign(rand-0.5) * (~a);
                        else
                            s5 = sign(rand-0.5);
                            s6 = sign(rand-0.5);
                        end
                    end
                    if im(r+s5,c+s6) < 1
                        im_n(r+s5,c+s6) = im_n(r+s5,c+s6) + (rand/4);
                        if im_n(r+s5,c+s6) > 1
                            im_n(r+s5,c+s6) = 1;
                        end
                    end

                    if nz > 3
                        if round(rand)
                            if round(rand)
                                a1 = round(rand);
                                s1 = sign(rand-0.5) * a1;
                                s2 = sign(rand-0.5) * (~a1);
                            else
                                s1 = sign(rand-0.5);
                                s2 = sign(rand-0.5);
                            end
                        end

                        if rand < 0.025
                            if round(rand)
                                im_n(r-1:r+1,c-1:c+1) = rand/10;
                            else
                                im_n(r-s1:r+s1,c-s2:c+s2) = 0;
                            end
                        else
                            im_n(r+s1,c+s2) = im_n(r+s1,c+s2)*0.7;
                        end
                    end
                end
	        end
        end
        im = im_n;
        % Show New Turn
        imshow(im, 'Parent',ax1, 'Colormap',cmap);
        title(sprintf("Frame #%i", i));
        pause(pause_period);
    end

elseif strcmpi(GAME_MODE, 'Max3')
    % Max's Test

    im_n = im;
    for i = 1:ITERATIONS
        for r = 4:rows-3
	        for c = 4:cols-3
		        nbhd = im(r-1:r+1, c-1:c+1);
                nbhd(2,2) = 0;
                s = sum(nbhd,"all");
                nz = nnz(nbhd);
                
                if  ((nz >= 3) && (nz < 7) || ((s<6.5) && (s>6)))
                    
                    im_n(r,c) = (im(r,c) + 0.1) * 1.9;
                    % Clip
                    if im_n(r,c) > 1
                        im_n(r,c) = 1;
                    end
                    if rand > 0.3
                        r_new = r + randi([-3,3]);
                        c_new = c + randi([-3,3]);
                        new_val = (im(r_new,c_new) + 0.1) * 5;

                        % Clip
                        if new_val > 1
                            new_val = 1;
                        elseif new_val < 0
                            new_val = 0;
                        end
                        im_n(r_new, c_new) = new_val;
                    end


                else
                    im_n(r,c) = (im(r,c)) * 0.9;
                    % Clip
                    if im_n(r,c) < 0 
                        im_n(r,c) = 0;
                    end
                end

	        end
        end
        im = im_n;
        % Show New Turn
        imshow(im, 'Parent',ax1, 'Colormap',cmap);
        title(sprintf("Frame #%i", i));
        pause(pause_period);
    end

elseif strcmpi(GAME_MODE, 'Max3_RGB')
    % Max's Test

    im_n = repmat(im,1,1,3);
    for i = 1:ITERATIONS
        for rgb = 1:3
            for r = 4:rows-3
	            for c = 4:cols-3
		            nbhd = im(r-1:r+1, c-1:c+1);
                    nbhd(2,2) = 0;
                    s = sum(nbhd,"all");
                    nz = nnz(nbhd);
                    
                    if  ((nz >= 3) && (nz < 7) || ((s<6.5) && (s>6)))
                        
                        im_n(r,c,rgb) = (im(r,c) + 0.1) * 1.9;
                        % Clip
                        if im_n(r,c,rgb) > 1
                            im_n(r,c,rgb) = 1;
                        end
                        if rand > 0.3
                            r_new = r + randi([-3,3]);
                            c_new = c + randi([-3,3]);
                            new_val = (im(r_new,c_new) + 0.1) * 5;
    
                            % Clip
                            if new_val > 1
                                new_val = 1;
                            elseif new_val < 0
                                new_val = 0;
                            end
                            im_n(r_new, c_new,rgb) = new_val;
                        end
    
    
                    else
                        im_n(r,c,rgb) = (im(r,c)) * 0.9;
                        % Clip
                        if im_n(r,c,rgb) < 0 
                            im_n(r,c,rgb) = 0;
                        end
                    end
    
	            end
            end
            im(:,:,rgb) = im_n(:,:,rgb);
            
        end
        % Show New Turn
        imshow(im, 'Parent',ax1, 'Colormap',cmap);
        title(sprintf("Frame #%i", i));
        pause(pause_period);
    end

elseif strcmpi(GAME_MODE, 'RandomMotion')
    % Max's Test

    im_n = im;
    for i = 1:ITERATIONS
        for r = 2:rows-1
	        for c = 2:cols-1
                if im(r,c) == 1
                    im_n(r,c) = 0;
                    r_new = r + randi([-1,1]);
                    c_new = c + randi([-1,1]);
                    im_n(r_new,c_new) = 1;
                end
	        end
        end
        im = im_n;
        % Show New Turn
        imshow(im, 'Parent',ax1);
        title(sprintf("Frame #%i", i));
        pause(pause_period);
    end

elseif strcmpi(GAME_MODE, 'RandomMotion_directed')
    % Max's Test
    
    tail = 0.95;
    im_rgb = repmat(im,1,1,3);
    im_n = im;
    dr = randi([-1,1]);
    dc = randi([-1,1]);
    d_buff = zeros(5,2);
    frac_buff = (1:5) .^(-2);
    for i = 1:ITERATIONS
        for rgb = 1:3
            im_n = im_rgb(:,:,rgb);
            for r = 2:rows-1
	            for c = 2:cols-1
    
                    if im_rgb(r,c,rgb) == 1
                        im_n(r,c) = tail;
                        % Recompute Direction
                        dr_new = randi([-1,1]);
                        dc_new = randi([-1,1]);
                        d_buff(2:end) = d_buff(1:end-1); % shift buffer
                        d_buff(1,:) = [dr_new,dc_new]; % add new direction
                        d = round(frac_buff * d_buff);
                        im_n(r+d(1),c+d(2)) = 1;
    
                    elseif im_n(r,c) < 1
                        im_n(r,c) = im_n(r,c) * tail;
                    end
    
	            end
            end
            im_rgb(:,:,rgb) = im_n;
        end
        
        % Show New Turn
        imshow(im_rgb, 'Parent',ax1);
        title(sprintf("Frame #%i", i));
        pause(pause_period);
    end


elseif strcmpi(GAME_MODE, 'Max4_RGB')
    % Max's Test

    % Create Kernel
    n_k = 3; % (this * 2) + 1 = kernel height & width
    X = meshgrid(-n_k:n_k);
    Y = X';
    XY = sqrt((X.^2) + (Y.^2)); % radial coordinate

    kernel = gauss_func(XY,1,0,2.5) - gauss_func(XY,1,0,1.5);
    kernel = kernel / sum(kernel,"all"); % normalize


    im_disp = im;
    im_n = zeros(size(im));
    for i = 1:ITERATIONS
        for r = n_k+1:rows-n_k
            for c = n_k+1:cols-n_k
	            nbhd = im_disp(r-n_k:r+n_k, c-n_k:c+n_k);
                nbhd(n_k+1,n_k+1) = 0; % point-in-question not counted
                
                x = sum(nbhd .* kernel, "all");
                
                if (x <= 0.505) && (x > 0.3)
                    im_n(r,c) = 1;
                else
                    im_n(r,c) = 0;
                end
            end
        end

        im_disp = im_n;
        
        % Show New Turn
        imshow(im_disp, 'Parent',ax1);
        title(sprintf("Frame #%i", i));
        pause(pause_period);
    end

elseif strcmpi(GAME_MODE, 'Max5_RGB')
    % Max's Test

    % Create Kernel
    n_k = 5; % (this * 2) + 1 = kernel height & width
    X = meshgrid(-n_k:n_k);
    Y = X';
    XY = sqrt((X.^2) + (Y.^2)); % radial coordinate

    kernel = gauss_func(XY,1,0,3) - gauss_func(XY,1,0,1);
    kernel = kernel / sum(kernel,"all"); % normalize

    min_bound = 0.16;
    max_bound = 0.885;
    bound_diff = max_bound - min_bound;


    im_disp = im;
    im_n = zeros(size(im));
    for i = 1:ITERATIONS
        for r = n_k+1:rows-n_k
            for c = n_k+1:cols-n_k
	            nbhd = im_disp(r-n_k:r+n_k, c-n_k:c+n_k);
                nbhd(n_k+1,n_k+1) = 0; % point-in-question not counted
                
                x = sum(nbhd .* kernel, "all");
                
                if (x <= max_bound) && (x > min_bound)
%                     im_n(r,c) = ((result-min_bound)*(1/bound_diff)) + min_bound;
                    im_n(r,c) = (-cos((bound_diff*pi*x)+(min_bound+(bound_diff/2)))+1) / 2;
                else
                    im_n(r,c) = 0;
                end
            end
        end

        im_disp = im_n;
        
        % Show New Turn
        imshow(im_disp, 'Parent',ax1);
        title(sprintf("Frame #%i", i));
        pause(pause_period);
    end


elseif strcmpi(GAME_MODE, 'Max6')
    % Max's Test

    % Create Kernel
    n_k = 2; % (this * 2) + 1 = kernel height & width
    X = meshgrid(-n_k:n_k);
    Y = X';
    XY = sqrt((X.^2) + (Y.^2)); % radial coordinate

    kernel = gauss_func(XY,1,0,3) - gauss_func(XY,1,0,1);
    kernel = kernel / sum(kernel,"all"); % normalize

    min_bound = 0.15;
    max_bound = 0.4;
    bound_diff = max_bound - min_bound;

    shx = min_bound; shy = 0.5; scale = 0.5;

    f1 = figure('Name', 'Stuff');
    subplot(2,3,1);
    imshow(kernel); title("Kernel");
    subplot(2,3,4);
    imshow(kernel,[]); title("Kernel (Range Normalized)");
    subplot(2,3,[2,3,5,6]);
    x = 0:0.01:1;
    y = ( ( -cos((1/(bound_diff*2))*2*pi*(x - shx)) ) * scale ) + shy;
    y(x < min_bound) = 0;
    plot(x, y);
    title("Decision Function"); xlabel("Kernel Sum"); ylabel("Pixel Output")




    im_disp = im;
    im_n = zeros(size(im));

    for i = 1:ITERATIONS
        for rgb = 1:3
            for r = n_k+1:rows-n_k
                for c = n_k+1:cols-n_k
	                nbhd = im_disp(r-n_k:r+n_k, c-n_k:c+n_k,rgb);
                    nbhd(n_k+1,n_k+1) = 0; % point-in-question not counted
                    
                    x = sum(nbhd .* kernel, "all");
                    
                    if (x < min_bound)
                        im_n(r,c,rgb) = 0;
                    else
                        y = ( ( -cos((1/(bound_diff*2))*2*pi*(x - shx)) ) * scale ) + shy;
                        im_n(r,c,rgb) = y;
                    end
                end
            end

            im_disp(:,:,rgb) = im_n(:,:,rgb);

        end

        % Show New Turn
        imshow(im_disp, 'Parent',ax1);
        title(ax1, sprintf("Frame #%i", i));
        pause(pause_period);
        
    end

elseif strcmpi(GAME_MODE, 'Fractal')
    % Max's Test

    % Create Kernel
    n_k = 2; % (this * 2) + 1 = kernel height & width
    X = meshgrid(-n_k:n_k);
    Y = X';
    XY = sqrt((X.^2) + (Y.^2)); % radial coordinate

    kernel = gauss_func(XY,1,0,3) - gauss_func(XY,1,0,1);
    kernel = kernel / sum(kernel,"all"); % normalize





    im_disp = im;
    im_n = zeros(size(im));

    for i = 1:ITERATIONS
        for rgb = 1:3
            for r = n_k+1:rows-n_k
                for c = n_k+1:cols-n_k
	                nbhd = im_disp(r-n_k:r+n_k, c-n_k:c+n_k,rgb);
                    nbhd(n_k+1,n_k+1) = 0; % point-in-question not counted
                    
                    x = sum(nbhd .* kernel, "all");
                    
%                     if (x < min_bound)
%                         im_n(r,c,rgb) = 0;
%                     else
%                         y = ( ( -cos((1/(bound_diff*2))*2*pi*(x - shx)) ) * scale ) + shy;
%                         im_n(r,c,rgb) = y;
%                     end
                end
            end

            im_disp(:,:,rgb) = im_n(:,:,rgb);

        end

        % Show New Turn
        imshow(im_disp, 'Parent',ax1);
        title(ax1, sprintf("Frame #%i", i));
        pause(pause_period);
        
    end


end


			