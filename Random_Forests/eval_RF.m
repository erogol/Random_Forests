function [f_output f_votes,of_votes]= eval_RF(Data,Random_Forest,varargin)

%Returns the output of the ensemble (f_output) as well as a [num_treesXnum_samples] matrix (f_votes) containing
%the outputs of the individual trees. 
%
%The 'oobe' flag allows the out-of-bag error to be used to 
%weight the final response (only for classification).
%
%The proba flag allows to return probabilities in f_output sized
%[Data,Classes]

okargs =   {'oobe','matlab','proba'};
defaults = {0,0,0};
[eid,emsg,oobe_flag,matlab_flag,proba_flag] = getargs(okargs,defaults,varargin{:});

proba_flag = proba_flag & ~strcmp(lower(Random_Forest(1).method),'r'); % only for classification

oobe = zeros(numel(Random_Forest),1);
if proba_flag ~= 0
    f_votes = zeros(numel(Random_Forest),size(Data,1),size(Random_Forest(1).labelcounts,2));
    for i = 1 : numel(Random_Forest)
        f_votes(i,:,:) = eval_cartree(Data,Random_Forest(i),matlab_flag,3); % proba
        oobe(i) = Random_Forest(i).oobe;
    end
 
else
    f_votes = zeros(numel(Random_Forest),size(Data,1));
    
    for i = 1 : numel(Random_Forest)
        f_votes(i,:) = eval_cartree(Data,Random_Forest(i),matlab_flag,1); % label
        oobe(i) = Random_Forest(i).oobe;
    end

end

of_votes =f_votes;
switch lower(Random_Forest(1).method)
    case {'c','g'}           
        if proba_flag ~= 0
            % accumulate_prediction
            % /= len(self.estimators_)
            f_output = squeeze(sum(f_votes,1))/length(Random_Forest)'; % emits probabilities [Data,Classes]
        else
            [unique_labels,~,f_votes]= unique(f_votes);
            f_votes = reshape(f_votes,numel(Random_Forest),size(Data,1));
            [~, f_output] = max(weighted_hist(f_votes,~oobe_flag+oobe_flag*oobe,numel(unique_labels)),[],1); %#ok<ASGLU>
            f_output = unique_labels(f_output);
        end
    case 'r'
        f_output = mean(f_votes,1);
    otherwise
        error('No idea how to evaluate this method');
end
