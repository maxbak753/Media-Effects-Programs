% Max Bakalos
% 6/24/2022
% MAIN MODULE

% Reconstructing Audio INCREMENTALLY from DCT coefficients

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Select Original Audio File
[file_name,path] = uigetfile('*.*');

tic % timer start


 %%%%%%%%%%%%%%%%%%%%%%%%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%%%%%% PARAMETERS %%%%%%%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 %%%%%%%%%%%%%%%%%%%%%%%%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 % Dialog Box for Input Parameters
dlg_title = 'Audio Transform Reconstructor Input Parameters';
prompt = {'Fraction of Total Coefficients to Use (Maximum Percent):', ...
          'Number of different percent levels:' ...
          'Percent of audio to be incrementally reconstructed (from start) 0 <= x <= 1  --> 0 = no reconstruction, 1 = only reconstruction', ...
          'Fade Length (perfect reconstruction -> original) in seconds (0 = no fade)'};
dlg_dims = [1,60];
definput = {'1','50','0.9','1.5'};
opts.Resize = 'on';
input_params = inputdlg(prompt,dlg_title,dlg_dims,definput,opts);

% Dialog Box for Audio File Format
profiles = {'.flac','.ogg','.opus','.wav','.mp4','.m4a'};
[lst_ind,~] = listdlg('PromptString', {'Select an Audio File Format', '(Recommended: MPEG-4 (.mp4, .m4a) or ', 'WAVE (.wav)):'}, ...
                      'SelectionMode', 'single', 'InitialValue', 5, ...
                      'ListSize',[200,100], ...
                      'ListString', profiles);

% Fraction of Total Coefficients to Use (Maximum Percent)
p_max = str2double(input_params{1});

% Number of different percent levels
lvl_num = str2double(input_params{2});

% Percent of audio to be incrementally reconstructed (from start)
% 0 <= x <= 1  --> 0 = no reconstruction, 1 = only reconstruction
reconstr_p = str2double(input_params{3});

% Fade Length (perfect reconstruction -> original) in seconds (0 = no fade)
fade_secs = str2double(input_params{4});

% Video Profile (File Type)
selected_format = profiles{lst_ind};


 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% File READ & Name %%%%%%%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Read original audio file
[audio,samp_r8] = audioread(strcat(path,file_name));

% Create filename for reconstructed audio
audio_reconstruct_name = strcat('dctReconstr_', num2str(p_max), ...
                                '_increment_', num2str(lvl_num), ...
                                '_percent_', num2str(reconstr_p), ...
                                '_', file_name, selected_format);


 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Variable Set-Up %%%%%%%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

mono_stereo = size(audio,2);    % 1 = mono, 2 = stereo

samples = size(audio,1);    % total samples
samples_reconstr = ceil(reconstr_p * samples);  % samples to be reconstructed

% Minimum Percent
p_min = 1 / samples_reconstr;

% Logarithmic Percent array
p = logspace(log10(p_min), log10(p_max), lvl_num);

% chunks
lvl_samples = round(samples_reconstr / lvl_num);

% preallocate
audio_reconstruct = zeros(samples_reconstr, mono_stereo);
audio_total_reconstruct = zeros(samples, mono_stereo);


 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Main Algorithm %%%%%%%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% MONO
if (mono_stereo == 1)
    % for each level
    for i = 1:lvl_num
        % Create reconstructed audio
        [audio_reconstruct_mono, audio_dct_reconstruct_mono] = DCT_reconstruct_1D(audio(:), p(i));
        
        if ( (i*lvl_samples) <= samples_reconstr )
            lvl_sample_range = (((i-1)*lvl_samples)+1) : (i*lvl_samples);
        else
            lvl_sample_range = (((i-1)*lvl_samples)+1) : samples_reconstr;
        end
        
        audio_reconstruct(lvl_sample_range,1) = audio_reconstruct_mono(lvl_sample_range);   % mono
    
    end

    % Full DCT reconstruction
    audio_total_reconstruct(:,1) = audio_reconstruct_mono;   % mono

% STEREO
elseif (mono_stereo == 2)
    % for each level
    for i = 1:lvl_num
        % Create reconstructed audio
        [audio_reconstruct_1, audio_dct_reconstruct_1] = DCT_reconstruct_1D(audio(:,1), p(i));
        [audio_reconstruct_2, audio_dct_reconstruct_2] = DCT_reconstruct_1D(audio(:,2), p(i));
        
        if ( (i*lvl_samples) <= samples_reconstr )
            lvl_sample_range = (((i-1)*lvl_samples)+1) : (i*lvl_samples);
        else
            lvl_sample_range = (((i-1)*lvl_samples)+1) : samples_reconstr;
        end
        
        audio_reconstruct(lvl_sample_range,1) = audio_reconstruct_1(lvl_sample_range);   % left
        audio_reconstruct(lvl_sample_range,2) = audio_reconstruct_2(lvl_sample_range);   % right
    
    end

    % Full DCT reconstruction
    audio_total_reconstruct(:,1) = audio_reconstruct_1;   % left
    audio_total_reconstruct(:,2) = audio_reconstruct_2;   % right

end


 %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Fade & Write %%%%%%%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% If there is unaltered audio post reconstruction
if (reconstr_p < 1)
    % Fade from perfect DCT reconstruction to original 
    % (including original after fade)
    audio_dct_2_original = audio((samples_reconstr+1) : samples, :);

    % Loop variables
    fade_samps = floor(fade_secs * samp_r8);
    a = 0;
    a_inc = 1/fade_samps;
    b = 1;
    
    % For each sample in the fade
    for ind = (samples_reconstr+1) : (samples_reconstr + fade_samps)
        % make the audio equal the linear fade between the 
        % DCT reconstruction (p=1 full quality) and the original audio
        audio_dct_2_original(b,:) = ((1-a) * audio_total_reconstruct(ind,:)) + (a * audio(ind,:));
        
        % increment
        a = a + a_inc;
        b = b + 1;
    end
    
    % Final Audio is the reconstruction followed by a fade into the rest of the unaltered audio
    audio_recontruct_final = [audio_reconstruct ; audio_dct_2_original];

% If only reconstruction
else
    % Final Audio is just the incremented reconstruction
    audio_recontruct_final = audio_reconstruct;
end


% WRITE Reconstructed Audio
audiowrite(audio_reconstruct_name, audio_recontruct_final, samp_r8);


toc % timer end