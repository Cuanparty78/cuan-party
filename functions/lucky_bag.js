'use strict';
const {randomInt,createHash}=require('node:crypto');
const AMOUNTS=[100000,500000,1000000,5000000],COUNTS=[10,20,40,60],MINUTES=[0,1,3,5];
function allocate(total,count,rng=randomInt){
 const weights=Array.from({length:count},()=>rng(100)+1),sum=weights.reduce((a,b)=>a+b,0);
 const shares=weights.map(w=>1+Math.floor((total-count)*w/sum));
 let rest=total-shares.reduce((a,b)=>a+b,0);
 for(let i=0;rest>0;i=(i+1)%count,rest--)shares[i]++;
 return shares;
}
function install({db,onCall,HttpsError,requireAuth,economyFrom,FieldValue}){
 const fail=(code,message)=>{throw new HttpsError(code,message);};
 const id=(v)=>{if(typeof v!=='string'||!/^[A-Za-z0-9_-]{1,160}$/.test(v))fail('invalid-argument','ID tidak valid.');return v;};
 const money=uid=>({root:db.doc(`users/${uid}`),econ:db.doc(`users/${uid}/private/economy`)});
 const credit=(tx,refs,coin)=>{for(const ref of [refs.root,refs.econ])tx.set(ref,{coin,updatedAt:FieldValue.serverTimestamp()},{merge:true});};
 const create=onCall(async r=>{
  const uid=requireAuth(r),roomId=id(r.data?.roomId),operation=id(r.data?.transactionId);
  if(operation.length<8)fail('invalid-argument','ID transaksi terlalu pendek.');
  const {amount,count,minutes}=r.data||{};
  if(!AMOUNTS.includes(amount)||!COUNTS.includes(count)||!MINUTES.includes(minutes))fail('invalid-argument','Pilihan Lucky Bag tidak valid.');
  const refs=money(uid),room=db.doc(`rooms/${roomId}`),member=db.doc(`rooms/${roomId}/members/${uid}`);
  const bagId=createHash('sha256').update(uid+':'+operation).digest('hex');
  const receipt=db.doc(`users/${uid}/luckyBagOperations/${operation}`),bag=db.doc(`rooms/${roomId}/luckyBags/${bagId}`);
  // Draw once outside retrying transactions; never publish unclaimed shares.
  const shares=allocate(amount,count),now=Date.now(),opensAt=now+minutes*60000;
  return db.runTransaction(async tx=>{
   const [old,rs,ms,us,es]=await Promise.all([receipt,room,member,refs.root,refs.econ].map(x=>tx.get(x)));
   if(old.exists)return old.data().result;
   if(!rs.exists||rs.data().isActive===false||!ms.exists)fail('failed-precondition','Masuk room aktif terlebih dahulu.');
   const coin=economyFrom(us.data(),es.data()).coin;
   if(!Number.isSafeInteger(coin)||coin<amount)fail('resource-exhausted','Koin tidak cukup.');
   const result={bagId:bag.path.split('/').at(-1),coin:coin-amount,opensAt};
   credit(tx,refs,coin-amount);
   tx.set(bag,{senderUid:uid,senderName:ms.data().name||'User',amount,count,claimedCount:0,remaining:amount,opensAt,status:'active',createdAt:FieldValue.serverTimestamp()});
   tx.set(db.doc(`${bag.path}/private/pool`),{shares});
   tx.set(receipt,{result,createdAt:FieldValue.serverTimestamp()});
   tx.set(db.doc(`rooms/${roomId}/messages/lucky_${bagId}`),{type:'chat',fromId:uid,fromName:ms.data().name||'User',text:`Membagikan Lucky Bag ${amount.toLocaleString('id-ID')} koin untuk ${count} orang`,createdAt:FieldValue.serverTimestamp()});
   return result;
  });
 });
 const claim=onCall(async r=>{
  const uid=requireAuth(r),roomId=id(r.data?.roomId),bagId=id(r.data?.bagId);
  const bag=db.doc(`rooms/${roomId}/luckyBags/${bagId}`),receipt=db.doc(`${bag.path}/claims/${uid}`),refs=money(uid);
  return db.runTransaction(async tx=>{
   const [old,bs,ps,rs,ms,us,es]=await Promise.all([receipt,bag,db.doc(`${bag.path}/private/pool`),db.doc(`rooms/${roomId}`),db.doc(`rooms/${roomId}/members/${uid}`),refs.root,refs.econ].map(x=>tx.get(x)));
   if(old.exists)return old.data();
   if(!rs.exists||rs.data().isActive===false||!ms.exists)fail('failed-precondition','Masuk room aktif terlebih dahulu.');
   if(!bs.exists)fail('not-found','Lucky Bag tidak ditemukan.');
   const b=bs.data();
   if(Date.now()<b.opensAt)fail('failed-precondition','Countdown belum selesai.');
   if(b.claimedCount>=b.count||b.status!=='active')fail('resource-exhausted','Lucky Bag sudah habis.');
   const reward=ps.data()?.shares?.[b.claimedCount],coin=economyFrom(us.data(),es.data()).coin;
   if(!Number.isSafeInteger(reward)||reward<1||reward>b.remaining||!Number.isSafeInteger(coin)||!Number.isSafeInteger(coin+reward))fail('internal','Saldo Lucky Bag tidak valid.');
   const result={amount:reward,coin:coin+reward,bagId};
   credit(tx,refs,coin+reward);tx.set(receipt,result);
   tx.update(bag,{claimedCount:b.claimedCount+1,remaining:b.remaining-reward,status:b.claimedCount+1===b.count?'completed':'active'});
   return result;
  });
 });
 return {createLuckyBag:create,claimLuckyBag:claim};
}
module.exports={AMOUNTS,COUNTS,MINUTES,allocate,install};
