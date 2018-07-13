function s = describe_RF(rf)

nodes = zeros(length(rf),1);
vars = zeros(length(rf),1);
depths = zeros(length(rf),1);
leaves = nodes;
for I=1:length(rf)
        rft = rf(I);
        nodedepth = zeros(length(rft.nodeCutValue),1);
        nodes(I) = length(rft.nodelabel); 
        for J=1:length(rft.nodelabel)
            node.Threshold = rft.nodeCutValue(J);            
            if rft.childnode(J) > 0
                nodedepth(rft.childnode(J)-1) = nodedepth(J)+1;
                nodedepth(rft.childnode(J)) = nodedepth(J)+1;
            else
                leaves(I) = leaves(I) + 1;
            end
        end
        depths(I) = max(nodedepth);
        vars(I) = max(rft.nodeCutVar); % 1-based
end
s = [];
s.trees = length(rf);
s.maxdepths = max(depths);
s.vars = max(vars);
s.total_nodes = sum(nodes);
s.total_leaves = sum(leaves);