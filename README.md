## EOS NAME SHOP

[中文版](README-cn.md)

With this DAPP, users can buy and sell EOS mainnet accounts with special name. It is in account "eosnamesshop".

This DAPP is also a part of [EOSVR](https://github.com/EOSVR/EOSVR/blob/master/README.md) ecosystem.

[List of Selling Names](http://eosnames.shop/) 

[APP](https://github.com/EOSVR/EOSVR/blob/master/wallet.md)

### Brief

You send EOS to eosnamesshop with wanted user in memo to buy it. Example: 

```
cleos transfer youraccounts eosnamesshop "1.0000 EOS" "mywantedname"
```

You can earn EOS for the confirmation reward, even if other exceed your price. It depends on return (distribution) rate.


### Details

This following will show how an account sell by a seller, buy by lots of buyer, and confirm by last buyer.

You must be a EOS developer to understand the following. If not, you can just try the [EOSVR APP](https://github.com/EOSVR/EOSVR/blob/master/wallet.md). Even if you are a developer, still prefer you try this APP to buy and sell. The commands are too complex to type.

If use other wallet, you still can send EOS to buy. But can not sell or take back account.

#### Seller

1, Give eosnamesshop the control permission;

Example of account xxxxx11xxxxx :

```
cleos set account permission xxxxx11xxxxx owner '{"threshold": 1,"keys": [{"key": "EOS79VxyaJogC11CGDUoE1FdGFPD9ogPWWpUabkPi2uG4iF7s3wCn","weight": 1}],"accounts": [{"permission":{"actor":"eosnamesshop","permission":"eosio.code"},"weight":1}]}' -p xxxxx11xxxxx@owner
```


2, Register the account to sell, also need the account of seller to receive token;

Example of seller 233233233233 :

```
cleos push action eosnamesshop regname '{"account":"xxxxx11xxxxx","seller":"233233233233","confirm_day":1,"distribution":20}' -p xxxxx11xxxxx@owner -p 233233233233
```

Parameters:

- confirm_day : Decide how many day(s) will it lock before finish. If it is 0, it can confirm immediately after buy, and the first buyer must be seller. This buy will return to seller without fee.

- distribution : Decide the distribution percent rate of extra token. 


Tokens will split into 3 parts:

- (1+(distribution / 100)) percent precedure fee will sustain the memory, bandwidth and CPU of contract account;

- In remain tokens, (distribution % 100) percent will send to last buyer to reward its confirmation. 

- Other tokens will send to seller.

Note: Seller do not have precedure fee;


Example: 

distribution=20, user A sell a name: xxxxx11xxxxx , user B buy it with "10 EOS". 

- At this time, system get 1% * 10 = 0.1 EOS; user A get 9.9 EOS;

Then, user C buy it with "30 EOS". At this time:

- system get: 1% * (30-10) = 0.2 EOS; 

- User A get (30-10-0.2) * (1-20%) = 15.84 EOS;

- User B get 30 - 15.84 - 0.2 = 13.96 EOS;


When distribution > 100, will send more token to system. It is for buying stock of eosnamesshop, will support later.


3, (Optional) Set starting token by sending token to eosnamesshop with memo which is the account name.

Example:

```
cleos transfer 233233233233 eosnamesshop "1.0000 EOS" "xxxxx11xxxxx"
```

Note:

- In the first 10 minutes after register, only seller can set starting token. The limitation will be removed after first set.


#### Buyer


4, Check current status

```
cleos get table eosnamesshop eosnamesshop namestocks
```

5, Auction

Send token to eosnamesshop with memo which is the account name.

Example:

```
cleos transfer helloworld11 eosnamesshop "2.0000 EOS" "xxxxx11xxxxx"
```

New buyer must sell 10% more tokens than last buyer.


6, Confirm account

After confirm_day days pass, the winner can confirm the ownership of bought account with a public key.

Example:

```
cleos push action eosnamesshop confirm '{"buyer":"233233233233","account":"xxxxx11xxxxx","pubkey":"EOS79VxyaJogC11CGDUoE1FdGFPD9ogPWWpUabkPi2uG4iF7s3wCn"}' -p 233233233233@active
```

Note: After confirm, eosnamesshop will release the control of selling account, and the pubkey can not change. If do not have private key of it in wallet, the account will lose and no one can access it.


7, Change the active public key of account after buy

Example:

```
cleos set account permission xxxxx11xxxxx active '{"threshold": 1,"keys": [{"key": "EOS79VxyaJogC11CGDUoE1FdGFPD9ogPWWpUabkPi2uG4iF7s3wCn","weight": 1}],"accounts": []}' owner -p xxxxx11xxxxx@owner
```

#### Contact

Email: contact@eosvr.io
