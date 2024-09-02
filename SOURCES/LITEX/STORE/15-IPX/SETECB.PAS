procedure SetECB (var ECB:ecbrec;ESRAddr:pointer;Socket:socketnr;
		  Imm:nodeaddr;PacketDescriptor:fragment);
{ Vyplnˆn¡ Event Control Blocku, pou‘¡v  se pro p©¡jem i vys¡l n¡
	ECB	         ©¡dic¡ blok
	ESRAddr          adresa rutiny, kter  se provede p©i vzniku ud losti,
			 tj. po vysl n¡  nebo p©ijet¡ paketu
			 NIL - ‘ dn  se neprov d¡
	Socket           ‡¡slo socketu
	PacketDescriptor popisova‡ paketu
}
begin
  ECB.ESRAddr:=ESRAddr;
  ECB.Socket:=Socket;
  ECB.ImmAddr:=Imm;
  ECB.FragCnt:=1;
  ECB.Frag1:=PacketDescriptor
end;
