function Random_Forest = train_RF(Data,Labels,varargin)

%Random_Forest = train_RF(Data,Labels,varargin)
%   
%       Data 	: is nxm matrix, rows are instances and columns are the variables
%
%   Creates an ensemble of CARTrees using Data(samplesXfeatures).
%   The following parameters can be set :
%
%       ntrees        : number of trees in the ensemble (default 50)
%
%       oobe         : out-of-bag error calculation, 
%                      values ('y'/'n' -> yes/no) (default 'n')
%
%       nsamtosample : number of randomly selected (with
%                      replacement) samples to use to grow
%                      each tree (default num_samples)
%
%
%   Furthermore the following parameters can be set regarding the
%   trees themselves :
%
%       method       : the criterion used for splitting the nodes
%                           'g' : gini impurity index (classification)
%                           'c' : information gain (classification)
%                           'r' : squared error (regression)
%
%       minparent    : the minimum amount of samples in an impure node
%                      for it to be considered for splitting
%
%       minleaf      : the minimum amount of samples in a leaf
%
%       weights      : a vector of values which weigh the samples 
%                      when considering a split
%
%       nvartosample : the number of (randomly selected) variables 
%                      to consider at each node 
%
%       verbose      : print progress
%   
%       maxdepth     : maximum depth of tree
%
%       countlabels  : count labels and nodes affecting the node 
%                      For classification divide it by sum of rows to
%                      obtain proba. We keep counts so that we know the
%                      importance of the node. For regression it is just
%                      the number of contributing samples.
%
% The maxdepth can be obtained also using trimming of the node by removing
% the nodes that are over a threshold. Then we need to rebuild the
% child-parent relationship to compensate for the removal.
%
% Emanuele Ruffaldi @MMI 2018 added maxdepth and countlabels
%
okargs =   {'minparent' 'minleaf' 'nvartosample' 'ntrees' 'nsamtosample' 'method' 'oobe' 'weights','verbose','maxdepth','countlabels'};
defaults = {2 1 round(sqrt(size(Data,2))) 50 numel(Labels) 'c' 'n' [],1,1000000,1};
[eid,emsg,minparent,minleaf,m,nTrees,n,method,oobe,W,verbose,maxdepth,countlabels] = getargs(okargs,defaults,varargin{:});

avg_accuracy = 0;
for i = 1 : nTrees
     
    TDindx = round(numel(Labels)*rand(n,1)+.5);
%    TDindx = unique(TDindx);
%     TDindx = randsample(numel(Labels),n,true);
%     TDindx = unique(TDindx);
    
    Random_ForestT = cartree(Data(TDindx,:),Labels(TDindx), ...
        'minparent',minparent,'minleaf',minleaf,'method',method,'nvartosample',m,'weights',W,'maxdepth',maxdepth,'countlabels',countlabels);
    
    Random_ForestT.method = method;

    if strcmpi(oobe,'y')        
        NTD = setdiff(1:numel(Labels),TDindx);
        tree_output = eval_cartree(Data(NTD,:),Random_ForestT)';
        
        switch lower(method)        
            case {'c','g'}                
                Random_ForestT.oobe = numel(find(tree_output-Labels(NTD)'==0))/numel(NTD);
            case 'r'
                Random_ForestT.oobe = sum((tree_output-Label(NTD)').^2);
        otherwise
            Random_ForestT.oobe = 0;
        end        
    else
            Random_ForestT.oobe = 0;        
    end
    
    Random_Forest(i) = Random_ForestT;

    accuracy = Random_ForestT.oobe;
    if i == 1
        avg_accuracy = accuracy;
    else
        avg_accuracy = (avg_accuracy*(i-1)+accuracy)/i;
    end
    
    if verbose 
        display(['--->Tree#',num2str(i),' created: Accu. = ', num2str(Random_ForestT.oobe)]);
        display(['/// Overall Accuracy = ', num2str(avg_accuracy)]);
    end
end
