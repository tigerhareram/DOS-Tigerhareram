Procedure WaitKey;
Var ReadPort: Byte;
Begin
  Repeat ReadPort:=Port[$60]; Until ReadPort>=128;
  Repeat ReadPort:=Port[$60]; Until ReadPort<128;
End;
