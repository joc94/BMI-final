function trees = trainClassifier(trainingData)



kernel = 'Boxcar'; 
dt = 5; 


%%
classData = zeros(size(trainingData,1)*8,99);
for a = 1:8
    for j=1:size(trainingData,1)
        for i = 1:98 
            
%             classData(j+100*(a-1),i)= mean(output.l_local_non_shifted{i,a}(j,270:340));
            z = fr_es(trainingData(j,a).spikes(i,1:320),dt,kernel);
            z_mean(i) = mean(z); 
            classData(j+size(trainingData,1)*(a-1),i) =  z_mean(i);

        end
%         [sortedZ,sortingIndices] = sort(z_mean,'descend');
%          
%         
%         for indices=1:98
%         classData(j+size(trainingData,1)*(a-1),sortingIndices(indices)) = indices;
% % classData(j+size(trainingData,1)*(a-1),sortingIndices(1:10)) = 1;
%         end 

       classData(j+size(trainingData,1)*(a-1),99)=a; 

    end 
end 

indices = find(classData(:,99)==0);
classData(indices,:)=[];

%%

 param.num = 300;         % Number of trees
    param.depth = 5;        % trees depth
    param.splitNum = 30;  
   param.split = 'Axis Aligned';


   trees = growTrees(classData,param);

% results = evaluate(classTest,classData,param, 0,true,8);

%     trees = growTrees(classData,param);

end

