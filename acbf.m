function acbf(filename)

%% Função Active Color Boost Filter
%  
%  Essa função tem o objetivo de aplicar o filtro Active Color Boost na Imagem
%  Inserida. 
%  
%  Input: imagem de entrada
%  
%  Output: imagem com o color boost aplicado
%  
%  Exemplo: acbf('image3.png');

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
    devH = std(H(:));
    devS = std(S(:));
    sigma = 0.63;
    t = abs(20*log(sigma+1));

    %% Aplicação do filtro no canal H
    for i = 1:r
        for j = 1:c
            x = abs((H(i,j)*meanH)/(2*pi*devH^2));
            es = exp((-sigma*pi)/((1-sigma^2)^0.5));
            imgnH(i,j) = 0.5*H(i,j) + 0.5*H(i,j).*((t-x)*es);
        end
    end

    % for i = 1:r
    %     for j = 1:c
    %         x = abs((S(i,j)*meanS)/(2*pi*devS^2));
    %         es = exp((-sigma*pi)/((1-sigma^2)^0.5));
    %         imgnS(i,j) = 0.17*S(i,j) + 0.83*S(i,j).*((t-x)*es);
    %     end
    % end

    %% Concatenação e melhoria da imagem
    eHSVcommon = cat(3, H, S, imadjust(V));
    eHSVacb = cat(3, imgnH, S, imadjust(V));
    imgRGBcomm = hsv2rgb(eHSVcommon);
    imgRGBacb = hsv2rgb(eHSVacb);
    % eme(imgRGBcomm)
    % eme(imgRGBacb)
    % entropy(imgRGBcomm)
    % entropy(imgRGBacb)

    %% Exibe e grava a imagem com o Color Boost
    figure, imshow(img), figure, imshow(imgRGBcomm), figure, imshow(imgRGBacb)
    imwrite(imgRGBacb,'imgCBF.png');
    %imwrite(imgRGB1,'withoutColorBoost.jpg');
end