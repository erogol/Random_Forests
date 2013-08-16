%Initialization of the input file
fileName = 'iris.txt';
fid = fopen(fileName);

%Flower categories saved as category numbers in output array
str_out1 = 'Iris-setosa';
str_out2 = 'Iris-versicolor';
str_out3 = 'Iris-virginica';

no_data =150;

%The first 4 columns of data
inputs = zeros(150,4);
%Flower categories 1, 2 or 3 is saved in this variable.
outputs = zeros(150,1);

pcursor = 0;
while(1)
pcursor = pcursor + 1;
%Read next line in the file
tline = fgetl(fid);
%Check for EOF
if (length(tline) < 2)
break;
end
%Find location of commas
commaLocs=findstr(',',tline);
%Extract data from the data files
%Input assignment
inputs(pcursor,1) = str2double(tline(1:(commaLocs(1)-1)));
inputs(pcursor,2) = str2double(tline((commaLocs(1)+1):(commaLocs(2)-1)));
inputs(pcursor,3) = str2double(tline((commaLocs(2)+1):(commaLocs(3)-1)));
inputs(pcursor,4) = str2double(tline((commaLocs(3)+1):(commaLocs(4)-1)));
%Output assignment
str_out = tline((commaLocs(4)+1):length(tline));
switch str_out
case str_out1
outputs(pcursor,:) = 1;
case str_out2
outputs(pcursor,:) = 2;
case str_out3
outputs(pcursor,:) = 3;
end
end
fclose(fid);