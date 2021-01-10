function plotnice(D)
M = size(D,1);
imAlpha=ones(size(D));
imAlpha(isnan(D))=0;
imagesc(0:M-1,0:M-1,D,'AlphaData',imAlpha);
set(gca,'color',0*[1 1 1]);