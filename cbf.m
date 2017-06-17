function cbf(filename)

%% Função Color Boost Filter
%  
%  Essa função tem o objetivo de aplicar o filtro Color Boost na Imagem
%  inserida. 
%  
%  Input: imagem de entrada
%  
%  Output: imagem com o color boost aplicado
%  
%  Exemplo: cbf('image3.png');

%% Leitura da imagem
    img = imread(filename);
    %img = imresize(img, 0.5);
    [r, c, s] = size(img);

imgHSV = rgb2hsv(img);
H = imgHSV(:,:,1);
S = imgHSV(:,:,2);
V = imgHSV(:,:,3);

%% Retira os valores da média e variancia dos canais H e S
meanH = mean2(H);
meanS = mean2(S);
sigma = 0.63;
t = abs(20*log(sigma+1));

%% Aplicação do filtro no canal H
for i = 1:r
    for j = 1:c
        x = abs(H(i,j)/meanH);
        es = exp((-sigma*pi)/((1-sigma^2)^0.5));
        imgnH(i,j) = H(i,j).*((t-x).*es);
    end
end

%% Aplicação do filtro no canal S
for i = 1:r
    for j = 1:c
        x = abs(S(i,j)/meanS);
        es = exp((-sigma*pi)/((1-sigma^2)^0.5));
        imgnS(i,j) = S(i,j).*((t-x).*es);
    end
end

%% Concatenação e melhoria da imagem
enhancedHSV1 = cat(3, imadjust(H), imadjust(S), imadjust(V));
enhancedHSV2 = cat(3, imadjust(imgnH), imadjust(imgnS), imadjust(V));
imgRGB1 = hsv2rgb(enhancedHSV1);
imgRGB2 = hsv2rgb(enhancedHSV2);

%% Exibe e grava a imagem com o Color Boost
figure, imshow(img), figure, imshow(imgnH), figure, imshow(imgRGB1), figure, imshow(imgRGB2)
imwrite(imgRGB2,'imgColorBoost.png');

end