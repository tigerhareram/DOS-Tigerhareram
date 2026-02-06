procedure CloseSocket(Socket:socketnr);
{ uzav©en¡ socketu, je v‘dy £spˆ¨n‚ }
var Regs:registers;
begin
  Regs.DX:=Socket;
  Regs.BX := 1;
  intr(IPXINT,Regs);
end;
