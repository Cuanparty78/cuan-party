(function(root){
 'use strict';
 const LIMIT=200;
 function restore(value){
  const source=value?.spinLog||value||{},rows=Array.isArray(source.rows)?source.rows:[];
  const valid=rows.filter(r=>Number.isSafeInteger(r.id)&&r.id>0&&Number.isFinite(r.at)&&r.at>0&&Number.isFinite(r.bet)&&r.bet>0&&Number.isFinite(r.win)&&r.win>=0&&typeof r.isFree==='boolean').map(r=>({id:r.id,at:r.at,bet:r.bet,win:r.win,isFree:r.isFree}));
  const unique=[...new Map(valid.map(r=>[r.id,r])).values()].sort((a,b)=>b.id-a.id).slice(0,LIMIT);
  return {count:Math.max(Number.isSafeInteger(source.count)&&source.count>=0?source.count:0,...unique.map(r=>r.id)),rows:unique};
 }
 function add(log,entry){const id=log.count+1;if(!Number.isSafeInteger(id))throw Error('Spin count limit');return {count:id,rows:[{id,at:entry.at,bet:entry.bet,win:entry.win,isFree:entry.isFree},...log.rows].slice(0,LIMIT)}}
 const api={LIMIT,restore,add};if(typeof module!=='undefined'&&module.exports)module.exports=api;else root.SpinHistory=api;
})(typeof globalThis!=='undefined'?globalThis:this);
