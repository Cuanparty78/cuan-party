'use strict';
const {randomInt}=require('node:crypto');
const Engine=require('./slot_engine');
const GoldBank=require('./slot_gold_bank');
const BETS=[50,100,250,500,1000,2500,10000,25000,50000,100000,250000,500000,1000000,2500000,5000000,10000000];
// Persisted separately for each Firebase Auth UID. No client-supplied UID/outcome.
function newState(now){return {count:0,free:0,freeBet:0,freeTotal:0,freeCap:0,totalBet:0,goldBank:GoldBank.create(now),revision:1};}
function settle(state,coin,requestedBet,now,rng=randomInt){
 const s=structuredClone(state),isFree=s.free>0,bet=isFree?s.freeBet:requestedBet;
 if(!BETS.includes(bet))throw Error('invalid-bet');
 if(!Number.isSafeInteger(coin)||coin<0)throw Error('invalid-wallet');
 if(!isFree&&coin<bet)throw Error('insufficient-coins');
 if(!Number.isSafeInteger(s.count)||s.count>=Number.MAX_SAFE_INTEGER)throw Error('counter-limit');
 s.goldBank=GoldBank.restore(s.goldBank,now);
 if(isFree)s.free--;else {s.totalBet+=bet;GoldBank.deposit(s.goldBank,bet,now);}
 const cap=isFree?s.freeCap-s.freeTotal:bet*Engine.CONFIG.maxWin;
 if(cap<=0)throw Error('invalid-bonus');
 const plan=Engine.planRound(bet,isFree,cap,rng);
 if(plan.frames.length>200)throw Error('outcome-too-large');
 if(isFree)s.freeTotal=Math.round((s.freeTotal+plan.total)*100)/100;
 else if(plan.award){s.freeBet=bet;s.freeTotal=0;s.freeCap=bet*Engine.CONFIG.maxWin-plan.total;}
 s.free=plan.capped?0:s.free+plan.award;
 s.count++;
 // App economy uses integer coins; retain sub-coin winnings for subsequent spins.
 const credit=plan.total+(s.coinRemainder||0),win=Math.floor(Math.round(credit*100)/100);
 s.coinRemainder=Math.round((credit-win)*100)/100;
 const balance=coin-(isFree?0:bet)+win;
 if(!Number.isSafeInteger(balance)||balance<0)throw Error('wallet-limit');
 const row={id:s.count,at:now,bet,win,isFree};
 return {state:s,balance,row,plan:{...plan,frames:plan.frames.map(f=>({...f,positions:[...f.positions]}))}};
}
function install({db,onCall,HttpsError,requireAuth,economyFrom,FieldValue}){
 const refs=uid=>{const user=db.doc(`users/${uid}`);return {user,economy:user.collection('private').doc('economy'),game:user.collection('private').doc('slotKingdom')};};
 const fail=(code,message)=>{throw new HttpsError(code,message);};
 const enabled=async tx=>{const snap=await (tx?tx.get(db.doc('gameConfig/slotKingdom')):db.doc('gameConfig/slotKingdom').get());if(snap.data()?.enabled!==true)fail('failed-precondition','SLOT KINGDOM belum diaktifkan.');};
 const operationId=data=>{const id=data?.transactionId;if(typeof id!=='string'||!/^[a-zA-Z0-9_-]{8,80}$/.test(id))fail('invalid-argument','transactionId tidak valid.');return id;};
 const getState=onCall(async request=>{const uid=requireAuth(request);const r=refs(uid);const [u,e,g]=await Promise.all([r.user.get(),r.economy.get(),r.game.get()]);const s=g.exists?g.data():newState(Date.now());s.goldBank=GoldBank.restore(s.goldBank,Date.now());const history=await r.game.collection('spins').orderBy('id','desc').limit(200).get();return {uid,serverNow:Date.now(),balance:economyFrom(u.data(),e.data()).coin,state:s,rows:history.docs.map(d=>d.data().row)};});
 const spin=onCall(async request=>{
  const uid=requireAuth(request),id=operationId(request.data),r=refs(uid),op=r.game.collection('operations').doc(id);
  return db.runTransaction(async tx=>{
   const previous=await tx.get(op);
   if(previous.exists){if(previous.data().kind!=='spin')fail('invalid-argument','ID transaksi sudah dipakai.');return previous.data().result;}
   await enabled(tx);
   const [u,e,g]=await Promise.all([tx.get(r.user),tx.get(r.economy),tx.get(r.game)]);
   const s=g.exists?g.data():newState(Date.now());
   if(request.data?.expectedCount!==s.count)fail('failed-precondition','Data spin berubah. Muat ulang game.');
   let result;try{result=settle(s,economyFrom(u.data(),e.data()).coin,request.data?.bet,Date.now());}catch(error){fail(error.message==='insufficient-coins'?'resource-exhausted':'failed-precondition',error.message==='insufficient-coins'?'Koin tidak cukup.':'Spin tidak dapat diproses.');}
   const response={...result,uid,serverNow:Date.now()};
   tx.set(r.game,result.state);tx.set(r.economy,{coin:result.balance,updatedAt:FieldValue.serverTimestamp()},{merge:true});tx.set(r.user,{coin:result.balance},{merge:true});
   tx.create(r.game.collection('spins').doc(String(result.row.id).padStart(16,'0')),{row:result.row,transactionId:id});
   tx.create(op,{kind:'spin',result:response,createdAt:FieldValue.serverTimestamp()});
   return response;
  });
 });
 const claim=onCall(async request=>{const uid=requireAuth(request),id=operationId(request.data),r=refs(uid),op=r.game.collection('operations').doc(id);return db.runTransaction(async tx=>{
  const prior=await tx.get(op);if(prior.exists){if(prior.data().kind!=='claim')fail('invalid-argument','ID transaksi sudah dipakai.');return prior.data().result;}
  await enabled(tx);const [u,e,g]=await Promise.all([tx.get(r.user),tx.get(r.economy),tx.get(r.game)]);const s=g.exists?g.data():newState(Date.now());s.goldBank=GoldBank.restore(s.goldBank,Date.now());
  const amount=GoldBank.claim(s.goldBank,Date.now());if(amount<=0)fail('failed-precondition','Reward belum tersedia atau sudah diklaim.');
  const credit=amount+(s.coinRemainder||0),paid=Math.floor(Math.round(credit*100)/100);s.coinRemainder=Math.round((credit-paid)*100)/100;
  const balance=economyFrom(u.data(),e.data()).coin+paid;if(!Number.isSafeInteger(balance))fail('failed-precondition','Batas saldo tercapai.');
  const result={uid,balance,state:s,amount:paid,serverNow:Date.now()};tx.set(r.game,s);tx.set(r.economy,{coin:balance,updatedAt:FieldValue.serverTimestamp()},{merge:true});tx.set(r.user,{coin:balance},{merge:true});tx.create(op,{kind:'claim',result,createdAt:FieldValue.serverTimestamp()});return result;
 });});
 return {slotKingdomGetState:getState,slotKingdomSpin:spin,slotKingdomClaimGoldBank:claim};
}
module.exports={install,settle,newState,BETS};
