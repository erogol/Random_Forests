function[X_norm, mu, sigma] = zscore_normalize_data(X, mu, sigma)
X_norm=bsxfun(@minus,X,mu);
X_norm=bsxfun(@rdivide,X_norm,sigma);