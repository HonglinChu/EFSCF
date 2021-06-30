
%            argmin_g(reg_win{k}, gamma, X , g_f)
function T = argmin_g(w0, gamma,   X,    T)
     lhd= 1 ./  (w0 .^2 + gamma); % left hand
     %surf(lhd);surf(w0);imagesc(lhd);
     %
     for i = 1:size(X,3)
         T(:,:,i) = lhd .* X(:,:,i);% 目标区域是1，非目标区域是0
     end
%      figure(3)
%      subplot(2,2,1);
%      surf(lhd);
%      subplot(2,2,2);
%      imagesc(lhd);
%      subplot(2,2,3);
%      surf(T(:,:,1));
%      subplot(2,2,4);
%      imagesc(T(:,:,1));
end


