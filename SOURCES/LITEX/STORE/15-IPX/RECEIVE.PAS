function receivePacket(VAR data: packetData;
         VAR fromNode: nodeaddr; waitTime: longint): boolean;
 { Ceka na prijeti packetu na DATA_SOCKET. Pokud se nedocka po dobu
   waitTime, vrati FALSE; jinak nastavi data a vrati TRUE;
   Navic nastavi fromNode na adresu stanice, odkud ramec dorazil
   ( z IPX headeru - podle SourceNode)
 }

 var pkt: packet;
     frg: fragment;
     ecb: ecbrec;
     w  : longint;
     result: byte;
 begin
   frg.adr:=@pkt;
   frg.len:=sizeof(pkt);
   SetECB(ecb,NIL,DATA_SOCKET,fromNode,frg);

   listen(ecb);
   w:=0;
   while (ecb.inUse<>0) and (w<waitTime) do
    begin
      If Key[1]=1 then AbortListen(ecb,result);
      Timer_Wait(10); Inc(w);
    end;

   if ecb.inUse<>0 then begin { Nedockal se }
                          AbortListen(ecb,result);
                          receivePacket:=FALSE;
                          Exit;
                        end;

    move(pkt.data,data,513);
    fromNode:=pkt.hdr.SourceNode;
    receivePacket:=TRUE;
end;
