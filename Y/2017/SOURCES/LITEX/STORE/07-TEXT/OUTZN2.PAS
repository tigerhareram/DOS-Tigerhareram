Procedure OutZnak2SVGA(X,Y:Word;Znak:Char);
Var Ordinal: Byte;
Begin
  Ordinal:=Ord(Znak);

  If Ordinal in [48..57] then {znaky 0..9}
  OutCifra2SVGA(X,Y+1,Ordinal-48);

  If Ordinal in [65..90] then {znaky A..Z}
  WriteTexterSprite2SVGA(X,Y+1,(Ordinal-65)*5,0,(Ordinal-65)*5+4,6,205);

  Case Ordinal of {ostatni znaky}

{+} 43: WriteTexterSprite2SVGA(X,Y+1,130,0,134,6,205);
{-} 45: WriteTexterSprite2SVGA(X,Y+1,135,0,139,6,205);
{*} 42: WriteTexterSprite2SVGA(X,Y+1,140,0,142,6,205);
{/} 47: WriteTexterSprite2SVGA(X,Y,143,0,149,6,205);
{:} 58: WriteTexterSprite2SVGA(X,Y+1,150,0,154,6,205);
{.} 46: WriteTexterSprite2SVGA(X,Y+1,155,0,155,6,205);
{,} 44: WriteTexterSprite2SVGA(X,Y+2,160,0,160,6,205);
{=} 61: WriteTexterSprite2SVGA(X,Y+1,165,0,169,6,205);
{?} 63: WriteTexterSprite2SVGA(X,Y+1,170,0,174,6,205);
{%} 37: WriteTexterSprite2SVGA(X,Y+1,175,0,179,6,205);
{!} 33: WriteTexterSprite2SVGA(X,Y+1,180,0,180,6,205);
{(} 40: WriteTexterSprite2SVGA(X,Y+1,185,0,189,6,205);
{)} 41: WriteTexterSprite2SVGA(X,Y+1,190,0,194,6,205);
{>} 62: WriteTexterSprite2SVGA(X,Y+1,195,0,199,6,205);
{<} 60: WriteTexterSprite2SVGA(X,Y+1,200,0,204,6,205);

{a}  97: WriteTexterSprite2SVGA(X,Y,0,0,5,7,132);
{b}  98: WriteTexterSprite2SVGA(X,Y,6,0,10,7,132);
{c}  99: WriteTexterSprite2SVGA(X,Y,11,0,15,7,132);
{d} 100: WriteTexterSprite2SVGA(X,Y,16,0,20,7,132);
{e} 101: WriteTexterSprite2SVGA(X,Y,21,0,25,7,132);
{f} 102: WriteTexterSprite2SVGA(X,Y,26,0,30,7,132);
{g} 103: WriteTexterSprite2SVGA(X,Y+2,31,0,35,7,132);
{h} 104: WriteTexterSprite2SVGA(X,Y,36,0,40,7,132);
{i} 105: WriteTexterSprite2SVGA(X,Y,41,0,43,7,132);
{j} 106: WriteTexterSprite2SVGA(X,Y+2,44,0,46,7,132);
{k} 107: WriteTexterSprite2SVGA(X,Y,47,0,50,7,132);
{l} 108: WriteTexterSprite2SVGA(X,Y,51,0,53,7,132);
{m} 109: WriteTexterSprite2SVGA(X,Y,54,0,59,7,132);
{n} 110: WriteTexterSprite2SVGA(X,Y,60,0,64,7,132);
{o} 111: WriteTexterSprite2SVGA(X,Y,65,0,69,7,132);
{p} 112: WriteTexterSprite2SVGA(X,Y+2,70,0,75,7,132);
{q} 113: WriteTexterSprite2SVGA(X,Y+2,76,0,81,7,132);
{r} 114: WriteTexterSprite2SVGA(X,Y,82,0,86,7,132);
{s} 115: WriteTexterSprite2SVGA(X,Y,87,0,91,7,132);
{t} 116: WriteTexterSprite2SVGA(X,Y,92,0,95,7,132);
{u} 117: WriteTexterSprite2SVGA(X,Y,96,0,101,7,132);
{v} 118: WriteTexterSprite2SVGA(X,Y,102,0,106,7,132);
{w} 119: WriteTexterSprite2SVGA(X,Y,107,0,113,7,132);
{x} 120: WriteTexterSprite2SVGA(X,Y,114,0,118,7,132);
{y} 121: WriteTexterSprite2SVGA(X,Y+2,119,0,123,7,132);
{z} 122: WriteTexterSprite2SVGA(X,Y,124,0,128,7,132);
{ } 160: Begin WriteTexterSprite2SVGA(X,Y,0,0,5,7,132); WriteTexterSprite2SVGA(X+3,Y,130,2,131,3,132); End;
{Ÿ} 159: Begin WriteTexterSprite2SVGA(X,Y,11,0,15,7,132); WriteTexterSprite2SVGA(X+1,Y,129,2,131,3,132); End;
{Ô} 212: Begin WriteTexterSprite2SVGA(X,Y,16,0,20,7,132); WriteTexterSprite2SVGA(X+1,Y-2,129,2,131,3,132); End;
{‚} 130: Begin WriteTexterSprite2SVGA(X,Y,21,0,25,7,132); WriteTexterSprite2SVGA(X+2,Y,130,2,131,3,132); End;
{Ø} 216: Begin WriteTexterSprite2SVGA(X,Y,21,0,25,7,132); WriteTexterSprite2SVGA(X+1,Y,129,2,131,3,132); End;
{¡} 161: Begin WriteTexterSprite2SVGA(X,Y,41,0,43,7,132); WriteTexterSprite2SVGA(X+1,Y+1,130,2,131,3,132); End;
{å} 229: Begin WriteTexterSprite2SVGA(X,Y,60,0,64,7,132); WriteTexterSprite2SVGA(X+1,Y,129,2,131,3,132); End;
{¢} 162: Begin WriteTexterSprite2SVGA(X,Y,65,0,69,7,132); WriteTexterSprite2SVGA(X+2,Y,130,2,131,3,132); End;
{ý} 253: Begin WriteTexterSprite2SVGA(X,Y,82,0,86,7,132); WriteTexterSprite2SVGA(X+1,Y,129,2,131,3,132); End;
{ç} 231: Begin WriteTexterSprite2SVGA(X,Y,87,0,91,7,132); WriteTexterSprite2SVGA(X+1,Y,129,2,131,3,132); End;
{œ} 156: Begin WriteTexterSprite2SVGA(X,Y,92,0,95,7,132); WriteTexterSprite2SVGA(X,Y-2,129,2,131,3,132); End;
{£} 163: Begin WriteTexterSprite2SVGA(X,Y,96,0,101,7,132); WriteTexterSprite2SVGA(X+3,Y,130,2,131,3,132); End;
{…} 133: Begin WriteTexterSprite2SVGA(X,Y,96,0,101,7,132); WriteTexterSprite2SVGA(X+1,Y-1,129,1,131,3,132); End;
{ì} 236: Begin WriteTexterSprite2SVGA(X,Y+2,119,0,123,7,132); WriteTexterSprite2SVGA(X+2,Y,130,2,131,3,132); End;
{§} 167: Begin WriteTexterSprite2SVGA(X,Y,124,0,128,7,132); WriteTexterSprite2SVGA(X+1,Y,129,2,131,3,132); End;

