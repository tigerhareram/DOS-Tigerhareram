procedure Listen (var ECB:ecbrec);
{ P©ijmi paket. Mus¡ b˜t otev©en socket, v ECB vyplnˆno ESRAddress,
  socket, ImmAddress, po‡et fragment– a popis fragment–.
}
var Regs:registers;
begin
  Regs.ES:=Seg(ECB); Regs.SI:=Ofs(ECB);
  Regs.BX := 4;
  intr(IPXInt,Regs);
end;
