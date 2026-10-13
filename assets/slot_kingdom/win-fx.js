(function(root){
 'use strict';
 const LEVELS=[{id:'big',title:'BIG',suffix:'WIN',min:5,max:10,ms:2400,coins:18},{id:'mega',title:'MEGA',suffix:'WIN',min:10,max:20,ms:3000,coins:24},{id:'super',title:'SUPER',suffix:'WIN',min:20,max:41,ms:3600,coins:30},{id:'sensational',title:'SENSASIONAL',suffix:'',min:41,max:5000,ms:4400,coins:36}];
 function level(amount,bet){if(!Number.isFinite(amount)||!Number.isFinite(bet)||amount<=0||bet<=0)return null;const ratio=amount/bet;return LEVELS.find(x=>ratio>=x.min&&(x.id==='sensational'?ratio<=x.max:ratio<x.max))||null}
 function amountAt(total,progress){const p=Math.max(0,Math.min(1,progress));return Math.min(total,Math.round(total*(1-Math.pow(1-p,3))*100)/100)}
 function duration(level,speed,reduced=false){return reduced?650:Math.max(900,level.ms/([1,2,4,8,16].includes(speed)?speed:1))}
 const api={LEVELS,level,amountAt,duration};if(typeof module!=='undefined'&&module.exports)module.exports=api;else root.WinFX=api;
})(typeof globalThis!=='undefined'?globalThis:this);
