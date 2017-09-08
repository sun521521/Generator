clc; clear;

alpha = 4;
% beta = 13;   % gamma

p3 = 0.2;  % 三层模型中的 p
truncated = 0.99999;
m = 0; 
for beta = 2:(20-2)/10:20
   nY2 =  nbininv(truncated, alpha , 1/(1+beta));  % 截断
   
    m = m + 1;
    
    nRepeat = 40;
    tfNB1 = cell(nRepeat, 1); tfNB2 = cell(nRepeat, 1); tfNB3 = cell(nRepeat, 1);
    for rep = 1:nRepeat
        fprintf('\t第 %d 次循环:\n', rep);
        % gamma
        %     alpha = 7;  beta = 9;
        nLamda = 400;   % lamda 的个数,即产生随机数的个数
        
        
        %     nY2 = 300;   % 产生的泊松（负二项）随机数的取值范围 [0, nY - 1], 要包含gamma的均值
        %  ------------- 两层模型 ----------
        tic; fprintf('\t\t\t计算两层模型...\t\t');
        NB2 = nBinTwoStage(alpha,  beta, nLamda, nY2 );
        toc;
        
        tic; fprintf('\t\t\t计算一层模型...\t\t');
        nY1 = nbininv(0.99999, alpha , 1/(1+beta));  % 产生 负二项 随机数的取值范围 [0, nY1 - 1]
        %  ------------- 一层模型 ----------
        NB1 = nBinOneStage(alpha,  beta, nLamda, nY1);
        toc;
        
        tic; fprintf('\t\t\t计算三层模型...\t\t');
        %     p3 = 0.1;
        alpha3 = alpha; beta3 = beta/p3;
        nY3 =  nbininv(truncated, alpha3 , 1/(1+beta3));
        %  ------------- 三层模型 ----------
        NB3 = nBinThreeStage(alpha3,  beta3, p3, nLamda, nY3 );
        toc;
        
        % 样本自相关  对 绝对值 求平均
        autoNB1 = autocorr(NB1);
        auto1NB1(rep) = autoNB1(2); auto2NB1(rep) = autoNB1(3); auto3NB1(rep) = autoNB1(4); auto4NB1(rep) = autoNB1(5);
        
        autoNB2 = autocorr(NB2);
        auto1NB2(rep) = autoNB2(2); auto2NB2(rep) = autoNB2(3); auto3NB2(rep) = autoNB2(4); auto4NB2(rep) = autoNB2(5);
        
        autoNB3 = autocorr(NB3);
        auto1NB3(rep) = autoNB3(2); auto2NB3(rep) = autoNB3(3); auto3NB3(rep) = autoNB3(4); auto4NB3(rep) = autoNB3(5);
        
        % KStest
        [HNB1(rep), PNB1(rep)] = kstest(NB1, 'alpha',0.05, 'CDF', [NB1, nbincdf(NB1, alpha, 1/(1+beta))]);
        [HNB2(rep), PNB2(rep)] = kstest(NB2, 'alpha',0.05, 'CDF', [NB2, nbincdf(NB2, alpha, 1/(1+beta))]);
        [HNB3(rep), PNB3(rep)] = kstest(NB3, 'alpha',0.05, 'CDF', [NB3, nbincdf(NB3, alpha, 1/(1+beta))]);
        
        
        % 频率直方图 与 真实概率密度
        num1 = max(NB1)-min(NB1)+1; num2 = max(NB2)-min(NB2)+1; num3 = max(NB3)-min(NB3)+1;
        [FNB1, center1] = hist(NB1, num1); FNB11 = FNB1./sum( FNB1 );
        [FNB2, center2] = hist(NB2, num2);  FNB22 = FNB2./sum( FNB2 );
        [FNB3, center3] = hist(NB3, num3); FNB33 = FNB3./sum( FNB3 );
        center1 = ceil(min(center1)):ceil(min(center1))+length(FNB11)-1;
        center2 = ceil(min(center2)):ceil(min(center2))+length(FNB22)-1;
        center3 = ceil(min(center3)):ceil(min(center3))+length(FNB33)-1;
        
        hist1 = zeros( 1, max(NB1)+10 ); hist1(1,center1) = FNB11; tfNB1{rep} = hist1; maxNum1(rep) = max(NB1)+10;
        hist2 = zeros( 1, max(NB2)+10 ); hist2(1,center2) = FNB22; tfNB2{rep} = hist2; maxNum2(rep) = max(NB2)+10;
        hist3 = zeros( 1, max(NB3)+10 ); hist3(1,center3) = FNB33; tfNB3{rep} = hist3; maxNum3(rep) = max(NB3)+10;
    end
    
    % 平均自相关
    meanAuto1NB1(m) = mean(abs(auto1NB1)); meanAuto2NB1(m) = mean(abs(auto2NB1)); meanAuto3NB1(m) = mean(abs(auto3NB1)); meanAuto4NB1(m) = mean(abs(auto4NB1));
    meanAuto1NB2(m) = mean(abs(auto1NB2)); meanAuto2NB2(m) = mean(abs(auto2NB2)); meanAuto3NB2(m) = mean(abs(auto3NB2)); meanAuto4NB2(m) = mean(abs(auto4NB2));
    meanAuto1NB3(m) = mean(abs(auto1NB3)); meanAuto2NB3(m) = mean(abs(auto2NB3)); meanAuto3NB3(m) = mean(abs(auto3NB3)); meanAuto4NB3(m) = mean(abs(auto4NB3));
    
    % 平均 KStest
    rightRateNB1(m) = 1- (sum(HNB1)/nRepeat);  meanPNB1 = mean(PNB1);
    rightRateNB2(m) = 1- (sum(HNB2)/nRepeat);  meanPNB2 = mean(PNB2);
    rightRateNB3(m) = 1- (sum(HNB3)/nRepeat);  meanPNB3 = mean(PNB3);
    
