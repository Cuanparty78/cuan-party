
// CUAN PARTY seller stock center: 2026-10-20
import { initializeApp, cert } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
let db:any=null, auth:any=null;
try {
 const raw=Bun.env.FIREBASE_SERVICE_ACCOUNT_JSON;
 if(raw){initializeApp({credential:cert(JSON.parse(raw)),projectId:"cuan-party"});db=getFirestore();auth=getAuth();}
} catch(e:any) { console.error("Firebase connection is not configured correctly"); }
class E extends Error {status:number;constructor(status:number,msg:string){super(msg);this.status=status}}
const fail=(code:number,msg:string):never=>{throw new E(code,msg)};
const res=(data:any,status=200)=>Response.json(data,{status,headers:{"Cache-Control":"no-store"}});
const validId=(x:any)=>typeof x==="string"&&/^[\w-]{8,120}$/.test(x);
const toCoin=(x:any)=>Number.isSafeInteger(x)&&x>=0?x:0;
const catalog:Record<string,number>={
 "Royal Crown":200000,"Golden Wings":20000,"Love Crown":20000,
 "Fantasy":20000,"Royal Car":20000,"Queen Crown":20000,"Royal Castle":20000,
 "Royal Rose":100,"Royal Coffee":500,"Royal Cake":1000,"Royal Heart":5000,
 "Diamond Ring":10000,"Golden Dragon":50000,"Royal Yacht":100000,
 "Golden Palace":500000,"Kingdom Throne":1000000
};
async function user(req:Request){
 if(!auth||!db)fail(503,"Server perlu Firebase Service Account dari pemilik");
 const t=req.headers.get("authorization")||"";
 if(!t.startsWith("Bearer "))fail(401,"Login diperlukan");
 try{return await auth.verifyIdToken(t.slice(7),true)}catch{fail(401,"Sesi tidak valid, login ulang")}
}
function owner(u:any){
 const email=(Bun.env.OWNER_EMAIL||"").toLowerCase();
 const uid=Bun.env.OWNER_UID||"";
 return Boolean((uid&&u.uid===uid)||(email&&u.email_verified&&u.email?.toLowerCase()===email));
}
async function role(u:any) {
 if(owner(u))return "owner";
 const s=await db.collection("coinSellers").doc(u.uid).get();
 return s.exists&&s.data()?.active===true?"seller":"user";
}
async function findAccount(value:any){
 const id=String(value||"").trim();
 if(!/^[0-9]{6,13}$/.test(id))fail(400,"ID akun tidak valid");
 // Newly registered accounts store CUAN IDs as strings, but some older
 // profiles stored them as integers. Accept either without allowing duplicates.
 const users=db.collection("users");
 const stringMatches=await users.where("cuanId","==",id).limit(2).get();
 if(stringMatches.size>1)fail(409,"ID akun ganda");
 const numericMatches=await users.where("cuanId","==",Number(id)).limit(2).get();
 const matches=new Map<string,any>();
 for(const doc of [...stringMatches.docs,...numericMatches.docs])matches.set(doc.id,doc);
 if(matches.size!==1)fail(matches.size===0?404:409,matches.size===0?"Akun tidak ditemukan":"ID akun ganda");
 return [...matches.values()][0];
}
async function issue(u:any,b:any){
 if(!owner(u))fail(403,"Hanya owner boleh membuat Coin baru");
 if(!validId(b.transactionId)||!Number.isSafeInteger(b.amount)||b.amount<1||b.amount>1000000000)fail(400,"Data transaksi salah");
 const to=await findAccount(b.targetId), tr=db.collection("economyTransactions").doc(b.transactionId);
 return db.runTransaction(async(t:any)=>{
  const [old,root,econ]=await Promise.all([t.get(tr),t.get(to.ref),t.get(to.ref.collection("private").doc("economy"))]);
  if(old.exists){const d=old.data();if(d.type!=="ownerIssue"||d.uid!==u.uid||d.targetUid!==to.id||d.amount!==b.amount)fail(409,"ID transaksi dipakai");return {replayed:true,coin:d.newCoin};}
  if(!root.exists)fail(404,"Penerima tidak ditemukan");
  const before=toCoin(econ.exists&&typeof econ.data()?.coin==="number"?econ.data()?.coin:root.data()?.coin),after=before+b.amount;
  if(!Number.isSafeInteger(after))fail(400,"Batas saldo");
  t.set(to.ref,{coin:after,updatedAt:FieldValue.serverTimestamp()},{merge:true});
  t.set(to.ref.collection("private").doc("economy"),{coin:after,updatedAt:FieldValue.serverTimestamp()},{merge:true});
  t.create(tr,{type:"ownerIssue",uid:u.uid,targetUid:to.id,targetCuanId:String(b.targetId),amount:b.amount,newCoin:after,createdAt:FieldValue.serverTimestamp()});
  t.create(to.ref.collection("walletHistory").doc(b.transactionId),{type:"ownerIssue",direction:"in",amount:b.amount,createdAt:FieldValue.serverTimestamp()});
  return {targetId:String(b.targetId),credited:b.amount,coin:after};
 });
}
async function seller(u:any,b:any){
 if(!owner(u))fail(403,"Owner saja");
 const to=await findAccount(b.targetId);
 const active=b.active===true;
 await db.collection("coinSellers").doc(to.id).set({active,cuanId:String(b.targetId),name:to.data()?.displayName||"",updatedBy:u.uid,updatedAt:FieldValue.serverTimestamp()},{merge:true});
 return {targetId:b.targetId,active};
}
async function transfer(u:any,b:any){
 // Legacy endpoint reserved to prevent mixing spendable wallet and seller stock.
 fail(410,"Transfer saldo pribadi Seller sudah tidak didukung. Gunakan fitur Stok Coin Seller.");
 if(!validId(b.transactionId)||!Number.isSafeInteger(b.amount)||b.amount<1||b.amount>1000000000)fail(400,"Data transaksi tidak valid");
 const to=await findAccount(b.targetId);
 if(to.id===u.uid)fail(400,"Tidak bisa transfer ke diri sendiri");
 const from=db.collection("users").doc(u.uid),tr=db.collection("economyTransactions").doc(b.transactionId);
 return db.runTransaction(async(t:any)=>{
   const fe=from.collection("private").doc("economy"),te=to.ref.collection("private").doc("economy");
   const [old,fr,frE,tt,ttE,ss]=await Promise.all([t.get(tr),t.get(from),t.get(fe),t.get(to.ref),t.get(te),t.get(db.collection("coinSellers").doc(u.uid))]);
   if(old.exists){const d=old.data();if(d.type!=="sellerTransfer"||d.uid!==u.uid||d.targetUid!==to.id||d.amount!==b.amount)fail(409,"ID transaksi dipakai");return {replayed:true,coin:d.newCoin}}
   if(!ss.exists||ss.data()?.active!==true)fail(403,"Seller tidak aktif");
   if(!fr.exists||!tt.exists)fail(404,"Akun tidak ada");
   const a=toCoin(frE.exists&&typeof frE.data()?.coin==="number"?frE.data()?.coin:fr.data()?.coin);
   if(a<b.amount)fail(400,"Saldo seller kurang");
   const v=toCoin(ttE.exists&&typeof ttE.data()?.coin==="number"?ttE.data()?.coin:tt.data()?.coin)+b.amount;
   if(!Number.isSafeInteger(v))fail(400,"Saldo penerima melebihi batas");
   for(const [ref,coin] of [[from,a-b.amount],[fe,a-b.amount],[to.ref,v],[te,v]])t.set(ref,{coin,updatedAt:FieldValue.serverTimestamp()},{merge:true});
   t.create(tr,{type:"sellerTransfer",uid:u.uid,targetUid:to.id,targetCuanId:String(b.targetId),amount:b.amount,newCoin:a-b.amount,createdAt:FieldValue.serverTimestamp()});
   t.create(from.collection("walletHistory").doc(b.transactionId),{type:"sellerTransfer",direction:"out",amount:b.amount,createdAt:FieldValue.serverTimestamp()});
   t.create(to.ref.collection("walletHistory").doc(b.transactionId),{type:"sellerTransfer",direction:"in",amount:b.amount,createdAt:FieldValue.serverTimestamp()});
   return {targetId:b.targetId,credited:b.amount,remaining:a-b.amount};
 });
}

