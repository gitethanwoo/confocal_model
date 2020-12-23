%Fom comparison. First we download the image in question


im = FastTiff('546_650gain.tif'); %the photon conversion factor is known

%we need to also import a fluorophore that is not there - say, 555

im555 = FastTiff('555Ecoli.tif');

%extract a representative for both:
ref546 = extractRef(im); %note these are scaled to 1
ref555 = extractRef(im555);

%okay so first we unmix the real image by itself to obtain a standard 
stdimage = zeros(904,904);

for i = 1:size(im, 1)
    for j = 1:size(im,2)
        
    pixel = permute(im(i,j,:), [3 1 2]) ;
    stdimage(i,j) = lsqnonneg(ref546, pixel);
    end
end

figure
imshow(rescale(stdimage))
%Okay now that we have a standard to compare to, we unmix the image with a
%fluorophore that is not present
%%
for i = 1:size(im, 1)
    for j = 1:size(im,2)  
    pixel = permute(im(i,j,:), [3 1 2]) ;
    imunmixed(i,j,:) = lsqnonneg([ref546 ref555], pixel);
    end
end
%%
figure
imshow(rescale(imunmixed(:,:,1)))
title('Alexa 546 unmixed with 546 and 555: 546 channel')

figure
imshow(rescale(imunmixed(:,:,2)))
title('Alexa 546 unmixed with 546 and 555: 555 channel')

%How do we calculate FOM with these images? FOM = # of correctly unmixed
%pixels / total pixels
% of correctly unmixed grey values = abs(standard - 546 channel)
%%
%FOM at every pixel:
FOM_image = imunmixed(:,:,1)./stdimage;
FOM_image(isnan(FOM_image))=1;
FOM_image_mean = mean(FOM_image,'all')



%NOW we have to convert these grey values to photons.
%start with the image
%%
photon_im = im.*38.568; %this is the photon conversion factor found from imageJ
%this loop then iterates through each pixel 
for i = 1:size(im, 1)
    for j = 1:size(im,2)
    pixel = permute(photon_im(i,j,:), [3 1 2]) ;
    std_photon_image(i,j) = lsqnonneg(ref546, pixel); %creates the standard 
    photon_imunmixed(i,j,:) = lsqnonneg([ref546 ref555], pixel); %creates the unmixed
    end
end
%%
figure
imshow(rescale(photon_imunmixed(:,:,1)))
title('Alexa 546 photon values unmixed with 546 and 555: 546 channel')

figure
imshow(rescale(photon_imunmixed(:,:,2)))
title('Alexa 546 photon values unmixed with 546 and 555: 555 channel')

FOM_photon_image = photon_imunmixed(:,:,1)./std_photon_image;
FOM_photon_image(isnan(FOM_photon_image))=1;
FOM__photon_image_mean = mean(FOM_photon_image,'all')