end

% alpha = 2:(20-2)/11:20;  x= alpha;
% beta = 2:(20-2)/10:20; x= beta;
% 
%  p3=0.1:(0.9-0.1)/21:0.9; x= p3;


% truncated = 0.7:(0.95-0.7)/17:0.95;  x= truncated*100;
% plot(x, rightRateNB1*100, 'm--',x, rightRateNB2*100, 'k-s',x, rightRateNB3*100, 'r-^')
% plot(x, meanAuto1NB1, 'm--',x, meanAuto1NB2, 'k-s',x, meanAuto1NB3, 'r-^')
% plot(x, meanAuto2NB1, 'm--',x, meanAuto2NB2, 'k-s',x, meanAuto2NB3, 'r-^')
% plot(x, meanAuto3NB1, 'm--',x, meanAuto3NB2, 'k-s',x, meanAuto3NB3, 'r-^')
% plot(x, meanAuto4NB1, 'm--',x, meanAuto4NB2, 'k-s',x, meanAuto4NB3, 'r-^')
% 
% plot(x, rightRateNB1*100, 'm--',x, rightRateNB2*100, 'k-s')




% 平均频率直方图
%  一层次
tfSet1 = zeros( nRepeat, max(maxNum1) );
for i = 1:nRepeat
    tfSet1( i, 1:length(tfNB1{i}) ) = tfNB1{i};
end
meanFNB1 = mean( tfSet1 );
center1 = find(meanFNB1>0); meanFNB11 = meanFNB1( center1 );

% 两层次
tfSet2 = zeros( nRepeat, max(maxNum2) );
for i = 1:nRepeat
    tfSet2( i, 1:length(tfNB2{i}) ) = tfNB2{i};
end
meanFNB2 = mean( tfSet2 );
center2 = find(meanFNB2>0); meanFNB22 = meanFNB2( center2 );

% 三层次
tfSet3 = zeros( nRepeat, max(maxNum3) );
for i = 1:nRepeat
    tfSet3( i, 1:length(tfNB3{i}) ) = tfNB3{i};
end
meanFNB3 = mean( tfSet3 );
center3 = find(meanFNB3>0); meanFNB33 = meanFNB3( center3 );


% save('固定所有数');




n = 5;  % 需为奇数

%%%%% 1
figure
while mod(length(center1), n) ~= 0
    center1 = [center1 center1(end)];
end
while mod(length(meanFNB11), n) ~= 0
    meanFNB11 = [meanFNB11 meanFNB11(end)];
end
newCenter1 = center1(1: n: end) + (n-1)/2;
newMeanFNB11 = 0;
for i = 1:n
    newMeanFNB11 = newMeanFNB11 + meanFNB11(i: n: end);
end
bar(newCenter1, newMeanFNB11, 'r');

true1 = 0;
for i = 1:n
    true1 = true1 + nbinpdf(center1(i: n: end), alpha, 1/(1+beta));
end
hold on
plot(newCenter1, true1, 'color', [0 0 0 ]);

%%%%% 2
figure
while mod(length(center2), n) ~= 0
    center2 = [center2 center2(end)];
end
while mod(length(meanFNB22), n) ~= 0
    meanFNB22 = [meanFNB22 meanFNB22(end)];
end
newCenter2 = center2(1: n: end) + (n-1)/2;
newMeanFNB22 = 0;
for i = 1:n
    newMeanFNB22 = newMeanFNB22 + meanFNB22(i: n: end);
end
bar(newCenter2, newMeanFNB22, 'r');

true2 = 0;
for i = 1:n
    true2 = true2 + nbinpdf(center2(i: n: end), alpha, 1/(1+beta));
end
hold on
plot(newCenter2, true2, 'color', [0 0 0 ]);

%%%%% 3
figure
while mod(length(center3), n) ~= 0
    center3 = [center3 center3(end)];
end
while mod(length(meanFNB33), n) ~= 0
    meanFNB33 = [meanFNB33 meanFNB33(end)];
end
newCenter3 = center3(1: n: end) + (n-1)/2;
newMeanFNB33 = 0;
for i = 1:n
    newMeanFNB33 = newMeanFNB33 + meanFNB33(i: n: end);
end
bar(newCenter3, newMeanFNB33, 'r');

true3 = 0;
for i = 1:n
    true3 = true3 + nbinpdf(center3(i: n: end), alpha, 1/(1+beta));
end
hold on
plot(newCenter3, true3, 'color', [0 0 0 ]);
