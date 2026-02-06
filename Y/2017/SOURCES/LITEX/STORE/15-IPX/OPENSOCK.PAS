procedure OpenSocket (Mode:byte;RequestedSocket:socketnr;
		      var Completion:byte;var AssignedSocket:socketnr);
{ otev©en¡ socketu:
      Mode            STAYOEN    nutno explicitnˆ uzav©¡t
		      AUTOCLOSE  uzav©e se s m po ukon‡en¡ programu
      RequestedSocket 0 ‡¡slo mi bude p©idˆleno
		      <>0 po‘aduji dan‚ ‡¡slo - interval $3333 a‘ $4444
      Completion      0 nebo ‡¡slo chyby
      AssignedSocket  ‡¡slo p©idˆlen‚ho socketu
}
var Regs:registers;
begin
    Regs.AL:=Mode;
    Regs.DX:=RequestedSocket;
    Regs.BX := 0;
    Intr(IPXINT,Regs);
    Completion:=Regs.AL;
    AssignedSocket:=Regs.DX
end;
