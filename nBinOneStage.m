function result = nBinOneStage(alpha,  beta, nLamda, nY1)

Y1 = [0 : nY1 - 1]';  % ������ �������ȡ��ֵ


p = nbincdf( Y1, alpha, 1/(1+beta) );

% p = p./max(max(p));  %%%% ����


NB = [];
for i = 1:nLamda
    U2 = rand(1);   % �������ɸ����������
    
    index = find(U2 < p);
    
    if isempty(index)
        fprintf('\n');
        warning('nY1 too small.');
    end
    
    NB = [NB; Y1(min(index))];
end
%  
result = NB;