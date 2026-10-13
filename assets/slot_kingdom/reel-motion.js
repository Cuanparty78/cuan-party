(function(root){
 'use strict';
 const SPEEDS=[1,2,4,8,16];
 function validSpeed(value){const n=Number(value);return SPEEDS.includes(n)?n:1}
 function duration(ms,speed,reduced=false){return reduced?20:ms/validSpeed(speed)}
 function strip(previous,result,column){
   const filler=Array.from({length:24+column*3},(_,i)=>({s:(i*5+column*3)%8,gold:false}));
   return {cells:[{s:(column+2)%8,gold:false},...result,...filler,...previous],startRow:1+result.length+filler.length,endRow:1};
 }
 function keyframes(start,end){const at=p=>'translate3d(0,'+(start+(end-start)*p)+'px,0)';return [
   {transform:at(0),offset:0,easing:'cubic-bezier(.42,0,1,1)'},
   {transform:at(.12),offset:.16,easing:'linear'},
   {transform:at(.9),offset:.72,easing:'cubic-bezier(0,0,.3,1)'},
   {transform:at(1),offset:1}
 ]}
 const api={SPEEDS,validSpeed,duration,strip,keyframes};
 if(typeof module!=='undefined'&&module.exports)module.exports=api;else root.ReelMotion=api;
})(typeof globalThis!=='undefined'?globalThis:this);
