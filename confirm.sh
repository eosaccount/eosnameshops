#!/bin/sh

if [ "$eosserver" == "" ] ; then
	eosserver=http://mainnet.eoscalgary.io
fi

if [ "$3" == "" ] ; then
	echo confirm.sh \[toSell\] \[publicKey\] \[seller\]
  echo
  echo Example: confirm.sh xxxxx11xxxxx EOS79VxyaJogC11CGDUoE1FdGFPD9ogPWWpUabkPi2uG4iF7s3wCn 233233233233
	exit
fi

cleos -u $eosserver push action eosnamesshop confirm '{"buyer":"'$3'","account":"'$1'","pubkey":"'$2'"}' -p $3@active || exit

echo Confirm $1 OK


