%Photon Experiment using 10 images acquired with varying laser power
%importing the images

d = dir('assets/images/experiment121920/Woo*');

images = struct;

for k = 1:length(d)                            %iterate through all the alexa fluors I have
    images(k).('name') = d(k).name;             %store their name in a structure
    images(k).('file') = FastTiff(['experiment121920/' d(k).name]); %then store their spectra in the stucture
end

images = images([1 3:10 2]); %just sorting


%we start with the brightest image (SNR10) and we want to find the
%brightest channel

%go through each page and find the overall sum

for i = 1:30
    
    p(i) = sum(images(10).file(:,:,i),'all');
    
    [i,j] = max(p);
end

%so j is the index of the overall brightest channel, which in this case
%happens to be channel 19. Great. Let's take a look at channel 19
%%
imshow(rescale(images(10).file(:,:,19))) %this rescales the image to 0-1 to display it correctly

I = rescale(images(10).file(:,:,19))

%we will perform image segmentation on this. We want the areas that define
%the bright points. We will analyze those points separately. 
%%

BW = imbinarize(I); %okay so this is further thresholding the image

CC = bwconncomp(BW);%this determines which pixels are connected and labels them. This basically
%creates a map of all the different e.coli which should vary in brightness
%across the images. This gives us numbers for mean and standard deviation
%across different intensities. 

L = labelmatrix(CC); %this uses the map to create a label matrix. basically
%an image where all the pixels in each ecoli are represented by a single number

RGB = label2rgb(L);
figure
imshow(RGB)

%[66,29 62,81 142,37 128,79] = (66:142,29:81) this square will define our 0 - the mean of
%which will be our offset (exposure independent)

%okay now that we have the locations of these ecoli, we can start to create
%the calculation from the paper

%let's find the offset
%%
for i = 1:size(images,2)
   blank(i) = mean(images(i).file(66:142,29:81,:),'all') ;
end

offset = mean(blank); %this is not a *true* offset, but for the purposes of this experiment, it should be close
%thinking about it more..... this can't be used because it's intensity
%dependent


%1. find the average intensity in the images
% - I'm going to take 2 routes. I'm going to take the average intensity of
% each ecoli region as if i'm taking 184 different images
 % - I'm going to take the average intensity of all the ecoli in each 
%each ecoli will give off a different intensity..but i would need a 
w = 1;
for i = 1:length(CC.PixelIdxList)
    for j = 1:length(images)
    [row, col] = ind2sub(size(I),CC.PixelIdxList{i});
    ecoli_mean(j,i) = mean(images(j).file(row,col,19),'all');
    var_of_each(j,i) = var(images(j).file(row,col,19),w,'all');
%here we have the mean intensity values for each ecoli. I want to group
%them and basically find e.coli that looks really similar to one another
    end
end

%overall method here: let's find the variance of EVERY 

