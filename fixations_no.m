function fix = fixations_no(eyex, eyez, dispersion_th, duration_th_frames)

if nargin == 2
    dispersion_th = 0.01;
    duration_th_frames = 13;
end

window = [1 duration_th_frames];
i = 1; % i is the fixations' index. first, second, third fixations
fdata = [];
placeholder = [];

while window(2) < length(eyex)
    D = ( max(eyex(window(1):window(2))) - min(eyex(window(1):window(2))) ) + ...
        ( max(eyez(window(1):window(2))) - min(eyez(window(1):window(2))) );

    if D <= dispersion_th
        
        while D <= dispersion_th && window(2) < length(eyex)
            window(2) = window(2) + 1;
            D = ( max(eyex(window(1):window(2))) - min(eyex(window(1):window(2))) ) + ...
                ( max(eyez(window(1):window(2))) - min(eyez(window(1):window(2))) );
        end
        
        if window(2) ~= length(eyex)
            window = [window(1), window(2) - 1];
        end
        
        fdata(i, 1:2) = [window(1) window(2)];
        fdata(i, 3) = (window(2) - window(1) + 1) / 130;
        fdata(i, 4:5) = [mean(eyex(window(1):window(2))), ...
            mean(eyez(window(1):window(2)))];
%         fdata(i, 6) = mean(sqrt(                          ...
%             (eyex(window(1):window(2)) - fdata(i, 4)).^2 + ...
%             (eyez(window(1):window(2)) - fdata(i, 5)).^2   ...
%             ));
%         fdata(i, 7) = ( max(eyex(window(1):window(2))) - min(eyex(window(1):window(2))) ) + ...
%             ( max(eyez(window(1):window(2))) - min(eyez(window(1):window(2))) );
        placeholder = [placeholder repmat(i, [1 window(2) - window(1) + 1])];
        i = i + 1;
        window = [window(2) + 1, window(2) + 13];
    else
        window = window + 1;
        placeholder = [placeholder 0];
    end
end

fix = fdata;

% sdata = [fdata(1:end - 1, 2), fdata(2:end, 1)];
% dist = [eyex(sdata(:,1)) - eyex(sdata(:,2)), eyez(sdata(:,1)) - eyez(sdata(:,2))];
% mag = sqrt(sum(dist .^2, 2));
% theta = radtodeg(mag ./ 0.5);
% 
% sdata = [sdata, theta];
% 
% sac = sdata;

end