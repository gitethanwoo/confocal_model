

function [refSpectra] = extractRef(pureFluorTiff)

[maxMean, I] = max(mean(pureFluorTiff,[1 2])); %Which slice has highest mean 
%intensity? take the mean of all, then return index of highest in I

fluorDouble = im2double(pureFluorTiff(:,:,I)); %covert tiff to double

threshold = mean(fluorDouble,'all') + std(fluorDouble,0,[1 2]);
%Here the threshold is the mean + 1 standard deviation

%Start with a quadrant that definitely contains a region of interest
%now find the top 10 brightest pixels in each row

%C is now a 10x10 matrix of the brightest pixels I
[Ix, Iy] = find(fluorDouble > threshold);

    for i = 1:1:length(Ix)
         a(:,i) = permute(pureFluorTiff(Ix(i),Iy(i),:),[3 1 2]);
    end
    
%Here the indices of the relevant pixels are used to create a bunch of
%columns of spectra, which are then averaged and rescaled to 0-1.

   refSpectra =  rescale(mean(a,2));
    
end