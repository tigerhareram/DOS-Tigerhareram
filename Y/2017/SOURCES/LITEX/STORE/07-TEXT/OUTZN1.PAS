Procedure OutZnak1VGA(X,Y:Word;Znak:Char;BufferTo:Word);
Var Ordinal: Byte;
Begin
  Ordinal:=Ord(Znak);

  If Ordinal in [48..57] then {znaky 0..9}
  OutCifra1VGA(X,Y+1,Ordinal-48,BufferTo);

  If Ordinal in [65..90] then {znaky A..Z}
  WriteTexterSprite1VGA(X,Y+1,(Ordinal-65)*5,0,(Ordinal-65)*5+4,6,BufferTo,205);

  Case Ordinal of {ostatni znaky}

{+} 43: WriteTexterSprite1VGA(X,Y+1,130,0,134,6,BufferTo,205);
{-} 45: WriteTexterSprite1VGA(X,Y+1,135,0,139,6,BufferTo,205);
{*} 42: WriteTexterSprite1VGA(X,Y+1,140,0,142,6,BufferTo,205);
{/} 47: WriteTexterSprite1VGA(X,Y,143,0,149,6,BufferTo,205);
{:} 58: WriteTexterSprite1VGA(X,Y+1,150,0,154,6,BufferTo,205);
{.} 46: WriteTexterSprite1VGA(X,Y+1,155,0,155,6,BufferTo,205);
{,} 44: WriteTexterSprite1VGA(X,Y+2,160,0,160,6,BufferTo,205);
{=} 61: WriteTexterSprite1VGA(X,Y+1,165,0,169,6,BufferTo,205);
{?} 63: WriteTexterSprite1VGA(X,Y+1,170,0,174,6,BufferTo,205);
{%} 37: WriteTexterSprite1VGA(X,Y+1,175,0,179,6,BufferTo,205);
{!} 33: WriteTexterSprite1VGA(X,Y+1,180,0,180,6,BufferTo,205);
{(} 40: WriteTexterSprite1VGA(X,Y+1,185,0,189,6,BufferTo,205);
{)} 41: WriteTexterSprite1VGA(X,Y+1,190,0,194,6,BufferTo,205);
{>} 62: WriteTexterSprite1VGA(X,Y+1,195,0,199,6,BufferTo,205);
{<} 60: WriteTexterSprite1VGA(X,Y+1,200,0,204,6,BufferTo,205);

