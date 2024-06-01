%% Load and modify image
% Select brain image: result1, result2, result3, result4
load('result4.mat')

% set background pixel intensity 0 to 10
image(image == 0) = 10;

% get ground-truth label
bg = (image==10);
csf = (image==48);
gm = (image==106);
wm = (image==154);

% normalize image
image = double(image)/255;

% set seed
rng(1234);

% add noise
Ig2 = imnoise(image, 'gaussian', 0.04);


%% Run algorithm to segment image

% List of potential Lambdas for TTV
lambda_ttv = (.0025:0.0025:.02); 

% a=1 TTV segmentation
beta_a1_ttv = [.25,.25,1]; % non tunable parameters for TTV (a=1)
[u_ttv1,c_ttv1,result_ttv1,lambda_ttv1,ssim_result_ttv1,time_result_ttv1] = ParameterTL1_2(@TTV,lambda_ttv,beta_a1_ttv,Ig2,csf, wm, gm,4);

% a=5 TTV segmentation
beta_a5_ttv = [.25,.25,5]; % non tunable parameters for TTV (a=5)
[u_ttv5,c_ttv5,result_ttv5,lambda_ttv5,ssim_result_ttv5,time_result_ttv5] = ParameterTL1_2(@TTV,lambda_ttv,beta_a5_ttv,Ig2,csf, wm, gm,4);

% a=10 TTV segmentation
beta_a10_ttv = [.25,.25,10]; % non tunable parameters for TTV (a=10)
[u_ttv10,c_ttv10,result_ttv10,lambda_ttv10,ssim_result_ttv10,time_result_ttv10] = ParameterTL1_2(@TTV,lambda_ttv,beta_a10_ttv,Ig2,csf, wm, gm,4);

%% plot results
figure; subplot(3,4,1); imagesc(Ig2); axis off; axis image; colormap gray; title('Noisy', 'Interpreter','latex', 'FontSize',16);
subplot(3,4,2); imagesc(labeloverlay(double(csf), u_ttv1(:,:,2)>0.5, 'Transparency', 0.1)); axis off; colormap gray; axis image; title('TTV $(a=1)$','Interpreter','latex', 'FontSize',16)
subplot(3,4,3); imagesc(labeloverlay(double(csf), u_ttv5(:,:,2)>0.5, 'Transparency', 0.1)); axis off; colormap gray; axis image; title('TTV $(a=5)$','Interpreter','latex', 'FontSize',16)
subplot(3,4,4); imagesc(labeloverlay(double(csf), u_ttv10(:,:,2)>0.5, 'Transparency', 0.1)); axis off; colormap gray; axis image; title('TTV $(a=10)$','Interpreter','latex', 'FontSize',16)

subplot(3,4,6); imagesc(labeloverlay(double(gm), u_ttv1(:,:,3)>0.5, 'Transparency', 0.1)); axis off; colormap gray; axis image;
subplot(3,4,7); imagesc(labeloverlay(double(gm), u_ttv5(:,:,3)>0.5, 'Transparency', 0.1)); axis off; colormap gray; axis image;
subplot(3,4,8); imagesc(labeloverlay(double(gm), u_ttv10(:,:,3)>0.5, 'Transparency', 0.1)); axis off; colormap gray; axis image;

subplot(3,4,10); imagesc(labeloverlay(double(wm), u_ttv1(:,:,1)>0.5, 'Transparency', 0.1)); axis off; colormap gray; axis image;
subplot(3,4,11); imagesc(labeloverlay(double(wm), u_ttv5(:,:,1)>0.5, 'Transparency', 0.1)); axis off; colormap gray; axis image;
subplot(3,4,12); imagesc(labeloverlay(double(wm), u_ttv10(:,:,1)>0.5, 'Transparency', 0.1)); axis off; colormap gray; axis image;
