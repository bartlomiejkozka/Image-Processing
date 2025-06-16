close all; clear; clc;

% image description
% skała: Piaskowiec magurski
% minerały: 
% - kwarc - szary, 
% - glaukonit - zielony, 
% - kalcyt - barwy pastelowe
% skala: 20x

% read data
% a - image with single polarizator
% b - images with corss polarizators
a = imread('piaskowiec/1N_00.jpg');
b = imread('piaskowiec/NX_00.jpg');
b30 = imread('piaskowiec/NX_30.jpg');
b60 = imread('piaskowiec/NX_60.jpg');
b90 = imread('piaskowiec/NX_90.jpg');
b120 = imread('piaskowiec/NX_120.jpg');
b150 = imread('piaskowiec/NX_150.jpg');
b180 = imread('piaskowiec/NX_180.jpg');
b210 = imread('piaskowiec/NX_210.jpg');
b240 = imread('piaskowiec/NX_240.jpg');
b270 = imread('piaskowiec/NX_270.jpg');
b300 = imread('piaskowiec/NX_300.jpg');
b330 = imread('piaskowiec/NX_330.jpg');

% ploting whole set of iamges to choose the best one from cross
% polarization
images = {b, b90, b120, b180};

figure;
for k = 1 : length(images)
    subplot(2, 2, k);
    imshow(images{k});
end

% choose the one with the 0 angle from cross polarizators
figure;
subplot(121), imshow(a);
subplot(122), imshow(b);

% looking for minerals

% 1. Kwarc
% a) pojedynczy polaryzator
% kolor:    jasno szary - piaskowy - jasno zółty
% RGB:      [180, 180, 150] 
kwarc = a(:,:,1) > 140 & ...
         a(:,:,2) > 140 & ...
         a(:,:,3) > 120;
kwarc = kwarc | ...
        (a(:,:,1) < 50 & ...
         a(:,:,2) < 50 & ...
         a(:,:,3) < 50);
kwarc = kwarc & ...
        abs(a(:,:,1) - a(:,:,2)) < 20;

% b) corss polaryzator
% kolor:    biały - szary - czarny
kwarc = kwarc & ... 
         ((abs(b(:,:,1) - b(:,:,2)) < 20) & ...
          (abs(b(:,:,1) - b(:,:,3)) < 20) & ...
          (abs(b(:,:,2) - b(:,:,3)) < 20));

kwarc = wiener2(kwarc, [3 3]);
kwarc = medfilt2(kwarc, [3 3]);
kwarc = wiener2(kwarc, [3 3]);
kwarc = medfilt2(kwarc, [10 10]);
kwarc = medfilt2(kwarc, [20 20]);
kwarc = bwareaopen(kwarc, 10000);
kwarc = medfilt2(kwarc, [50 50]);
kwarc = ~bwareaopen(~kwarc, 1000);
kwarc = ~imdilate(~kwarc, ones(10));


figure;
subplot(121), imshow(b);
subplot(122), imshow(kwarc);


% 2. Glaukonit
% a) pojedynczy polaryzator
% kolor:            zielony, żółty
% kolor dominujący: zielony
% RGB:      [:, :, <100] 
glaukonit = (a(:,:,2) > 100) & ...
            (a(:,:,3) < 100) & ...
            (a(:,:,1) < 120);

% b) corss polaryzator
% kolor:    biały - szary - czarny
glaukonit = glaukonit | ...
            ((b(:,:,2) > 100) & ...
            (b(:,:,3) < 100) & ...
            ((abs(b(:,:,1) - b(:,:,2)) > 50) | ...
            (abs(b(:,:,1) - b(:,:,3)) > 50) | ...
            (abs(b(:,:,2) - b(:,:,3)) > 50)) ...
            );

glaukonit = glaukonit & ...
            b(:,:,1) < 130;

%}
%{
glaukonit = bwareaopen(glaukonit, 10);
glaukonit = imdilate(glaukonit, ones(3));
glaukonit = medfilt2(glaukonit, [5 5]);
glaukonit = wiener2(glaukonit, [7 7]);
glaukonit = medfilt2(glaukonit, [10 10]);
glaukonit = medfilt2(glaukonit, [10 10]);
glaukonit = ~bwareaopen(~glaukonit, 1000);

glaukonit = bwareaopen(glaukonit, 5000);
glaukonit = medfilt2(glaukonit, [10 10]);
glaukonit = medfilt2(glaukonit, [20 20]);
glaukonit = medfilt2(glaukonit, [10 10]);

%}
%{
%glaukonit = ~bwareaopen(~glaukonit, 50);
glaukonit = wiener2(glaukonit, [3 3]);


glaukonit = medfilt2(glaukonit, [10 10]);
glaukonit = wiener2(glaukonit, [10 10]);

glaukonit = bwareaopen(glaukonit, 10000);
glaukonit = ~bwareaopen(~glaukonit, 1000);

glaukonit = ~imdilate(~glaukonit, ones(30));


glaukonit = medfilt2(glaukonit, [10 10]);
glaukonit = bwareaopen(glaukonit, 5000);
glaukonit = ~imdilate(~glaukonit, ones(10));
glaukonit = bwareaopen(glaukonit, 5000);
glaukonit = medfilt2(glaukonit, [5 5]);

%}


figure;
subplot(121), imshow(b);
subplot(122), imshow(glaukonit);
