d = dir('assets/images/matchExperiment4/*.tif');

%d = d(d=='*.tif');

fluorimg = struct('tiff',[]);

for k = 1:length(d)
    
fluorimg(k).tiff = FastTiff(d(k).name);
fluorimg(k).name = d(k).name;

pureFluorTiff = fluorimg(k).tiff;
 %the following loop will find the threshold values for EACH channel in the
 %entire tiff image.
for j = 1:size(pureFluorTiff,3)
    thresh(j,:) = multithresh(pureFluorTiff(:,:,j),2);
end 
%here, we check to basically make sure the threshold levels aren't close to
%one another. In other words, to the computer, there's a clearly bright
%channel.
maxvals = maxk(thresh(:,2),3);

diff = maxvals(1)-maxvals(2);

%this loop only occurs when the "brightest channel" or channel of interest
%is ambiguous. The threshold values must be within 2.5% of one another for
%this to trigger. This finds the REAL channel of interest using the average
%size of objects as a metric.

if (diff<maxvals(1)*0.025)
    for m = 1:size(pureFluorTiff,3)
        CC = bwconncomp(pureFluorTiff(:,:,m));
        numPixels = cellfun(@numel,CC.PixelIdxList);
        avgSizeObject(m) = mean(numPixels);
    end
    [~, I] = max(avgSizeObject);
    threshVal = thresh(I,:);
    seg_I = imquantize(pureFluorTiff(:,:,I(1)),threshVal);

else 
    [threshVal, I] = max(thresh);
    seg_I = imquantize(pureFluorTiff(:,:,I(1)),threshVal);
end

%here, the threshold value is the maximum threshold from every channel
% 
% [threshVal, I] = max(thresh);
% seg_I = imquantize(pureFluorTiff(:,:,I(1)),threshVal);
% RGB = label2rgb(seg_I); 	 
% figure;
% imshow(RGB)
% axis off
% title(['RGB Segmented Image '  fluorimg(k).name])

%Here the threshold is the mean + 1 standard deviation



[Ix, Iy] = find(seg_I == 3);
%for each pixel that is above our threshold, 
i = 1;

a = zeros(size(pureFluorTiff,3),length(Ix));

    for i = 1:1:length(Ix)
         a(:,i) = permute(pureFluorTiff(Ix(i),Iy(i),:),[3 1 2]);
    end
    
%Here the indices of the relevant pixels are used to create a bunch of
%columns of spectra, which are then averaged and rescaled to 0-1.

b = a';
g = sortrows(b,I,'descend');
f = floor(size(g,1)/10);

fluorimg(k).refSpectra = mean(g(1:f,:),1)';
% 
% fluorimg(k).refSpectra =  mean(a,2);
   
end
%%


realStandard = uint16([fluorimg.refSpectra]');
figure

c = colororder;
realplot = plot(1:length(realStandard),realStandard, 'LineWidth',3);

title("Real Representative Spectra")
axis([0 length(realStandard) 0 255])
legend({d.name})

realplot = plot(1:length(realStandard)-1,realStandard(:,1:end-1), 'LineWidth',3);
