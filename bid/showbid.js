#!/usr/local/bin/node

let fs = require('fs');

let run_exec = function (cmd, params, output) {
  var child_process = require('child_process');
  var fs = require('fs');

  var out = fs.openSync(output, 'w+');
  
  child_process.spawnSync(cmd, params, {
      detached: true,
      stdio: ['ignore', out]
  });
}

let morethan100 = [];

let doSync = function(first) {
  if (!first) first = '1';
  
  run_exec('/bin/sh', ['cl', 'get', 'table', 'eosio', 'eosio', 'namebids', '-l', '10000', '-L', first], 'tp.json');
  
  let data = fs.readFileSync('tp.json', 'utf-8');
  
  let j = JSON.parse(data);
  
  let last = '';
  for(var one in j.rows) {
    let oneData = j.rows[one];
    last = oneData.newname;
    if (oneData.high_bid < 10000000) continue; // > 1000
      
    let secondPass = (new Date() - (+oneData.last_bid_time) / 1000) / 1000;
    
    console.log((oneData.high_bid / 10000).toFixed(1) + "," + oneData.newname + "," + oneData.high_bidder + "," + secondPass);
  }
  
  if (j.more) return last;
  
  return '';
}


let next = '';
while(true) {
  next = doSync(next);
    
  if (!next) break;
}

fs.unlinkSync('tp.json');




