Procedure KnihovnaInfoOperate;
Var Y: Byte;
Begin
  FileName:='KNIHOVNA\index.dat';
  FindFirst(FileName , Archive, DirInfo);
  If DosError = 0 then Begin {jiz existuje}
                         Assign(F,FileName);
                         Reset(F,SizeOf(KnihovnaInfo));
                         BlockRead(F,KnihovnaInfo,1);
                         Close(F);
                       End
                  else Begin {je treba vytvorit}
                         For Y:=0 to 9 do KnihovnaInfo.JmenaSesitu[Y]:='';
                         For Y:=0 to 4 do KnihovnaInfo.JmenaBloku[Y]:='';
                         For Y:=0 to 4 do KnihovnaInfo.JmenaKnih[Y]:='';

                         {ulozeni jmen knih a sesitu}
                         Assign(F,FileName);
                         ReWrite(F,SizeOf(KnihovnaInfo));
                         BlockWrite(F,KnihovnaInfo,1);
                         Close(F);
                       End;

  MainWorldScreen;
End;
