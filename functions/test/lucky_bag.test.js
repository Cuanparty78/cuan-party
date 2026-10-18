'use strict';
const test=require('node:test'),assert=require('node:assert/strict');
const {allocate,AMOUNTS,COUNTS,install}=require('../lucky_bag');
class HttpsError extends Error {constructor(code,message){super(message);this.code=code;}}
function harness(){
 const values=new Map(),versions=new Map();let tail=Promise.resolve();
 const ref=path=>({path}),snap=path=>({exists:values.has(path),data:()=>structuredClone(values.get(path))});
 const write=(p,d,merge)=>{values.set(p,merge?{...values.get(p),...structuredClone(d)}:structuredClone(d));versions.set(p,(versions.get(p)||0)+1);};
 const db={doc:ref,runTransaction:async fn=>{
  for(let i=0;i<100;i++){
   const reads=new Map(),writes=[];
   const tx={get:async r=>{reads.set(r.path,versions.get(r.path)||0);return snap(r.path);},set:(r,d,o)=>writes.push([r.path,d,o?.merge]),update:(r,d)=>writes.push([r.path,d,true])};
   const result=await fn(tx);let release;const previous=tail;tail=new Promise(r=>release=r);await previous;
   try{if([...reads].some(([p,v])=>(versions.get(p)||0)!==v))continue;for(const w of writes)write(...w);return result;}finally{release();}
  }throw Error('Too many retries');
 }};
 const api=install({db,onCall:f=>f,HttpsError,requireAuth:r=>{if(!r.auth?.uid)throw new HttpsError('unauthenticated','Login');return r.auth.uid;},economyFrom:(u,e)=>({coin:e?.coin??u?.coin??0}),FieldValue:{serverTimestamp:()=>Date.now()}});
 const seed=(p,d)=>write(p,d,false);seed('rooms/royal',{isActive:true});seed('rooms/royal/members/sender',{name:'JEP'});seed('users/sender',{coin:5000000});
 return {api,values,seed};
}
const req=(uid,data)=>({auth:{uid},data});
const config={roomId:'royal',amount:100000,count:10,minutes:0,transactionId:'bag-operation-001'};
test('every Lucky Bag option conserves the pool with positive integer shares',()=>{
 for(const amount of AMOUNTS)for(const count of COUNTS)for(let seed=0;seed<20;seed++){
  let n=seed;const shares=allocate(amount,count,max=>(n++*37)%max);
  assert.equal(shares.length,count);assert.equal(shares.reduce((a,b)=>a+b,0),amount);assert(shares.every(x=>Number.isSafeInteger(x)&&x>=1));
 }
});
test('concurrent create and claim retries debit and credit once; total is conserved',async()=>{
 const {api,values,seed}=harness();
 const results=await Promise.all(Array.from({length:10},()=>api.createLuckyBag(req('sender',config))));
 assert(results.every(x=>x.bagId===results[0].bagId));assert.equal(values.get('users/sender').coin,4900000);
 const bagId=results[0].bagId;assert(!values.get(`rooms/royal/luckyBags/${bagId}`).shares);
 for(let i=0;i<10;i++){seed(`rooms/royal/members/u${i}`,{name:`User${i}`});seed(`users/u${i}`,{coin:0});}
 const received=await Promise.all(Array.from({length:10},(_,i)=>api.claimLuckyBag(req('u'+i,{roomId:'royal',bagId}))));
 assert.equal(received.reduce((s,r)=>s+r.amount,0),100000);
 const replay=await Promise.all(Array.from({length:10},()=>api.claimLuckyBag(req('u0',{roomId:'royal',bagId}))));
 assert(replay.every(x=>x.amount===received[0].amount));assert.equal(values.get('users/u0').coin,received[0].amount);
 assert.equal(values.get(`rooms/royal/luckyBags/${bagId}`).remaining,0);
 seed('rooms/royal/members/extra',{});
 await assert.rejects(()=>api.claimLuckyBag(req('extra',{roomId:'royal',bagId})),e=>e.code==='resource-exhausted');
});
test('auth, membership, balance, valid options and countdown are enforced on server',async()=>{
 const {api,seed,values}=harness();
 await assert.rejects(()=>api.createLuckyBag({data:config}),e=>e.code==='unauthenticated');
 await assert.rejects(()=>api.createLuckyBag(req('outsider',config)),e=>e.code==='failed-precondition');
 await assert.rejects(()=>api.createLuckyBag(req('sender',{...config,amount:1})),e=>e.code==='invalid-argument');
 seed('users/sender',{coin:99999});await assert.rejects(()=>api.createLuckyBag(req('sender',config)),e=>e.code==='resource-exhausted');
 assert.equal(values.get('users/sender').coin,99999);
 seed('users/sender',{coin:100000});const {bagId}=await api.createLuckyBag(req('sender',{...config,minutes:1}));
 await assert.rejects(()=>api.claimLuckyBag(req('sender',{roomId:'royal',bagId})),e=>e.code==='failed-precondition');
 assert.equal(values.get(`rooms/royal/luckyBags/${bagId}`).remaining,100000);
});
