function [realFOMS] = compareFOM()
%compareFOM This function will import real images that I acquired and unmix
%them, calculating the FOM

a = FastTiff('assets/546Ecoli.tif');
b = FastTiff('assets/555Ecoli.tif');
%c = FastTiff('assets/mixedEcoli.tif');

%create reference from each

refa = extractRef(a);
refb = extractRef(b);

%combine

refmat = [refa refb];

%unmix every pixel of the mixed image

%unmixedimg = zeros(size(c,1),size(c,2),size(refmat,2));
standard546 = zeros(904,904);
standard555 = zeros(904, 904);

%first we unmix 546 and 555 by themselves to create standards
for i = 1:size(c,1)
    for j = 1:size(c,2)
        pixela = rescale(permute(a(i,j,:),[3 2 1]));
        pixelb = rescale(permute(b(i,j,:), [3 2 1]));
        standard546(i,j) = lsqnonneg(refa, pixela);
        standard555(i,j) = lsqnonneg(refb, pixelb);
    end 
end

%next, we have to unmix each pure fluor by the reference matrix
fakeunmix546 = zeros(904,904,2);
fakeunmix555 = zeros(904,904,2);

for i = 1:size(c,1)
    for j = 1:size(c,2)
        pixela = rescale(permute(a(i,j,:),[3 2 1]));
        pixelb = rescale(permute(b(i,j,:), [3 2 1]));
        
        fakeunmix546(i,j,:) = lsqnonneg(refmat,pixela); %546 is unmixed with both fluorophores
        fakeunmix555(i,j,:) = lsqnonneg(refmat,pixelb);%555 is unmixed with both fluorophores
    end 
end


realFOMS(1) = 1 - mean(abs(standard546 - fakeunmix546(:,:,1)),'all');
realFOMS(2) = 1 - mean(abs(standard555 - fakeunmix555(:,:,2)),'all');


end