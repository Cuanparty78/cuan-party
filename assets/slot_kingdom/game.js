'use strict';
const $=id=>document.getElementById(id),fmt=n=>n.toLocaleString('id-ID',{maximumFractionDigits:2}),bets=[50,100,250,500,1000,2500,10000,25000,50000,100000,250000,500000,1000000,2500000,5000000,10000000];let balance=0,betIndex=1,board,busy=true,auto=0,speed=1,free=0,freeBet=0,freeTotal=0,freeCap=0,totalBet=0,goldBank=GoldBank.create(Date.now()),spinLog=SpinHistory.restore();
const ART=[[62,132,340,340],[416,132,344,340],[779,132,340,340],[1139,129,342,342],[168,490,251,215],[481,490,250,215],[792,490,250,215],[1119,490,250,215],[367,707,388,305],[769,705,400,307]];
const reduced=matchMedia('(prefers-reduced-motion: reduce)').matches;
try{speed=ReelMotion.validSpeed(localStorage.getItem('cuanKingdomSpeed'));}catch{}
let accountUid='',serverOffset=0;
const serverTime=()=>Date.now()+serverOffset;
function save(){} // Account data is written only by authenticated server callables.
function saveBank(){}
function applyAccount(result){
 const st=result.state;balance=result.balance;free=st.free;freeBet=st.freeBet;freeTotal=st.freeTotal;freeCap=st.freeCap;totalBet=st.totalBet;goldBank=st.goldBank;serverOffset=result.serverNow-Date.now();accountUid=result.uid;
 spinLog=SpinHistory.restore({count:st.count,rows:result.rows||spinLog.rows});
 if(result.row)spinLog=SpinHistory.restore({count:st.count,rows:[result.row,...spinLog.rows]});
}
const pendingKey=()=> 'slotKingdomPending:'+accountUid;
function pendingSpin(){try{return JSON.parse(localStorage.getItem(pendingKey()));}catch{return null;}}
async function syncAccount(){applyAccount(await AccountBridge.request('state'));render();}
const bankDate=n=>new Intl.DateTimeFormat('id-ID',{timeZone:'Asia/Jakarta',day:'numeric',month:'short',hour:'2-digit',minute:'2-digit',hourCycle:'h23'}).format(n)+' WIB';
function refreshBank(){const now=serverTime(),prior=JSON.stringify(goldBank);GoldBank.reconcile(goldBank,now);if(prior!==JSON.stringify(goldBank))saveBank();const reward=GoldBank.available(goldBank,now);$('piggyBalance').textContent=fmt(goldBank.contribution);$('piggy').classList.toggle('claim-ready',reward>0);$('piggy').setAttribute('aria-label',reward>0?'Gold Bank: reward siap diklaim':'Lihat Gold Bank');$('piggyTotal').textContent=fmt(goldBank.contribution);$('bankNextReset').textContent=bankDate(goldBank.periodStart+GoldBank.DAY);$('bankReward').textContent=fmt(goldBank.reward?.amount||0);$('claimBank').disabled=busy||auto>0||reward<=0;$('claimBank').textContent=goldBank.reward?.status==='claimed'?'SUDAH DIKLAIM':'KLAIM KOIN';$('bankClaimStatus').textContent=reward>0?'Reward tersedia. Klaim sebelum batas waktu.':goldBank.reward?.status==='claimed'?'Reward sudah masuk ke saldo koin.':'Belum ada reward. Tabungan hari ini tersedia pukul 23.00 WIB.';if(reward>0){const seconds=Math.max(0,Math.ceil((goldBank.reward.expiresAt-now)/1000)),h=Math.floor(seconds/3600),m=Math.floor(seconds%3600/60),sec=seconds%60;$('bankExpiry').textContent='Hangus: '+bankDate(goldBank.reward.expiresAt)+' · '+h+'j '+m+'m '+sec+'d';}else $('bankExpiry').textContent='';}

