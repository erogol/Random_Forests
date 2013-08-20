config;
read_data;
random_indices = randperm(150,150);

train_x =  inputs(random_indices(1:80),:);
test_x = inputs(random_indices(81:150),:);

train_y = outputs(random_indices(1:80),:);
test_y = outputs(random_indices(81:150),:);

% For this data problem is about the unit differences of the columns.

% [train_x,mu,sigma] = zscore_normalize_data(train_x, mean(train_x), std(train_x)); % zscore norm
% [test_x,~,~]= zscore_normalize_data(test_x,mu,sigma);

% train_x is nxm matrix where rows are instances and columns are the variables
% train_y is nx1 matrix where each row is the label of the mathing instance
% For other parameters refer to source code
tic;
model = train_RF(train_x, train_y,'ntrees', 1000,'oobe','y','nsamtosample',50,'method','g','nvartosample',2);
pred = eval_RF(test_x, model, 'oobe', 'y');
accuracy = cal_accuracy(test_y,pred)
display(['Execution takes ',num2str(toc),' secs!!!']);
