function result = nBinTwoStage(alpha,  beta, nLamda,nY )


%  ------------- ����ģ�� ----------
U1 = rand(nLamda, 1);

lamda = gaminv( U1, alpha, beta );   % ��任����gamma�ֲ�

Y = [0 : nY-1]'; % �����������ȡ��ֵ

NB = [];

for i = 1:length( lamda )
    U2 = rand(1);   % �������ɲ��������
    p = poisscdf( Y, lamda(i) );
    
        p = p./max(max(p));  %%%% ����
    
    index = find(U2 < p);
    
    if isempty(index)
        fprintf('\n');
        warning('nY too small.');
    end
    
    NB = [NB; Y(min(index))];
end
%  ---------------------------------------
result = NB;