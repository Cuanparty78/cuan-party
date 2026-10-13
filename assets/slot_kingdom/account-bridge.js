'use strict';
const AccountBridge=(()=>{
 const pending=new Map();let serial=0;
 window.slotKingdomReply=reply=>{const p=pending.get(reply.id);if(!p)return;pending.delete(reply.id);clearTimeout(p.timer);reply.ok?p.resolve(reply.data):p.reject(Object.assign(new Error(reply.error||'Tidak dapat terhubung ke server.'),{code:reply.code}));};
 function request(method,data={}){return new Promise((resolve,reject)=>{const id=String(++serial);const timer=setTimeout(()=>{pending.delete(id);reject(new Error('Koneksi terputus. Buka kembali game untuk melanjutkan.'));},60000);pending.set(id,{resolve,reject,timer});try{SlotKingdomHost.postMessage(JSON.stringify({type:'slotKingdom.request',id,method,data}));}catch(error){clearTimeout(timer);pending.delete(id);reject(error);}});}
 const transactionId=()=>crypto.randomUUID();
 return {request,transactionId};
})();