function validCoinAmount(b:any){
 if(!Number.isSafeInteger(b.amount)||b.amount<1||b.amount>1000000000)fail(400,"Jumlah harus 1 - 1.000.000.000 Coin");
 if(!validId(b.transactionId))fail(400,"ID transaksi tidak valid");
}
async function sellerSelf(u:any){
 if(!owner(u))fail(403,"Hanya owner boleh mengaktifkan dirinya sebagai Coin Seller");
 const profile=await db.collection("users").doc(u.uid).get();
 if(!profile.exists)fail(404,"Akun JEP belum terdaftar di aplikasi");
 const id=String(profile.data()?.cuanId||"").trim();
 if(!/^[0-9]{6,13}$/.test(id))fail(400,"CUAN ID profil belum valid");
 await db.collection("coinSellers").doc(u.uid).set({active:true,cuanId:id,name:profile.data()?.name||profile.data()?.displayName||"JEP",updatedBy:u.uid,updatedAt:FieldValue.serverTimestamp()},{merge:true});
 return {active:true,cuanId:id};
}
async function sellerCheck(u:any,id:any){
 if(!owner(u))fail(403,"Hanya Owner boleh memeriksa status Coin Seller");
 const target=await findAccount(id);
 const seller=await db.collection("coinSellers").doc(target.id).get();
 const data=seller.data()||{};
 return {cuanId:String(target.data()?.cuanId??id),name:target.data()?.displayName||"",active:data.active===true,stockCoin:toCoin(data.stockCoin)};
}
async function sellerMe(u:any){
 const [seller,root]=await Promise.all([db.collection("coinSellers").doc(u.uid).get(),db.collection("users").doc(u.uid).get()]);
 const data=seller.data()||{};
 return {active:data.active===true,owner:owner(u),stockCoin:toCoin(data.stockCoin),cuanId:String(root.data()?.cuanId||data.cuanId||""),walletCoin:toCoin(root.data()?.coin)};
}
async function sellerFund(u:any,b:any){
 if(!owner(u))fail(403,"Hanya owner bisa mengisi saldo stok seller");
 validCoinAmount(b);
 const target=await findAccount(b.targetId);
 const ref=db.collection("coinSellers").doc(target.id),tr=db.collection("economyTransactions").doc(b.transactionId);
 return db.runTransaction(async(t:any)=>{
  const [old,sellerSnap]=await Promise.all([t.get(tr),t.get(ref)]);
  if(old.exists){
   const d=old.data();
   if(d.type!=="sellerStockTopup"||d.uid!==u.uid||d.targetUid!==target.id||d.amount!==b.amount)fail(409,"ID transaksi sudah digunakan");
   return {replayed:true,stockCoin:toCoin(d.newStockCoin),targetId:String(b.targetId)};
  }
  if(!sellerSnap.exists||sellerSnap.data()?.active!==true)fail(403,"Seller belum aktif");
  const after=toCoin(sellerSnap.data()?.stockCoin)+b.amount;
  if(!Number.isSafeInteger(after))fail(400,"Saldo seller melebihi batas");
  t.set(ref,{stockCoin:after,updatedAt:FieldValue.serverTimestamp()},{merge:true});
  t.create(tr,{type:"sellerStockTopup",uid:u.uid,targetUid:target.id,targetCuanId:String(b.targetId),amount:b.amount,newStockCoin:after,createdAt:FieldValue.serverTimestamp()});
  t.create(ref.collection("stockHistory").doc(b.transactionId),{type:"stockTopup",direction:"in",amount:b.amount,createdAt:FieldValue.serverTimestamp()});
  return {credited:b.amount,targetId:String(b.targetId),stockCoin:after};
 });
}
async function sellerStockSend(u:any,b:any){
 validCoinAmount(b);
 const target=await findAccount(b.targetId);
 const stockRef=db.collection("coinSellers").doc(u.uid);
 const tr=db.collection("economyTransactions").doc(b.transactionId);
 return db.runTransaction(async(t:any)=>{
  const targetEconomy=target.ref.collection("private").doc("economy");
  const [old,sellerSnap,root,econ]=await Promise.all([t.get(tr),t.get(stockRef),t.get(target.ref),t.get(targetEconomy)]);
  if(old.exists){
   const d=old.data();
   if(d.type!=="sellerStockSend"||d.uid!==u.uid||d.targetUid!==target.id||d.amount!==b.amount)fail(409,"ID transaksi sudah digunakan");
   return {replayed:true,credited:b.amount,targetId:String(b.targetId),stockCoin:toCoin(d.newStockCoin)};
  }
  if(!sellerSnap.exists||sellerSnap.data()?.active!==true)fail(403,"Coin Seller belum aktif");
  if(!root.exists)fail(404,"Akun penerima tidak ditemukan");
  const stock=toCoin(sellerSnap.data()?.stockCoin);
  if(stock<b.amount)fail(400,"Saldo stok Coin Seller tidak mencukupi");
  const nextCoin=toCoin(econ.exists&&typeof econ.data()?.coin==="number"?econ.data()?.coin:root.data()?.coin)+b.amount;
  if(!Number.isSafeInteger(nextCoin))fail(400,"Saldo dompet user melebihi batas");
  const left=stock-b.amount;
  t.set(stockRef,{stockCoin:left,updatedAt:FieldValue.serverTimestamp()},{merge:true});
  t.set(target.ref,{coin:nextCoin,updatedAt:FieldValue.serverTimestamp()},{merge:true});
  t.set(targetEconomy,{coin:nextCoin,updatedAt:FieldValue.serverTimestamp()},{merge:true});
  t.create(tr,{type:"sellerStockSend",uid:u.uid,targetUid:target.id,targetCuanId:String(b.targetId),amount:b.amount,newStockCoin:left,newCoin:nextCoin,createdAt:FieldValue.serverTimestamp()});
  t.create(target.ref.collection("walletHistory").doc(b.transactionId),{type:"sellerStockSend",direction:"in",amount:b.amount,createdAt:FieldValue.serverTimestamp()});
  t.create(stockRef.collection("stockHistory").doc(b.transactionId),{type:"stockSend",direction:"out",targetCuanId:String(b.targetId),amount:b.amount,createdAt:FieldValue.serverTimestamp()});
  return {credited:b.amount,targetId:String(b.targetId),stockCoin:left,walletCoin:nextCoin};
 });
}
async function sellerStockHistory(u:any){
 const s=await db.collection("coinSellers").doc(u.uid).get();
 if(!s.exists||s.data()?.active!==true)fail(403,"Coin Seller belum aktif");
 const docs=await s.ref.collection("stockHistory").orderBy("createdAt","desc").limit(40).get();
 return {items:docs.docs.map((d:any)=>({type:d.data().type,direction:d.data().direction,amount:d.data().amount,targetCuanId:d.data().targetCuanId||null,createdAt:d.data().createdAt?.toMillis?.()||0}))};
}

