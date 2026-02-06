Procedure Text_Init(Barva:Byte);
Var Offset,I,A: Word;
Begin

  TexterColor:=Barva;

  For I:=0 to 204 do
  Begin
    Dec2Bin(Znaky[I]);
    For A:=7 downto 0 do
    If b[A]=1 then mem[BufferC:205*(7-A)+I]:=TexterColor;
  End;

  For I:=0 to 49 do
  Begin
    Dec2Bin(Cifry[I]);
    For A:=7 downto 0 do
    If b[A]=1 then mem[BufferC1:50*(7-A)+I]:=TexterColor;
  End;

  For I:=0 to 39 do
  Begin
    Dec2Bin(SmallCifry[I]);
    For A:=7 downto 0 do
    If b[A]=1 then mem[BufferC2:40*(7-A)+I]:=TexterColor;
  End;

  For I:=0 to 131 do
  Begin
    Dec2Bin(SmallZnaky[I]);
    For A:=7 downto 0 do
    If b[A]=1 then mem[BufferC3:132*(7-A)+I]:=TexterColor;
  End;
End;