{µ} 181: Begin WriteTexterSprite2SVGA(X,Y+1,0,0,4,6,205); WriteTexterSprite2SVGA(X+2,Y-2,130,2,131,3,132); End;
{¬} 172: Begin WriteTexterSprite2SVGA(X,Y+1,10,0,14,6,205); WriteTexterSprite2SVGA(X+1,Y-2,129,2,131,3,132); End;
{Ò} 210: Begin WriteTexterSprite2SVGA(X,Y+1,15,0,19,6,205); WriteTexterSprite2SVGA(X+1,Y-2,129,2,131,3,132); End;
{} 144: Begin WriteTexterSprite2SVGA(X,Y+1,20,0,24,6,205); WriteTexterSprite2SVGA(X+2,Y-2,130,2,131,3,132); End;
{·} 183: Begin WriteTexterSprite2SVGA(X,Y+1,20,0,24,6,205); WriteTexterSprite2SVGA(X+1,Y-2,129,2,131,3,132); End;
{Ö} 214: Begin WriteTexterSprite2SVGA(X,Y+1,40,0,44,6,205); WriteTexterSprite2SVGA(X+1,Y-2,130,2,131,3,132); End;
{Õ} 213: Begin WriteTexterSprite2SVGA(X,Y+1,65,0,69,6,205); WriteTexterSprite2SVGA(X+1,Y-2,129,2,131,3,132); End;
{à} 224: Begin WriteTexterSprite2SVGA(X,Y+1,70,0,74,6,205); WriteTexterSprite2SVGA(X+2,Y-2,130,2,131,3,132); End;
{ü} 252: Begin WriteTexterSprite2SVGA(X,Y+1,85,0,89,6,205); WriteTexterSprite2SVGA(X+1,Y-2,129,2,131,3,132); End;
{æ} 230: Begin WriteTexterSprite2SVGA(X,Y+1,90,0,94,6,205); WriteTexterSprite2SVGA(X+1,Y-2,129,2,131,3,132); End;
{›} 155: Begin WriteTexterSprite2SVGA(X,Y+1,95,0,99,6,205); WriteTexterSprite2SVGA(X+1,Y-2,129,2,131,3,132); End;
{é} 233: Begin WriteTexterSprite2SVGA(X,Y+1,100,0,104,6,205); WriteTexterSprite2SVGA(X+2,Y-2,130,2,131,3,132); End;
{Þ} 222: Begin WriteTexterSprite2SVGA(X,Y+1,100,0,104,6,205); WriteTexterSprite2SVGA(X+1,Y-3,129,1,131,3,132); End;
{í} 237: Begin WriteTexterSprite2SVGA(X,Y+1,120,0,124,6,205); WriteTexterSprite2SVGA(X+2,Y-2,130,2,131,3,132); End;
{¦} 166: Begin WriteTexterSprite2SVGA(X,Y+1,125,0,129,6,205); WriteTexterSprite2SVGA(X+1,Y-2,129,2,131,3,132); End;
  End; {Case End}

End;
