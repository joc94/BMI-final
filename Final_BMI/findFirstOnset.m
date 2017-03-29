function closest_trial = findFirstOnset(trial,i,a)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

first_spike = find(trial(1,a).spikes(i,:),1); 
 closest_trial = 1; 

for n = 1:100
    
    if(find(trial(n,a).spikes(i,:),1)<first_spike)
    first_spike = find(trial(n,a).spikes(i,:),1); 
    closest_trial = n;
    end
    
end

end