// Final decision from Owner JEP: Gift pays Diamond 1:1; Exchange returns 70% Coin.
// Keep both rates enforced by the trusted backend, never by editable client fields.
const GIFT_DIAMOND_PERCENT=100;
const DIAMOND_EXCHANGE_COIN_PERCENT=70;
function giftDiamondPercent(){ return GIFT_DIAMOND_PERCENT; }
async function exchangeDiamond(u:any,b:any){
 // Diamond to Coin conversion: always server-enforced 70%. No client minting.
 const diamond=b?.diamond;
 if(!validId(b?.transactionId)||!Number.isSafeInteger(diamond)||diamond<100||diamond>1000000000||diamond%100!==0)
   fail(400,"Jumlah Diamond harus kelipatan 100 (100–1.000.000.000), dan ID transaksi valid");
 const coinAdded=(diamond/100)*DIAMOND_EXCHANGE_COIN_PERCENT;
 const root=db.collection("users").doc(u.uid);
 const econ=root.collection("private").doc("economy");
 const tr=db.collection("economyTransactions").doc(b.transactionId);
 return db.runTransaction(async(t:any)=>{
   const [old,rootSnap,econSnap]=await Promise.all([t.get(tr),t.get(root),t.get(econ)]);
   if(old.exists){
     const saved=old.data();
     if(saved?.type!=="diamondExchange"||saved?.uid!==u.uid||saved?.diamondSpent!==diamond)
       fail(409,"ID transaksi sudah digunakan");
     return {replayed:true,...saved.result};
   }
   if(!rootSnap.exists)fail(404,"Profil akun tidak ditemukan");
   const data=rootSnap.data()||{}, privateData=econSnap.data()||{};
   const currentDiamond=toCoin(econSnap.exists&&typeof privateData.diamond==="number"?privateData.diamond:data.diamond);
   const currentCoin=toCoin(econSnap.exists&&typeof privateData.coin==="number"?privateData.coin:data.coin);
   if(currentDiamond<diamond)fail(400,"Saldo Diamond tidak mencukupi");
   const nextDiamond=currentDiamond-diamond,nextCoin=currentCoin+coinAdded;
   if(!Number.isSafeInteger(nextCoin))fail(400,"Saldo Coin melebihi batas");
   const result={coin:nextCoin,diamond:nextDiamond,coinAdded,diamondSpent:diamond};
   const updatedAt=FieldValue.serverTimestamp();
   t.set(root,{coin:nextCoin,diamond:nextDiamond,updatedAt},{merge:true});
   t.set(econ,{coin:nextCoin,diamond:nextDiamond,updatedAt},{merge:true});
   t.create(tr,{type:"diamondExchange",uid:u.uid,diamondSpent:diamond,coinAdded,result,createdAt:FieldValue.serverTimestamp()});
   t.create(root.collection("walletHistory").doc(b.transactionId+"_diamond"),{type:"diamondExchange",currency:"diamond",direction:"out",amount:diamond,createdAt:FieldValue.serverTimestamp()});
   t.create(root.collection("walletHistory").doc(b.transactionId+"_coin"),{type:"diamondExchange",currency:"coin",direction:"in",amount:coinAdded,createdAt:FieldValue.serverTimestamp()});
   return result;
 });
}

