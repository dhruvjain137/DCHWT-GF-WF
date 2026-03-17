function [C c]=dchwt(x,nlevel)
[p,q]=size(x);
arow=floor(p/2^abs(nlevel));
acol=floor(q/2^abs(nlevel));
k=1;
if nlevel==0
    c=x;
    C=x;
elseif nlevel > 0
    Id=dct2(x);
    % ===== SAFE DETAIL EMPHASIS =====
    [M,N] = size(Id);
    [u,v] = meshgrid(0:N-1,0:M-1);
    D = sqrt(u.^2 + v.^2);
    D = D / max(D(:));   % normalize 0–1
    beta = 0.2;   % SAFE range: 0.1–0.2
    W = 1 + beta * (D.^1.8); 
    % Do NOT modify very low frequencies
    low_mask = (u < acol & v < arow);
    W(low_mask) = 1;
    
    Id = Id .* W;
    % ================================================

    temp{k}=idct2(Id(1:arow,1:acol));
    xwt=temp{k};
    k=k+1;
    for i = 1:nlevel
        rr=arow*2^(i-1);
        cc=acol*2^(i-1);
        % Extract detail bands
        Dv = idct2(Id(1:rr,cc+1:2*cc));
        Dh = idct2(Id(rr+1:2*rr,1:cc));
        Dd = idct2(Id(rr+1:2*rr,cc+1:2*cc));
        % ---- Gradient magnitude reinforcement ----
        [Gx,Gy] = gradient(Dv);
        mag_v = sqrt(Gx.^2 + Gy.^2);
        [Gx,Gy] = gradient(Dh);
        mag_h = sqrt(Gx.^2 + Gy.^2);
        [Gx,Gy] = gradient(Dd);
        mag_d = sqrt(Gx.^2 + Gy.^2);
        lambda = 0.05;
        temp{k}   = Dv .* (1 + lambda * mat2gray(mag_v));
        temp{k+1} = Dh .* (1 + lambda * mat2gray(mag_h));
        temp{k+2} = Dd .* (1 + lambda * mat2gray(mag_d));
        xwt=[xwt temp{k}; temp{k+1} temp{k+2}];
        k=k+3;
    end
    c=xwt;
    len=size(temp,2);
    for i=1:len
        C{i}=temp{len-i+1};
    end
else
    k=size(x,2);
    xtemp=dct2(x{k});
    k=k-1;
    for i=1:abs(nlevel)
        xtemp=[xtemp dct2(x{k}); ...
               dct2(x{k-1}) dct2(x{k-2})];
        k=k-3;
    end
    C=idct2(xtemp);
end