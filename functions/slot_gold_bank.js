(function(root){
  'use strict';
  const DAY=86400000,ANCHOR=16*3600000; // 23:00 Asia/Jakarta, UTC+7.
  const round=n=>Math.round(n*100)/100;
  const period=now=>Math.floor((now-ANCHOR)/DAY)*DAY+ANCHOR;
  function create(now,amount=0){return {periodStart:period(now),contribution:round(Math.max(0,amount)),reward:null};}
  function restore(value,now,legacy=0){
    if(!value||!Number.isFinite(value.periodStart)||value.periodStart!==period(value.periodStart)||value.periodStart>period(now)||!Number.isFinite(value.contribution)||value.contribution<0)return create(now,legacy);
    const bank={periodStart:value.periodStart,contribution:round(value.contribution),reward:null},r=value.reward;
    if(r&&Number.isFinite(r.amount)&&r.amount>=0&&r.availableAt===bank.periodStart&&r.expiresAt===r.availableAt+DAY&&['available','claimed'].includes(r.status))bank.reward={amount:round(r.amount),availableAt:r.availableAt,expiresAt:r.expiresAt,status:r.status};
    return reconcile(bank,now);
  }
  function reconcile(bank,now){
    const start=period(now);
    if(start>bank.periodStart){
      bank.reward=start===bank.periodStart+DAY&&bank.contribution>0?{amount:bank.contribution,availableAt:start,expiresAt:start+DAY,status:'available'}:null;
      bank.periodStart=start;bank.contribution=0;
    }
    if(bank.reward&&now>=bank.reward.expiresAt)bank.reward=null;
    return bank;
  }
  function deposit(bank,bet,now){reconcile(bank,now);if(!Number.isFinite(bet)||bet<=0)throw new Error('Invalid paid bet');bank.contribution=round(bank.contribution+bet*.01);return bank;}
  function available(bank,now){reconcile(bank,now);const r=bank.reward;return r&&r.status==='available'&&now>=r.availableAt&&now<r.expiresAt?r.amount:0;}
  function claim(bank,now){const amount=available(bank,now);if(amount>0)bank.reward.status='claimed';return amount;}
  const api={DAY,period,create,restore,reconcile,deposit,available,claim};
  if(typeof module!=='undefined'&&module.exports)module.exports=api;else root.GoldBank=api;
})(typeof globalThis!=='undefined'?globalThis:this);
