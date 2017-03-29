function [out,filter,xhat] = predictKalman(filter,angle,z, start_position,start)



% if(size(z,2)<100) 
 if (~start)
P{1}= filter{angle}.P;
xhat(:,1) = filter{angle}.start;
% xhat(2:6,1)=0;
%  elseif (exists(filter{angle}.P))
%  elseif (any(strcmp('P',fieldnames(filter{angle}))))
%      P{1}= filter{angle}.P;
% xhat(:,1) = start_position; 
% xhat(3:4,1)=0;

 else 
xhat(:,1) = start_position; 
% xhat(3:4,1)=0;
P{1}= zeros(size(xhat,1),size(xhat,1));

 end 
 
 if (size(z,2)==1)
   z(:,end+1) =  z(:,end);
 end 
 
for k=2:size(z,2)
    
    xbar(:,k) = filter{angle}.A*xhat(:,k-1);
    Pbar{k} = filter{angle}.A*(P{k-1})*transpose(filter{angle}.A) + filter{angle}.W; 
    K{k}= Pbar{k}*transpose(filter{angle}.H)*inv(filter{angle}.H*Pbar{k}*transpose(filter{angle}.H)+filter{angle}.Q); 
  
    xhat(:,k) = xbar(:,k) + K{k}*(z(:,k)-filter{angle}.H*xbar(:,k));
    
    P{k}= (eye(size(K{k},1))- K{k}*filter{angle}.H)*Pbar{k};

end

out = xhat(:,end);

filter{angle}.P = P{end}; 
filter{angle}.start = xhat(:,end); 
 
end

