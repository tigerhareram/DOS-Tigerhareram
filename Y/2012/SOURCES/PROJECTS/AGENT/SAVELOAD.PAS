Procedure SaveLoad(Save: Boolean);
Begin
  FindFirst('agent.dat',Archive,DirInfo);
  Case DosError Of
  0: Begin {OK -> LOAD or SAVE}
       Assign(F,'agent.dat');
       If Save=True then Begin {SAVE}
                           ReWrite(F,1);
                           BlockWrite(F,HiScore,4);
                         End
                    else Begin {LOAD}
                           Reset(F,1);
                           BlockRead(F,HiScore,4);
                         End;
       Close(F);
     End;
 18: Begin {Not found -> Create new}
       Assign(F,'agent.dat');
       ReWrite(F,1);
       HiScore:=DefaultHiScore;
       BlockWrite(F,HiScore,4);
       Close(F);
     End;
  End; {Case End}
End;