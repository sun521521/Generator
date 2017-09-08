function result = nBinTwoStage(alpha,  beta, nLamda,nY )


%  ------------- 两层模型 ----------
U1 = rand(nLamda, 1);

lamda = gaminv( U1, alpha, beta );   % 逆变换产生gamma分布

Y = [0 : nY-1]'; % 泊松随机数可取的值

NB = [];

for i = 1:length( lamda )
    U2 = rand(1);   % 用于生成泊松随机数
    p = poisscdf( Y, lamda(i) );
    
        p = p./max(max(p));  %%%% 近似
    
    index = find(U2 < p);
    
    if isempty(index)
        fprintf('\n');
        warning('nY too small.');
    end
    
    NB = [NB; Y(min(index))];
end
%  ---------------------------------------
result = NB;