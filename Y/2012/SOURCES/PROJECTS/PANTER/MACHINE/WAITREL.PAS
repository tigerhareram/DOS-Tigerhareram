Procedure WaitRelease;
Var ReadPort: Byte;
Begin
  Repeat ReadPort:=InPortB($60); Until ReadPort>=128;
End;
