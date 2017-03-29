function trial = cart2polar( trial, shift )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

for n=1:size(trial,1)
    for a = 1:size(trial,2)
        for u = 1:size(trial(1,1).spikes,1)
    sizes_recordings(u,n,a) = length(trial(n,a).spikes(u,:));
        end 
    end 
end 



for n=1:size(trial,1)
    for a = 1:size(trial,2)
    positions = trial(n,a).handPos;
    [theta, rho] = cart2pol(positions(1,:),positions(2,:));
    trial(n,a).handPosPolar = [theta; rho];
    end
end 

if (shift)
first_fire = zeros(1,size(trial,2)); 

for a = 1:size(trial,2)
    for n=1:size(trial,1)
    [peakreftemp locsreftemp] = max(trial(n,a).handPosPolar(1,:));
    if (n == 1) 
     first_fire(a) = locsreftemp; 
    elseif  locsreftemp(1)<first_fire(a)
        first_fire(a)  = locsreftemp; 
    end
    end

end


for a = 1:size(trial,2)
    for n=1:size(trial,1)
    %for j = 1:8
    
    [peak locs] = max(trial(n,a).handPosPolar(1,:));
    
    diff = first_fire(a)-locs(1)+1; 
    
    trial(n,a).spikes =  circshift(trial(n,a).spikes,diff);
    
    trial(n,a).handPosPolar(1,:) =   circshift(trial(n,a).handPosPolar(1,:), diff);
    
    trial(n,a).handPosPolar(2,:) =   circshift(trial(n,a).handPosPolar(2,:), diff);
% 
%     trial(n,a).handPos(1,:) =   circshift(trial(n,a).handPos(1,:), diff);
% 
%     trial(n,a).handPos(2,:) =   circshift(trial(n,a).handPos(2,:), diff);

    
    

    end
end 

end 

end

