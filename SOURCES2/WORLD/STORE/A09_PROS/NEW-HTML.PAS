Procedure New_HTML;
Var F: Text;
    Fi: Text;
    i: Byte;
Begin
  FindFirst('E:\NETWORK\WEBS\ip-addr.txt', Archive, DirInfo);
  If DosError = 0 then Begin {E:\NETWORK\WEBS je pritomne}
                         Assign(F,'E:\NETWORK\WEBS\ipx-addr.txt');
                         ReWrite(F);
                         For i:=0 to 5 do Write(F,recNode[i],'.');
                         Close(F);
                         Assign(F,'E:\NETWORK\WEBS\ipx-serv.htm');
                         ReWrite(F);
                       End
                  else Begin {E:\NETWORK\WEBS neexistuje}
                         Assign(F,'ipx-addr.txt');
                         ReWrite(F);
                         For i:=0 to 5 do Write(F,recNode[i],'.');
                         Close(F);
                         Assign(F,'ipx-serv.htm');
                         ReWrite(F);
                       End;

  For i:=0 to 79 do Write(F,'-');                                           WriteLn(F,' <br>'); WriteLn('/r/n');

  Write(F,'IPX DOSBox-0.74 server applikace');                              WriteLn(F,' <br>'); WriteLn('/r/n');

  For i:=0 to 79 do Write(F,'-');                                           WriteLn(F,' <br>'); WriteLn('/r/n');

  Write(F,'Pro navazani spojeni zadejte v dosboxu prikaz:');                WriteLn(F,' <br>'); WriteLn('/r/n');

  Write(F,'Z:\IPXNET connect IP-ADRESA-SERVERU');                           WriteLn(F,' <br>'); WriteLn('/r/n');

  Write(F,'IP adresa serveru je: ');                                        WriteLn(F,' <br>'); WriteLn('/r/n');

  Write(F,'<iframe src="IP-ADDR.TXT" Width="400" Height="40" ></iframe>');  WriteLn(F,' <br>'); WriteLn('/r/n');

  Write(F,'Spustte program klienta a pripojte se k IPX adrese.');           WriteLn(F,' <br>'); WriteLn('/r/n');

  Write(F,'IPX adresa serveru je: ');                                       WriteLn(F,' <br>'); WriteLn('/r/n');

  Write(F,'<iframe src="IPX-ADDR.TXT" Width="400" Height="40" ></iframe>'); WriteLn(F,' <br>'); WriteLn('/r/n');

  Write(F,'IPX adresa je pouze docasna hodnota dosbox tunelingu.');         WriteLn(F,' <br>'); WriteLn('/r/n');

  Write(F,'Pri dalsim spusteni bude jiz pravdepodobne zmenena.');           WriteLn(F,' <br>'); WriteLn('/r/n');

  Write(F,'Aktualni hodnoty adres naleznete zde na teto strance.');        WriteLn(F,' <br>'); WriteLn('/r/n');

  Close(F);
End;