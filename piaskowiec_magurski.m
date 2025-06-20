close all; clear; clc;

% skała: Piaskowiec magurski
% minerały: 
% - kwarc - szary, 
% - glaukonit - zielony, 
% - kalcyt - barwy pastelowe
% skala: 20x


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
images = {b, b300, a, b240};
% figure;
% for k = 1 : length(images)
%     subplot(2, 2, k);
%     imshow(images{k});
% end



% -------------------------
% 1. Kwarc
% -------------------------
kwarc1 = a(:,:,1) > 170 & ...
         a(:,:,2) > 160 & ...
         a(:,:,3) > 140 & ...
         a(:,:,2) < 190;
kwarc1 = kwarc1 & ...
        abs(a(:,:,1) - a(:,:,2)) < 15;

kwarc1 = kwarc1 & ... 
         ((abs(b(:,:,1) - b(:,:,2)) < 20) & ...
          (abs(b(:,:,1) - b(:,:,3)) < 20) & ...
          (abs(b(:,:,2) - b(:,:,3)) < 20));

kwarc=medfilt2(kwarc1, [4 4]);
kwarc=wiener2(kwarc, [5 6]);
kwarc=medfilt2(kwarc, [10 10]);
kwarc=medfilt2(kwarc, [7 7]);
kwarc=wiener2(kwarc, [7 7]);
kwarc=medfilt2(kwarc, [7 7]);
kwarc=medfilt2(kwarc, [16 16]);
kwarc=~bwareaopen(~kwarc, 7000);
kwarc=bwareaopen(kwarc, 1500);
se = strel('rectangle', [35 1]);
kwarc=imerode(kwarc, se);
kwarc=bwareaopen(kwarc, 5000);
warc=medfilt2(kwarc, [16 16]);
kwarc=medfilt2(kwarc, [16 16]);
kwarc=medfilt2(kwarc, [9 9]);
kwarc=medfilt2(kwarc, [9 9]);
kwarc=medfilt2(kwarc, [11 11]);
kwarc=~bwareaopen(~kwarc, 20000);



% -------------------------
% 2. Glaukonit
% -------------------------
for k=1:3
    a(:,:,k)=medfilt2(a(:,:,k), [15 15]);
end

[Nz, Nx, ~] = size(a);
glaukonit = ones(Nz, Nx) - kwarc;
 
glaukonit = glaukonit & (a(:,:,1) > 90) & ...
                 (a(:,:,2) > 90) & ...
                 (a(:,:,3) > 10);

glaukonit = glaukonit & ...
         ((abs(a(:,:,1) - a(:,:,2)) > 20) | ...
          (abs(a(:,:,1) - a(:,:,3)) > 20) | ...
          (abs(a(:,:,2) - a(:,:,3)) > 20));

glaukonit = glaukonit & ...
            ( ...
            (a(:,:,1) < 140) & ...
            (a(:,:,3) < 100) & ...
            (a(:,:,3) > 45) ...
            );

glaukonit_color = b(:,:,1) < 180 & (b(:,:,1) - b(:,:,2)) < 20 & b(:,:,2) > 70;
glaukonit_konc = glaukonit & glaukonit_color;

glaukonit_konc=medfilt2(glaukonit_konc, [7 7]); 
glaukonit_konc=wiener2(glaukonit_konc, [5 5]);
glaukonit_konc=wiener2(glaukonit_konc, [7 7]);
glaukonit_konc=medfilt2(glaukonit_konc, [21 21]);
glaukonit_konc=medfilt2(glaukonit_konc, [7 7]); 
glaukonit_konc=medfilt2(glaukonit_konc, [17 17]); 
glaukonit_konc=~bwareaopen(~glaukonit_konc, 3000);
glaukonit_konc=bwareaopen(glaukonit_konc, 7000);



% -------------------------
% Kalcyt
% -------------------------
for k=1:3
    b(:,:,k)=medfilt2(b(:,:,k), [15 15]);
end
% zielen
% R -> 90 : 110
% G -> 105 : 125
% B -> 60 : 80
% dla poj. pol.
% R -> 160 : 200
% G -> 160 : 200
% B -> 120 : 160

[Nz, Nx, ~] = size(a);
kalcyt = ones(Nz, Nx) - kwarc;
kalcyt = kalcyt - glaukonit_konc;

