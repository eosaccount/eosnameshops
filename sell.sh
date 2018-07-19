#!/bin/sh

if [ "$eosserver" == "" ] ; then
	eosserver=http://mainnet.eoscalgary.io
fi

if [ "$3" == "" ] ; then
	echo sell.sh \[toSell\] \[publicKey\] \[seller\] \[confirm_day\] \[distribution\]
  echo
  echo Example: sell.sh xxxxx11xxxxx EOS79VxyaJogC11CGDUoE1FdGFPD9ogPWWpUabkPi2uG4iF7s3wCn 233233233233
	exit
fi

confirmday=$4
if [ "$4" == "" ] ; then
  confirmday=1
fi

distribution=$5
if [ "$5" == "" ] ; then
  distribution=20
fi

cleos -u $eosserver system delegatebw $3 $1 "0.0100 EOS" "0.0400 EOS" || exit

cleos -u $eosserver set account permission $1 owner '{"threshold": 1,"keys": [{"key": "'$2'","weight": 1}],"accounts": [{"permission":{"actor":"eosnamesshop","permission":"eosio.code"},"weight":1}]}' -p $1@owner || exit


cleos -u $eosserver push action eosnamesshop regname '{"account":"'$1'","seller":"'$3'","confirm_day":'$confirmday',"distribution":'$distribution'}' -p $1@owner -p $3 || exit

echo Sell $1 OK
