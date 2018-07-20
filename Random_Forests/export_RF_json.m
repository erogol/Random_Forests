function bosque_to_json(rf,jsonname,outputmode)

switch outputmode
    case 'nodeid'
        outputmode = 1; % full node
    case 'leavesid'
        outputmode = 2; % only leaves with index to leav
    case 'direct'
        outputmode = 3; % value in threshold
    otherwise
        error('Output can be: leavesid,nodeid,direct');
end

%Output:
%   array[TreeCount]
%       Nodes: array[NodeCount]
%           Variable: index 
%           Threshold: float
%           Left (0..NodeCount-1)
%           Right (0..NodeCount-1)
%       OOBE: float
%       NodesLabel: int array[NodeCount]
%       NodesProba: float array[NodeCount,Classes]
%       .. 
% Storing as JSON makes very large AND moreover not loadable in Labview
%
% 
% Input:
%    nodeCutVar
%    nodeCutValue
%    childnode: x[nodeCurtVar] < nodeCutValue pick childnode-1
%    nodelabel
%    method
%    oobe

% Forest Made of trees
forest =[];
for I=1:length(rf)
        rft = rf(I);
        tree = [];
        tree.Nodes = [];
        nodedepth = zeros(length(rft.nodeCutValue),1);
        if outputmode == 1  
            tree.Outputs = zeros(length(rft.nodelabel),1);
        elseif outputmode == 2
            tree.Outputs = []; % unknwn number
        elseif outputmode == 3
            tree.Outputs = []; % empty
        end
        if ~isempty(rft.labelcounts)
            % export normalized
            tree.Proba = rft.labelcounts./repmat(sum(rft.labelcounts,2),1,size(rft.labelcounts,2));
        else
            tree.Proba = {{}}; % so JSON emits [[]]
        end

        % not tree.NodesProba
        tree.OOBE = rft.oobe;
        tree.method= rft.method;
        tree.outputmode = outputmode;
        leafid = 0;
        for J=1:length(rft.nodelabel)
            node = [];

            
            node.Threshold = rft.nodeCutValue(J);            
            if rft.childnode(J) > 0
                % C code: if (Data[i + (cvar-1)*M] < cut_val[current_node]) current_node = nodechilds[current_node]-1;
                %node.Left = rft.childnode(J)-1;
                node.Variable = rft.nodeCutVar(J)-1; % zero based index to the Variable in X
                node.Right = rft.childnode(J);
                if outputmode == 1
                    tree.Outputs(J) = rft.nodelabel(J); % all values
                end
                % assign depth of children: in NEW version trees have DEPTH
                nodedepth(rft.childnode(J)-1) = nodedepth(J)+1;
                nodedepth(rft.childnode(J)) = nodedepth(J)+1;
            else
                %node.Left = 0;
                if outputmode == 2 
                    % INDEX into Leaf
                    leafid = leafid + 1;                
                    node.Variable = leafid; % zero based index to the Leaf output
                    tree.Outputs(leafid) = rft.nodelabel(J); % ONLY for leaves
                elseif outputmode == 3
                    % Store in Variable (int) and Threshold (float)
                    node.Variable = rft.nodelabel(J);
                    node.Threshold = rft.nodelabel(J);
                else
                    % Node zero based
                    node.Variable = J-1; % identity zero based
                    tree.Outputs(J) = rft.nodelabel(J); % all values
                end
                node.Right = 0; % marks as leaf
            end

            tree.Nodes = [tree.Nodes, node];
                
        end
        tree.maxdepth = max(nodedepth);
        tree.variablescount = max(rft.nodeCutVar); % 1-based
            
    forest = [forest; tree];
end
fp = fopen(jsonname,'w');
fwrite(fp,jsonencode(forest));
fclose(fp);
