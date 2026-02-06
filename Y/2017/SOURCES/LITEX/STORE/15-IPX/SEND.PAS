procedure Send (var ECB:ecbrec);
{ Vy¨li paket. V ECB p©edem vyplnit ESRaddress, socket, ImmAddress,
  po‡et fragment– a deskriptor fragment–. V z hlav¡ paketu vyplnit
  typ paketu a adres ta. €¡slo socketu nen¡ pro vys¡l n¡ podstatn‚
  a socket nemus¡ b˜t otev©en. Adres t z nˆj ale zjist¡, na jak˜ socket
  m–‘e odpov¡dat.
}
var Regs:registers;
begin
  if ecb.socket < $3333 then exit;
  ecb.frag1.adr^.hdr.ptype := 0;

  Regs.ES:=Seg(ECB); Regs.SI:=Ofs(ECB);
  Regs.Bx := 3;
  Intr(IPXInt,Regs);
end;
