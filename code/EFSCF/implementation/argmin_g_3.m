%先进行稀疏选择 在进行正则窗口
%            argmin_g(reg_win{k}, gamma, X , g_f)
function T = argmin_g_3(w0, gamma,   X,  T, seq,small_filter_sz,output_sz)

     if isfield(seq,'ratio')
	ratio=seq.ratio;
     else
	ratio=1.4;
     end     
     
     if isfield(seq,'lambda1')
        lambda1=seq.lambda1;
     else 
	lambda1=2.2;
     end
     
     X_temp=X;
     % solve_h 行稀疏 
     L_21=sqrt(sum(sum(X_temp.^2,3),2));%先对通道求和，再对每一行求和
     S_21=max(0,1-lambda1./(numel(X_temp)*L_21));%这里(1./(mu))
     [~,b]=sort(S_21(:),'descend');   
     S_21(b(ceil(small_filter_sz(1)/output_sz(1)*ratio*numel(b)):end)) = 0;% 前 small_filter_sz
     
     L21_temp=repmat(S_21,1,size(X_temp,2));% imagesc(L21_temp); surf(L21_temp);
     X_temp=repmat(L21_temp,1,1,size(X_temp,3)).*X_temp;%surf(X_temp(:,:,2));
    
     % sovle_g 列稀疏
     L_12=sqrt(sum(sum(X_temp.^2,3),1));%先对通道求和，再对每一列求和
     S_12=max(0,1-lambda1./(numel(X_temp)*L_12));%surf(L_12);
     [~,b]=sort(S_12(:),'descend');   
     S_12(b(ceil(small_filter_sz(2)/output_sz(2)*ratio*numel(b)):end)) = 0;%前 small_filter_sz 1.12
     
     L12_temp=repmat(S_12,size(X_temp,1),1);%imagesc(L12_temp);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
     X_temp=repmat(L12_temp,1,1,size(X_temp,3)).*X_temp;%imagesc(X_temp(:,:,2));
     T=X_temp;
     
end


