Procedure TestSend(IPXProm:Transmit);
Begin
  move(IPXProm,IPXdata,SizeOf(IPXProm)+1);
  if sendPacket(recNode,IPXdata) then Begin End;
End;