kalcyt1 = kalcyt & ...
            ( ...
                ( ...
                    (a(:,:,1) > 150) & (a(:,:,1) < 200) & ...
                    (a(:,:,2) > 150) & (a(:,:,2) < 200) & ...
                    (a(:,:,3) > 150) & (a(:,:,3) < 170) ...
                ) | ...
                ( ...
                    (a(:,:,3) > 130) & (a(:,:,3) < 150) & ...
                    (a(:,:,2) > 180) ...
                ) ...
             );

kalcyt = kalcyt1 & ...
         ( ...
            ( ...
                (b(:,:,1) > 90) & (b(:,:,1) < 140) & ...
                (b(:,:,2) > 105) & (b(:,:,2) < 140) & ...
                (b(:,:,3) > 60) & (b(:,:,3) < 80) ...
            ) | ...
            ( ...
                (b(:,:,1) > 180) & ...
                (b(:,:,2) > 180) & ...
                (b(:,:,3) > 100) ...
            ) ...
         );


kalcyt=medfilt2(kalcyt, [7 7]);
kalcyt=wiener2(kalcyt, [3 3]);
kalcyt=medfilt2(kalcyt, [11 11]);
kalcyt=medfilt2(kalcyt, [11 11]);
kalcyt=wiener2(kalcyt, [3 3]);
kalcyt=imdilate(kalcyt, ones(9));
kalcyt=medfilt2(kalcyt, [21 21]);
kalcyt=~bwareaopen(~kalcyt, 5000);

se = strel('rectangle', [10 1]);
kalcyt = imerode(kalcyt, se);
se = strel('rectangle', [1 10]);
kalcyt = imerode(kalcyt, se);
kalcyt = imerode(kalcyt, ones(4));
kalcyt = bwareaopen(kalcyt, 2000);

se = strel('rectangle', [20 1]);
kalcyt = imdilate(kalcyt, se);


% -------------------------
% Inne
% -------------------------
inne=true(size(kwarc));
inne=inne - kwarc - glaukonit_konc - kalcyt;
inne = ~bwareaopen(~inne, 5000);
inne=bwareaopen(inne, 1000);


% -------------------------
% Pole powierzchni
% -------------------------
sk = imread('piaskowiec/NX_00_skala.jpg');

skala = (50^2)/(178^2);

% Obliczenia powierzchni (µm²)
area_kalcyt = bwarea(kalcyt) * skala;
area_kwarc = bwarea(kwarc) * skala;
area_glauk = bwarea(glaukonit_konc) * skala;
area_inne = bwarea(inne) * skala;

% Całkowita powierzchnia w pikselach
total_area = bwarea(true(size(kwarc)));

% Obliczenia udziałów procentowych
percent_kalcyt = bwarea(kalcyt) / total_area * 100;
percent_kwarc = bwarea(kwarc) / total_area * 100;
percent_glauk = bwarea(glaukonit_konc) / total_area * 100;
percent_inne = bwarea(inne) / total_area * 100;

fprintf('--- Powierzchnia (um2) ---\n');
fprintf('Kalcyt         : %.2f um2\n', area_kalcyt);
fprintf('Kwarc          : %.2f um2\n', area_kwarc);
fprintf('Glaukonit      : %.2f um2\n', area_glauk);
fprintf('Inne           : %.2f um2\n\n', area_inne);

fprintf('--- Udział procentowy ---\n');
fprintf('Kalcyt         : %.2f %%\n', percent_kalcyt);
fprintf('Kwarc          : %.2f %%\n', percent_kwarc);
fprintf('Glaukonit      : %.2f %%\n', percent_glauk);
fprintf('Inne           : %.2f %%\n', percent_inne);


% -------------------------
% Wizualizacja
% -------------------------
[m, n] = size(kwarc);
rgbImage = zeros(m, n, 3);

rgbImage(:,:,1) = kwarc;
rgbImage(:,:,2) = glaukonit_konc;
rgbImage(:,:,3) = kalcyt;

sumMask = kwarc + glaukonit_konc + kalcyt;
conflictPixels = sumMask ~= 1;
rgbImage(repmat(conflictPixels, [1 1 3])) = 0;

figure;
imshow(rgbImage);
title('Mapa Minerałów');

hold on;
kolory = [1 0 0; 0 1 0; 0 0 1; 0 0 0];
nazwy = ["Kwarc", "Glaukonit", "Kalcyt", "Inne"];

for k = 1:length(nazwy)
    scatter(NaN, NaN, 100, kolory(k,:), 'filled', 'DisplayName', nazwy(k));
end

legend('Location', 'bestoutside');
hold off;
