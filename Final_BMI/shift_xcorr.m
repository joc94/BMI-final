function [shifted_sig,shifted_handpos] = shift_xcorr(s1,s2, n_spikes)  

fns1 = find(s1,n_spikes);
fns2 = find(s2,n_spikes); 

if(isempty(fns2) || isempty(fns1))
    [c,lags]=xcorr(s1,s2);
else 
[c,lags]=xcorr(s1(1:(fns1(end))),s2(1:(fns2(end))));

end

[~,iLag]=max(c(find(lags==0):end));
shifted_sig =circshift(s2,[0 iLag]); 


end 