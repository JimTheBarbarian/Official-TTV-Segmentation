function [u,c,result,lambda,SegmentationScore,time] = ParameterTL1_2(f,x,p,I,csf, wm, gm,n)
%UNTITLED2 Summary of this function goes here
%   I is the image we are using
%   f is the function we are performing parameter tuning on 
%   x is a vector whose entries are the different parameters we will
%   attempt to use 
%   c is a vector containing all the non-tunable parameters
lambda = 0;
SegmentationScore = 0;
time = 0;

for i = 1:length(x)
    tic;
    [u1,c1,result1] = f(I,n,x(i),p(1),p(2),p(3),2);
    t = toc;
    csf_score = max([dice(u1(:,:,1)>0.5,csf), dice(u1(:,:,2)>0.5,csf),  dice(u1(:,:,3)>0.5,csf),  dice(u1(:,:,4)>0.5,csf)]);
    wm_score = max([dice(u1(:,:,1)>0.5,wm), dice(u1(:,:,2)>0.5,wm),  dice(u1(:,:,3)>0.5,wm),  dice(u1(:,:,4)>0.5,wm)]);
    gm_score = max([dice(u1(:,:,1)>0.5,gm), dice(u1(:,:,2)>0.5,gm),  dice(u1(:,:,3)>0.5,gm),  dice(u1(:,:,4)>0.5,gm)]);
    mean_score = (csf_score+wm_score+gm_score)/3
    if mean_score > SegmentationScore
        SegmentationScore = mean_score;
        lambda = x(i);
        time = t;
        u = u1; c = c1; result = result1;
    end
end



end