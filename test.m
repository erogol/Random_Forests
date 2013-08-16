
random_indices = randperm(150,150);

train_x =  inputs(random_indices(1:80),:);
test_x = inputs(random_indices(81:150),:);

train_y = outputs(random_indices(1:80),:);
test_y = outputs(random_indices(81:150),:);

% train_x is nxm matrix where rows are instances and columns are the variables
% train_y is nx1 matrix where each row is the label of the mathing instance
% For other parameters refer to source code
model = train_RF(train_x, train_y,'ntrees', 10,'oobe','y','nsamtosample',20,'method','g','nvartosample',2);
pred = eval_RF(test_x, model, 'oobe', 'y');
accuracy = cal_accuracy(test_y,pred)
