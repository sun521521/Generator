function   result = nBinThreeStage(alpha,  beta, p3, nLamda,nY2 )


%  ------------- 三层模型 ----------
NB2 = nBinTwoStage(alpha,  beta, nLamda, nY2 );

nY3 = max(NB2);
Y3 = [0 : nY3 - 1]';   % 二项分布随机数可取的值

NB3 = [];
for i = 1:length( NB2 )
    U2 = rand(1);   % 用于生成二项随机数
    p = binocdf( Y3, NB2(i), p3 );
    
     p = p./max(max(p));  %%%% 近似
    
     index = find(U2 < p);
    
    if isempty(index)
        fprintf('\n');
        warning('nY3 too small.');
    end
    
    NB3 = [NB3; Y3(min(index))];
end

result = NB3;