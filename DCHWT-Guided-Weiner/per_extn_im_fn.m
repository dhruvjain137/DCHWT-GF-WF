function [xout_ext]=per_extn_im_fn(x,wsize)
hwsize=(wsize-1)/2; %%% Half window size excluding centre pixel.
[p,q]=size(x); 
xout_ext=zeros(p+wsize-1,q+wsize-1); 
xout_ext(hwsize+1:p+hwsize,hwsize+1:q+hwsize)=x;
%%% Row-wise periodic extension.
xout_ext(1:hwsize,:)=xout_ext(wsize:-1:hwsize+2,:); 
xout_ext(p+hwsize+1:p+wsize-1,:)=xout_ext(p+hwsize-1:-1:p,:); 
%%% Column-wise periodic extension.
xout_ext(:,1:hwsize)=xout_ext(:,wsize:-1:hwsize+2); 
xout_ext(:,q+hwsize+1:q+wsize-1)=xout_ext(:,q+hwsize-1:-1:q); 