function createCell(x,c,r,highlight=new Set()){const cell=document.createElement('div');cell.className='cell'+(x.gold?' gold':'')+(highlight.has(c+':'+r)?' win':'');cell.dataset.pos=c+':'+r;const [ax,ay,aw,ah]=ART[x.s],art=document.createElement('span');art.className='symbol-art';art.setAttribute('role','img');art.setAttribute('aria-label',['King','Queen','Knight','Dragon','A','K','Q','J','Wild','Scatter'][x.s]);art.style.backgroundSize=(1536/aw*100)+'% '+(1024/ah*100)+'%';art.style.backgroundPosition=(ax/(1536-aw)*100)+'% '+(ay/(1024-ah)*100)+'%';cell.append(art);return cell;}
function createReel(col,c,highlight=new Set()){const reel=document.createElement('div'),track=document.createElement('div');reel.className='reel';reel.style.height='calc(var(--symbol-size,34px) * '+col.length+' + 4px)';track.className='reel-track';col.forEach((x,r)=>track.append(createCell(x,c,r,highlight)));reel.append(track);return {reel,track};}
function paint(highlight=new Set()){const box=$('board');box.replaceChildren();board.forEach((col,c)=>box.append(createReel(col,c,highlight).reel));}
async function animateTrack(track,frames,ms){
 if(typeof track.animate==='function'){const animation=track.animate(frames,{duration:ms,fill:'forwards'});try{await animation.finished;}catch{}animation.cancel();}
 else{track.style.transform=frames[0].transform;void track.offsetHeight;track.style.transition='transform '+ms+'ms cubic-bezier(.15,.5,.15,1)';track.style.transform=frames.at(-1).transform;await new Promise(resolve=>setTimeout(resolve,ms));track.style.transition='';}
}
async function rollReels(previous,result,spinSpeed){
 const box=$('board');box.style.setProperty('--cell-transition',ReelMotion.duration(240,spinSpeed,reduced)+'ms');box.replaceChildren();const size=parseFloat(getComputedStyle(box).getPropertyValue('--symbol-size'))||34,tasks=[];box.setAttribute('aria-busy','true');
 result.forEach((col,c)=>{const {reel,track}=createReel(col,c),strip=ReelMotion.strip(previous[c],col,c);track.replaceChildren();strip.cells.forEach((x,r)=>track.append(createCell(x,c,r)));reel.classList.add('spinning');box.append(reel);
 const start=-strip.startRow*size,end=-strip.endRow*size;track.style.transform='translate3d(0,'+start+'px,0)';
 tasks.push(animateTrack(track,ReelMotion.keyframes(start,end),ReelMotion.duration(1250+c*170,spinSpeed,reduced)).then(()=>{track.replaceChildren();col.forEach((x,r)=>track.append(createCell(x,c,r)));track.style.transform='';reel.classList.remove('spinning');beep(420+c*45,.035);}));});
 await Promise.all(tasks);box.setAttribute('aria-busy','false');
}
async function dropSymbols(previous,result,positions,spinSpeed){
 board=result;paint();if(reduced)return;const box=$('board'),size=parseFloat(getComputedStyle(box).getPropertyValue('--symbol-size'))||34,tasks=[];
 Array.from(box.children).forEach((reel,c)=>{const track=reel.firstElementChild;let oldRow=0,remaining=[];previous[c].forEach((x,r)=>{if(!positions.has(c+':'+r)||x.gold)remaining.push(r);});const added=result[c].length-remaining.length;
 Array.from(track.children).forEach((cell,r)=>{const distance=r<added?added:Math.max(0,r-remaining[oldRow++]);if(distance>0)tasks.push(animateTrack(cell,[{transform:'translate3d(0,'+(-distance*size)+'px,0)',opacity:r<added?0:1},{transform:'translate3d(0,0,0)',opacity:1}],ReelMotion.duration(380,spinSpeed)));});});
 await Promise.all(tasks);
}

function render(){ refreshBank();renderHistory(); $('balance').textContent=fmt(balance);$('bet').textContent=fmt(free?freeBet:bets[betIndex]);$('betSelect').disabled=busy||auto>0||free>0;$('addCoins').disabled=busy||auto>0;$('betSelect').value=String(betIndex);$('spin').disabled=busy||auto>0||(!free&&balance<bets[betIndex]);$('minus').disabled=busy||auto>0||free>0||betIndex===0;$('plus').disabled=busy||auto>0||free>0||betIndex===bets.length-1;$('auto').innerHTML=auto>0?'STOP<small>'+(auto===Infinity?'TANPA BATAS':auto+' TERSISA')+'</small>':'AUTO<small>PILIH PUTARAN</small>';$('auto').classList.toggle('active',auto>0);$('speedSelect').value=String(speed);$('speedSelect').disabled=busy;$('free').textContent=free?'FREE SPIN · '+free+' TERSISA':'MODE NORMAL';}
function multiplier(n){const powers=Array.from({length:11},(_,i)=>2**i),at=powers.indexOf(n),index=at<0?0:at,pick=offset=>'×'+powers[(index+offset+11)%11];$('mult').textContent='×'+n;$('previous').textContent=pick(-2)+'　'+pick(-1);$('next').textContent=pick(1)+'　'+pick(2);}