{a}  97: WriteTexterSprite1VGA(X,Y,0,0,5,7,BufferTo,132);
{b}  98: WriteTexterSprite1VGA(X,Y,6,0,10,7,BufferTo,132);
{c}  99: WriteTexterSprite1VGA(X,Y,11,0,15,7,BufferTo,132);
{d} 100: WriteTexterSprite1VGA(X,Y,16,0,20,7,BufferTo,132);
{e} 101: WriteTexterSprite1VGA(X,Y,21,0,25,7,BufferTo,132);
{f} 102: WriteTexterSprite1VGA(X,Y,26,0,30,7,BufferTo,132);
{g} 103: WriteTexterSprite1VGA(X,Y+2,31,0,35,7,BufferTo,132);
{h} 104: WriteTexterSprite1VGA(X,Y,36,0,40,7,BufferTo,132);
{i} 105: WriteTexterSprite1VGA(X,Y,41,0,43,7,BufferTo,132);
{j} 106: WriteTexterSprite1VGA(X,Y+2,44,0,46,7,BufferTo,132);
{k} 107: WriteTexterSprite1VGA(X,Y,47,0,50,7,BufferTo,132);
{l} 108: WriteTexterSprite1VGA(X,Y,51,0,53,7,BufferTo,132);
{m} 109: WriteTexterSprite1VGA(X,Y,54,0,59,7,BufferTo,132);
{n} 110: WriteTexterSprite1VGA(X,Y,60,0,64,7,BufferTo,132);
{o} 111: WriteTexterSprite1VGA(X,Y,65,0,69,7,BufferTo,132);
{p} 112: WriteTexterSprite1VGA(X,Y+2,70,0,75,7,BufferTo,132);
{q} 113: WriteTexterSprite1VGA(X,Y+2,76,0,81,7,BufferTo,132);
{r} 114: WriteTexterSprite1VGA(X,Y,82,0,86,7,BufferTo,132);
{s} 115: WriteTexterSprite1VGA(X,Y,87,0,91,7,BufferTo,132);
{t} 116: WriteTexterSprite1VGA(X,Y,92,0,95,7,BufferTo,132);
{u} 117: WriteTexterSprite1VGA(X,Y,96,0,101,7,BufferTo,132);
{v} 118: WriteTexterSprite1VGA(X,Y,102,0,106,7,BufferTo,132);
{w} 119: WriteTexterSprite1VGA(X,Y,107,0,113,7,BufferTo,132);
{x} 120: WriteTexterSprite1VGA(X,Y,114,0,118,7,BufferTo,132);
{y} 121: WriteTexterSprite1VGA(X,Y+2,119,0,123,7,BufferTo,132);
{z} 122: WriteTexterSprite1VGA(X,Y,124,0,128,7,BufferTo,132);
{ } 160: Begin
           WriteTexterSprite1VGA(X,Y,0,0,5,7,BufferTo,132);
           WriteTexterSprite1VGA(X+3,Y,130,2,131,3,BufferTo,132);
         End;
{Ÿ} 159: Begin
           WriteTexterSprite1VGA(X,Y,11,0,15,7,BufferTo,132);
           WriteTexterSprite1VGA(X+1,Y,129,2,131,3,BufferTo,132);
         End;
{Ô} 212: Begin
           WriteTexterSprite1VGA(X,Y,16,0,20,7,BufferTo,132);
           WriteTexterSprite1VGA(X+1,Y-2,129,2,131,3,BufferTo,132);
         End;
{‚} 130: Begin
           WriteTexterSprite1VGA(X,Y,21,0,25,7,BufferTo,132);
           WriteTexterSprite1VGA(X+2,Y,130,2,131,3,BufferTo,132);
         End;
{Ø} 216: Begin
           WriteTexterSprite1VGA(X,Y,21,0,25,7,BufferTo,132);
           WriteTexterSprite1VGA(X+1,Y,129,2,131,3,BufferTo,132);
         End;
{¡} 161: Begin
           WriteTexterSprite1VGA(X,Y,41,0,43,7,BufferTo,132);
           WriteTexterSprite1VGA(X+1,Y+1,130,2,131,3,BufferTo,132);
         End;
{å} 229: Begin
           WriteTexterSprite1VGA(X,Y,60,0,64,7,BufferTo,132);
           WriteTexterSprite1VGA(X+1,Y,129,2,131,3,BufferTo,132);
         End;
{¢} 162: Begin
           WriteTexterSprite1VGA(X,Y,65,0,69,7,BufferTo,132);
           WriteTexterSprite1VGA(X+2,Y,130,2,131,3,BufferTo,132);
         End;
{ý} 253: Begin
           WriteTexterSprite1VGA(X,Y,82,0,86,7,BufferTo,132);
           WriteTexterSprite1VGA(X+1,Y,129,2,131,3,BufferTo,132);
         End;
{ç} 231: Begin
           WriteTexterSprite1VGA(X,Y,87,0,91,7,BufferTo,132);
           WriteTexterSprite1VGA(X+1,Y,129,2,131,3,BufferTo,132);
         End;
{œ} 156: Begin
           WriteTexterSprite1VGA(X,Y,92,0,95,7,BufferTo,132);
           WriteTexterSprite1VGA(X,Y-2,129,2,131,3,BufferTo,132);
         End;
{£} 163: Begin
           WriteTexterSprite1VGA(X,Y,96,0,101,7,BufferTo,132);
           WriteTexterSprite1VGA(X+3,Y,130,2,131,3,BufferTo,132);
         End;
{…} 133: Begin
           WriteTexterSprite1VGA(X,Y,96,0,101,7,BufferTo,132);
           WriteTexterSprite1VGA(X+1,Y-1,129,1,131,3,BufferTo,132);
         End;
{ì} 236: Begin
           WriteTexterSprite1VGA(X,Y+2,119,0,123,7,BufferTo,132);
           WriteTexterSprite1VGA(X+2,Y,130,2,131,3,BufferTo,132);
         End;
{§} 167: Begin
           WriteTexterSprite1VGA(X,Y,124,0,128,7,BufferTo,132);
           WriteTexterSprite1VGA(X+1,Y,129,2,131,3,BufferTo,132);
         End;

