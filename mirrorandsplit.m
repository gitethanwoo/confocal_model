
a = FastTiff('assets/images/gainExperiment/Woo_alexa546_550gain.tif');
for i =  1:1:size(a,3)
   channelsum(i) = sum(a(:,:,i),'all');
end

[val, idx] = max(channelsum);

a = a(:,:,idx);

sample = a;

sample2 = flip(sample,2); %upper right
sample3 = flip(sample,1); %lower left
sample4 = flip(sample2,1); %bottom right

tiled = [sample sample2;sample3 sample4]; %this puts it all into one large image

%split the entire image into 4x4

tiles = mat2tiles(tiled, size(tiled)/4);


%okay so the "out of band" mean noisy energy is going to be found by going
%in tiles
%so we need to take the fft2 of each one
fftiles = {};

x = size(tiles{1,1},1);
y = size(tiles{1,1},2);
r = floor(0.5*x);
kt = .8;
r = r*kt;
[xgrid,ygrid] = meshgrid(1:x,1:y);
mask1 = ((xgrid-x/2).^2 + (ygrid-y/2).^2) >= r.^2;

meanvalues = zeros(4,4);
meanI = zeros(4,4);

for i = 1:1:4
    for j = 1:1:4
        A = fft2(tiles{i,j}); %first we take the fourier transform
        A = fftshift(A); %we shift the low frequency values to center
        values1 = A(mask1); %apply our mask to get an index of values
        maskedA = double(mask1); %generate a map of doubles corresponding to our mask
        maskedA(mask1) = values1; %fill our map with those values
        inversedA = abs(ifft2(maskedA)); %now we have a tile that has been high-pass filtered 
        fftiles{i,j} = var(inversedA,[],'all');
        meanI(i,j) = mean(tiles{i,j},'all');
    end
end

% x = meanI(:);
% y = cell2mat(fftiles(:));
% format long
% b1 = x\y;
% 
% yCalc1 = b1*x;
% scatter(x,y)
% hold on
% plot(x,yCalc1)
% xlabel('Mean Intensities')
% ylabel('Variances')
% title('Linear Regression Relation Between variance and mean intensity')
% grid on
% %%
% X = [ones(length(x),1) x];
% b = X\y;
% 
% 
% 
% 
% yCalc2 = X*b;
% plot(x,yCalc2,'--')
% legend('Data','Slope','Slope & Intercept','Location','best');

%%
% hold off
varOffset = b(1);

%now the whole input image

x = size(sample,1);
y = size(sample,2);
r = floor(0.5*x);
kt = 0.8;
r = r*kt;
[xgrid,ygrid] = meshgrid(1:x,1:y);
mask = ((xgrid-x/2).^2 + (ygrid-y/2).^2) >= r.^2;

samplefft = fft2(sample); %we take the fft of our image
samplefft = fftshift(samplefft);
values = samplefft(mask); %this all the values that lie outside our circle
maskedsamplefft = double(mask); %this initiates a mask on maskedsamplefit
maskedsamplefft(mask) = values; %this puts only our values outside the circle into the masked sample

inversedsample = abs(ifft2(maskedsamplefft));
%here we do something tricky.. we take the inverse fft of what we
%previously had done
%figure
%imagesc(inversedsample)
%title("scaled image")
% figure
% imshow(inversedsample)
% title('imshow of inversed sample')
% figure
% imshow(sample)

calc1 = var(inversedsample,[],'all');

M = length(sample).^2;
T = length(values);

calc2 = mean(sample,'all');

g = (calc1 - varOffset)/(calc2)


%S = g*n