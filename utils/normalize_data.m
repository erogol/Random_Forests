%
% Normalize data columnwise to reduce different unit's effect
%

function[X_norm, val] = normalize_data(X,val)

% if ~exist('va','var')
%     [val,ind] = max(X,[],1);
% end
% X_norm = bsxfun(@rdivide, X, val);

temp = max(X) - min(X);               % this is a vector
temp = repmat(temp, [length(a) 1]);  % this makes it a matrix
                                       % of the same size as A
X_norm = X./temp;  % your normalized matrix