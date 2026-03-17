close all; clear; clc;

%%% Fusion Method Parameters
detail_exponent = 1;
Nlevels = 6;
NoOfBands = 3 * Nlevels + 1;
wname = 'DCHWT';
%% Image Input
arr = ['A'; 'B'];
for m = 1:2
    string = arr(m);
    inp_image = strcat('images\abc', string, '.jpg');
    x{m} = imread(inp_image);
end
%% Processing
% Applying Guided Filter at pre-processing
for m = 1:2
    for c = 1:3
        temp = double(x{m}(:,:,c));
        temp = imguidedfilter(temp,'NeighborhoodSize',[9 9],'DegreeOfSmoothing',35);
        x{m}(:,:,c) = uint8(temp);
    end
end
sigma_e = 0.2;   % Exposure sensitivity parameter
for m = 1:2
    I_norm = im2double(rgb2gray(x{m}));
end
[M, N, ~] = size(x{1});
fused_rgb = zeros(M, N, 3, 'uint8');
tic
for c = 1:3 % R, G, B channels
    for m = 1:2
        xin = double(x{m}(:,:,c));
        CW = dchwt(xin, Nlevels);
        inp_wt{m} = CW;
    end
    %% Fusion and Reconstruction
    % Fusion
    fuse_im = fusion(inp_wt, Nlevels, detail_exponent);
    % Reconstruction
    xrcw = uint8(dchwt(fuse_im, -Nlevels));
    % Resizing
    xrcw_resized = imresize(xrcw, [M, N]);
    fused_rgb(:,:,c) = xrcw_resized;
end
toc
%% Display of Images and Metrices Calculation
% Display original and fused RGB image
figure, imshow(x{1}); title('Input Image A');
figure, imshow(x{2}); title('Input Image B');
figure, imshow(fused_rgb); title('Fused Image');
% Evaluate matrices
matrices_new(rgb2gray(fused_rgb),rgb2gray(x{1}),im2gray(x{2}));
