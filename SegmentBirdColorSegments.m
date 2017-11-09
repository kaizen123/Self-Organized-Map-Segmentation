

clc; clear all; close all;
% Solve a Clustering Problem with a Self-Organizing Map
% Script generated by NCTOOL
%
% This script assumes these variables are defined:
%
%   simpleclusterInputs - input data.
I=imread('Gold-Finch.jpg'); 
%I = imresize(I,0.5);
figure,imshow(I);
title('Original Image');

% I=rgb2gray(I);
I1=I(:,:,1);
%Label Every Pixel in the Image Using the Results from KMEANS
nrows=size(I1,1);
ncols=size(I1,2);

I1=reshape(I1,1,[]);
I1=double(I1);
 normA = (I1-min(I1(:))) ./ (max(I1(:))-min(I1(:)));
 
 I2=I(:,:,2);
I2=reshape(I2,1,[]);
I2=double(I2);
 normB = (I2-min(I2(:))) ./ (max(I2(:))-min(I2(:)));
 
  I3=I(:,:,3);
I3=reshape(I3,1,[]);
I3=double(I3);
 normC = (I3-min(I3(:))) ./ (max(I3(:))-min(I3(:)));
 
 
 % normB = (b-min(b(:))) ./ (max(b(:))-min(b(:)));


% cform = makecform('srgb2lab');
% lab_I = applycform(I,cform);
% ab = double(lab_I(:,:,2:3));
% nrows = size(ab,1);
% ncols = size(ab,2);
% ab = reshape(ab,nrows*ncols,2);
% a = ab(:,1);
% b = ab(:,2);
% normA = (a-min(a(:))) ./ (max(a(:))-min(a(:)));
% normB = (b-min(b(:))) ./ (max(b(:))-min(b(:)));
% ab = [normA normB];
% newnRows = size(ab,1);
% newnCols = size(ab,2);



inputs=[normA;  normB;  normC];

%%inputs = simpleclusterInputs;

% Create a Self-Organizing Map
dimension1 = 3;
dimension2 =3;
net = selforgmap([dimension1 dimension2]);

% Train the Network
[net,tr] = train(net,inputs);

% Test the Network
outputs = net(inputs);

% View the Network
view(net)

cluster=9;

clusterindex=outputs;

clusterindex=vec2ind(clusterindex);




pixel_labels = reshape(clusterindex,nrows,ncols);

segmented_images = cell(1,4);
rgb_label = repmat(pixel_labels,[1 1 3]);

SegmentedImage=zeros(nrows,ncols,3);
SegmentedImage=uint8(SegmentedImage);
for k = 1:cluster
    color = I;
    color(rgb_label ~= k) = 0;
    A=color(rgb_label == k);
    A1=color(:,:,1);
    A2=color(:,:,2);
    A3=color(:,:,3);
    Q1=median(A1(pixel_labels==k));
    Q2=median(A2(pixel_labels==k));
    Q3=median(A3(pixel_labels==k));
    Q=median(color(rgb_label == k));
    BB1=repmat(Q1 ,nrows,ncols);
    BB2=repmat(Q2 ,nrows,ncols);
    BB3=repmat(Q3 ,nrows,ncols);
    BB=zeros(nrows,ncols,3);
    BB(:,:,1)=BB1;
    BB(:,:,2)=BB2;
    BB(:,:,3)=BB3;
    
     %color(rgb_label == k) = BB;
     %color(rgb_label == k) = [Q1 Q2 Q3];
%        color(rgb_label == k) = Q1 ;
%          koko=find(color);
   colorimg=Replacevalues(color,Q1,Q2,Q3);
    segmented_images{k} = colorimg;
    qqq=segmented_images{k};
    qqq=uint8(qqq);
%     figure,imshow(uint8(segmented_images{k}))
   SegmentedImage=imadd(SegmentedImage,qqq);
end



figure,imshow(SegmentedImage);
title('Color Segments');