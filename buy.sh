#!/bin/sh

if [ "$eosserver" == "" ] ; then
	eosserver=http://mainnet.eoscalgary.io
fi

if [ "$3" == "" ] ; then
	echo buy.sh \[toSell\] \[seller\] \[price\]
  echo
  echo Example: buy.sh xxxxx11xxxxx 233233233233 \"3 EOS\"
	exit
fi

cleos -u $eosserver transfer $2 eosnamesshop "$3" "$1" || exit

echo Buy OK
