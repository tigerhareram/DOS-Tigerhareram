procedure InitIPX (var Completion:byte);
{ test instalace IPX.COM }
var
  Regs:registers;

begin
  Regs.AX:=$7A00;
  Intr($2F,Regs);
  if Regs.AL<>$0FF then Completion := NOIPX
  else Completion := 0;
end;
