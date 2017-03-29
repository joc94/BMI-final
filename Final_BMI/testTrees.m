function label = testTrees(data,tree)
% Slow version - pass data point one-by-one

cc = [];
D = size(data,2);

for T = 1:length(tree)
    for m = 1:size(data,1)
        idx = 1;
        
        while tree(T).node(idx).dim
     
            if(tree(T).node(idx).c)
                c = tree(T).node(idx).c;
                b = tree(T).node(idx).b;
                a = tree(T).node(idx).a;
                index = tree(T).node(idx).dims; 


                if (dot([data(m,index(1)).^2,data(m,index(1)),data(m,index(2)),1],[a b -1 c])<0)
                    idx = idx*2;
                else 
                    idx = idx*2+1;
                end
                
            elseif(tree(T).node(idx).a)
                b = tree(T).node(idx).b;
                a = tree(T).node(idx).a;
                index = tree(T).node(idx).dims; 
                
                if (dot([data(m,index(1)),data(m,index(2)),1],[a -1 b])<0)
                    idx = idx*2;
                else
                    idx = idx*2+1;
                end
            elseif(tree(T).node(idx).dims) 
            t = tree(T).node(idx).t; 
            dims = tree(T).node(idx).dims; 
                if (data(:,dims(1))-data(:,dims(2)) < t)
                    idx = idx*2;
                else 
                    idx = idx*2+1;
                end 
            else
            t = tree(T).node(idx).t;
            dim = tree(T).node(idx).dim;
            % Decision
            if data(m,dim) < t % Pass data to left node
                idx = idx*2;
            else
                idx = idx*2+1; % and to right
            end
            end
        end
        leaf_idx = tree(T).node(idx).leaf_idx;
        
        if ~isempty(tree(T).leaf(leaf_idx))
            p(m,:,T) = tree(T).leaf(leaf_idx).prob;
            label(m,T) = tree(T).leaf(leaf_idx).label;
            
%             if isfield(tree(T).leaf(leaf_idx),'cc') % for clustering forest
%                 cc(m,:,T) = tree(T).leaf(leaf_idx).cc;
%             end
        end
    end
end

end

