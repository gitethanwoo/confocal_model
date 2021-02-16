%make E.coli

bigpicture = zeros(1000);
rgbunmixed = zeros(1000,1000,3);

howmany = 2000;

eheight = 12,;%this is a standardized height variable

for i = 1:1:howmany
    
    moldensity = 1./randi([1 10]); %this 
    fluor = randi([1 3]);
    ewidth = randi([10 60]);
    
    [x,y] = meshgrid(1:ewidth,1:eheight);


    centerx = floor(ewidth/2);
    centery = floor(eheight/2);
    radiusx = floor(ewidth/2);
    radiusy = floor(eheight/2);

    ellipsePixels = (y - centery).^2 ./ radiusy^2 ...
    + (x - centerx).^2 ./ radiusx^2 <= 1    ;

    starts = randi([1 size(bigpicture,1)-60],1,2); %this just provides random starting points
    angle = randi([0 360]);
    ecoli = imrotate(ellipsePixels,angle);
    
    xrange = starts(1):starts(1)+size(ecoli,1)-1;
    yrange = starts(2):starts(2)+size(ecoli,2)-1;

    bigpicture(xrange,yrange) = bigpicture(xrange,yrange) + moldensity.*ecoli;
    rgbunmixed(xrange,yrange,fluor) = bigpicture(xrange,yrange) + moldensity.*ecoli;
    
end
figure
imshow(rescale(rgbunmixed))

%%
q = 0.2;
s = round(rescale(bigpicture,0,255));
figure
imshow(photons)
photons = round(s*q); %this number is found from imageJ
C = imnoise(photons*1e-12, 'poisson')*1e12; %this function then applies poisson noise to the entire image
%convert back to grey values
greys = round(C./q);
%greys = imnoise(greys,'gaussian')

exposed = greys;
exposed(exposed>255) = 255;


figure
imshow(rescale(exposed))





