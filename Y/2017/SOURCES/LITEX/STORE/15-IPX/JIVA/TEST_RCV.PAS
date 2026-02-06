Procedure TestReceive(Var IPXProm:Transmit);
Var i: Word;
Begin
  if not receivePacket(IPXdata,fromNode,WAIT_FOR_PACKET_TIME)
  then begin
         IPXProm.Prvni:=0; {Paket nedorazil}
       end
  else begin
         {IPXdata[1..512] = Transmit}                   {JIVA PACAKET}
         {-----------------------------------------------------------}
         IPXProm.Prvni:=1; {prvni bajt}
         for i:=0 to 5 do IPXProm.SourceAddr[i]:=IPXdata[1+i]; {6 bajtu}
         IPXProm.Proces:=IPXdata[7]; {jeden bajt}
         for i:=0 to 399 do IPXProm.Data[i]:=IPXdata[8+i]; {400 bajtu}
       end;
End;