const historyDay=n=>new Intl.DateTimeFormat('id-ID',{timeZone:'Asia/Jakarta',day:'2-digit',month:'short',year:'numeric'}).format(n),historyTime=n=>new Intl.DateTimeFormat('id-ID',{timeZone:'Asia/Jakarta',hour:'2-digit',minute:'2-digit',second:'2-digit',hourCycle:'h23'}).format(n);
function renderHistory(){
 $('spinNumber').textContent='No.'+String(spinLog.count).padStart(6,'0');
 if(!$('historyDialog').open)return;
 $('historySummary').textContent=spinLog.rows.length+' putaran terbaru · Total '+fmt(spinLog.count)+' spin';$('historyEmpty').hidden=spinLog.rows.length>0;
 $('historyRows').innerHTML=spinLog.rows.map(r=>'<tr><td><b>No.'+r.id+'</b><span>'+historyDay(r.at)+'</span><span>'+historyTime(r.at)+'</span></td><td>'+fmt(r.isFree?0:r.bet)+(r.isFree?'<small>FREE SPIN · Bet '+fmt(r.bet)+'</small>':'')+'</td><td class="'+(r.win?'history-win':'')+'">'+fmt(r.win)+'</td></tr>').join('');
}
$('history').onclick=()=>{$('historyDialog').showModal();renderHistory();};$('closeHistory').onclick=()=>$('historyDialog').close();

function beep(f=500,d=.06){RoyalAudio.effect(f,d);}
function renderAudio(){const settings=RoyalAudio.settings;for(const key of ['music','voice','effects'])$('audio'+key[0].toUpperCase()+key.slice(1)).checked=settings[key];$('audioVolume').value=Math.round(settings.volume*100);$('sound').classList.toggle('active',settings.music||settings.voice||settings.effects);$('sound').setAttribute('aria-label','Pengaturan musik dan suara');}
$('sound').onclick=()=>{RoyalAudio.unlock();renderAudio();$('audioDialog').showModal();};$('closeAudio').onclick=()=>{RoyalAudio.endWin();$('audioDialog').close();};$('audioDialog').addEventListener?.('close',()=>RoyalAudio.endWin());for(const key of ['music','voice','effects'])$('audio'+key[0].toUpperCase()+key.slice(1)).onchange=e=>{RoyalAudio.configure({[key]:e.target.checked});RoyalAudio.unlock();renderAudio();};$('audioVolume').oninput=e=>RoyalAudio.configure({volume:Number(e.target.value)/100});
document.addEventListener('pointerdown',()=>RoyalAudio.unlock(),{once:true});document.addEventListener('keydown',()=>RoyalAudio.unlock(),{once:true});renderAudio();

