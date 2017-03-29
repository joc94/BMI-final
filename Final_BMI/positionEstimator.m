function [decodedPosX, decodedPosY, newParameters] = positionEstimator(testData, kalmans)
% Template for our function to get outputs from the model
% Inputs: past_current_trial (spikes from start of trial to current time) 
%         modelParameters (Model parameters from the trained model)
times = size(testData.spikes(1,:),2);

% kernel = false; 
% 
% dt = 20; 
% 
% start = 1;
% lag = 0;


% kernel = 'Gaussian'; 
% 
% dt = 5; 
% 
% start = 1;
% lag = 0;

% if (angle == 7)
% kernel = 'Gaussian'; 
% dt = 3; 
% start = 1;
% lag = 0;
% elseif (angle == 5)
% kernel = 'Gaussian'; 
% dt = 5; 
% start = 1;
% lag = 0;
% elseif (angle == 1)
% kernel = 'Gaussian'; 
% dt = 8; 
% start = 1;
% lag = 0;
% elseif (angle == 2 || angle == 3)
% kernel = 'Gaussian'; 
% dt = 3; 
% start = 1;
% lag = 0;
% elseif (angle == 4 || angle == 6 || angle==8)
% kernel = 'Gaussian'; 
% dt = 7; 
% start = 1;
% lag = 0;
% end 


% 
% if (angle == 7 )
% kernel = 'Gaussian'; 
% dt = 1; 
% start = 1;
% lag = 0;
% elseif (angle == 8)
% kernel = 'Gaussian'; 
% dt = 2; 
% start = 1;
% lag = 0; 
%  elseif (angle == 2|| angle == 3)
% kernel = 'Gaussian'; 
% dt = 2; 
% start = 1;
% lag = 0;
% else 
% kernel = 'Gaussian'; 
% dt = 5; 
% start = 1;
% lag = 0;
% end 

kernel = 'Gaussian';
dt = 10; 
start = 1;
lag = 0;


if ( times >320) 
    
% if times<size(kalmans{angle}.Z,2)
% [~,newParameters,xhat] = predictKalman(kalmans,angle,kalmans{angle}.Z(:,times-dt:times),testData.startHandPos,false);
% % [~,newParameters,xhat] = predictKalman(kalmans,angle,kalmans{angle}.Z(:,times),testData.startHandPos,false);
% 
% else 
angle = kalmans{9}.angle;
     for i = 1:98
%  z(i,:) = smooth(output.l_local_non_shifted{i,a}(t,:),1000);
z(i,:) = fr_es(testData.spikes(i,times-lag-2*dt:times-lag),dt,kernel);
%  z(i,:) = fr_es(testData.spikes(i,1:times),dt,kernel);
%   z(i,:) = z(i,:) - mean(z(i,:));
  
     end
     z(z<0)=0;
    z(99,:) = times-2*dt:times;

 [~,newParameters,xhat] = predictKalman(kalmans,angle,z,testData.startHandPos,false); 
 
% end 
%  xhat= cat(2,xhat,xhat2);
% elseif (times == 340) 
%     
%     for i = 1:98
% %  z(i,:) = smooth(output.l_local_non_shifted{i,a}(t,:),1000);
% % z(i,:) = fr_es(testData.spikes(i,start:times-lag),dt,kernel);
% z(i,:) = fr_es(testData.spikes(1:340),dt,kernel);
% 
%   z(i,:) = z(i,:) - mean(z(i,:));
%     end
%          z(z<0)=0;
% 
%   z(99,:) = 1:times;
% 
%     
%      [~,newParameters,xhat] = predictKalman(kalmans,angle,z,testData.startHandPos,true);


% z(99,:) = start+lag+dt:times;
else 
    
      for i = 1:98
%  z(i,:) = smooth(output.l_local_non_shifted{i,a}(t,:),1000);
% z(i,:) = fr_es(testData.spikes(i,start:times-lag),dt,kernel);
z(i,:) = fr_es(testData.spikes(1:320),dt,kernel);

%   z(i,:) = z(i,:) - mean(z(i,:));
    end
         z(z<0)=0;
         
  angle = predictClassifier(testData,kalmans{9}.trees);


  z(99,:) = 1:times;
    
 [~,newParameters,~] = predictKalman(kalmans,angle,z,testData.startHandPos,true);
 
 
 newParameters{angle}.start = testData.startHandPos;
 newParameters{9}.angle  = angle;
%  newParameters = kalmans;
xhat = testData.startHandPos;
%  [out,newParameters,xhat] = predictKalman(kalmans,angle,kalmans{angle}.Z(:,1:times),testData.startHandPos,true);

    
end 


decodedPosX=xhat(1,end);

decodedPosY=xhat(2,end);



end

