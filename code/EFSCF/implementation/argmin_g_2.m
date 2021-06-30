%先进行稀疏选择 在进行正则窗口
%            argmin_g(reg_win{k}, gamma, X , g_f)
function T = argmin_g_2(w0, gamma,   X,  T, seq)

     L= max(0,1-gamma./(numel(X)*sqrt(sum(X.^2,3))));
     
     lhd=L;
     [~,b] = sort(lhd(:),'descend');
    
     if isfield(seq,'ratio')
         lhd(b(ceil(seq.ratio*numel(b)):end))=0;%0.04 在otb2013和OTB50上效果很好 在OTB100效果差
     else
         lhd(b(ceil(0.07*numel(b)):end))=0;%0.04 在otb2013和OTB50上效果很好 在OTB100效果差
                                           %0.06  STRCF_OURS [0.662] STRCF_OURS [0.871                            
     end     
     
     for i = 1:size(X,3)
         T(:,:,i) = lhd .* X(:,:,i);%目标区域是1，非目标区域是0
     end

end


