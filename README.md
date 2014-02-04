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

One possible run of test.m
<pre>
...
--->Tree#968 created: Accu. = 0.9375
/// Overall Accuracy = 0.92497
--->Tree#969 created: Accu. = 0.975
/// Overall Accuracy = 0.92503
--->Tree#970 created: Accu. = 0.95349
/// Overall Accuracy = 0.92506
--->Tree#971 created: Accu. = 0.95745
/// Overall Accuracy = 0.92509
--->Tree#972 created: Accu. = 0.88095
/// Overall Accuracy = 0.92504
--->Tree#973 created: Accu. = 0.88095
/// Overall Accuracy = 0.925
--->Tree#974 created: Accu. = 0.84091
/// Overall Accuracy = 0.92491
--->Tree#975 created: Accu. = 0.92683
/// Overall Accuracy = 0.92491
--->Tree#976 created: Accu. = 0.925
/// Overall Accuracy = 0.92491
--->Tree#977 created: Accu. = 0.95349
/// Overall Accuracy = 0.92494
--->Tree#978 created: Accu. = 0.89744
/// Overall Accuracy = 0.92491
--->Tree#979 created: Accu. = 0.93023
/// Overall Accuracy = 0.92492
--->Tree#980 created: Accu. = 0.89744
/// Overall Accuracy = 0.92489
--->Tree#981 created: Accu. = 0.92308
/// Overall Accuracy = 0.92489
--->Tree#982 created: Accu. = 0.775
/// Overall Accuracy = 0.92474
--->Tree#983 created: Accu. = 0.875
/// Overall Accuracy = 0.92469
--->Tree#984 created: Accu. = 0.92857
/// Overall Accuracy = 0.92469
--->Tree#985 created: Accu. = 0.86957
/// Overall Accuracy = 0.92464
--->Tree#986 created: Accu. = 0.95455
/// Overall Accuracy = 0.92467
--->Tree#987 created: Accu. = 0.8913
/// Overall Accuracy = 0.92463
--->Tree#988 created: Accu. = 0.93023
/// Overall Accuracy = 0.92464
--->Tree#989 created: Accu. = 0.97727
/// Overall Accuracy = 0.92469
--->Tree#990 created: Accu. = 0.93333
/// Overall Accuracy = 0.9247
--->Tree#991 created: Accu. = 0.91489
/// Overall Accuracy = 0.92469
--->Tree#992 created: Accu. = 0.95
/// Overall Accuracy = 0.92471
--->Tree#993 created: Accu. = 0.85714
/// Overall Accuracy = 0.92465
--->Tree#994 created: Accu. = 0.97561
/// Overall Accuracy = 0.9247
--->Tree#995 created: Accu. = 0.93182
/// Overall Accuracy = 0.92471
--->Tree#996 created: Accu. = 0.97619
/// Overall Accuracy = 0.92476
--->Tree#997 created: Accu. = 0.88889
/// Overall Accuracy = 0.92472
--->Tree#998 created: Accu. = 0.9375
/// Overall Accuracy = 0.92473
--->Tree#999 created: Accu. = 0.9
/// Overall Accuracy = 0.92471
--->Tree#1000 created: Accu. = 0.95
/// Overall Accuracy = 0.92473

accuracy =

    0.9571

Execution takes 3.1872 secs!!!
</pre>


