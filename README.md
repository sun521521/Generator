# Generator
一种截尾负二项分布伪随机数生成器

## 介绍
  我们提出了一种利用层次模型来生成服从截尾负二项分布的伪随机数生成器。从数据结构的角度来看，
我们的算法是一个Hierarchical Directed Acyclic Graph (HDAG)。在模拟试验中，我们测试了各
个参数的影响，结果表明，相比于形状参数 ，尺度参数 对随机数性能的影响较大。对于截尾的情况，
覆盖率仅仅只需大于阈值(实验中大约是77%)，随机数的性能就会一直保持在很高的水平。最后，我们
计算了随机数的自相关，结果表明算法产生的随机数具有很好的独立性。

### 分析
我们设计的伪随机数生成器可以看作是一个非线性系统，它使用了层次模型和混合分布的技术。
从数据结构的角度来看，它是一个Hierarchical Directed Acyclic Graph (HDAG)，
如图：
![](https://github.com/sun521521/Generator/blob/master/results/algorithm.jpg)

大量的模拟实验表明，我们提出的算法可以产生性能优良的负二项分布随机数，二阶段模型（leftt）和三阶段模型(right)模拟效果:<br>
![](https://github.com/sun521521/Generator/blob/master/results/results2.jpg)<br>
![](https://github.com/sun521521/Generator/blob/master/results/results3.jpg)<br>
他们都可以很好的产生满足要求的随机数。

实验中，我们设定模型中的参数，分别产生了500个随机数来比较随机模拟与真实的结果 。
特别地，如果序列对的散点图具有 东北-西南的趋势，则表明随机数具有一阶正相关，类似的，如果散点图具有 东南-西北 的趋势，则表明随机数具有一阶负相关。
我们设计的两阶段算法和三阶段算法的滞后一阶的序列对的散点图被展示出来：
![](https://github.com/sun521521/Generator/blob/master/results/independence.jpg)
