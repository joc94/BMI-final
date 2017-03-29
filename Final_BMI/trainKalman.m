function K = trainKalman(output,input,dt,lag,start)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here


 
for angle = 1:length(output.Av_po)
    
len = size(output.Av_po{angle},2);

% rawvelocity_x = diff(sqrt(output.Av_po{angle}(1,lag+1:len).^2));
% rawvelocity_y = diff(sqrt(output.Av_po{angle}(2,lag+1:len).^2));
% 
% rawvelocity_x= cat(2,[0],rawvelocity_x);
% rawvelocity_y= cat(2,[0],rawvelocity_y);

%  K{angle}.X = output.Av_po{angle}(1:2,lag+1:len); 
 
% K{angle}.X(3,:) = rawvelocity_x(:);
% K{angle}.X(4,:) = rawvelocity_y(:);

% K{angle}.X_1 = output.Av_po{angle}(1:2,lag+1:(len-1)); 
% K{angle}.X_1(3,:) = rawvelocity_x(1:end-1);
% K{angle}.X_1(4,:) = rawvelocity_y(1:end-1);

% K{angle}.X_2 = output.Av_po{angle}(1:2,lag+2:len);
% K{angle}.X_2(3,:) = rawvelocity_x(2:end);
% K{angle}.X_2(4,:) = rawvelocity_y(2:end);


% K{angle}.A = K{angle}.X_2*transpose(K{angle}.X_1)*inv(K{angle}.X_1*transpose(K{angle}.X_1));


for i = 1:98
    
    A = output.l_local_non_shifted{i,angle}(:,1:len-lag); 
%     K{angle}.Z(i,:) = output.l_PSTH_non_shifted{i,angle}(:,1:len-lag); 
     K{angle}.Z(i,:) = reshape(A.',1,numel(A)); 
    
end 
B = lag+1:len; 

K{angle}.Z(99,:) = repmat(B,1, size(A,1));

K{angle}.X = [];
K{angle}.X_1 = []; 
K{angle}.X_2 = []; 


for n = 1:size(A,1)
    
    
K{angle}.X = [K{angle}.X, output.original_Po{n,angle}(1:2,lag+1:len)]; 

if (n == size(A,1))
    K{angle}.X_1 = [K{angle}.X_1, output.original_Po{n,angle}(1:2,lag+1:len-1)]; 
    else 
K{angle}.X_1 = [K{angle}.X_1, output.original_Po{n,angle}(1:2,lag+1:len)]; 
end 
if (n==1)
  K{angle}.X_2 = [K{angle}.X_2, output.original_Po{n,angle}(1:2,lag+2:len)]; 
else 
    K{angle}.X_2 = [K{angle}.X_2, output.original_Po{n,angle}(1:2,lag+1:len)]; 

end 
end 

K{angle}.A = K{angle}.X_2*transpose(K{angle}.X_1)*inv(K{angle}.X_1*transpose(K{angle}.X_1));


K{angle}.H = K{angle}.Z*transpose(K{angle}.X)*inv(K{angle}.X*transpose(K{angle}.X)); 

K{angle}.W = (K{angle}.X_2-K{angle}.A*K{angle}.X_1)*transpose(K{angle}.X_2-K{angle}.A*K{angle}.X_1)./(size(K{angle}.X_1,2));
K{angle}.Q = (K{angle}.Z - K{angle}.H*K{angle}.X)*transpose(K{angle}.Z - K{angle}.H*K{angle}.X)/(size(K{angle}.Z,2)); 
end 


end

