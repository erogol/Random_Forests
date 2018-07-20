function RETree = cartree(Data,Labels,varargin)

%RETree = cartree(Data,Labels,varargin)
%
%   Grows a CARTree using Data(samplesXfeatures)
%   and one of the following criteria which
%   can be set via the parameter 'method'
%
%       'g' : gini impurity index (classification)
%       'c' : information gain (classification, default)
%       'r' : squared error (regression)
%
%   Other parameters that can be set are:
%
%       minparent    : the minimum amount of samples in an impure node
%                      for it to be considered for splitting (default 2)
%
%       minleaf      : the minimum amount of samples in a leaf (default 1)
%
%       weights      : a vector of values which weigh the samples 
%                      when considering a split (default [])
%
%       nvartosample : the number of (randomly selected) variables 
%                      to consider at each node (default all)
%
%       maxdepth     : maximium depth
%
%       countlabels  : compute labels for proba
%
okargs =   {'minparent' 'minleaf' 'nvartosample' 'method' 'weights','maxdepth','countlabels'};
defaults = {2 1 size(Data,2) 'c' [],100000,0};
[eid,emsg,minparent,minleaf,m,method,W,maxdepth,countlabels] = getargs(okargs,defaults,varargin{:});
        
N = numel(Labels);
L = 2*ceil(N/minleaf) - 1;
M = size(Data,2);

nodeDataIndx = cell(L,1);
nodeDataIndx{1} = 1 : N;
depth = zeros(L,1);
nodeCutVar = zeros(L,1);
nodeCutValue = zeros(L,1);

isreg = strcmp(method,'r');
if countlabels
    if isreg
        labelcounts = zeros(L,1);
    else
        labelcounts = zeros(L,length(unique(Labels)));
    end
else
    labelcounts = [];
end
nodeflags = zeros(L+1,1);

nodelabel = zeros(L,1);
childnode = zeros(L,1);

nodeflags(1) = 1;

switch lower(method)
    case {'c','g'}
        [unique_labels,~,Labels]= unique(Labels);
        max_label = numel(unique_labels);    
    otherwise
        max_label= [];
end

current_node = 1;

while nodeflags(current_node) == 1;
    free_node = find(nodeflags == 0,1);
    currentDataIndx = nodeDataIndx{current_node};
    
    if  numel(unique(Labels(currentDataIndx)))==1
        switch lower(method)
            case {'c','g'}
                h = hist(Labels(currentDataIndx),1:max_label);
                if countlabels
                    labelcounts(current_node,:) = h;
                end
                nodelabel(current_node) = unique_labels(Labels(currentDataIndx(1)));
            case 'r'
                nodelabel(current_node) = Labels(currentDataIndx(1));
                if countlabels
                    labelcounts(current_node) = length(currentDataIndx);
end
        end
        nodeCutVar(current_node) = 0;
        nodeCutValue(current_node) = 0;
    else
        if numel(currentDataIndx)>=minparent && depth(current_node) < maxdepth
             
             node_var = randperm(M);
             node_var = node_var(1:m);
%             node_var = (randsample(M,m,0));
                     
            if numel(W)>0
                Wcd = W(currentDataIndx);
            else
                Wcd = [];
            end
            
            [bestCutVar bestCutValue] = ...
                best_cut_node(method,Data(currentDataIndx,node_var),Labels(currentDataIndx),Wcd,minleaf,max_label);
                        
            if bestCutVar~=-1
                
                nodeCutVar(current_node) = node_var(bestCutVar);              
                nodeCutValue(current_node) = bestCutValue;
                
                nodeDataIndx{free_node} = currentDataIndx(Data(currentDataIndx, node_var(bestCutVar))<bestCutValue);                
                nodeDataIndx{free_node+1} = currentDataIndx(Data(currentDataIndx, node_var(bestCutVar))>bestCutValue);
                depth(free_node) = depth(current_node) + 1;
                depth(free_node+1) = depth(free_node);
                
                % no need to store here
%                 if countlabels
%                     if ~isreg 
%                         % no nee
%                         %[c,u] = countUnique(Labels(nodeDataIndx{free_node}));
%                         %labelcounts(free_node,c) = u; 
%                         %[c,u] = countUnique(Labels(nodeDataIndx{free_node+1}));
%                         %labelcounts(free_node+1,c) = u;
%                     else
%                         % in regression we just count number of nodes
%                         labelcounts(free_node) = length(nodeDataIndx{free_node});
%                         labelcounts(free_node+1) = length(nodeDataIndx{free_node+1});
%                     end
%                 end

                nodeflags(free_node:free_node + 1) = 1;
                childnode(current_node)=free_node;
            else
                switch lower(method)
                    case {'c' 'g'}
                        h = hist(Labels(currentDataIndx),1:max_label);
                        if countlabels
                            labelcounts(current_node,:) = h;
                        end
                        [~, leaf_label] = max(h);
                        nodelabel(current_node)=unique_labels(leaf_label);
                    case 'r'
                        nodelabel(current_node)  = mean(Labels(currentDataIndx));
                        if countlabels
                            labelcounts(current_node) = length(currentDataIndx);
                        end
                        
                end
                
            end
        else
            switch lower(method)
                case {'c' 'g'}
                    h = hist(Labels(currentDataIndx),1:max_label);
                    if countlabels
                        labelcounts(current_node,:) = h;
                    end
                    [~, leaf_label] = max(h);
                    nodelabel(current_node)=unique_labels(leaf_label);
                case 'r'
                    nodelabel(current_node)  = mean(Labels(currentDataIndx));
                        if countlabels
                            labelcounts(current_node) = length(currentDataIndx);
                        end
            end
        end
    end
    current_node = current_node+1;
end

RETree.nodeCutVar = nodeCutVar(1:current_node-1);
RETree.nodeCutValue =nodeCutValue(1:current_node-1);
RETree.childnode = childnode(1:current_node-1);
RETree.nodelabel = nodelabel(1:current_node-1);
RETree.depth = depth(1:current_node-1);
if countlabels
    if isreg
        RETree.labelcounts = labelcounts(1:current_node-1);
    else
        RETree.labelcounts = labelcounts(1:current_node-1,:);
    end
else
    RETree.labelcounts = [];
end

% knowing that labels are in fixed range we can use histogram
function [u,c] = countUnique(X)
[u,~,ui] = unique(X);
c = accumarray(ui,1);