{µ} 181: Begin
           WriteTexterSprite1VGA(X,Y+1,0,0,4,6,BufferTo,205);
           WriteTexterSprite1VGA(X+2,Y-2,130,2,131,3,BufferTo,132);
         End;
{¬} 172: Begin
           WriteTexterSprite1VGA(X,Y+1,10,0,14,6,BufferTo,205);
           WriteTexterSprite1VGA(X+1,Y-2,129,2,131,3,BufferTo,132);
         End;
{Ò} 210: Begin
           WriteTexterSprite1VGA(X,Y+1,15,0,19,6,BufferTo,205);
           WriteTexterSprite1VGA(X+1,Y-2,129,2,131,3,BufferTo,132);
         End;
{} 144: Begin
           WriteTexterSprite1VGA(X,Y+1,20,0,24,6,BufferTo,205);
           WriteTexterSprite1VGA(X+2,Y-2,130,2,131,3,BufferTo,132);
         End;
{·} 183: Begin
           WriteTexterSprite1VGA(X,Y+1,20,0,24,6,BufferTo,205);
           WriteTexterSprite1VGA(X+1,Y-2,129,2,131,3,BufferTo,132);
         End;
{Ö} 214: Begin
           WriteTexterSprite1VGA(X,Y+1,40,0,44,6,BufferTo,205);
           WriteTexterSprite1VGA(X+1,Y-2,130,2,131,3,BufferTo,132);
         End;
{Õ} 213: Begin
           WriteTexterSprite1VGA(X,Y+1,65,0,69,6,BufferTo,205);
           WriteTexterSprite1VGA(X+1,Y-2,129,2,131,3,BufferTo,132);
         End;
{à} 224: Begin
           WriteTexterSprite1VGA(X,Y+1,70,0,74,6,BufferTo,205);
           WriteTexterSprite1VGA(X+2,Y-2,130,2,131,3,BufferTo,132);
         End;
{ü} 252: Begin
           WriteTexterSprite1VGA(X,Y+1,85,0,89,6,BufferTo,205);
           WriteTexterSprite1VGA(X+1,Y-2,129,2,131,3,BufferTo,132);
         End;
{æ} 230: Begin
           WriteTexterSprite1VGA(X,Y+1,90,0,94,6,BufferTo,205);
           WriteTexterSprite1VGA(X+1,Y-2,129,2,131,3,BufferTo,132);
         End;
{›} 155: Begin
           WriteTexterSprite1VGA(X,Y+1,95,0,99,6,BufferTo,205);
           WriteTexterSprite1VGA(X+1,Y-2,129,2,131,3,BufferTo,132);
         End;
{é} 233: Begin
           WriteTexterSprite1VGA(X,Y+1,100,0,104,6,BufferTo,205);
           WriteTexterSprite1VGA(X+2,Y-2,130,2,131,3,BufferTo,132);
         End;
{Þ} 222: Begin
           WriteTexterSprite1VGA(X,Y+1,100,0,104,6,BufferTo,205);
           WriteTexterSprite1VGA(X+1,Y-3,129,1,131,3,BufferTo,132);
         End;
{í} 237: Begin
           WriteTexterSprite1VGA(X,Y+1,120,0,124,6,BufferTo,205);
           WriteTexterSprite1VGA(X+2,Y-2,130,2,131,3,BufferTo,132);
         End;
{¦} 166: Begin
           WriteTexterSprite1VGA(X,Y+1,125,0,129,6,BufferTo,205);
           WriteTexterSprite1VGA(X+1,Y-2,129,2,131,3,BufferTo,132);
         End;
  End; {Case End}

End;
