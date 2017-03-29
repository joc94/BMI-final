function output = fr_processing(trial,dt,kernel)

output = struct();

output.l_PSTH_non_shifted = cell(98,8);
output.l_PSTH_shifted = cell(98,8);
% output.mean_raster = cell(98,8);

% output.shifted_signal = cell(98,8);
output.l_local_shifted = cell(98,8);
output.l_local_non_shifted = cell(98,8);

output.Av_po = cell(1,8);


for n=1:size(trial,1)
    for a = 1:size(trial,2)
    sizes_recordings(n,a) = length(trial(n,a).spikes(1,:));
    end 
end 


for i = 1:size(trial(1,1).spikes,1)
     for a = 1:size(trial,2)

         max_len = max(sizes_recordings(:,a));
        min_len = min(sizes_recordings(:,a));

output.l_PSTH_non_shifted{i,a} = zeros(1, max_len); 

% A = zeros(1,max_len);
% B = zeros(1,max_len);

         
% closest_trial = findFirstOnset(trial,i,a);
% output.l_local_shifted{i,a} = zeros(size(trial,1), max(max(max(sizes_recordings(:,:,:)))));
 output.l_local_non_shifted{i,a} = zeros(size(trial,1), max_len);

% output.shifted_signal{i,a} = zeros(size(trial,1), max(max(max(sizes_recordings(:,:,:)))));

for n = 1:size(trial,1)
    

% len = length(trial(n,a).spikes(i,:));

% [new_shift] = shift_xcorr(trial(closest_trial,a).spikes(i,:),trial(n,a).spikes(i,:),2); %shift by best shift to max cross corr

% A(1:len) = A(1:len) + new_shift;
% B(1:len) = B(1:len) + trial(n,a).spikes(i,:);


% output.l_local_shifted{i,a}(n,1:length(fr_es(new_shift,dt))) = fr_es(new_shift,dt);
output.l_local_non_shifted{i,a}(n,1:length(fr_es(trial(n,a).spikes(i,:),dt,kernel))) = fr_es(trial(n,a).spikes(i,:),dt,kernel);

% output.shifted_signal{i,a}(n,1:length(new_shift)) = new_shift; 

% B(1:len) = B(1:len) + trial(n,a).spikes(i,:);

end 

% output.l_PSTH_shifted{i,a} = fr_es(A,dt);
% l = zeros(1,length(B));

% for j = (dt+1):(length(B))
%  l(j) = sum(B((j-dt):j))./(dt);
% 
% end

% l = fr_es(B,dt);

%  output.l_PSTH_non_shifted{i,a}(1:min_len) = l(1:min_len)./100;
 
% output.l_PSTH_non_shifted{i,a}(1:min_len) = sum(output.l_local_non_shifted{i,a}(:,1:min_len),1)./100; 
 

% output.l_PSTH_non_shifted{i,a}(1:max_len) = sum(output.l_local_non_shifted{i,a}(:,1:max_len),1)./100; 

%         for index = (min_len+1):max_len
% %         output.l_PSTH_non_shifted{i,a}(index) = l(index)./sum((sizes_recordings(:,a)>(index-1)));
%         output.l_PSTH_non_shifted{i,a}(index) = sum(output.l_local_non_shifted{i,a}(:,index),1)./sum((sizes_recordings(:,a)>(index-1))); 
% 
%         end

       
% output.l_PSTH_non_shifted{i,a}(1:max_len) = output.l_PSTH_non_shifted{i,a}(1:max_len) - mean(output.l_PSTH_non_shifted{i,a}(1:max_len));
% output.l_PSTH_non_shifted{i,a}(output.l_PSTH_non_shifted{i,a}<0)=0;
     end 
end 



    for angle = 1:8
        max_len = max(sizes_recordings(:,angle));
        min_len = min(sizes_recordings(:,angle));

        output.Av_po{angle} = zeros(3,max_len);
        for n = 1:size(trial,1)
        output.original_Po{n,angle} = zeros(3,max_len);

%         output.Av_po{angle}(:,1:size(trial(n,angle).handPos,2)) = output.Av_po{angle}(:,1:size(trial(n,angle).handPos,2)) + trial(n,angle).handPos;
        output.original_Po{n,angle}(:,1:size(trial(n,angle).handPos,2)) = trial(n,angle).handPos;

        end 
        output.Av_po{angle}(:,1:min_len) = output.Av_po{angle}(:,1:min_len)./n;
%         for index = (min_len+1):max_len
%         output.Av_po{angle}(:,index) = output.Av_po{angle}(:,index)./sum((sizes_recordings(:,angle)>(index-1)));
%        end
    end 


end

