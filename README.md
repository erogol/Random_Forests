<h3> Random Forests </h3>

**This is forked from the Stochastic_Bosque code from http://www.mathworks.com/matlabcentral/fileexchange/31036-random-forest

**They claim that the code is licenced but it is irrational to have proprietary malfunctioning code :) Therefore I make it working and release as open-source.

** This is really efficient code based on low level <b>cart tree</b> implementation on C++.

** However original code has some functioning flows. These are checked and add some additional features with additional performance boosts.

** If you have a matlab distribution including parallel processing toolbox you might try to use <b>parfor</b> instead of for at the random_forests.m

** To learn the usage refer to the test.m and before the use of test.m you need to run config.m to inlude the library to path.

** If you have any question: 
<b>erengolge@gmail.com</b>
www.erengolge.com

<b>Notice:</b> for some machines, you might need to compile mex files again regarding your machine configurations

<h2> Example Run </h2>
<pre>
random_indices = randperm(150,150);

train_x = inputs(random_indices(1:80),:);
test_x = inputs(random_indices(81:150),:);

train_y = outputs(random_indices(1:80),:);
test_y = outputs(random_indices(81:150),:);

% train_x is nxm matrix where rows are instances and columns are the variables
% train_y is nx1 matrix where each row is the label of the mathing instance
% For other parameters refer to source code
model = train_RF(train_x, train_y,'ntrees', 10,'oobe','y','nsamtosample',20,'method','g','nvartosample',2);
pred = eval_RF(test_x, model, 'oobe', 'y');
accuracy = cal_accuracy(test_y,pred)
</pre>


