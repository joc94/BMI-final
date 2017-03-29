function predict = predictClassifier(testData,trees)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

kernel = 'Boxcar'; 
dt = 5; 
%% 
classTest = zeros(size(testData,1)*8,99);

for a= 1:size(testData,2)
for t=1:size(testData,1)
for i = 1:98
%  z(i,:) = smooth(output.l_local_non_shifted{i,a}(t,:),1000);
z = fr_es(testData(t,a).spikes(i,1:320),dt,kernel);
z_mean(i) = mean(z); 
classTest(t+size(testData,1)*(a-1),i) = z_mean(i);


end
% 
% [sortedZ,sortingIndices] = sort(z_mean,'descend');
% 
%  for indices=1:98
% classTest(t+size(testData,1)*(a-1),sortingIndices(indices)) = indices;
% % classTest(t+size(testData,1)*(a-1),sortingIndices(1:10)) = 1;
% 
%  end 

% classTest(t+size(testData,1)*(a-1),i) = mean(z);

classTest(t+size(testData,1)*(a-1),99) = 0; 
end
end
%%

for n=1:size(classTest,1)
                    leaves = testTrees(classTest(n,:),trees);
  
                    % average the class distributions of leaf nodes of all trees
                    p_rf = trees(1).prob(leaves(leaves~=0),:);
                    p_rf_sum = sum(p_rf)/length(trees);
                    [~,predict(n)] = max(p_rf_sum); 
end
 %%
 
 predict = predict(1);
 
end



