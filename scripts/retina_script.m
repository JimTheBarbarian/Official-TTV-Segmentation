%% Load and modify image: 21_manual1, 22_manual1, 24_manual1
img = imread('22_manual1.gif');
img = rescale(double(img));

% change pixel intensity
img(img==0) = 0.40;
img(img==1) = 0.75;

% add noise
rng(1234);
Ig2 = imnoise(img, 'gaussian', 0.01);

%% Run TTV segmentation algorithm

%List of potential Lambdas for TTV
lambda_ttv = (.005:0.005:.05); 

% a=5 TTV segmentation
beta_a5_ttv = [.25,.25,5]; % non tunable parameters for TTV (a=0.5)
[u_ttv5,c_ttv5,result_ttv5,lambda_ttv5,ssim_result_ttv5,time_result_ttv5] = ParameterTL1(@TTV,lambda_ttv,beta_a5_ttv,Ig2,img==0.75,2);

% a= 10 TTV segmentation
beta_a10_ttv = [.25,.25,10]; % non tunable parameters for TTV (a=10)
[u_ttv10,c_ttv10,result_ttv10,lambda_ttv10,ssim_result_ttv10,time_result_ttv10] = ParameterTL1(@TTV,lambda_ttv,beta_a10_ttv,Ig2,img==0.75,2);

% a=100 TTV segmentation
beta_a100_ttv = [.25,.25,100]; % non tunable parameters for TTV (a=1)

[u_ttv100,c_ttv100,result_ttv100,lambda_ttv100,ssim_result_ttv100,time_result_ttv100] = ParameterTL1(@TTV,lambda_ttv,beta_a100_ttv,Ig2,img==0.75,2);

%% Plot figure
img(img==0.4) = 0; img(img==0.75)=1;
figure; subplot(1,4,1); imagesc(Ig2); axis off; axis image; colormap gray; title('Noisy', 'Interpreter','latex', 'FontSize',16);
subplot(1,4,2); imagesc(labeloverlay(img, u_ttv5(:,:,1)<0.5, 'Transparency', 0.1),[0.4,0.75]); axis off; colormap gray; axis image; title('TTV $(a=5)$','Interpreter','latex', 'FontSize',16)
subplot(1,4,3); imagesc(labeloverlay(img, u_ttv10(:,:,1)<0.5, 'Transparency', 0.1),[0.4,0.75]); axis off; colormap gray; axis image; title('TTV $(a=10)$','Interpreter','latex', 'FontSize',16)
subplot(1,4,4); imagesc(labeloverlay(img, u_ttv100(:,:,1)<0.5, 'Transparency', 0.1),[0.4,0.75]); axis off; colormap gray; axis image; title('TTV $(a=100)$','Interpreter','latex', 'FontSize',16)
