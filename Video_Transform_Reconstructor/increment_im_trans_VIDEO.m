
% INCREMENTAL IMAGE TRANSFORMATION VIDEO CREATION FUNCTION

function increment_im_trans_VIDEO(bw_rgb, video_r, video_w, vid_type, trans_type, p_min, p_max)
    arguments
        bw_rgb
        video_r     % v_reader
        video_w     % v_writer
        vid_type    
        trans_type  
        p_min       
        p_max
    end

    % Amount of video frames
    frames_amt = get(video_r, 'numberOfFrames');

    % Initialize percent array incrementer
    i = 1;
    
    % Linear or Logarithmic percents
    if (vid_type == 1)
        % Linear percent array
        p = linspace(p_min,p_max,frames_amt);
    elseif (vid_type == 2)
        % Logarithmic Percent array
        p = logspace(log10(p_min), log10(p_max), frames_amt);
    end
    
    % Black & White
    if (bw_rgb == 0)
        % Discrete Cosine Transform
        if (trans_type == 0)
            % Create new video
            while hasFrame(video_r)
                % get current frame
                frame = readFrame(video_r);
                % convert to grayscale
                frame = rgb2gray(frame);
                
                % calculate image
                [frame_p, ~] = Discrete_Cosine_Tranform_NoName(frame, p(i));
    
                % if pixels < 0 exist make them zero
                frame_p = max(frame_p,0);
                % if pixels > 1 exist make them one
                frame_p = min(frame_p,1);
            
                % write new frame to new video
                writeVideo(video_w, frame_p);

                % increment percent array
                i = i + 1;
            end
        % Wavelet Tranform (Daubechies)
        elseif ( (trans_type >= 1) && (trans_type <= 45) )
            % create wave-name string for Daubechies wavelet
            wname = strcat('db', num2str(trans_type));

            % Create new video
            while hasFrame(video_r)
                % get current frame
                frame = readFrame(video_r);
                % convert to grayscale
                frame = rgb2gray(frame);
                % normalize
                frame = im2double(frame);

                % calculate image
                [frame_p, ~] = dwt_2LVL_NonSqFix(frame, p(i), wname);
    
                % if pixels < 0 exist make them zero
                frame_p = max(frame_p,0);
                % if pixels > 1 exist make them one
                frame_p = min(frame_p,1);
            
                % write image to video frame
                writeVideo(video_w, frame_p);

                % increment percent array
                i = i + 1;
            end
        end

    % Color
    elseif (bw_rgb == 1)
        % Discrete Cosine Transform
        if (trans_type == 0)
            % Create new video
            while hasFrame(video_r)
                % get current frame
                frame = readFrame(video_r);

                % RED
                [frame_p(:,:,1), ~] = Discrete_Cosine_Tranform_NoName(frame(:,:,1), p(i));
                % GREEN
                [frame_p(:,:,2), ~] = Discrete_Cosine_Tranform_NoName(frame(:,:,2), p(i));
                % BLUE
                [frame_p(:,:,3), ~] = Discrete_Cosine_Tranform_NoName(frame(:,:,3), p(i));
    
                % if pixels < 0 exist make them zero
                frame_p = max(frame_p,0);
                % if pixels > 1 exist make them one
                frame_p = min(frame_p,1);
            
                % write new frame to new video
                writeVideo(video_w, frame_p);

                % increment percent array
                i = i + 1;
            end
        % Wavelet Tranform (Daubechies)
        elseif ( (trans_type >= 1) && (trans_type <= 45) )
            % create wave-name string for Daubechies wavelet
            wname = strcat('db', num2str(trans_type));

            % Create new video
            while hasFrame(video_r)
                % get current frame
                frame = readFrame(video_r);
                % normalize
                frame = im2double(frame);

                % calculate image
                % RED
                [frame_p(:,:,1), ~] = dwt_2LVL_NonSqFix(frame(:,:,1), p(i), wname);
                % GREEN
                [frame_p(:,:,2), ~] = dwt_2LVL_NonSqFix(frame(:,:,2), p(i), wname);
                % BLUE
                [frame_p(:,:,3), ~] = dwt_2LVL_NonSqFix(frame(:,:,3), p(i), wname);
    
                % if pixels < 0 exist make them zero
                frame_p = max(frame_p,0);
                % if pixels > 1 exist make them one
                frame_p = min(frame_p,1);
            
                % write image to video frame
                writeVideo(video_w, frame_p);

                % increment percent array
                i = i + 1;
            end
        end
    end



    %{
    % Color
    if (bw_rgb == 1)
        % Linear
        if (vid_type == 1)
            % Discrete Cosine Transform
            if (trans_type == 0)
                for p = linspace(p_min,p_max,frames_amt)
                    % calculate image
                    % RED
                    [frame_p(:,:,1), ~] = Discrete_Cosine_Tranform_NoName(im(:,:,1), p);
                    % GREEN
                    [frame_p(:,:,2), ~] = Discrete_Cosine_Tranform_NoName(im(:,:,2), p);
                    % BLUE
                    [frame_p(:,:,3), ~] = Discrete_Cosine_Tranform_NoName(im(:,:,3), p);
        
                    % if pixels < 0 exist make them zero
                    frame_p = max(frame_p,0);
                    % if pixels > 1 exist make them one
                    frame_p = min(frame_p,1);
                
                    % write image to video frame
                    writeVideo(video, frame_p);
                end
            % Wavelet Tranform (Daubechies)
            elseif ( (trans_type >= 1) && (trans_type <= 45) )
                % create wave-name string for Daubechies wavelet
                wname = strcat('db', num2str(trans_type));
                for p = linspace(p_min,p_max,frames_amt)
                    % calculate image
                    % RED
                    [frame_p(:,:,1), ~] = dwt_2LVL_NonSqFix(im_n(:,:,1), p, wname);
                    % GREEN
                    [frame_p(:,:,2), ~] = dwt_2LVL_NonSqFix(im_n(:,:,2), p, wname);
                    % BLUE
                    [frame_p(:,:,3), ~] = dwt_2LVL_NonSqFix(im_n(:,:,3), p, wname);
        
                    % if pixels < 0 exist make them zero
                    frame_p = max(frame_p,0);
                    % if pixels > 1 exist make them one
                    frame_p = min(frame_p,1);
                
                    % write image to video frame
                    writeVideo(video, frame_p);
                end
            end
        
        % Exponential (Logarithmic)
        elseif (vid_type == 2)
            % Discrete Cosine Transform
            if (trans_type == 0)
                for p = logspace(log10(p_min), log10(p_max), frames_amt)
                    % calculate image
                    % RED
                    [frame_p(:,:,1), ~] = Discrete_Cosine_Tranform_NoName(im(:,:,1), p);
                    % GREEN
                    [frame_p(:,:,2), ~] = Discrete_Cosine_Tranform_NoName(im(:,:,2), p);
                    % BLUE
                    [frame_p(:,:,3), ~] = Discrete_Cosine_Tranform_NoName(im(:,:,3), p);
        
                    % if pixels < 0 exist make them zero
                    frame_p = max(frame_p,0);
                    % if pixels > 1 exist make them one
                    frame_p = min(frame_p,1);
                
                    % write image to video frame
                    writeVideo(video, frame_p);
                end
            % Wavelet Tranform (Daubechies)
            elseif ( (trans_type >= 1) && (trans_type <= 45) )
                % create wave-name string for Daubechies wavelet
                wname = strcat('db', num2str(trans_type));
                for p = logspace(log10(p_min), log10(p_max), frames_amt)
                    % calculate image
                    % RED
                    [frame_p(:,:,1), ~] = dwt_2LVL_NonSqFix(im_n(:,:,1), p, wname);
                    % GREEN
                    [frame_p(:,:,2), ~] = dwt_2LVL_NonSqFix(im_n(:,:,2), p, wname);
                    % BLUE
                    [frame_p(:,:,3), ~] = dwt_2LVL_NonSqFix(im_n(:,:,3), p, wname);
        
                    % if pixels < 0 exist make them zero
                    frame_p = max(frame_p,0);
                    % if pixels > 1 exist make them one
                    frame_p = min(frame_p,1);
                
                    % write image to video frame
                    writeVideo(video, frame_p);
                end
            end
        end
    end
    %}

    %close(video); %close the file

end