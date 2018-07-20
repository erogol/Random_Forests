function tree_output = eval_cartree(Data,RETree,useMatlab,returnType)

% Return Types
%   returnType = 1 label
%   returnType = 2 node
%   returnType = 3 proba

if nargin < 3
    useMatlab = 0;
end
if nargin < 4
    returnType = 1;
end

if useMatlab == 0
    if returnType > 1
        % compute nodes by not passing nodelabel
        tree_output_nodes = mx_eval_cartree(Data,RETree.nodeCutVar,RETree.nodeCutValue,RETree.childnode);
    else
        tree_output = mx_eval_cartree(Data,RETree.nodeCutVar,RETree.nodeCutValue,RETree.childnode,RETree.nodelabel);
    end
else
    node = 1;
    tree_output = zeros(size(Data,1),1);
    tree_output_nodes = zeros(size(Data,1),1);
    for I=1:size(Data,1)
        while RETree.childnode(node) > 0
            cvar = RETree.nodeCutVar(node)+1;
            if Data(I,cvar) < RETree.nodeCutValue(node)
                node = RETree.childnode(node)-1; % already 1 based
            else
                node = RETree.childnode(node); % already 1 based
            end
        end
        if returnType > 1
            tree_output_nodes(I) = node;
        else
            tree_output(I) = RETree.nodelabel(node);
        end
    end
end
if returnType == 2 % node
    tree_output = tree_output_nodes;
elseif returnType == 3 % proba
    q = RETree.labelcounts(tree_output_nodes,:);
    tree_output = q./repmat(sum(q,2),1,size(q,2));
end
