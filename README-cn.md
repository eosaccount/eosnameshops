## EOS 帐号商店

[English](README.md)

本 DAPP 可以对 EOS 主网帐号进行买卖，它被部署在帐号 "eosnamesshop" 中。

它也是 [EOSVR](https://github.com/EOSVR/EOSVR/blob/master/README-cn.md) 生态的一部分。

[正在出售](http://eosnames.shop/index-cn.html) 

[APP下载](https://github.com/EOSVR/EOSVR/blob/master/wallet-cn.md)

### 概述

简而言之，向 eosnamesshop 这个帐号发送 EOS，并在 memo 中写下你要购买的帐号名即可参与帐号竞拍，比如：

```
cleos transfer youraccounts eosnamesshop "1.0000 EOS" "mywantedname"
```

即使你被其他人超过了，你也可以获取EOS，这是你肯定了这个帐号价值的报酬。报酬取决于帐号出售时设置的回报率。


### 详细说明

下面这些说明了一个帐号是如何被出售，然后被多人购买，最后被确认购买的。

你需要是一个EOS开发者才能看明白下面这些，如果你不是的话，你可以使用我们的 [EOSVR APP](https://github.com/EOSVR/EOSVR/blob/master/wallet.md)，它提供了快速买卖的方式。就算你是开发者，也推荐你使用这个APP进行操作，直接敲命令太麻烦了。

如果使用其他钱包，也可以发送 EOS 来进行购买，但无法卖或者收回帐号。


#### 卖家

1, 把帐号控制权给 eosnamesshop ；

下面的例子中，将准备出售帐号 xxxxx11xxxxx ：

```
cleos set account permission xxxxx11xxxxx owner '{"threshold": 1,"keys": [{"key": "EOS79VxyaJogC11CGDUoE1FdGFPD9ogPWWpUabkPi2uG4iF7s3wCn","weight": 1}],"accounts": [{"permission":{"actor":"eosnamesshop","permission":"eosio.code"},"weight":1}]}' -p xxxxx11xxxxx@owner
```

2, 注册帐号进行售卖，需要一个收款帐号；

下面的例子中，帐号 233233233233 将作为收款帐号：

```
cleos push action eosnamesshop regname '{"account":"xxxxx11xxxxx","seller":"233233233233","confirm_day":1,"feedback_rate":20}' -p xxxxx11xxxxx@owner -p 233233233233
```


参数说明:

- confirm_day : 表示在有人出价后锁定多少天。如果是0的话，表示一口价成交，这时第一次出价必须是卖家，此次出价将原路返回，不会有手续费。

- distribution : 表示溢价的分配比例。

每次出价的代币除了返还上一个出价的部分以外，被分成3部分：

- (1+(distribution / 100))% 手续费用在 eosnamesshop 的内存，带宽和CPU以及维护上；

- 剩余部分中，(distribution MOD 100)% 将发送给上一个购买者，以奖励他对价格确定性的提供；（MOD 100 是指取distribution 的最后两位）

- 剩下部分发送给卖家；

注意：出售者对自己帐号的出价将全额返还，无手续费；

例子：

distribution=20, 用户 A 出售一个帐号: xxxxx11xxxxx , 用户 B 用了 10 EOS 购买，那么：

- 系统得到 1% * 10 = 0.1 EOS; 用户 A 得到 9.9 EOS;

然后，用户 C 用了 30 EOS 购买，这时：

- 系统得到 1% * (30-10) = 0.2 EOS; 

- 卖家 A 得到：(30-10-0.2) * (1-20%) = 15.84 EOS;

- 用户 B 得到： 30 - 15.84 - 0.2 = 13.96 EOS；他上次购买花费了 10 EOS，所以他虽然没有获得帐号，但也获得了 3.96 EOS收益；

distribution 大于 100时，将给系统发送更多 token，这用于购买 eosnamesshop 系统的股份，将在之后支持。


3, (可选) 设置拍卖起始代币数。与下面的步骤5一致，给 eosnamesshop 发送代币，并在memo中写上出售的帐号名；

例子:

```
cleos transfer 233233233233 eosnamesshop "1.0000 EOS" "xxxxx11xxxxx"
```

注意:

- 注册后10分钟内，只有出售者才能对帐号进行出价，但第一次出价后限制解除；



#### 买家


4, 查看当前状态

```
cleos get table eosnamesshop eosnamesshop namestocks
```

5, 拍卖

发送代币到 eosnamesshop 并使用拍卖帐号作为 memo；

不用担心发错，所有错误（比如帐号已拍卖结束，或者代币不足）或者失败的发送都将不扣代币；

例子:

```
cleos transfer helloworld11 eosnamesshop "2.0000 EOS" "xxxxx11xxxxx"
```

新出价必须比上次多10%，且至少多 0.1 EOS；


6, 拍卖确认

在一个买家出价后的confirm_day天都没有新买家，那么买家将可以给这个设置owner的公钥（public key）以获取这个帐号；

例子:

```
cleos push action eosnamesshop confirm '{"buyer":"helloworld11","account":"xxxxx11xxxxx","pubkey":"EOS79VxyaJogC11CGDUoE1FdGFPD9ogPWWpUabkPi2uG4iF7s3wCn"}' -p helloworld11@active
```

注意: 确认发送后，eosnamesshop 将释放对帐号的控制。所以如果公钥是错误的，将会无人能控制这个帐号了。


7, （可选）购买后修改帐号的active公钥以便完全控制帐号

例子:

```
cleos set account permission xxxxx11xxxxx active '{"threshold": 1,"keys": [{"key": "EOS79VxyaJogC11CGDUoE1FdGFPD9ogPWWpUabkPi2uG4iF7s3wCn","weight": 1}],"accounts": []}' owner -p xxxxx11xxxxx@owner
```

#### 联系方式

Email: contact@eosvr.io
