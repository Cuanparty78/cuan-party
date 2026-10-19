import 'dart:math';
import 'package:flutter/material.dart';

/// Playable offline mini games. Never change coin or diamond balances.
class PartyMiniGamesPage extends StatefulWidget {
  const PartyMiniGamesPage({super.key, this.initialGame = 'XO Party'});
  final String initialGame;
  @override
  State<PartyMiniGamesPage> createState() => _PartyMiniGamesPageState();
}
class _PartyMiniGamesPageState extends State<PartyMiniGamesPage> {
  static const gold=Color(0xFFEFCB78);
  final rnd=Random();
  String mode='XO Party',status='Giliran kamu (X)';
  List<String> board=List.filled(9,'');
  int d1=1,d2=1,round=0,score=0,turns=0;
  bool over=false,blocked=false;
  late List<String> cards;
  Set<int> open={},found={};
  @override
  void initState(){
    super.initState();
    mode=const ['XO Party','Dadu Party','Memory Match'].contains(widget.initialGame)?widget.initialGame:'XO Party';
    shuffle();
  }
  void shuffle(){
    cards=['👑','💎','🌹','🏰','🦋','🐉','👑','💎','🌹','🏰','🦋','🐉']..shuffle(rnd);
    open={}; found={}; turns=0;blocked=false;
  }
  String result(){
    const lines=[[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]];
    for(final w in lines){ if(board[w[0]].isNotEmpty&&board[w[0]]==board[w[1]]&&board[w[1]]==board[w[2]])return board[w[0]]; }
    return board.contains('')?'':'D';
  }
  void tapX(int i){
    if(over||board[i].isNotEmpty)return;
    setState((){
      board[i]='X';
      if(result().isEmpty){
        final available=<int>[];
        for(var k=0;k<9;k++){if(board[k].isEmpty)available.add(k);}
        if(available.isNotEmpty) board[available[rnd.nextInt(available.length)]]='O';
      }
      final w=result();
      if(w.isNotEmpty){over=true;status=w=='X'?'Kamu menang! 🏆':w=='O'?'Bot menang, main lagi!':'Seri, coba lagi!';}
    });
  }
  void tapCard(int i){
    if(blocked||found.contains(i)||open.contains(i))return;
    setState((){
      open.add(i);
      if(open.length==2){
        turns++;
        final pair=open.toList();
        if(cards[pair[0]]==cards[pair[1]]){found.addAll(pair);open.clear();}
        else {
          blocked=true;
          Future.delayed(const Duration(milliseconds:850),(){
            if(mounted)setState((){open.clear();blocked=false;});
          });
        }
      }
    });
  }
  Widget panel(Widget child)=>Container(padding:const EdgeInsets.all(17),
    decoration:BoxDecoration(color:const Color(0xFF291A47),borderRadius:BorderRadius.circular(23),
    border:Border.all(color:gold.withOpacity(.5))),child:child);
  Widget goldButton(String title,VoidCallback action)=>FilledButton(
    onPressed:action,style:FilledButton.styleFrom(backgroundColor:gold,foregroundColor:const Color(0xFF21172E)),
    child:Text(title,style:const TextStyle(fontWeight:FontWeight.w900)));
  Widget xo()=>panel(Column(children:[
    const Text('XO PARTY',style:TextStyle(color:gold,fontSize:24,fontWeight:FontWeight.bold)),
    Text(status,style:const TextStyle(color:Colors.white70)),
    const SizedBox(height:18),
    AspectRatio(aspectRatio:1,child:GridView.builder(
      physics:const NeverScrollableScrollPhysics(),itemCount:9,
      gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:3,mainAxisSpacing:8,crossAxisSpacing:8),
      itemBuilder:(_,i)=>Material(color:const Color(0xFF4B3471),borderRadius:BorderRadius.circular(14),
        child:InkWell(onTap:()=>tapX(i),child:Center(child:Text(board[i],
          style:TextStyle(fontSize:46,fontWeight:FontWeight.w900,color:board[i]=='X'?gold:Colors.pinkAccent))))))),
    const SizedBox(height:12),goldButton('Main Lagi',()=>setState((){
      board=List.filled(9,'');over=false;status='Giliran kamu (X)';
    }))
  ]));
  Widget dice()=>panel(Column(children:[
    const Text('DADU PARTY',style:TextStyle(color:gold,fontSize:24,fontWeight:FontWeight.bold)),
    const Text('Gratis • tanpa taruhan',style:TextStyle(color:Colors.white70)),
    const SizedBox(height:24),
    Row(mainAxisAlignment:MainAxisAlignment.spaceAround,children:[
      for(final d in [d1,d2])Container(width:105,height:105,alignment:Alignment.center,
        decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(20)),
        child:Text(['','⚀','⚁','⚂','⚃','⚄','⚅'][d],
          style:const TextStyle(fontSize:70,color:Colors.black)))
    ]),
    const SizedBox(height:24),
    Text('Hasil '+(d1+d2).toString(),style:const TextStyle(color:gold,fontSize:25,fontWeight:FontWeight.bold)),
    Text('Putaran: '+round.toString()+' • Total: '+score.toString(),style:const TextStyle(color:Colors.white70)),
    const SizedBox(height:12),
    goldButton('🎲 Lempar Dadu',()=>setState((){
      d1=rnd.nextInt(6)+1;d2=rnd.nextInt(6)+1;round++;score+=d1+d2;
    }))
  ]));
  Widget memory()=>panel(Column(children:[
    const Text('MEMORY MATCH',style:TextStyle(color:gold,fontSize:24,fontWeight:FontWeight.bold)),
    Text('Pasangan '+(found.length~/2).toString()+'/6 • Langkah '+turns.toString(),
      style:const TextStyle(color:Colors.white70)),
    const SizedBox(height:17),
    AspectRatio(aspectRatio:1,child:GridView.builder(
      physics:const NeverScrollableScrollPhysics(),itemCount:12,
      gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:3,mainAxisSpacing:8,crossAxisSpacing:8),
      itemBuilder:(_,i)=>Material(color:found.contains(i)?const Color(0xFF1C6A5B):const Color(0xFF4B3471),
        borderRadius:BorderRadius.circular(12),
        child:InkWell(onTap:()=>tapCard(i),
          child:Center(child:Text(open.contains(i)||found.contains(i)?cards[i]:'❖',
            style:const TextStyle(fontSize:35,color:gold))))))),
    const SizedBox(height:14),
    if(found.length==12)const Text('🏆 Semua pasangan ditemukan!',style:TextStyle(color:gold)),
    goldButton('Acak Ulang',()=>setState(shuffle)),
  ]));
  @override
  Widget build(BuildContext context)=>Scaffold(
    backgroundColor:const Color(0xFF130D2A),
    appBar:AppBar(title:const Text('CUAN PARTY • GAME'),backgroundColor:const Color(0xFF130D2A),foregroundColor:gold),
    body:SafeArea(child:ListView(padding:const EdgeInsets.all(16),children:[
      const Text('Main gratis dulu sambil ngobrol!',style:TextStyle(color:Colors.white70)),
      const SizedBox(height:16),
      Wrap(spacing:7,runSpacing:7,children:[
        for(final game in const ['XO Party','Dadu Party','Memory Match'])
          ChoiceChip(label:Text(game),selected:mode==game,
            selectedColor:gold,labelStyle:TextStyle(color:mode==game?Colors.black:Colors.white),
            backgroundColor:const Color(0xFF3B2859),onSelected:(_)=>setState(()=>mode=game)),
      ]),
      const SizedBox(height:16),
      if(mode=='XO Party')xo(),
      if(mode=='Dadu Party')dice(),
      if(mode=='Memory Match')memory(),
      const SizedBox(height:15),
      const Text('Game hiburan. Tidak menggunakan Coin atau hadiah uang.',
        textAlign:TextAlign.center,style:TextStyle(color:Colors.white54,fontSize:12)),
    ])));
}
