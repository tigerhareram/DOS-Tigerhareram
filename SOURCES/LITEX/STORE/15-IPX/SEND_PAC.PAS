function sendPacket(destNode: nodeaddr; data: packetData): boolean;
{ Vraci: TRUE=OK, FALSE=ERR }
 var pkt: packet;
     frg: fragment;
     ecb: ecbrec;
 begin
   move(data,pkt.data,sizeof(data));

   { V hlavicce packetu staci vyplni adresata; typ paketu nastavi SetECB }
   pkt.hdr.DestNet:=thisnet;
   pkt.hdr.DestNode:=destNode;
   pkt.hdr.DestSocket:=DATA_SOCKET;

   { Odesilatel se vyplnuje proto, aby RECEIVE vedel, komu odpovidat }
   pkt.hdr.SourceNet:=thisnet;
   pkt.hdr.SourceNode:=sendNode;

   frg.adr:=@pkt;
   frg.len:=sizeof(pkt); { Paket ma vzdy stejnou delku, u ridicich paketu }
                        { vyznamove pouze data podle jejich definice     }

   SetECB(ecb,NIL,DATA_SOCKET,destNode,frg);
   send(ecb);

  while ecb.inUse<>0 do;
  if ecb.Completion<>0 then
   writeln('Kriticka chyba komunikace: nepodarilo se vyslat packet');

  sendPacket:=(ecb.Completion=0);
 end;
