procedure AbortListen (var ECB:ecbrec; var Completion:byte);
{ Zru¨en¡ ‘ dosti o p©¡jem paketu }
var Regs:registers;
begin
  Regs.ES := seg(ECB); Regs.SI := Ofs(ECB);
  Regs.BX := 6;
  Intr(IPXInt,Regs);
  Completion := Regs.al;
end;
