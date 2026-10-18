(function(root){
 'use strict';
 function create(host){return {open(){try{const channel=host.SlotKingdomHost;if(typeof channel?.postMessage!=='function')return false;channel.postMessage(JSON.stringify({type:'slotKingdom.openWallet',version:1}));return true;}catch{return false;}}};}
 if(typeof module!=='undefined'&&module.exports)module.exports={create};else root.WalletBridge={create};
})(typeof globalThis!=='undefined'?globalThis:this);
