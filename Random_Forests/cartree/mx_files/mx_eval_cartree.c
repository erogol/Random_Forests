#include <stdio.h>
#include <mex.h>
#include <math.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    
    double *Data,*tree_output,*cut_var,*cut_val,*nodechilds,*nodelabel;
    int i,current_node,M,cvar;

    if(nrhs < 3 || nlhs != 1)
    {
        mexErrMsgTxt("Error: output = (Data,Variables,Thresholds,Children,[Labels])");
        return;
    }
    
    Data= mxGetPr(prhs[0]);
    cut_var = mxGetPr(prhs[1]);
    cut_val = mxGetPr(prhs[2]);
    nodechilds = mxGetPr(prhs[3]);
    if (nrhs == 5)
        nodelabel = mxGetPr(prhs[4]);
    else
        nodelabel = 0;

    M=mxGetM(prhs[0]);
        
    plhs[0] = mxCreateDoubleMatrix(M, 1, mxREAL);
    tree_output = mxGetPr(plhs[0]);
        
    for(i = 0;i<M;i++){
        current_node = 0;
        while (nodechilds[current_node]!=0){
            cvar = cut_var[current_node];
            if (Data[i + (cvar-1)*M] < cut_val[current_node]) current_node = nodechilds[current_node]-1;
            else current_node = nodechilds[current_node];
        }
        tree_output[i] = nodelabel ? nodelabel[current_node]: current_node+1; 
    }
}
