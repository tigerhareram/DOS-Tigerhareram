Procedure PowerOn;
Var BaseIO: word;
    IRQ: byte;
    DMA: byte;
    DMA16: byte;

Begin
  RAM_Init;                             { global memory model     }
  Timer_Init;                           { paralel processing      }
  SVGA_Init;                            { 640x480 x256 colors     }
  Text_Init(255);                       { Text,Numbers output     }
  Spkr_Init;                            { PC-Speaker              }

  ZvukKarta:=False;
  GetSettings(BaseIO,IRQ,DMA,DMA16);
  If InitSB(BaseIO,IRQ,DMA,DMA16)=True  { SMIX by Ethan Brodsky   }
  then Begin
         ZvukKarta:=True;
         SetSamplingRate(8000);
         InitMixing;
         InitXMS;
         InitSharing;
       End;

  Kbd_Init;                             { Keyboard handler        }
  Mouse_Show;                           { Mouse handler           }
  InitIPX(IPXResult);                   { Grygarek IPX            }
End;