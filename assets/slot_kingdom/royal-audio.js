(function(root){
 'use strict';
 const TIERS=['big','mega','super','sensational'];
 const VOICE_MS={big:624,mega:600,super:792,sensational:840};
 function create(env){
  const settings={music:true,voice:true,effects:true,volume:.45};
  try{const saved=JSON.parse(env.localStorage?.getItem('cuanKingdomAudio'));for(const key of ['music','voice','effects'])if(typeof saved?.[key]==='boolean')settings[key]=saved[key];if(Number.isFinite(saved?.volume)&&saved.volume>=0&&saved.volume<=1)settings.volume=saved.volume}catch{}
  let theme=null,context=null,unlocked=false,duck=false,epoch=0;const clips={},sources=new Set();
  function clipVolume(kind){return settings[kind]?Math.min(1,settings.volume*(kind==='voice'?1.6:.3)):0}
  function apply(){if(theme)theme.volume=settings.volume*(duck?.05:.35);for(const clip of Object.values(clips)){const volume=clipVolume(clip.kind);clip.audio.volume=volume;for(const node of sources)if(node.clip===clip)node.gain.gain.value=volume}}
  function play(audio){try{audio?.play()?.catch(()=>{})}catch{}}
  function ensure(){if(theme||!env.Audio)return;theme=new env.Audio('assets/audio/kingdom-groove.mp3');theme.loop=true;theme.preload='auto';for(const id of TIERS)for(const kind of ['voice','effects']){const path='assets/audio/'+(kind==='voice'?'voice-':'win-')+id+(kind==='voice'?'-impact':'')+'.mp3';clips[kind+'-'+id]={kind,path,audio:new env.Audio(path),buffer:null,pending:null};clips[kind+'-'+id].audio.preload='auto'}apply()}
  function load(clip){if(!context||!env.fetch||clip.pending)return;clip.pending=env.fetch(clip.path).then(r=>{if(!r.ok)throw Error('Audio unavailable');return r.arrayBuffer()}).then(data=>context.decodeAudioData(data)).then(buffer=>{clip.buffer=buffer}).catch(()=>{})}
  function unlock(){ensure();const first=!unlocked;unlocked=true;try{if(!context){const Constructor=env.AudioContext||env.webkitAudioContext;if(Constructor)context=new Constructor();if(context){const source=context.createBufferSource();source.buffer=context.createBuffer(1,1,context.sampleRate);source.connect(context.destination);source.start()}}context?.resume()?.catch(()=>{})}catch{}if(settings.music)play(theme);
   if(first){const priming=[];for(const clip of Object.values(clips)){load(clip);clip.audio.volume=0;try{const promise=clip.audio.play();if(promise){priming.push(promise.then(()=>{if(!clip.playing){clip.audio.pause();clip.audio.currentTime=0}}).catch(()=>{}))}}catch{}}Promise.all(priming).then(apply)}
  }
  function stopKind(kind){for(const clip of Object.values(clips))if(clip.kind===kind){clip.playing=false;clip.audio.pause();}for(const node of [...sources])if(node.clip.kind===kind){try{node.source.stop()}catch{}sources.delete(node)}}
  function configure(patch){for(const key of ['music','voice','effects'])if(typeof patch[key]==='boolean')settings[key]=patch[key];if(Number.isFinite(patch.volume))settings.volume=Math.max(0,Math.min(1,patch.volume));try{env.localStorage?.setItem('cuanKingdomAudio',JSON.stringify(settings))}catch{}apply();if(!settings.music)theme?.pause();else if(unlocked)play(theme);for(const kind of ['voice','effects'])if(!settings[kind])stopKind(kind)}
  function endWin(){epoch++;for(const kind of ['voice','effects'])stopKind(kind);duck=false;apply()}
  function startClip(clip,token){if(token!==epoch||!settings[clip.kind])return;if(context?.state==='running'&&clip.buffer){const source=context.createBufferSource(),gain=context.createGain();source.buffer=clip.buffer;gain.gain.value=clipVolume(clip.kind);source.connect(gain);gain.connect(context.destination);const node={clip,source,gain};sources.add(node);source.onended=()=>{sources.delete(node);source.disconnect();gain.disconnect()};source.start();}else{clip.playing=true;clip.audio.currentTime=0;play(clip.audio)}}
  function win(id){endWin();if(!unlocked||!TIERS.includes(id))return 0;ensure();duck=true;apply();const token=epoch;for(const kind of ['voice','effects'])if(settings[kind]){const clip=clips[kind+'-'+id];if(!clip)continue;if(clip.pending&&!clip.buffer)clip.pending.then(()=>startClip(clip,token));else startClip(clip,token)}return settings.voice?VOICE_MS[id]+750:0}
  function effect(frequency=500,seconds=.06){if(!settings.effects||!unlocked||!context)return;try{context.resume()?.catch(()=>{});const osc=context.createOscillator(),gain=context.createGain();osc.type='triangle';osc.frequency.value=frequency;gain.gain.setValueAtTime(.04*settings.volume,context.currentTime);gain.gain.exponentialRampToValueAtTime(.0001,context.currentTime+seconds);osc.connect(gain);gain.connect(context.destination);osc.start();osc.stop(context.currentTime+seconds)}catch{}}
  function pause(){theme?.pause();endWin()}
  return {settings,configure,unlock,win,endWin,effect,pause,voiceAvailable:()=>!!env.Audio};
 }
 if(typeof module!=='undefined'&&module.exports)module.exports={create,VOICE_MS};else root.RoyalAudio=create(root);
})(typeof globalThis!=='undefined'?globalThis:this);
