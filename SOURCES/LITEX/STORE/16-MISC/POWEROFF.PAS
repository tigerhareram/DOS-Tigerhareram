Procedure PowerOff;
Begin
  Mouse_Hide;            { Mouse handler           }
  Kbd_Done;              { Keyboard handler        }

  If ZvukKarta=True      { Sound Card              }
  then Begin
         ShutdownSB;
         ShutdownMixing;
         ShutdownSharing;
       End;

  Spkr_Done;             { PC-Speaker              }
  Text_Done;             { Text,Numbers output     }

  Timer_Done;            { paralel processing      }
  RAM_Done;              { global memory model     }
End;