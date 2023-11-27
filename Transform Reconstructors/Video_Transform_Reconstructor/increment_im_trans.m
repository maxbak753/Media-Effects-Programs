
% INCREMENTAL IMAGE TRANSFORMATION VIDEO CREATION FUNCTION

function increment_im_trans(rgb_bw, video, vid_type, trans_type, im, im_n, p_min, p_max, frames_amt)
    arguments
        rgb_bw
        video
        vid_type    
        trans_type  
        im
        im_n
        p_min       
        p_max       
        frames_amt  
    end
    
    % Black & White
    if (rgb_bw == 0)
        % Linear
        if (vid_type == 1)
            % Discrete Cosine Transform
            if (trans_type == 0)
                for p = linspace(p_min,p_max,frames_amt)
                    % calculate image
                    [im_p, ~] = Discrete_Cosine_Tranform_NoName(im, p);
        
                    % if pixels < 0 exist make them zero
                    im_p = max(im_p,0);
                    % if pixels > 1 exist make them one
                    im_p = min(im_p,1);
                
                    % write image to video frame
                    writeVideo(video, im_p);
                end
            % Wavelet Tranform (Daubechies)
            elseif ( (trans_type >= 1) && (trans_type <= 45) )
                % create wave-name string for Daubechies wavelet
                wname = strcat('db', num2str(trans_type));
                for p = linspace(p_min,p_max,frames_amt)
                    % calculate image
                    [im_p, ~] = dwt_2LVL_NonSqFix(im_n, p, wname);
        
                    % if pixels < 0 exist make them zero
                    im_p = max(im_p,0);
                    % if pixels > 1 exist make them one
                    im_p = min(im_p,1);
                
                    % write image to video frame
                    writeVideo(video, im_p);
                end
            end
        
        % Exponential (Logarithmic)
        elseif (vid_type == 2)
            % Discrete Cosine Transform
            if (trans_type == 0)
                for p = logspace(log10(p_min), log10(p_max), frames_amt)
                    % calculate image
                    [im_p, ~] = Discrete_Cosine_Tranform_NoName(im, p);
        
                    % if pixels < 0 exist make them zero
                    im_p = max(im_p,0);
                    % if pixels > 1 exist make them one
                    im_p = min(im_p,1);
                
                    % write image to video frame
                    writeVideo(video, im_p);
                end
            % Wavelet Tranform (Daubechies)
            elseif ( (trans_type >= 1) && (trans_type <= 45) )
                % create wave-name string for Daubechies wavelet
                wname = strcat('db', num2str(trans_type));
                for p = logspace(log10(p_min), log10(p_max), frames_amt)
                    % calculate image
                    [im_p, ~] = dwt_2LVL_NonSqFix(im_n, p, wname);
        
                    % if pixels < 0 exist make them zero
                    im_p = max(im_p,0);
                    % if pixels > 1 exist make them one
                    im_p = min(im_p,1);
                
                    % write image to video frame
                    writeVideo(video, im_p);
                end
            end
        end
    end
    
    % Color
    if (rgb_bw == 1)
        % Linear
        if (vid_type == 1)
            % Discrete Cosine Transform
            if (trans_type == 0)
                for p = linspace(p_min,p_max,frames_amt)
                    % calculate image
                    % RED
                    [im_p(:,:,1), ~] = Discrete_Cosine_Tranform_NoName(im(:,:,1), p);
                    % GREEN
                    [im_p(:,:,2), ~] = Discrete_Cosine_Tranform_NoName(im(:,:,2), p);
                    % BLUE
                    [im_p(:,:,3), ~] = Discrete_Cosine_Tranform_NoName(im(:,:,3), p);
        
                    % if pixels < 0 exist make them zero
                    im_p = max(im_p,0);
                    % if pixels > 1 exist make them one
                    im_p = min(im_p,1);
                
                    % write image to video frame
                    writeVideo(video, im_p);
                end
            % Wavelet Tranform (Daubechies)
            elseif ( (trans_type >= 1) && (trans_type <= 45) )
                % create wave-name string for Daubechies wavelet
                wname = strcat('db', num2str(trans_type));
                for p = linspace(p_min,p_max,frames_amt)
                    % calculate image
                    % RED
                    [im_p(:,:,1), ~] = dwt_2LVL_NonSqFix(im_n(:,:,1), p, wname);
                    % GREEN
                    [im_p(:,:,2), ~] = dwt_2LVL_NonSqFix(im_n(:,:,2), p, wname);
                    % BLUE
                    [im_p(:,:,3), ~] = dwt_2LVL_NonSqFix(im_n(:,:,3), p, wname);
        
                    % if pixels < 0 exist make them zero
                    im_p = max(im_p,0);
                    % if pixels > 1 exist make them one
                    im_p = min(im_p,1);
                
                    % write image to video frame
                    writeVideo(video, im_p);
                end
            end
        
        % Exponential (Logarithmic)
        elseif (vid_type == 2)
            % Discrete Cosine Transform
            if (trans_type == 0)
                for p = logspace(log10(p_min), log10(p_max), frames_amt)
                    % calculate image
                    % RED
                    [im_p(:,:,1), ~] = Discrete_Cosine_Tranform_NoName(im(:,:,1), p);
                    % GREEN
                    [im_p(:,:,2), ~] = Discrete_Cosine_Tranform_NoName(im(:,:,2), p);
                    % BLUE
                    [im_p(:,:,3), ~] = Discrete_Cosine_Tranform_NoName(im(:,:,3), p);
        
                    % if pixels < 0 exist make them zero
                    im_p = max(im_p,0);
                    % if pixels > 1 exist make them one
                    im_p = min(im_p,1);
                
                    % write image to video frame
                    writeVideo(video, im_p);
                end
            % Wavelet Tranform (Daubechies)
            elseif ( (trans_type >= 1) && (trans_type <= 45) )
                % create wave-name string for Daubechies wavelet
                wname = strcat('db', num2str(trans_type));
                for p = logspace(log10(p_min), log10(p_max), frames_amt)
                    % calculate image
                    % RED
                    [im_p(:,:,1), ~] = dwt_2LVL_NonSqFix(im_n(:,:,1), p, wname);
                    % GREEN
                    [im_p(:,:,2), ~] = dwt_2LVL_NonSqFix(im_n(:,:,2), p, wname);
                    % BLUE
                    [im_p(:,:,3), ~] = dwt_2LVL_NonSqFix(im_n(:,:,3), p, wname);
        
                    % if pixels < 0 exist make them zero
                    im_p = max(im_p,0);
                    % if pixels > 1 exist make them one
                    im_p = min(im_p,1);
                
                    % write image to video frame
                    writeVideo(video, im_p);
                end
            end
        end
    end

    %close(video); %close the file

end