let finishWin=null;
async function celebrateWin(amount,bet,spinSpeed){
 const tier=WinFX.level(amount,bet);if(!tier)return;if(document.hidden||$('gamePanel').hidden)return;
 const overlay=$('winCelebration'),voiceTime=RoyalAudio.win(tier.id),duration=Math.max(WinFX.duration(tier,spinSpeed,reduced),voiceTime);overlay.className='win-celebration tier-'+tier.id;overlay.style.setProperty('--win-time',duration+'ms');overlay.hidden=false;
 $('winTitle').textContent=tier.title;$('winTitle').setAttribute('data-text',tier.title);$('winSuffix').textContent=tier.suffix;$('winSuffix').setAttribute('data-text',tier.suffix);$('winSuffix').hidden=!tier.suffix;
 $('winAnnouncement').textContent=tier.title+' '+tier.suffix+'! '+fmt(amount)+' koin.';$('winAmount').textContent=reduced?fmt(amount):'0';$('stopWinAuto').hidden=auto<=0;$('winCoins').replaceChildren();
 if(!reduced)for(let i=0;i<tier.coins;i++){const coin=document.createElement('span');coin.className='win-coin';coin.textContent='';coin.style.setProperty('--x',((i*37+9)%101)+'%');coin.style.setProperty('--drift',((i%2?1:-1)*(15+i%5*8))+'px');coin.style.setProperty('--turn',(i%2?540:-540)+'deg');coin.style.setProperty('--fall',Math.max(700,duration*(.5+(i%5)*.08))+'ms');coin.style.setProperty('--wait',(-(i%7)*duration/9)+'ms');coin.style.setProperty('--size',(18+i%4*7)+'px');$('winCoins').append(coin);}
 if(!reduced)for(let i=0;i<14;i++){const star=document.createElement('span');star.className='win-spark';star.textContent='✦';star.style.setProperty('--spark-x',((i*47)%240-120)+'px');star.style.setProperty('--spark-y',((i*79)%260-130)+'px');star.style.setProperty('--spark-wait',(i%5*.13)+'s');$('winCoins').append(star);}

 let frame=0,timer=0;const began=performance.now(),countDuration=duration*.72;
 await new Promise(resolve=>{let done=false;finishWin=()=>{if(done)return;done=true;cancelAnimationFrame(frame);clearTimeout(timer);RoyalAudio.endWin();$('winAmount').textContent=fmt(amount);overlay.hidden=true;$('winCoins').replaceChildren();finishWin=null;resolve();};
 const tick=now=>{if(done)return;$('winAmount').textContent=fmt(WinFX.amountAt(amount,(now-began)/countDuration));if(now-began<countDuration)frame=requestAnimationFrame(tick);};
 if(!reduced)frame=requestAnimationFrame(tick);timer=setTimeout(()=>finishWin?.(),duration);});
}
$('continueWin').onclick=()=>finishWin?.();$('stopWinAuto').onclick=()=>{auto=0;render();finishWin?.();};
const delay=(t,atSpeed=speed)=>new Promise(r=>setTimeout(r,ReelMotion.duration(t,atSpeed,reduced)));
async function spin(){
 if(busy)return;busy=true;const previousBoard=board,spinSpeed=speed;
 let outcome;
 try{
  const data=pendingSpin()||{transactionId:AccountBridge.transactionId(),bet:bets[betIndex],expectedCount:spinLog.count};
  localStorage.setItem(pendingKey(),JSON.stringify(data));
  outcome=await AccountBridge.request('spin',data);localStorage.removeItem(pendingKey());
 }catch(error){if(['invalid-argument','failed-precondition','resource-exhausted','unauthenticated'].includes(error.code))localStorage.removeItem(pendingKey());auto=0;busy=false;$('message').textContent=error.message;try{await syncAccount();}catch{}render();return;}
 const isFree=outcome.row.isFree,bet=outcome.row.bet,startingBalance=balance,plan=outcome.plan;
 plan.frames.forEach(frame=>frame.positions=new Set(frame.positions));
 applyAccount(outcome);
 const finalBalance=balance,finalFree=free,finalFreeBet=freeBet,finalFreeTotal=freeTotal,finalFreeCap=freeCap;
 multiplier(isFree?8:1,isFree);$('last').textContent='0';$('message').textContent=isFree?'FREE SPIN · Pengali awal ×8':'Gulungan berputar…';render();await rollReels(previousBoard,plan.initial,spinSpeed);board=plan.initial;paint();
for(const frame of plan.frames){board=frame.board;paint(frame.positions);balance=Math.round((startingBalance-(isFree?0:bet)+frame.total)*100)/100;$('balance').textContent=fmt(balance);$('last').textContent=fmt(frame.total);$('message').textContent='COMBO ×'+frame.mult+' · +'+fmt(frame.credited)+' KOIN';beep(620+Math.log2(frame.mult)*50,.16);await delay(650,spinSpeed);if(frame.nextBoard){document.querySelectorAll('.cell.win:not(.gold)').forEach(x=>x.classList.add('gone'));await delay(240,spinSpeed);multiplier(frame.nextMult,isFree);await dropSymbols(frame.board,frame.nextBoard,frame.positions,spinSpeed);await delay(150,spinSpeed);}}
balance=finalBalance;free=finalFree;freeBet=finalFreeBet;freeTotal=finalFreeTotal;freeCap=finalFreeCap;board=plan.board;$('last').textContent=fmt(plan.total);if(plan.capped){auto=0;$('message').textContent='PUTARAN SELESAI · Total hadiah sudah masuk ke saldo.';}else if(plan.award){$('message').textContent=board.flat().filter(x=>x.s===SCATTER).length+' SCATTER! +'+plan.award+' FREE SPIN';}else if(isFree&&!free){$('message').textContent='FREE GAME SELESAI · '+fmt(freeTotal)+' KOIN ';}else $('message').textContent=plan.total?'TOTAL MENANG · '+fmt(plan.total)+' KOIN ':'Belum ada kombinasi. Putar lagi!';save();render();await celebrateWin(plan.total,bet,spinSpeed);try{await syncAccount();}catch{auto=0;}busy=false;resizeBoard();if(auto>0&&auto!==Infinity)auto--;render();if(auto>0){await delay(750);if(auto>0)spin();}}
$('spin').onclick=()=>{RoyalAudio.unlock();spin();};$('minus').onclick=()=>{if(busy||auto||free)return;betIndex=Math.max(0,betIndex-1);save();render();};$('plus').onclick=()=>{if(busy||auto||free)return;betIndex=Math.min(bets.length-1,betIndex+1);save();render();};$('auto').onclick=()=>{if(auto){auto=0;render();return;}if(busy)return;$('autoDialog').showModal();};$('closeAuto').onclick=()=>$('autoDialog').close();document.querySelectorAll('[data-rounds]').forEach(button=>{button.onclick=()=>{if(busy||auto)return;const rounds=button.dataset.rounds==='infinite'?Infinity:Number(button.dataset.rounds);if(![7,77,777,7777,Infinity].includes(rounds))return;RoyalAudio.unlock();$('autoDialog').close();auto=rounds;render();spin();};});$('speedSelect').onchange=()=>{if(busy){$('speedSelect').value=String(speed);return;}speed=ReelMotion.validSpeed($('speedSelect').value);try{localStorage.setItem('cuanKingdomSpeed',String(speed));}catch{}render();};$('info').onclick=()=>$('rules').showModal();$('close').onclick=()=>$('rules').close();$('piggy').onclick=()=>{refreshBank();$('piggyDialog').showModal();};$('claimBank').onclick=async()=>{if(busy||auto)return;busy=true;render();try{let id=localStorage.getItem('slotKingdomClaim:'+accountUid);if(!id){id=AccountBridge.transactionId();localStorage.setItem('slotKingdomClaim:'+accountUid,id);}const result=await AccountBridge.request('claim',{transactionId:id});localStorage.removeItem('slotKingdomClaim:'+accountUid);applyAccount(result);await syncAccount();$('message').textContent='Gold Bank diklaim · +'+fmt(result.amount)+' KOIN';}catch(error){if(['invalid-argument','failed-precondition','unauthenticated'].includes(error.code))localStorage.removeItem('slotKingdomClaim:'+accountUid);$('message').textContent=error.message;try{await syncAccount();}catch{}}finally{busy=false;render();}};$('closePiggy').onclick=()=>$('piggyDialog').close();document.addEventListener('visibilitychange',()=>{if(document.hidden){auto=0;finishWin?.();RoyalAudio.pause();render();}});
const names=['King','Queen','Knight','Dragon','A','K','Q','J'];
function paytableCards(){return '<div class="paytable-grid">'+PAY.map((pay,s)=>{const [ax,ay,aw,ah]=ART[s];const image='<span class="pay-symbol symbol-art" role="img" aria-label="'+names[s]+'" style="background-size:'+(1536/aw*100)+'% '+(1024/ah*100)+'%;background-position:'+(ax/(1536-aw)*100)+'% '+(ay/(1024-ah)*100)+'%"></span>';return '<article class="pay-card">'+image+'<h4>'+names[s]+'</h4><dl>'+[6,5,4,3].map(count=>'<div><dt>'+count+' simbol</dt><dd>×'+Number((pay[count-3]*CONFIG.payScale).toFixed(8))+'</dd></div>').join('')+'</dl></article>';}).join('')+'</div>';}
$('rulebody').innerHTML='<h3>1. Tabel hadiah</h3>'+paytableCards()+'<p class="paytable-note">Nilai di atas berlaku untuk satu kombinasi, sebelum pengali combo. Hadiah = taruhan × nilai simbol × jumlah ways yang menang × pengali combo.</p><h3>2. Wild & bingkai emas</h3><p>Wild menggantikan semua simbol kecuali Scatter. Bingkai emas muncul pada simbol biasa di gulungan 3 dan 4. Jika simbol emas menang, simbol itu menjadi Wild pada cascade berikutnya.</p><h3>3. Cascade & combo</h3><p>Simbol pemenang dihapus, simbol di atasnya jatuh dan ruang kosong diisi simbol baru. Pengali normal dimulai ×1 dan berlipat setelah setiap kemenangan hingga ×1.024. Spin normal baru kembali ke ×1.</p><h3>4. Free spin</h3><p>3 Scatter di posisi mana pun pada papan akhir memberi 10 free spin. Setiap Scatter tambahan memberi 2 putaran lagi. Scatter juga dapat menambah putaran saat free game. Free spin dimulai dengan pengali ×8, lalu combo dapat naik hingga ×1.024, dan tidak memotong saldo. Taruhan mengikuti nilai saat bonus dimulai.</p><h3>5. Kombinasi kemenangan</h3><p>6 gulungan dengan susunan 3–4–5–5–4–3 menghasilkan 3.600 ways. Minimal 3 gulungan berurutan dari kiri harus memuat simbol yang cocok. Simbol tidak perlu berada pada baris yang sama. Jumlah ways dihitung dengan mengalikan jumlah simbol cocok pada setiap gulungan tersebut.</p><h3>6. Gold Bank</h3><p>1% dari setiap taruhan berbayar masuk ke tabungan harian. Pukul 23.00 WIB tabungan menjadi reward yang bisa diklaim selama 24 jam. Reward yang tidak diklaim sampai batas waktunya hangus. Kemenangan dan free spin tidak menambah Gold Bank.</p><h3>7. Putaran otomatis</h3><p>Pilih 7, 77, 777, 7777 putaran atau otomatis tanpa batas. Tekan Stop untuk berhenti setelah putaran yang berjalan selesai. Auto juga berhenti ketika saldo tidak cukup, putaran mencapai batas permainan, halaman disembunyikan, atau game ditutup.</p>';

