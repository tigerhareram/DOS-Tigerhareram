Procedure Text_WriteText(FontBuffer,FontX,FontY,FontDelka,FontVyska,mezera,x,y:Word;retezec:string;BufferTo:Word;Mode:TMode);
Var I: Word;
    posuv:Byte;
    Ordinal: Byte;
Begin
  posuv:=FontDelka+mezera;
  For I:=1 to Length(retezec) do
  Begin
    Ordinal:=Ord(retezec[I]);
    If Mode=VGA then WriteZnak1VGA(FontBuffer,FontX,FontY,FontDelka,FontVyska,X,Y,retezec[I],BufferTo);
    If Mode=SVGA then WriteZnak2SVGA(FontBuffer,FontX,FontY,FontDelka,FontVyska,X,Y,retezec[I]);
    Inc(X,posuv);
  End;
End;