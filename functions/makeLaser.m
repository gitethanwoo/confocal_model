%%create a laser line

function [lasers] = makeLaser(wavelengths)
    for i = 1:1:length(wavelengths)

        mu = wavelengths(i);                                %// Mean
        sigma = 0.4;                            %// Standard deviation

        %// Plot curve
        x = (-5 * sigma:0.1:5 * sigma) + mu;  %// Plotting range
        y = exp(- 0.5 * ((x - mu) / sigma) .^ 2) / (sigma * sqrt(2 * pi));

        lasers(:,:,i) = ([x; y])';
    end
end