board=makeBoard();paint();multiplier(1);render();

$('hideGame').onclick=()=>{auto=0;finishWin?.();RoyalAudio.pause();SlotKingdomHost.postMessage(JSON.stringify({type:'slotKingdom.close'}));};$('openGame').onclick=()=>{RoyalAudio.unlock();$('gamePanel').hidden=false;$('openGame').hidden=true;};$('expand').onclick=()=>{document.body.classList.toggle('expanded');$('expand').setAttribute('aria-label',document.body.classList.contains('expanded')?'Kecilkan game':'Perbesar game');};

$('betSelect').innerHTML=bets.map((n,i)=>'<option value="'+i+'">'+fmt(n)+'</option>').join('');$('betSelect').value=String(betIndex);$('betSelect').onchange=()=>{if(busy||auto||free)return;betIndex=Number($('betSelect').value);save();render();};const wallet=WalletBridge.create(window);$('addCoins').onclick=()=>{if(busy||auto)return;if(!wallet.open())$('walletDialog').showModal();};$('closeWallet').onclick=()=>$('walletDialog').close();
function resizeBoard(){if(busy)return;const el=$('board');if(!el.clientHeight||!el.clientWidth)return;const size=Math.max(12,Math.floor(Math.min((el.clientHeight-10)/5-1,(el.clientWidth-25)/6)));el.style.setProperty('--symbol-size',size+'px');}
new ResizeObserver(resizeBoard).observe($('board'));window.addEventListener('resize',resizeBoard);resizeBoard();render();

