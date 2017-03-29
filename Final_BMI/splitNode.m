function [node,nodeL,nodeR] = splitNode(data,node,param)
% Split node

visualise = 0 ;

% Initilise child nodes
iter = param.splitNum;
nodeL = struct('idx',[],'t',nan,'dim',0,'prob',[],'a',0,'b',0,'c',0,'dims',[]);
nodeR = struct('idx',[],'t',nan,'dim',0,'prob',[],'a',0,'b',0,'c',0,'dims',[]);

if length(node.idx) <= 5 % make this node a leaf if has less than 5 data points
    node.t = nan;
    node.dim = 0;
    return;
end

idx = node.idx;
data = data(idx,:);
[N,D] = size(data);
ig_best = -inf; % Initialise best information gain
idx_best = [];
for n = 1:iter
    
    
    % Split function - Modify here and try other types of split function
    if (strcmp(param.split,'Axis Aligned'))
    dim = randi(D-1); % Pick one random dimension
    d_min = single(min(data(:,dim))) + eps; % Find the data range of this dimension
    d_max = single(max(data(:,dim))) - eps;
    t = d_min + rand*((d_max-d_min)); % Pick a random value within the range as threshold
    for k=1:size(data,1)
    idx_(k) = data(k,dim) < t;
    end 
    
    ig = getIG(data,idx_); % Calculate information gain
    
    if visualise
        visualise_splitfunc(idx_,data,dim,t,ig,n);
        pause();
    end
    
    [node, ig_best, idx_best] = updateIG(node,ig_best,ig,t,idx_,dim,idx_best,0,0,0,[]);
    elseif (strcmp(param.split,'Linear'))
     dim = randi(D-1);
    
     for dim=1:D
    d_min(dim) = single(min(data(:,dim))) + eps; % Find the data range of this dimension
    d_max(dim) = single(max(data(:,dim))) -  eps;
     end 
     
    notDone=true; 
    
    while(notDone)
     for i =1:2
      index = randsample(D-1,1); 
         for dim = 1:D-1
             if (index == dim)
                  min_max = randsample(2,1); 
                 if (min_max == 0)
            choice(i,dim) = d_min(dim);
                 else 
            choice(i,dim) = d_max(dim);
                 end 
             else 
             choice(i,dim) = d_min(dim)+(d_max(dim)-d_min(dim))*rand;
             end 
             
         end
     end 
     
     index = randsample(D-1,2,false);
     
     coefficients = polyfit([choice(:,index(1))], [choice(:,index(2))], 1);
    a = coefficients(1);
    b = coefficients(2);
    
    for k=1:size(data,1)
        idx_(k) = dot([data(k,index(1)),data(k,index(2)),1],[a -1 b])<0; 
    end 
    if (range(idx_))
        notDone = false; 
    end 
    end
    ig = getIG(data,idx_); % Calculate information gain
    
    if visualise
        visualise_splitfunclinear(idx_,data,a,b,ig,n,index);
        pause();
     end
    
    [node, ig_best, idx_best] = updateIG(node,ig_best,ig,0,idx_,dim,idx_best,a,b,0,index);
    
    
    elseif (strcmp(param.split,'Non Linear'))
     dim = randi(D-1);
    
     for dim=1:D
    d_min(dim) = single(min(data(:,dim))) + eps; % Find the data range of this dimension
    d_max(dim) = single(max(data(:,dim))) -  eps;
     end 
     
    notDone=true; 
    
    while(notDone)
     for i =1:3
      index = randsample(D,1); 
         for dim = 1:D-1
             if (index == dim && i<3)
                  min_max = randsample(2,1); 
                 if (min_max == 0)
            choice(i,dim) = d_min(dim);
                 else 
            choice(i,dim) = d_max(dim);
                 end 
             else 
             choice(i,dim) = d_min(dim)+(d_max(dim)-d_min(dim))*rand;
             end    
         end
     end 
     
     index = randsample(D-1,2,false);

     coefficients = polyfit([choice(:,index(1))],[choice(:,index(2))],2); 
    a = coefficients(1);
    b = coefficients(2);
    c = coefficients(3);
    
    for k=1:size(data,1)
        idx_(k) = dot([data(k,index(1)).^2,data(k,index(1)),data(k,index(2)),1],[a b -1 c])<0; 
    end 
    if (range(idx_))
        notDone = false; 
    end 
    end
    ig = getIG(data,idx_); % Calculate information gain
    
    if visualise
        visualise_splitfuncnonlinear(idx_,data,a,b,c,ig,n,index);
        pause();
    end
     
    [node, ig_best, idx_best] = updateIG(node,ig_best,ig,0,idx_,dim,idx_best,a,b,c,index);

    elseif (strcmp(param.split,'Two Pixel'))
     dims = randsample(D-1,2,false); % Pick two random dimension
    
    t_min = single(min(data(:,dims(1))-data(:,dims(2)))) + eps; % Find the data range of this dimension
    t_max = single(max(data(:,dims(1))-data(:,dims(2)))) -  eps;
     
    t = t_min + rand*((t_max-t_min)); % Pick a random value within the range as threshold
    for k=1:size(data,1)
    idx_(k) = (data(k,dims(1))-data(k,dims(2))) < t;
    end
    
    ig = getIG(data,idx_); % Calculate information gain
    
    if visualise
        visualise_splitfunc2pixel(idx_,data,ig,n,dims);
        pause();
     end
    
    [node, ig_best, idx_best] = updateIG(node,ig_best,ig,t,idx_,dims(1),idx_best,0,0,0,dims);
        
    else
        
      error('specify split');  
    end
    
  
        
    
end

nodeL.idx = idx(idx_best);
nodeR.idx = idx(~idx_best);

end

function ig = getIG(data,idx) % Information Gain - the 'purity' of data labels in both child nodes after split. The higher the purer.
L = data(idx);
R = data(~idx);
H = getE(data);
HL = getE(L);
HR = getE(R);
ig = H - sum(idx)/length(idx)*HL - sum(~idx)/length(idx)*HR;
end

function H = getE(X) % Entropy
if(X)
cdist= histc(X(:,1:end), unique(X(:,end))) + 1;
cdist= cdist/sum(cdist);
cdist= cdist .* log(cdist);
else 
    cdist = 0; 
end
H = -sum(cdist);

end

function [node, ig_best, idx_best] = updateIG(node,ig_best,ig,t,idx,dim,idx_best,a,b,c,dims) % Update information gain
if ig > ig_best
    ig_best = ig;
    node.t = t;
    node.dim = dim;
    node.dims = dims;
    idx_best = idx;
    node.c = c; 
    node.b = b; 
    node.a = a; 
else
    idx_best = idx_best;
end
end