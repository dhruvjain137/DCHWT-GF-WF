function fuse_im=fusion(inp_wt,Nlevels,detail_exponent)
NoOfBands=3*Nlevels+1;
%%% Significance factor of all subbands who has childrens.
for k=NoOfBands-1:-1:4
   rr=1;
   level_cnt=Nlevels-ceil(k/3)+1;
   for mm=level_cnt:Nlevels
    % WIENER FILTER ON DETAIL BANDS
    temp_sb1 = cell2mat(inp_wt{1}(k-3*(mm-level_cnt)));
    temp_sb2 = cell2mat(inp_wt{2}(k-3*(mm-level_cnt)));
    temp_sb1 = wiener2(temp_sb1,[3 3]);
    temp_sb2 = wiener2(temp_sb2,[3 3]);
    sband1{rr} = temp_sb1;
    sband2{rr} = temp_sb2;
    rr=rr+1;
   end
   [p,q]=size(sband1{1});
   abs_sum1=0; abs_sum2=0;
   for ii=1:p
      for jj=1:q
         abs_sum1=abs_sum1+abs(sband1{1}(ii,jj));
         abs_sum2=abs_sum2+abs(sband2{1}(ii,jj));         
         for tt=2:length(sband1)
            temp1=sband1{tt}(2^(tt-1)*ii-[2^(tt-1)-1:-1:0],2^(tt-1)*jj-[2^(tt-1)-1:-1:0]);
            temp2=sband2{tt}(2^(tt-1)*ii-[2^(tt-1)-1:-1:0],2^(tt-1)*jj-[2^(tt-1)-1:-1:0]);
            abs_sum1=abs_sum1+sum(abs(temp1(:)));
            abs_sum2=abs_sum2+sum(abs(temp2(:)));
            clear temp1 temp2;
         end
         sig_temp1(ii,jj)=abs_sum1; 
         sig_temp2(ii,jj)=abs_sum2;
         abs_sum1=0; abs_sum2=0;
      end
   end
    sig_mat1{k} = imgaussfilt(sig_temp1,1);
    sig_mat2{k} = imgaussfilt(sig_temp2,1);
   clear sband1 sig_temp1;
   clear sband2 sig_temp2;
end
wsize=3;
hwsize=(wsize-1)/2;
for k=3:-1:1
   temp1=cell2mat(inp_wt{1}(k));
   temp2=cell2mat(inp_wt{2}(k));
   temp1_ext=per_extn_im_fn(temp1,wsize);
   temp2_ext=per_extn_im_fn(temp2,wsize);   
   [p,q]=size(temp1_ext);
   for ii=hwsize+1:p-hwsize
      for jj=hwsize+1:q-hwsize
         rpt1=ii-hwsize; rpt2=ii+hwsize;
         cpt1=jj-hwsize; cpt2=jj+hwsize;
         temp1_energy=temp1_ext(rpt1:rpt2,cpt1:cpt2).^2;
         temp2_energy=temp2_ext(rpt1:rpt2,cpt1:cpt2).^2;
         sig_temp1(ii-hwsize,jj-hwsize)=sum(temp1_energy(:))/wsize^2;
         sig_temp2(ii-hwsize,jj-hwsize)=sum(temp2_energy(:))/wsize^2;
      end
   end
   sig_mat1{k}=sig_temp1;
   sig_mat2{k}=sig_temp2;
   clear sig_temp1 sig_temp2;
end
sig_mat1{NoOfBands}=sig_mat1{NoOfBands-1}+sig_mat1{NoOfBands-2}+(sig_mat1{NoOfBands-3}).^detail_exponent; %% Vertical,Horizontal,Diagonal resp
sig_mat2{NoOfBands}=sig_mat2{NoOfBands-1}+sig_mat2{NoOfBands-2}+(sig_mat2{NoOfBands-3}).^detail_exponent;
for k = 1:NoOfBands
    tt1 = cell2mat(inp_wt{1}(k));
    tt2 = cell2mat(inp_wt{2}(k));
    gamma = 1.2;  
    S1 = sig_mat1{k};
    S2 = sig_mat2{k};
    W1 = (S1.^gamma) ./ (S1.^gamma + S2.^gamma + eps);
    W2 = 1 - W1;
    fuse_im{k} = W1 .* tt1 + W2 .* tt2;
end