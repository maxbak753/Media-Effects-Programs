% Reconstruct (audio) waveform by using DCT coefficients

function [audio_reconstruct, audio_dct_reconstruct] = DWT_reconstruct_1D(audio, p)
    
    arguments
        audio   double  % Original audio waveform
        p       double  % Percent of DCT coefficients to use in reconstruction
    end

    % (a) DCT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % Read Image - - - - - - - - - - - - - - - - -
    length = size(audio,1);          % length of audio file in samples
    
    % i) Apply 2-D DCT (dct2) to the complete image (not block-by-block) ~
    audio_dct = dct(audio);
    

    % ii) Keep p% of the largest-energy coefficients (squared value) ~ ~ ~
    % unchanged & set the remaining ones to zero

    % reshape array of squared coefficients into 1-D vector
    % & order the coefficients
    audio_dct_sqr = audio_dct .^ 2;
    audio_dct_v = sort(audio_dct_sqr, 'descend');

    % # of dct coefficients
    coef_amt = size(audio_dct_v,1);
    % # of dct coefficients to keep
    coef_keep_amt = p * coef_amt;

    threshold = audio_dct_v(ceil(coef_keep_amt));

    % preallocate
    audio_dct_reconstruct = audio_dct;
    % set audio_dct_reconstruct to 0 when coefficient isnt't within the threshold
    for i = 1:length
        if (audio_dct_sqr(i) < threshold)
            audio_dct_reconstruct(i) = 0;
        end
    end

    % iii) Apply 1-D inverse DCT (idct) to the partially-zeroed ~ ~ ~ ~ ~
    % coefficient array. This results in an approximate image

    audio_reconstruct = rescale( idct(audio_dct_reconstruct) );
    
end