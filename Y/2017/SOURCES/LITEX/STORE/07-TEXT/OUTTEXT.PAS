Procedure Text_OutText(X,Y:Word;retezec:string;BufferTo:Word;Mode:TMode);
Var I: Word;
    posuv:Byte;
    Ordinal: Byte;
Begin
  posuv:=6; {default}
  For I:=1 to Length(retezec) do
  Begin
    Ordinal:=Ord(retezec[I]);
    Case Ordinal of {znaky o jine delce nez 5 ... nastavit jiny posuv}
{Ö} 214: posuv:=4;
{I} 73: posuv:=4;
{*} 42: posuv:=4;
{/} 47: posuv:=8;
{a} 97: posuv:=7;
{i} 105: posuv:=4;
{j} 106: posuv:=4;
{k} 107: posuv:=5;
{l} 108: posuv:=4;
{m} 109: posuv:=7;
{p} 112: posuv:=7;
{q} 113: posuv:=7;
{t} 116: posuv:=5;
{u} 117: posuv:=7;
{w} 119: posuv:=8;
{ } 160: posuv:=7;
{¡} 161: posuv:=4;
{£} 163: posuv:=7;
{…} 133: posuv:=7;
{œ} 156: posuv:=5;
    End; {Case End}
    If Mode=VGA then OutZnak1VGA(X,Y,retezec[I],BufferTo);
    If Mode=SVGA then OutZnak2SVGA(X,Y,retezec[I]);
    Inc(X,posuv);
    posuv:=6; {default}
  End;
End;