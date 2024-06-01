function [d_new] = d_subproblem(v, lambda, beta2,a,q, direction)
%UNTITLED4 Summary of this function goes here
%   a is our transform parameter
%   lambda is the regularization parameter
%   v is the auxillary variable assigned to u for which each entry has n
%   channels. 
%   q is the Lagrange multipliers associated with the constraint 
% grad(v_i) = d_i.

[~, ~, regions] = size(v);


if direction == 1
    d_new = Dx(v); 
else
    d_new = Dy(v); 
end
d_new = d_new + 1/beta2 * q;


if (lambda/beta2) > a^2/ (2*(a+1))
    tau = sqrt(2*(lambda/beta2) * (a+1)) - a/2;
else
    tau = (lambda/beta2) * (a+1)/a;
end

for i = 1:regions
    channel = d_new(:,:,i); % concatenate into one large vector; allows us to vectorize this subproblem.
    phi = d_sub_phi(channel,lambda/beta2,a); % compute lambda subfunction
    channel = sign(channel).* ((2/3) * (a + abs(channel)).*cos(phi/3) - 2*a/3 + abs(channel) / 3);
    channel(abs(d_new(:,:,i)) < tau) = 0; % apply thresholding to d_i,x and d_i,y
    d_new(:,:,i) = channel;
end

end