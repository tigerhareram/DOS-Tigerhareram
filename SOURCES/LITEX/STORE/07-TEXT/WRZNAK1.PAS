Procedure WriteZnak1VGA(FontBuffer,FontX,FontY,FontDelka,FontVyska,x,y:Word;Znak:Char;BufferTo:Word);
Var radek,N,zn: Byte;
Begin
  zn:=Ord(Znak);

  If ((zn>=97) and (zn<124)) then
  Begin
    If (zn>=97) and (zn<107) then {a..j , 1.radek}
    Begin
      N:=zn-97;
      radek:=0;
    End;
    If ((zn>=107) and (zn<117)) then {k..t , 2.radek}
    Begin
      N:=zn-107;
      radek:=1;
    End;
    If ((zn>=117) and (zn<124)) then {u..z , 3.radek}
    Begin
      N:=zn-117;
      radek:=2;
    End;
    VGA_SprZ(x,y,FontX+N*FontDelka,FontY+radek*FontVyska,
             FontX+N*FontDelka+(FontDelka-1),FontY+radek*FontVyska+(FontVyska-1),
             0,FontBuffer,BufferTo);
  End;

  If ((zn>=48) and (zn<58)) then {0..9 , 4.radek}
  Begin
    N:=zn-48;
    radek:=3;
    VGA_SprZ(x,y,FontX+N*FontDelka,FontY+radek*FontVyska,
             FontX+N*FontDelka+(FontDelka-1),FontY+radek*FontVyska+(FontVyska-1),
             0,FontBuffer,BufferTo);
  End;

  If zn=61 then {=}
  VGA_SprZ(x,y,FontX+6*FontDelka,FontY+2*FontVyska,FontX+6*FontDelka+(FontDelka-1),FontY+2*FontVyska+(FontVyska-1),
           0,FontBuffer,BufferTo);

  If zn=43 then {+}
  VGA_SprZ(x,y,FontX+7*FontDelka,FontY+2*FontVyska,FontX+7*FontDelka+(FontDelka-1),FontY+2*FontVyska+(FontVyska-1),
           0,FontBuffer,BufferTo);

  If zn=45 then {-}
  VGA_SprZ(x,y,FontX+8*FontDelka,FontY+2*FontVyska,FontX+8*FontDelka+(FontDelka-1),FontY+2*FontVyska+(FontVyska-1),
           0,FontBuffer,BufferTo);

  If zn=47 then {/}
  VGA_SprZ(x,y,FontX+9*FontDelka,FontY+2*FontVyska,FontX+9*FontDelka+(FontDelka-1),FontY+2*FontVyska+(FontVyska-1),
           0,FontBuffer,BufferTo);
End;