if(free){$('message').textContent='Bonus dilanjutkan · '+free+' free spin tersisa';}if(new URLSearchParams(location.search).get('embed')==='1'){document.body.classList.add('embedded','expanded');$('expand').hidden=true;}

// Reconcile elapsed days on reopen, even if the page was closed at 23:00 WIB.
save();refreshBank();setInterval(refreshBank,1000);window.addEventListener('focus',refreshBank);document.addEventListener('visibilitychange',()=>{if(!document.hidden)refreshBank();});

async function loadAccount(){
 try{await syncAccount();const data=pendingSpin();if(data){const result=await AccountBridge.request('spin',data);localStorage.removeItem(pendingKey());applyAccount(result);board=result.plan.board;paint();$('last').textContent=fmt(result.row.win);await syncAccount();}
 busy=false;$('message').textContent=free?'Bonus dilanjutkan · '+free+' free spin tersisa':'Kumpulkan 3 SCATTER untuk 10 free spin';render();
 }catch(error){if(['invalid-argument','failed-precondition','resource-exhausted'].includes(error.code)){localStorage.removeItem(pendingKey());busy=false;}else busy=true;$('message').textContent=error.message;render();}
}
window.slotKingdomResume=()=>{if(!busy){auto=0;loadAccount();}};
loadAccount();