async function gift(u:any,b:any) {
 const roomId=String(b.roomId||""),name=String(b.targetName||"").trim(),item=b.giftName;
 if(!/^[\w-]{4,160}$/.test(roomId)||!validId(b.transactionId)||!name||name.length>100||!Object.hasOwn(catalog,item)||!Number.isSafeInteger(b.quantity)||b.quantity<1||b.quantity>7777)fail(400,"Gift tidak valid");
 const percent=giftDiamondPercent();
 const total=catalog[item]*b.quantity, diamondReward=Math.floor(total*percent/100);
 if(!Number.isSafeInteger(total)||total<1||!Number.isSafeInteger(diamondReward)||diamondReward<1)fail(400,"Jumlah hadiah di luar batas");
 const from=db.collection("users").doc(u.uid),room=db.collection("rooms").doc(roomId);
 const sender=await from.get();if(!sender.exists)fail(404,"Pengirim tidak ada");
 let targetUid=u.uid;
 if(name!=="Saya"&&name!==sender.data()?.displayName){
   const q=await room.collection("members").where("name","==",name).limit(2).get();
   if(q.size!==1)fail(404,"Penerima tidak ada atau nama ganda");
   targetUid=q.docs[0].id;
 }
 const tr=db.collection("economyTransactions").doc(b.transactionId);
 return db.runTransaction(async(t:any)=>{
   const econ=from.collection("private").doc("economy"),member=room.collection("members").doc(u.uid),toMember=room.collection("members").doc(targetUid);
   const receiver=db.collection("users").doc(targetUid),receiverEcon=receiver.collection("private").doc("economy");
   const [old,rr,m1,m2,root,ee,targetRoot,targetEconomy]=await Promise.all([
      t.get(tr),t.get(room),t.get(member),t.get(toMember),t.get(from),t.get(econ),t.get(receiver),t.get(receiverEcon)
   ]);
   if(old.exists){const d=old.data();if(d.type!=="roomGift"||d.uid!==u.uid||d.roomId!==roomId||d.receiverUid!==targetUid||d.giftName!==item||d.quantity!==b.quantity)fail(409,"ID transaksi dipakai");return {replayed:true,coin:d.newCoin,total,diamondReward:d.diamondReward||0};}
   if(!rr.exists||rr.data()?.isActive===false||!m1.exists||!m2.exists)fail(403,"Anggota atau room sudah keluar");
   if(!targetRoot.exists)fail(404,"Profil penerima gift tidak ditemukan");
   if(targetUid!==u.uid&&m2.data()?.name!==name)fail(409,"Penerima berubah");
   const before=toCoin(ee.exists&&typeof ee.data()?.coin==="number"?ee.data()?.coin:root.data()?.coin);
   if(before<total)fail(400,"Coin tidak cukup");
   const after=before-total;
   const diamondBefore=toCoin(targetEconomy.exists&&typeof targetEconomy.data()?.diamond==="number"
      ?targetEconomy.data()?.diamond:targetRoot.data()?.diamond);
   const diamondAfter=diamondBefore+diamondReward;
   if(!Number.isSafeInteger(diamondAfter))fail(400,"Saldo diamond penerima melebihi batas");
   // One atomic settlement: charge sender Coin AND credit recipient Diamond.
   // When a user gifts themselves, preserve both balances in the same writes.
   const sameUser=targetUid===u.uid;
   const senderPatch:any={coin:after,updatedAt:FieldValue.serverTimestamp()};
   if(sameUser)senderPatch.diamond=diamondAfter;
   t.set(from,senderPatch,{merge:true});
   t.set(econ,senderPatch,{merge:true});
   if(!sameUser){
     t.set(receiver,{diamond:diamondAfter,updatedAt:FieldValue.serverTimestamp()},{merge:true});
     t.set(receiverEcon,{diamond:diamondAfter,updatedAt:FieldValue.serverTimestamp()},{merge:true});
   }
   t.set(room,{giftTotal:FieldValue.increment(total),lastActivityAt:FieldValue.serverTimestamp()},{merge:true});
   t.create(room.collection("messages").doc(b.transactionId),{type:"gift",fromId:u.uid,fromName:m1.data()?.name||"User",toId:targetUid,toName:m2.data()?.name||name,giftName:item,quantity:b.quantity,coinCost:total,createdAt:FieldValue.serverTimestamp()});
   t.create(db.collection("giftTransactions").doc(b.transactionId),{senderUid:u.uid,receiverUid:targetUid,roomId,giftName:item,quantity:b.quantity,unitPrice:catalog[item],total,diamondReward,diamondPercent:percent,createdAt:FieldValue.serverTimestamp()});
   t.create(tr,{type:"roomGift",uid:u.uid,receiverUid:targetUid,roomId,giftName:item,quantity:b.quantity,total,diamondReward,newCoin:after,createdAt:FieldValue.serverTimestamp()});
   t.create(from.collection("walletHistory").doc(b.transactionId),{type:"roomGift",currency:"coin",direction:"out",amount:total,createdAt:FieldValue.serverTimestamp()});
   t.create(receiver.collection("walletHistory").doc(b.transactionId+"_diamond"),{type:"giftReceived",currency:"diamond",direction:"in",amount:diamondReward,createdAt:FieldValue.serverTimestamp()});
   return {coin:after,roomId,receiverUid:targetUid,giftName:item,quantity:b.quantity,total,diamondReward,messageId:b.transactionId};
 });
}
const HTML = `<!doctype html><html lang="id"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>CUAN PARTY Workspace</title><style>body{font-family:system-ui;background:linear-gradient(135deg,#080916,#362053);color:#fff;margin:0;min-height:100vh}header{padding:22px 6%;border-bottom:1px solid #95763c}h1,h2{color:#f1d48c}main{max-width:1000px;margin:auto;padding:20px}.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(270px,1fr));gap:18px}.card{padding:22px;border:1px solid #8d6f5d;border-radius:20px;background:#251a3b;margin-bottom:16px}input,select{display:block;width:100%;padding:12px;box-sizing:border-box;border-radius:10px;background:#140e26;color:white;border:1px solid #987aa4;margin:8px 0 15px}button{border:0;border-radius:12px;padding:13px 18px;background:linear-gradient(90deg,#f3dea1,#bc8b3e);font-weight:800;cursor:pointer}small,p{color:#c5bad0;line-height:1.6}.hide{display:none}pre{overflow:auto;white-space:pre-wrap}</style>
<header><h1>♛ CUAN PARTY • Workspace</h1><small>Panel Owner • Coin Seller • Gift</small></header><main><section class="card" id="login"><h2>Masuk Google</h2><button id="signIn">Login Panel</button><button id="signOutAlt" class="hide" type="button">Keluar dari akun ini</button><p id="loginIssue" role="alert"></p><small>Gunakan browser Safari/Chrome biasa, jangan mode Private atau browser di dalam aplikasi. Jika sesi Google gagal, kembali ke panel lalu coba login lagi.</small><p id="serverStatus">Menghubungkan...</p></section>
<div id="dashboard" class="hide"><section class="card"><h2>Manajemen COIN</h2><p id="identity"></p><small>User tidak bisa melakukan top-up sendiri. Hanya owner yang bisa membuat coin baru. Seller hanya bisa kirim dari saldo miliknya.</small></section><div class="grid"><section class="card"><h2 id="sendTitle">💰 Kirim Coin</h2><p id="sendExplain">Owner mengirim Coin ke dompet pemain. Seller mengirim dari stok seller, bukan Coin pribadi.</p><form id="send"><label>ID akun penerima</label><input name="targetId" required placeholder="1000110"><label>Jumlah Coin</label><input type="number" name="amount" min="1" max="1000000000" required><button>Kirim Coin</button><p id="sendStatus" role="status" aria-live="polite" style="font-size:15px;font-weight:700;color:#f1d48c"></p></form></section><section class="card" id="sellerBox"><h2>🏪 Akun Coin Seller</h2><form id="seller"><label>ID akun Seller</label><input name="targetId" required placeholder="1000111"><label>Status</label><select name="active"><option value="true">Aktif</option><option value="false">Nonaktif</option></select><button>Simpan Seller</button><p id="sellerStatus" role="status" aria-live="polite"></p></form><button type="button" id="sellerSelf">👑 Aktifkan JEP sebagai Coin Seller</button><p id="selfStatus" role="status"></p><hr style="border:0;border-top:1px solid #725a59;margin:22px 0"><h3 style="color:#f1d48c">💰 Isi Saldo Stok Coin Seller</h3><p>Stok Coin Seller terpisah dari dompet pribadi. Seller boleh kirim ke dompetnya sendiri atau pemain lain.</p><form id="sellerFund"><label>ID akun seller</label><input name="targetId" required placeholder="ID akun JEP / seller lain"><label>Jumlah Coin stok</label><input type="number" name="amount" min="1" max="1000000000" required><button>Isi Stok Seller</button><p id="fundStatus" role="status"></p></form></section></div><section class="card"><h2>📃 Riwayat</h2><button id="refresh">Muat Ulang</button><pre id="history"></pre></section><section class="card"><h2>Keamanan</h2><p>🔒 Transaksi melalui server dan ID unik. Tidak ada pembayaran otomatis. Firestore Rules wajib memblokir perubahan coin dari sisi APK.</p><button id="signOut">Keluar</button></section><pre id="out"></pre></div></main>
<script type="module">import{initializeApp}from"https://www.gstatic.com/firebasejs/11.10.0/firebase-app.js";import{getAuth,GoogleAuthProvider,signInWithPopup,onAuthStateChanged,signOut}from"https://www.gstatic.com/firebasejs/11.10.0/firebase-auth.js";const q=x=>document.getElementById(x);const conf=await fetch("/api/config").then(r=>r.json());q("serverStatus").textContent=conf.ready?"Backend terhubung":"Firebase credential belum diaktifkan";const a=getAuth(initializeApp({apiKey:conf.apiKey,authDomain:"cuan-party.firebaseapp.com",projectId:"cuan-party"}));async function call(url,data){if(!a.currentUser)throw Error("Login dulu");const opt={headers:{Authorization:"Bearer "+await a.currentUser.getIdToken()}};if(data){opt.method="POST";opt.headers["Content-Type"]="application/json";opt.body=JSON.stringify(data)}const r=await fetch(url,opt);const j=await r.json();if(!r.ok)throw Error(j.error||"Gagal");return j};let role="user";q("signIn").onclick=async()=>{const area=q("loginIssue"),btn=q("signIn");area.textContent="";btn.disabled=true;try{await signInWithPopup(a,new GoogleAuthProvider())}catch(err){area.textContent="❌ Login Google gagal: "+(err.message||"Periksa browser")+". Bila Safari menampilkan missing initial state, kembali ke panel di tab yang sama dan coba lagi dari Safari biasa."}finally{btn.disabled=false}};q("signOut").onclick=()=>signOut(a);q("signOutAlt").onclick=()=>signOut(a);async function history(){try{q("history").textContent=JSON.stringify((await call("/api/history")).items,null,2)}catch(e){q("history").textContent=e.message}}q("refresh").onclick=history;onAuthStateChanged(a,async u=>{role="user";q("dashboard").classList.add("hide");q("login").classList.toggle("hide",!!u);q("signIn").classList.toggle("hide",!!u);q("signOutAlt").classList.toggle("hide",!u);if(!u){q("loginIssue").textContent="";return}try{const me=await call("/api/me");role=me.role;if(role!=="owner"&&role!=="seller"){q("login").classList.remove("hide");q("loginIssue").textContent="Akun ini bukan Owner / Coin Seller aktif. Hubungi OWNER untuk aktivasi seller berdasarkan ID akun.";return}q("login").classList.add("hide");q("dashboard").classList.remove("hide");q("identity").textContent=(u.displayName||"Akun")+" • "+role.toUpperCase();q("sellerBox").classList.toggle("hide",role!=="owner");q("sendTitle").textContent=role==="owner"?"👑 Owner • Isi Coin User":"🏪 Seller • Kirim Stok Coin";q("sendExplain").textContent=role==="owner"?"Coin diterbitkan Owner ke wallet penerima. Semua transaksi tercatat.":"Coin diambil dari stok Seller dan dikirim ke wallet penerima, bukan Coin pribadi.";history()}catch(e){q("login").classList.remove("hide");q("loginIssue").textContent="Gagal memeriksa hak akses panel: "+e.message}});q("send").onsubmit=async e=>{e.preventDefault();const d=Object.fromEntries(new FormData(e.target));d.amount=Number(d.amount);d.transactionId=crypto.randomUUID();const status=q("sendStatus"),btn=q("send").querySelector("button");if(!["owner","seller"].includes(role)){status.textContent="Akses ditolak";return}if(!/^[0-9]{6,13}$/.test(d.targetId)||!Number.isSafeInteger(d.amount)||d.amount<1||d.amount>1000000000){status.textContent="Periksa ID akun penerima dan nominal Coin";return}if(!confirm("Kirim "+d.amount.toLocaleString("id-ID")+" Coin ke ID "+d.targetId+"?"))return;btn.disabled=true;status.textContent="⏳ Memproses pengiriman...";try{const result=await call(role==="owner"?"/api/coin/issue":"/api/seller/send",d);status.textContent="✅ BERHASIL: "+Number(result.credited||d.amount).toLocaleString("id-ID")+" Coin ke ID "+d.targetId+(role==="seller"?" • Sisa stok Seller: "+Number(result.stockCoin).toLocaleString("id-ID"):"")+".";q("out").textContent=JSON.stringify(result,null,2);q("send").reset();history()}catch(err){status.textContent="❌ GAGAL: "+err.message;q("out").textContent=err.message}finally{btn.disabled=false}};q("seller").onsubmit=async e=>{e.preventDefault();if(role!=="owner"){q("sellerStatus").textContent="❌ Hanya OWNER boleh mengatur seller";return}const d=Object.fromEntries(new FormData(e.target));d.active=d.active==="true";const el=q("sellerStatus"),btn=q("seller").querySelector("button");el.textContent="⏳ Menyimpan status seller...";btn.disabled=true;try{const v=await call("/api/seller/set",d);const current=await call("/api/seller/check",{targetId:d.targetId});if(current.active!==d.active)throw Error("Status Seller belum sesuai. Periksa ulang sebelum mengisi stok.");el.textContent=(current.active?"✅ SELLER AKTIF":"✅ SELLER DINONAKTIFKAN")+" — "+(current.name||"Akun")+" • ID "+current.cuanId+" • Stok "+Number(current.stockCoin||0).toLocaleString("id-ID");q("out").textContent=JSON.stringify(v,null,2)}catch(err){el.textContent="❌ "+err.message;q("out").textContent=err.message}finally{btn.disabled=false}};
q("sellerSelf").onclick=async()=>{if(!confirm("Aktifkan akun JEP sebagai Coin Seller?"))return;const el=q("selfStatus");el.textContent="Memproses...";try{const result=await call("/api/seller/self",{});el.textContent="✅ JEP menjadi Coin Seller. CUAN ID: "+result.cuanId+" (masukkan ID ini ketika mengisi stok).";q("out").textContent=JSON.stringify(result,null,2)}catch(err){el.textContent="❌ "+err.message}};
q("sellerFund").onsubmit=async e=>{e.preventDefault();const d=Object.fromEntries(new FormData(e.target));d.amount=Number(d.amount);d.transactionId=crypto.randomUUID();if(!confirm("Isi STOK seller ID "+d.targetId+" sebanyak "+d.amount.toLocaleString("id-ID")+" Coin?"))return;const el=q("fundStatus"),btn=q("sellerFund").querySelector("button");btn.disabled=true;el.textContent="⏳ Memproses stok seller...";try{const v=await call("/api/seller/fund",d);el.textContent="✅ STOK SELLER TERISI: "+Number(v.credited).toLocaleString("id-ID")+" Coin → ID "+v.targetId+". Saldo stok: "+Number(v.stockCoin).toLocaleString("id-ID");q("out").textContent=JSON.stringify(v,null,2);history()}catch(err){el.textContent="❌ "+err.message}finally{btn.disabled=false}};</script></html>`;
Bun.serve({port:Number(Bun.env.PORT||3000),async fetch(req:Request){
 try{
  const url=new URL(req.url),p=url.pathname;
  if(req.method==="GET"&&p==="/")return new Response(HTML,{headers:{"Content-Type":"text/html; charset=utf-8","Cache-Control":"no-store","X-Frame-Options":"DENY","X-Content-Type-Options":"nosniff"}});
  if(req.method==="GET"&&p==="/health")return res({online:true,ready:!!db});
  if(req.method==="GET"&&p==="/api/config")return res({ready:!!db,apiKey:Bun.env.FIREBASE_WEB_API_KEY||"",sellerCenter:true});
  if(!p.startsWith("/api/")&&p!=="/gift/send")fail(404,"Tidak ditemukan");
  if(p==="/gift/send" && Bun.env.GIFT_WRITES_ENABLED!=="true")fail(503,"Pengiriman gift belum diaktifkan");
  const u=await user(req);
  if(req.method==="GET"&&p==="/api/me")return res({role:await role(u),ready:!!db});
  if(req.method==="GET"&&p==="/api/seller/me")return res(await sellerMe(u));
  if(req.method==="GET"&&p==="/api/seller/history")return res(await sellerStockHistory(u));
  if(req.method==="GET"&&p==="/api/wallet/history"){
    // Backend-only query. Never return another user's transaction ledger.
    const ledger=db.collection("users").doc(u.uid).collection("walletHistory");
    const [own,received,sent]=await Promise.all([
      ledger.orderBy("createdAt","desc").limit(75).get(),
      db.collection("economyTransactions").where("targetUid","==",u.uid).limit(100).get(),
      db.collection("economyTransactions").where("uid","==",u.uid).limit(100).get(),
    ]);
    const records=new Map<string,any>();
    const ms=(v:any)=>v&&typeof v.toMillis==="function"?v.toMillis():0;
    for(const doc of own.docs){
      const d=doc.data(),amount=d.amount;
      if(!Number.isSafeInteger(amount)||amount<1)continue;
      records.set(doc.id,{id:doc.id,type:d.type,direction:d.direction,currency:d.currency==="diamond"?"diamond":"coin",amount,createdAt:ms(d.createdAt)});
    }
    // Legacy entries created before per-user walletHistory was deployed.
    for(const doc of [...received.docs,...sent.docs]){
      if(records.has(doc.id))continue;
      const d=doc.data(),incoming=d.targetUid===u.uid;
      if(!incoming&&d.uid!==u.uid)continue;
      const amount=d.type==="roomGift"?d.total:d.amount;
      if(!["ownerIssue","sellerTransfer","sellerStockSend","roomGift"].includes(d.type)||!Number.isSafeInteger(amount)||amount<1)continue;
      // Coin issuance is not a debit from the owner. Only the recipient sees it as a top up.
      if(d.type==="ownerIssue"&&!incoming)continue;
      records.set(doc.id,{id:doc.id,type:d.type,direction:incoming?"in":"out",currency:"coin",amount,createdAt:ms(d.createdAt)});
    }
    return res({items:[...records.values()].sort((a,b)=>b.createdAt-a.createdAt).slice(0,50)});
  }
  if(req.method==="GET"&&p==="/api/history"){
   const r=await role(u);if(r==="user")fail(403,"Hanya owner dan seller");
   const docs=await db.collection("economyTransactions").orderBy("createdAt","desc").limit(75).get();
   const list=docs.docs.map((x:any)=>({id:x.id,...x.data()})).filter((x:any)=>r==="owner"||x.uid===u.uid).slice(0,25);
   return res({items:list.map((x:any)=>({type:x.type,amount:x.amount,total:x.total,targetCuanId:x.targetCuanId,roomId:x.roomId}))});
  }
  if(req.method!=="POST")fail(405,"Metode tidak didukung");
  if(!db || Bun.env.COIN_WRITES_ENABLED!=="true")fail(503,"Fungsi saldo terkunci sampai Firestore Rules aman dan server siap");
  const text=await req.text();if(text.length>8192)fail(413,"Terlalu besar");
  let b:any;try{b=JSON.parse(text)}catch{fail(400,"JSON tidak valid")}
  if(p==="/api/coin/issue")return res(await issue(u,b));
  if(p==="/api/seller/set")return res(await seller(u,b));
  if(p==="/api/seller/check")return res(await sellerCheck(u,b.targetId));
  if(p==="/api/seller/self")return res(await sellerSelf(u));
  if(p==="/api/seller/fund")return res(await sellerFund(u,b));
  if(p==="/api/seller/send")return res(await sellerStockSend(u,b));
  if(p==="/api/coin/transfer")return res(await transfer(u,b));
  if(p==="/api/diamond/exchange")return res(await exchangeDiamond(u,b));
  if(p==="/gift/send")return res(await gift(u,b));
  fail(404,"Endpoint tidak ditemukan");
 }catch(e:any){if(!(e instanceof E))console.error("request error",e?.name||"unknown");return res({error:e instanceof E?e.message:"Server gagal memproses permintaan"},e instanceof E?e.status:500)}
}});
