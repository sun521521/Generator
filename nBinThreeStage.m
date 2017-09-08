function   result = nBinThreeStage(alpha,  beta, p3, nLamda,nY2 )


%  ------------- ����ģ�� ----------
NB2 = nBinTwoStage(alpha,  beta, nLamda, nY2 );

nY3 = max(NB2);
Y3 = [0 : nY3 - 1]';   % ����ֲ��������ȡ��ֵ

NB3 = [];
for i = 1:length( NB2 )
    U2 = rand(1);   % �������ɶ��������
    p = binocdf( Y3, NB2(i), p3 );
    
     p = p./max(max(p));  %%%% ����
    
     index = find(U2 < p);
    
    if isempty(index)
        fprintf('\n');
        warning('nY3 too small.');
    end
    
    NB3 = [NB3; Y3(min(index))];
end

result = NB3;