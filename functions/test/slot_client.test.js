'use strict';
const test=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),vm=require('node:vm'),path=require('node:path');
const root=path.resolve(__dirname,'../../assets/slot_kingdom');
const Engine=require('../slot_engine'),GoldBank=require('../slot_gold_bank');
const ReelMotion=require(path.join(root,'reel-motion')),WinFX=require(path.join(root,'win-fx')),SpinHistory=require(path.join(root,'spin-history')),WalletBridge=require(path.join(root,'wallet-bridge'));
const html=fs.readFileSync(path.join(root,'index.html'),'utf8');
function harness(remote,storage=new Map()){
 const waits=[];let timer=0;const cancelled=new Set();
 function element(){return {textContent:'',innerHTML:'',disabled:false,hidden:false,children:[],dataset:{},classList:{add(){},remove(){},toggle(){}},style:{setProperty(){}},setAttribute(){},replaceChildren(){this.children=[]},append(x){this.children.push(x)},get firstElementChild(){return this.children[0]},showModal(){this.open=true},close(){this.open=false},clientHeight:300,clientWidth:360,animate(){return {finished:new Promise(r=>waits.push(r)),cancel(){}}}};}
 const elements=new Map([...html.matchAll(/id="([^"]+)"/g)].map(([,id])=>[id,element()]));
 const channel=[];const window={addEventListener(){},SlotKingdomHost:{postMessage:m=>channel.push(JSON.parse(m))}};
 const schedule=fn=>{const id=++timer;waits.push(()=>{if(!cancelled.has(id))fn()});return id;};
 const context=vm.createContext({...Engine,GoldBank,ReelMotion,WinFX,SpinHistory,WalletBridge,AccountBridge:{request:remote,transactionId:()=>require('node:crypto').randomUUID()},SlotKingdomHost:{postMessage:m=>channel.push(JSON.parse(m))},RoyalAudio:{settings:{music:true,voice:true,effects:true,volume:.45},effect(){},unlock(){},win(){return 0},endWin(){},pause(){},configure(){}},performance:{now:()=>0},requestAnimationFrame:schedule,cancelAnimationFrame:id=>cancelled.add(id),clearTimeout:id=>cancelled.add(id),getComputedStyle:()=>({getPropertyValue:()=>34}),Intl,URLSearchParams,Date,location:{search:''},matchMedia:()=>({matches:true}),localStorage:{getItem:k=>storage.get(k)||null,setItem:(k,v)=>storage.set(k,v),removeItem:k=>storage.delete(k)},setTimeout:schedule,setInterval(){},ResizeObserver:class{observe(){}},window,document:{getElementById:id=>{assert(elements.has(id),id);return elements.get(id)},querySelectorAll:()=>[],createElement:element,addEventListener(){},body:{classList:{contains:()=>true,toggle(){},add(){}}}},makeBoard:()=>Engine.HEIGHTS.map(n=>Array.from({length:n},()=>({s:0,gold:false}))) });
 vm.runInContext(fs.readFileSync(path.join(root,'game.js'),'utf8'),context);
 async function pump(){for(let i=0;i<500;i++){if(waits.length)waits.shift()();for(let j=0;j<12;j++)await Promise.resolve();if(!vm.runInContext('busy||auto>0',context)&&!waits.length)return;}throw Error('UI stuck');}
 return {context,elements,storage,pump,channel};
}
test('account UI ignores standalone wallet; lost response recovers without a second charge',async()=>{
 let count=0,balance=10000,lost=true;const receipts=new Map(),rows=[];
 const state=()=>({uid:'alice',balance,serverNow:Date.now(),state:{count,free:0,freeBet:0,freeTotal:0,freeCap:0,totalBet:count*100,goldBank:GoldBank.create(Date.now())},rows:[...rows]});
 const remote=async(method,data)=>{if(method==='state')return state();if(receipts.has(data.transactionId))return structuredClone(receipts.get(data.transactionId));assert.equal(data.expectedCount,count);count++;balance-=90;const board=Engine.HEIGHTS.map(n=>Array.from({length:n},()=>({s:0,gold:false})));const row={id:count,at:Date.now(),bet:100,win:10,isFree:false};rows.unshift(row);const result={...state(),row,plan:{initial:board,board,frames:[],total:10,award:0,capped:false}};receipts.set(data.transactionId,result);if(lost){lost=false;throw Error('response lost');}return structuredClone(result);};
 const storage=new Map([['cuanKingdomBankV3',JSON.stringify({balance:999999999,spinLog:{count:999,rows:[]}})]]);
 const ui=harness(remote,storage);await ui.pump();assert.equal(ui.elements.get('balance').textContent,'10.000');assert.equal(ui.elements.get('spinNumber').textContent,'No.000000');
 ui.elements.get('spin').onclick();await ui.pump();assert.equal(count,1);assert.equal(balance,9910);assert(storage.has('slotKingdomPending:alice'));
 const reopen=harness(remote,storage);await reopen.pump();assert.equal(count,1);assert.equal(balance,9910);assert.equal(reopen.elements.get('spinNumber').textContent,'No.000001');assert(!storage.has('slotKingdomPending:alice'));
 reopen.elements.get('spin').onclick();await reopen.pump();assert.equal(count,2);assert.equal(balance,9820);assert.equal(reopen.elements.get('spinNumber').textContent,'No.000002');
 reopen.elements.get('addCoins').onclick();assert.equal(reopen.channel.at(-1).type,'slotKingdom.openWallet');assert.equal(balance,9820);
});
test('bridge matches response IDs and preserves terminal error codes',async()=>{
 const messages=[],timers=[];const window={};const c=vm.createContext({window,SlotKingdomHost:{postMessage:m=>messages.push(JSON.parse(m))},crypto:{randomUUID:()=> 'id-12345678'},setTimeout:f=>{timers.push(f);return timers.length;},clearTimeout(){},Map,Error});
 vm.runInContext(fs.readFileSync(path.join(root,'account-bridge.js'),'utf8'),c);
 const first=vm.runInContext("AccountBridge.request('state')",c);window.slotKingdomReply({id:messages[0].id,ok:true,data:{uid:'alice'}});assert.equal((await first).uid,'alice');
 const second=vm.runInContext("AccountBridge.request('spin')",c);window.slotKingdomReply({id:messages[1].id,ok:false,error:'Saldo kurang',code:'resource-exhausted'});await assert.rejects(()=>second,e=>e.code==='resource-exhausted');
});
