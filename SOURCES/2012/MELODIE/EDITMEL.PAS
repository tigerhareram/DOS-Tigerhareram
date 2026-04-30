Procedure CountRepNum(N: Byte);
Var I: LongInt;
    ReadByte: Byte;
    count: LongInt;
Begin
  If Melody.Repetice>0 then I:=Melody.Repetice-1
                       else I:=0;
  count:=0;
  While I>StartNum do
  Begin
    ReadByte:=mem[Melody.DataSeg:N*3000+I];
    If ReadByte<=120 then Inc(count); {nota nebo prazdne pole}
    If ReadByte>=128 then Inc(count,ReadByte-128); {mezera}
    Dec(I);
  End;
  RepNum[N]:=count;
End;


Procedure WritePlayScreen;
Var X,Y: Word;
Begin
  X:=110;
  Y:=70;
  Blok(X,Y,X+108,Y+70,246,Buffer[1]);
  Ramecek(X,Y,X+108,Y+70,253,Buffer[1]);
  OutText(X+2,Y+2,'Enter,P=Play',Buffer[1]);
  OutText(X+2,Y+15,'Esc=Zpet',Buffer[1]);
  OutText(X+2,Y+28,'PgUp,PgDn=Tempo',Buffer[1]);
  OutText(X+2,Y+41,'Tempo=',Buffer[1]);
  OutText(X+2,Y+54,'J=Skok za repetici',Buffer[1]);
  OutNumber(X+40,Y+42,Melody.Tempo,False,Buffer[1]);
  WaitRetrace;
  FlipPage(Buffer[1],Buffer[4]);
End;


Procedure StartPlayScreen;
Var Ending: Boolean;
Begin
  Ending:=False;
  WritePlayScreen;
  Repeat
{PgUp}  If Key[73]=True then
        Begin
          While Key[73]=True do WaitButton(73);
          If Melody.Tempo<12 then Inc(Melody.Tempo);
          SetMelodyTempo(Melody.Tempo);
          WritePlayScreen;
        End;

{PgDn}  If Key[81]=True then
        Begin
          While Key[81]=True do WaitButton(81);
          If Melody.Tempo>1 then Dec(Melody.Tempo);
          SetMelodyTempo(Melody.Tempo);
          WritePlayScreen;
        End;

{P}     If ((Key[25]=True) or (Key[28]=True)) then
{Enter} Begin
          While Key[25]=True do Begin End;
          While Key[28]=True do Begin End;
          If ((StartNum>0) and (Melody.Repetice>0) and
              (StartNum<Melody.Repetice))
          then Begin
                 Melody.Start:=StartNum;
                 Melody.Finish:=Melody.Repetice;
               End;
          If ((StartNum=0) and (Melody.Repetice>0))
          then Begin
                 Melody.Start:=0;
                 Melody.Finish:=Melody.Repetice;
               End;
          If ((StartNum>0) and (Melody.Repetice=0))
          then Begin
                 Melody.Start:=StartNum;
                 Melody.Finish:=0;
               End;
          If ((StartNum=0) and (Melody.Repetice=0))
          then Begin
                 Melody.Start:=0;
                 Melody.Finish:=0;
               End;
          StartGMPlay(Melody.Tempo,127,Melody.Start,Melody.Finish,False);
        End;

{J}     If Key[36]=True then
        Begin
          While Key[36]=True do Begin End;
          JumpToMelodyRepeat;
        End;

{Esc}   If Key[1]=True then
        Begin
          While Key[1]=True do Begin End;
          Ending:=True;
          StopGMPlay;
        End;

  Until Ending=True;
End;


Procedure WriteDrumText(Cislo: Byte;X,Y: Word);
Begin
  Case Cislo of
   35: OutText(x,y,'Acoustic Bass Drum',Buffer[1]);
   36: OutText(x,y,'Bass Drum 1',Buffer[1]);
   37: OutText(x,y,'Side Stick',Buffer[1]);
   38: OutText(x,y,'Acoustic Snare',Buffer[1]);
   39: OutText(x,y,'Hand Clap',Buffer[1]);
   40: OutText(x,y,'Electric Snare',Buffer[1]);
   41: OutText(x,y,'Low Floor Tom',Buffer[1]);
   42: OutText(x,y,'Closed High Hat',Buffer[1]);
   43: OutText(x,y,'High Floor Tom',Buffer[1]);
   44: OutText(x,y,'Pedal Gigh Hat',Buffer[1]);
   45: OutText(x,y,'Low Tom',Buffer[1]);
   46: OutText(x,y,'Open High Hat',Buffer[1]);
   47: OutText(x,y,'Low-Mid Tom',Buffer[1]);
   48: OutText(x,y,'High-Mid Tom',Buffer[1]);
   49: OutText(x,y,'Crash Cymbal 1',Buffer[1]);
   50: OutText(x,y,'High Tom',Buffer[1]);
   51: OutText(x,y,'Ride Cymbal 1',Buffer[1]);
   52: OutText(x,y,'Chinese Cymbal',Buffer[1]);
   53: OutText(x,y,'Ride Ball',Buffer[1]);
   54: OutText(x,y,'Tambourine',Buffer[1]);
   55: OutText(x,y,'Splash Cymbal',Buffer[1]);
   56: OutText(x,y,'Cowbell',Buffer[1]);
   57: OutText(x,y,'Crash Cymbal 2',Buffer[1]);
   58: OutText(x,y,'Vibraslap',Buffer[1]);
   59: OutText(x,y,'Ride Cymbal 2',Buffer[1]);
   60: OutText(x,y,'High Bongo',Buffer[1]);
   61: OutText(x,y,'Low Bongo',Buffer[1]);
   62: OutText(x,y,'Mute High Conga',Buffer[1]);
   63: OutText(x,y,'Open High Conga',Buffer[1]);
   64: OutText(x,y,'Low Conga',Buffer[1]);
   65: OutText(x,y,'High Timbale',Buffer[1]);
   66: OutText(x,y,'Low Timbale',Buffer[1]);
   67: OutText(x,y,'High Agogo',Buffer[1]);
   68: OutText(x,y,'Low Agogo',Buffer[1]);
   69: OutText(x,y,'Cabasa',Buffer[1]);
   70: OutText(x,y,'Maracas',Buffer[1]);
   71: OutText(x,y,'Short Whistle',Buffer[1]);
   72: OutText(x,y,'Long Whistle',Buffer[1]);
   73: OutText(x,y,'Short Guiro',Buffer[1]);
   74: OutText(x,y,'Long Guiro',Buffer[1]);
   75: OutText(x,y,'Claves',Buffer[1]);
   76: OutText(x,y,'High Wood Block',Buffer[1]);
   77: OutText(x,y,'Low Wood Block',Buffer[1]);
   78: OutText(x,y,'Mute Cuica',Buffer[1]);
   79: OutText(x,y,'Open Cuica',Buffer[1]);
   80: OutText(x,y,'Mute Triangle',Buffer[1]);
   81: OutText(x,y,'Open Triangle',Buffer[1]);
  End; {Case End}
End;


Procedure WriteNastrojText(Cislo:Byte;X,Y:Word);
Begin
  Case Cislo of
   1: OutText(X,Y,'Acoustic Grand',Buffer[1]);
   2: OutText(X,Y,'Bright Acoustic',Buffer[1]);
   3: OutText(X,Y,'Electric Grand',Buffer[1]);
   4: OutText(X,Y,'Honky-Tonk',Buffer[1]);
   5: OutText(X,Y,'Electric Piano 1',Buffer[1]);
   6: OutText(X,Y,'Electric Piano 2',Buffer[1]);
   7: OutText(X,Y,'Harpsichord',Buffer[1]);
   8: OutText(X,Y,'Clav',Buffer[1]);
   9: OutText(X,Y,'Celesta',Buffer[1]);
  10: OutText(X,Y,'Glockenspiel',Buffer[1]);
  11: OutText(X,Y,'Music Box',Buffer[1]);
  12: OutText(X,Y,'Vibraphone',Buffer[1]);
  13: OutText(X,Y,'Marimba',Buffer[1]);
  14: OutText(X,Y,'Xylophone',Buffer[1]);
  15: OutText(X,Y,'Tubular Bells',Buffer[1]);
  16: OutText(X,Y,'Dulcimer',Buffer[1]);
  17: OutText(X,Y,'Drawbar Organ',Buffer[1]);
  18: OutText(X,Y,'Percussive Organ',Buffer[1]);
  19: OutText(X,Y,'Rock Organ',Buffer[1]);
  20: OutText(X,Y,'Church Organ',Buffer[1]);
  21: OutText(X,Y,'Reed Organ',Buffer[1]);
  22: OutText(X,Y,'Accoridan',Buffer[1]);
  23: OutText(X,Y,'Harmonica',Buffer[1]);
  24: OutText(X,Y,'Tango Accordian',Buffer[1]);
  25: OutText(X,Y,'Acoustic Gouitar (nylon)',Buffer[1]);
  26: OutText(X,Y,'Acoustic Guitar (steel)',Buffer[1]);
  27: OutText(X,Y,'Electric Guitar (jazz)',Buffer[1]);
  28: OutText(X,Y,'Electric Guitar (clean)',Buffer[1]);
  29: OutText(X,Y,'Electric Guitar (muted)',Buffer[1]);
  30: OutText(X,Y,'Overdriven Guitar',Buffer[1]);
  31: OutText(X,Y,'Distortion Guitar',Buffer[1]);
  32: OutText(X,Y,'Guitar Harmonics',Buffer[1]);
  33: OutText(X,Y,'Acoustic Bass',Buffer[1]);
  34: OutText(X,Y,'Electric Bass (finger)',Buffer[1]);
  35: OutText(X,Y,'Electric Bass (pick)',Buffer[1]);
  36: OutText(X,Y,'Fretless Bass',Buffer[1]);
  37: OutText(X,Y,'Slap Bass 1',Buffer[1]);
  38: OutText(X,Y,'Slap Bass 2',Buffer[1]);
  39: OutText(X,Y,'Synth Bass 1',Buffer[1]);
  40: OutText(X,Y,'Synth Bass 2',Buffer[1]);
  41: OutText(X,Y,'Violin',Buffer[1]);
  42: OutText(X,Y,'Viola',Buffer[1]);
  43: OutText(X,Y,'Cello',Buffer[1]);
  44: OutText(X,Y,'Contrabass',Buffer[1]);
  45: OutText(X,Y,'Tremolo Strings',Buffer[1]);
  46: OutText(X,Y,'Pizzicato Strings',Buffer[1]);
  47: OutText(X,Y,'Orchestral Strings',Buffer[1]);
  48: OutText(X,Y,'Timpani',Buffer[1]);
  49: OutText(X,Y,'String Ensemble 1',Buffer[1]);
  50: OutText(X,Y,'String Ensemble 2',Buffer[1]);
  51: OutText(X,Y,'SynthStrings 1',Buffer[1]);
  52: OutText(X,Y,'SynthStrings 2',Buffer[1]);
  53: OutText(X,Y,'Choir Aahs',Buffer[1]);
  54: OutText(X,Y,'Voice Oohs',Buffer[1]);
  55: OutText(X,Y,'Synth Voice',Buffer[1]);
  56: OutText(X,Y,'Orchestra Hit',Buffer[1]);
  57: OutText(X,Y,'Trumpet',Buffer[1]);
  58: OutText(X,Y,'Trombone',Buffer[1]);
  59: OutText(X,Y,'Tuba',Buffer[1]);
  60: OutText(X,Y,'Muted Trumpet',Buffer[1]);
  61: OutText(X,Y,'French Horn',Buffer[1]);
  62: OutText(X,Y,'Brass Section',Buffer[1]);
  63: OutText(X,Y,'SynthBrass 1',Buffer[1]);
  64: OutText(X,Y,'SynthBrass 2',Buffer[1]);
  65: OutText(X,Y,'Soprano Sax',Buffer[1]);
  66: OutText(X,Y,'Alto Sax',Buffer[1]);
  67: OutText(X,Y,'Tenor Sax',Buffer[1]);
  68: OutText(X,Y,'Baritone Sax',Buffer[1]);
  69: OutText(X,Y,'Oboe',Buffer[1]);
  70: OutText(X,Y,'English Horn',Buffer[1]);
  71: OutText(X,Y,'Bassoon',Buffer[1]);
  72: OutText(X,Y,'Clarinet',Buffer[1]);
  73: OutText(X,Y,'Piccolo',Buffer[1]);
  74: OutText(X,Y,'Flute',Buffer[1]);
  75: OutText(X,Y,'Recorder',Buffer[1]);
  76: OutText(X,Y,'Pan Flute',Buffer[1]);
  77: OutText(X,Y,'Blown Bottle',Buffer[1]);
  78: OutText(X,Y,'Skakuhachi',Buffer[1]);
  79: OutText(X,Y,'Whistle',Buffer[1]);
  80: OutText(X,Y,'Ocarina',Buffer[1]);
  81: OutText(X,Y,'Lead 1 (square)',Buffer[1]);
  82: OutText(X,Y,'Lead 2 (sawtooth)',Buffer[1]);
  83: OutText(X,Y,'Lead 3 (calliope)',Buffer[1]);
  84: OutText(X,Y,'Lead 4 (chiff)',Buffer[1]);
  85: OutText(X,Y,'Lead 5 (charang)',Buffer[1]);
  86: OutText(X,Y,'Lead 6 (voice)',Buffer[1]);
  87: OutText(X,Y,'Lead 7 (fifths)',Buffer[1]);
  88: OutText(X,Y,'Lead 8 (bass+lead)',Buffer[1]);
  89: OutText(X,Y,'Pad 1 (new age)',Buffer[1]);
  90: OutText(X,Y,'Pad 2 (warm)',Buffer[1]);
  91: OutText(X,Y,'Pad 3 (polysynth)',Buffer[1]);
  92: OutText(X,Y,'Pad 4 (choir)',Buffer[1]);
  93: OutText(X,Y,'Pad 5 (bowed)',Buffer[1]);
  94: OutText(X,Y,'Pad 6 (metallic)',Buffer[1]);
  95: OutText(X,Y,'Pad 7 (halo)',Buffer[1]);
  96: OutText(X,Y,'Pad 8 (sweep)',Buffer[1]);
  97: OutText(X,Y,'FX 1 (rain)',Buffer[1]);
  98: OutText(X,Y,'FX 2 (soundtrack)',Buffer[1]);
  99: OutText(X,Y,'FX 3 (crystal)',Buffer[1]);
 100: OutText(X,Y,'FX 4 (atmosphere)',Buffer[1]);
 101: OutText(X,Y,'FX 5 (brightness)',Buffer[1]);
 102: OutText(X,Y,'FX 6 (goblins)',Buffer[1]);
 103: OutText(X,Y,'FX 7 (echoes)',Buffer[1]);
 104: OutText(X,Y,'FX 8 (sci-fi)',Buffer[1]);
 105: OutText(X,Y,'Sitar',Buffer[1]);
 106: OutText(X,Y,'Banjo',Buffer[1]);
 107: OutText(X,Y,'Shamisen',Buffer[1]);
 108: OutText(X,Y,'Koto',Buffer[1]);
 109: OutText(X,Y,'Kalimba',Buffer[1]);
 110: OutText(X,Y,'Bagpipe',Buffer[1]);
 111: OutText(X,Y,'Fiddle',Buffer[1]);
 112: OutText(X,Y,'Shanai',Buffer[1]);
 113: OutText(X,Y,'Tinkle Bell',Buffer[1]);
 114: OutText(X,Y,'Agogo',Buffer[1]);
 115: OutText(X,Y,'Steel Drums',Buffer[1]);
 116: OutText(X,Y,'Woodblock',Buffer[1]);
 117: OutText(X,Y,'Taiko Drum',Buffer[1]);
 118: OutText(X,Y,'Melodic Tom',Buffer[1]);
 119: OutText(X,Y,'Synth Drum',Buffer[1]);
 120: OutText(X,Y,'Reverse Cymbal',Buffer[1]);
 121: OutText(X,Y,'Guitar Fret Noise',Buffer[1]);
 122: OutText(X,Y,'Breath Noise',Buffer[1]);
 123: OutText(X,Y,'Seashore',Buffer[1]);
 124: OutText(X,Y,'Bird Tweet',Buffer[1]);
 125: OutText(X,Y,'Telephone Ring',Buffer[1]);
 126: OutText(X,Y,'Helicopter',Buffer[1]);
 127: OutText(X,Y,'Applause',Buffer[1]);
 128: OutText(X,Y,'Gunshot',Buffer[1]);
  End; {Case End}
End;


Procedure SetupNastrojeScreen;
Var Y: Byte;
Begin
  ClearPage(Buffer[1]);
  For Y:=0 to 7 do Blok(0,Y*20,319,Y*20+18,249,Buffer[1]);
  Blok(0,NastrojY*20,319,NastrojY*20+18,246,Buffer[1]);

  For Y:=1 to 7 do
  Begin
    OutNumber(0,Y*20+2,Melody.Kanal[Y].Nastroj,False,Buffer[1]);
    OutText(238,Y*20+1,'oktava=',Buffer[1]);
    OutNumber(280,Y*20+2,Melody.Kanal[Y].DefaultOktava,False,Buffer[1]);
    OutNumber(300,Y*20+2,Melody.Kanal[Y].Balance,False,Buffer[1]);
  End;

  If NotDrums=0 then Begin
                       OutNumber(0,2,DrumNote,False,Buffer[1]);
                       OutText(20,1,'Drum =',Buffer[1]);
                       WriteDrumText(DrumNote,62,1);
                     End
                else Begin
                       OutNumber(0,2,Melody.Kanal[0].Nastroj,False,Buffer[1]);
                       OutText(20,1,'Nastroj 0 =',Buffer[1]);
                       WriteNastrojText(Melody.Kanal[0].Nastroj+1,92,1);
                       OutText(238,1,'oktava=',Buffer[1]);
                       OutNumber(280,2,Melody.Kanal[0].DefaultOktava,False,Buffer[1]);
                       OutNumber(300,2,Melody.Kanal[0].Balance,False,Buffer[1]);
                     End;

  OutText(20,21,'Nastroj 1 =',Buffer[1]);
  WriteNastrojText(Melody.Kanal[1].Nastroj+1,92,21);
  OutText(20,41,'Nastroj 2 =',Buffer[1]);
  WriteNastrojText(Melody.Kanal[2].Nastroj+1,92,41);
  OutText(20,61,'Nastroj 3 =',Buffer[1]);
  WriteNastrojText(Melody.Kanal[3].Nastroj+1,92,61);
  OutText(20,81,'Nastroj 4 =',Buffer[1]);
  WriteNastrojText(Melody.Kanal[4].Nastroj+1,92,81);
  OutText(20,101,'Nastroj 5 =',Buffer[1]);
  WriteNastrojText(Melody.Kanal[5].Nastroj+1,92,101);
  OutText(20,121,'Nastroj 6 =',Buffer[1]);
  WriteNastrojText(Melody.Kanal[6].Nastroj+1,92,121);
  OutText(20,141,'Nastroj 7 =',Buffer[1]);
  WriteNastrojText(Melody.Kanal[7].Nastroj+1,92,141);

  If ShowHelp2=True then
  Begin
    Blok(0,146,319,199,254,Buffer[1]);
    OutText(10,148,'N=kanal0=bici/midi',Buffer[1]);
    OutText(10,162,'doleva,doprava=balance',Buffer[1]);
    OutText(160,162,'nahoru,dolu=vyber',Buffer[1]);
    OutText(10,176,'pgup,pgdn=+/-nastroj (drum)',Buffer[1]);
    OutText(200,176,'T=test',Buffer[1]);
    OutText(250,176,'O=oktava',Buffer[1]);
    OutText(10,190,'F2=SAVE',Buffer[1]);
    OutText(62,190,'Esc=zpet',Buffer[1]);
  End;
End;


Procedure WriteNastrojeScreen;
Begin
  WaitRetrace;
  FlipPage(Buffer[1],Buffer[4]);
End;


Procedure SetupNastroju;
Var Ending: Boolean;
    I,Vyska: Byte;
Begin
  Ending:=False;
  NastrojY:=0;
  ShowHelp2:=False;
  SetupNastrojeScreen;
  Repeat
    WriteNastrojeScreen;
{Up}    If Key[72]=True then
        Begin
          While Key[72]=True do WaitButton(72);
          If NastrojY>0 then Dec(NastrojY);
          SetupNastrojeScreen;
        End;

{Down}  If Key[80]=True then
        Begin
          While Key[80]=True do WaitButton(80);
          If NastrojY<7 then Inc(NastrojY);
          SetupNastrojeScreen;
        End;

{Left}  If Key[75]=True then
        Begin
          While Key[75]=True do WaitButton(75);
          If Melody.Kanal[NastrojY].Balance>0 then
          Dec(Melody.Kanal[NastrojY].Balance);
          SetupNastrojeScreen;
        End;

{Right} If Key[77]=True then
        Begin
          While Key[77]=True do WaitButton(77);
          If Melody.Kanal[NastrojY].Balance<127 then
          Inc(Melody.Kanal[NastrojY].Balance);
          SetupNastrojeScreen;
        End;

{PgUp}  If Key[73]=True then
        Begin
          While Key[73]=True do WaitButton(73);
          If NastrojY=0 then
          Begin
            If NotDrums=0 then
            Begin
              If NastrojDrum<46 then Inc(NastrojDrum);
              DrumNote:=35+NastrojDrum;
            End else
            Begin
              If Melody.Kanal[NastrojY].Nastroj<127 then
              Inc(Melody.Kanal[NastrojY].Nastroj);
            End;
          End else
          Begin
            If Melody.Kanal[NastrojY].Nastroj<127 then
            Inc(Melody.Kanal[NastrojY].Nastroj);
          End;
          SetupNastrojeScreen;
        End;

{PgDn}  If Key[81]=True then
        Begin
          While Key[81]=True do WaitButton(81);
          If NastrojY=0 then
          Begin
            If NotDrums=0 then
            Begin
              If NastrojDrum>0 then Dec(NastrojDrum);
              DrumNote:=35+NastrojDrum;
            End else
            Begin
              If Melody.Kanal[NastrojY].Nastroj>0 then
              Dec(Melody.Kanal[NastrojY].Nastroj);
            End;
          End else
          Begin
            If Melody.Kanal[NastrojY].Nastroj>0 then
            Dec(Melody.Kanal[NastrojY].Nastroj);
          End;
          SetupNastrojeScreen;
        End;

{O}   If Key[24]=True then
      Begin
        While Key[24]=True do Begin End;
        If Melody.Kanal[NastrojY].DefaultOktava<9
        then Inc(Melody.Kanal[NastrojY].DefaultOktava)
        else Melody.Kanal[NastrojY].DefaultOktava:=0;
        SetupNastrojeScreen;
      End;

{T}   If Key[20]=True then
      Begin
        While Key[20]=True do Begin End;
        If NastrojY>0 then
        Begin
          SetNastroj(NastrojY,Melody.Kanal[NastrojY].Nastroj);
          SetBalance(NastrojY,Melody.Kanal[NastrojY].Balance);
          For Vyska:=0 to 11 do
          Begin
            NotaOn(NastrojY,Melody.Kanal[NastrojY].DefaultOktava*12+Vyska,127);
            Wait(200);
            NotaOff(NastrojY,Melody.Kanal[NastrojY].DefaultOktava*12+Vyska,127);
          End;
        End else
        Begin
          If NotDrums=0 then
          Begin
            SetBalance(9,Melody.Kanal[0].Balance);
            For I:=0 to 4 do
            Begin
              NotaOn(9,DrumNote,127);
              Wait(200);
              NotaOff(9,DrumNote,127);
            End;
          End else
            Begin
            SetNastroj(NastrojY,Melody.Kanal[NastrojY].Nastroj);
            SetBalance(NastrojY,Melody.Kanal[NastrojY].Balance);
            For Vyska:=0 to 11 do
            Begin
              NotaOn(NastrojY,Melody.Kanal[NastrojY].DefaultOktava*12+Vyska,127);
              Wait(200);
              NotaOff(NastrojY,Melody.Kanal[NastrojY].DefaultOktava*12+Vyska,127);
            End;
          End;
        End;
      End;

{N}   If Key[49]=True then
      Begin
        While Key[49]=True do Begin End;
        If NotDrums=0 then Begin
                             NotDrums:=1;
                             ZalohaDrumNote:=DrumNote;
                             Melody.Kanal[0].Nastroj:=ZalohaNastroj0;
                             End
                      else Begin
                             NotDrums:=0;
                             DrumNote:=ZalohaDrumNote;
                             ZalohaNastroj0:=Melody.Kanal[0].Nastroj;
                           End;
        SetupNastrojeScreen;
      End;

{F1}  If Key[59]=True then
      Begin
        While Key[59]=True do Begin End;
        If ShowHelp2=True then ShowHelp2:=False
                          else ShowHelp2:=True;
        SetupNastrojeScreen;
        WriteNastrojeScreen;
      End;

{F2}  If Key[60]=True then
      Begin
        While Key[60]=True do Begin End;
        CountMelodyLenght;
        SaveMELFile(FileName);
        SoundDone;
      End;

{Esc} If Key[1]=True then
      Begin
        While Key[1]=True do Begin End;
        Ending:=True;
        StopGMPlay;
      End;

  Until Ending=True;
End;


Procedure WriteKros(X,Y: Word);
Var I: Byte;
Begin
  WritePixel(X+1,Y+1,253,Buffer[1]);
  WritePixel(X+3,Y+1,253,Buffer[1]);
  WritePixel(X+1,Y+3,253,Buffer[1]);
  WritePixel(X+3,Y+3,253,Buffer[1]);
  WritePixel(X+1,Y+5,253,Buffer[1]);
  WritePixel(X+3,Y+5,253,Buffer[1]);
  For I:=0 to 4 do
  WritePixel(X+I,Y+2,253,Buffer[1]);
  For I:=0 to 4 do
  WritePixel(X+I,Y+4,253,Buffer[1]);
End;


Procedure SetupMelScreen;
Var A,I: Byte;
    X,Y,Mezivysledek,Oktava,Nota,Offset: Word;
Begin
  ClearPage(Buffer[1]);
  For I:=1 to 15 do Blok(I*20,0,I*20+18,10,249,Buffer[1]);
  For I:=1 to 15 do
  Begin
    If MelSelectX1+(I-1)=StartNum then Blok(I*20,0,I*20+18,10,250,Buffer[1]);
    If MelSelectX1+(I-1)<1000
    then OutNumber(I*20+1,2,MelSelectX1+(I-1),False,Buffer[1])
    else OutNumber(I*20,2,MelSelectX1+(I-1),True,Buffer[1]);
  End;
  For Y:=0 to 7 do
  Begin
    Blok(0,12+Y*20,18,12+Y*20+18,249,Buffer[1]);
    If ((Y=0) and (NotDrums=0))
    then OutText(7,16,'D',Buffer[1])
    else OutNumber(1,17+Y*20,Melody.Kanal[Y].Nastroj,False,Buffer[1]);
  End;
  For Y:=0 to 7 do
  For I:=1 to 15 do Blok(I*20,12+Y*20,I*20+18,12+Y*20+18,248,Buffer[1]);
  Blok(20+MelSelectX2*20,12+MelSelectY*20,20+MelSelectX2*20+18,12+MelSelectY*20+18,246,Buffer[1]);

  For A:=0 to 7 do
  For I:=0 to 14 do
  Begin
    X:=21+I*20;
    Y:=13+A*20;
    Offset:=A*3000+MelSelectX1+I;
    If mem[Melody.DataSeg:Offset]=121 then
    Begin
      OutText(X,Y-1,'rep',Buffer[1]);
      OutNumber(X-1,Y+10,RepNum[A],True,Buffer[1]);
    End;
    If mem[Melody.DataSeg:Offset]>=128 then
    Begin
      MeziVysledek:=mem[Melody.DataSeg:Offset]-128;
      OutText(X+5,Y-1,'m',Buffer[1]);
      If MeziVysledek<10 then OutNumber(X+6,Y+9,MeziVysledek,True,Buffer[1]);
      If ((MeziVysledek>=10) and (MeziVysledek<100)) then OutNumber(X+4,Y+9,MeziVysledek,True,Buffer[1]);
      If MeziVysledek>=100 then OutNumber(X+1,Y+9,MeziVysledek,True,Buffer[1]);
    End;
    If ((A=0) and (NotDrums=0)) then
    Begin
      If Mem[Melody.DataSeg:Offset]<120 then
      OutNumber(X+2,Y+4,Mem[Melody.DataSeg:Offset],False,Buffer[1]);
    End else
    Begin
      If Mem[Melody.DataSeg:Offset]<120 then
      Begin
        OutNumber(X+3,Y+11,Mem[Melody.DataSeg:Offset],True,Buffer[1]);
        Oktava:=Trunc(Mem[Melody.DataSeg:Offset]/12);
        OutNumber(X,Y+1,Oktava,False,Buffer[1]);
        Mezivysledek:=Oktava*12;
        Nota:=Mem[Melody.DataSeg:Offset]-Mezivysledek;
        Case Nota of
          0: Begin OutText(X+6,Y,'C',Buffer[1]); End;
          1: Begin OutText(X+6,Y,'C',Buffer[1]); WriteKros(X+12,Y+1); End;
          2: Begin OutText(X+6,Y,'D',Buffer[1]); End;
          3: Begin OutText(X+6,Y,'D',Buffer[1]); WriteKros(X+12,Y+1); End;
          4: Begin OutText(X+6,Y,'E',Buffer[1]); End;
          5: Begin OutText(X+6,Y,'F',Buffer[1]); End;
          6: Begin OutText(X+6,Y,'F',Buffer[1]); WriteKros(X+12,Y+1); End;
          7: Begin OutText(X+6,Y,'G',Buffer[1]); End;
          8: Begin OutText(X+6,Y,'G',Buffer[1]); WriteKros(X+12,Y+1); End;
          9: Begin OutText(X+6,Y,'A',Buffer[1]); End;
         10: Begin OutText(X+6,Y,'A',Buffer[1]); WriteKros(X+12,Y+1); End;
         11: Begin OutText(X+6,Y,'H',Buffer[1]); End;
        End; {Case End}
      End;
    End;
  End;

  If ShowHelp1=True then
  Begin
    Blok(0,127,319,179,254,Buffer[1]);
    OutText(10,130,'N=kanal0=bici/midi',Buffer[1]);
    If NotDrums=1 then OutText(120,130,'(nastaveno midi)',Buffer[1])
                  else OutText(120,130,'(nastaveno bici)',Buffer[1]);
    OutText(10,140,'B=nastavit zacatek',Buffer[1]);
    OutText(10,150,'R=nastavit repetici',Buffer[1]);
    OutText(10,160,'m=mezera, pgup,pgdn=+/-mezera, Q,W=+/-mezera',Buffer[1]);
    OutText(10,180,'mezernik=drum',Buffer[1]);
    OutText(98,180,'del=smazat',Buffer[1]);
    OutText(166,180,'P=play',Buffer[1]);
    OutText(210,180,'S=setup nastroju',Buffer[1]);
    OutText(10,170,'pgup,pgdown=oktava+/-',Buffer[1]);
    OutText(268,170,'F2=SAVE',Buffer[1]);
    OutText(210,170,'Esc=EXIT',Buffer[1]);
  End;

  For I:=0 to 11 do Blok(10+I*25,190,10+I*25+23,199,249,Buffer[1]);
  X:=11;
  Y:=191;
  OutText(X,Y,'C=C',Buffer[1]);
  Inc(X,25);
  OutText(X,Y,'C=C',Buffer[1]); WriteKros(X+18,Y+1);
  Inc(X,25);
  OutText(X,Y,'D=D',Buffer[1]);
  Inc(X,25);
  OutText(X,Y,'D=D',Buffer[1]); WriteKros(X+18,Y+1);
  Inc(X,25);
  OutText(X,Y,'E=E',Buffer[1]);
  Inc(X,25);
  OutText(X,Y,'F=F',Buffer[1]);
  Inc(X,25);
  OutText(X,Y,'F=F',Buffer[1]); WriteKros(X+18,Y+1);
  Inc(X,25);
  OutText(X,Y,'G=G',Buffer[1]);
  Inc(X,25);
  OutText(X,Y,'G=G',Buffer[1]); WriteKros(X+18,Y+1);
  Inc(X,25);
  OutText(X,Y,'A=A',Buffer[1]);
  Inc(X,25);
  OutText(X,Y,'A=A',Buffer[1]); WriteKros(X+18,Y+1);
  Inc(X,25);
  OutText(X,Y,'H=H',Buffer[1]);
End;


Procedure WriteMelScreen;
Begin
  WaitRetrace;
  FlipPage(Buffer[1],Buffer[4]);
End;


Procedure EditMel;
Var Ending: Boolean;
    I: Byte;
Begin
  Ending:=False;
  MelSelectX0:=0;
  MelSelectX1:=0;
  MelSelectX2:=0;
  MelSelectY:=0;
  Cis:=False;
  Dis:=False;
  Fis:=False;
  Gis:=False;
  His:=False;
  DrumNote:=35;
  ZalohaDrumNote:=35;
  For I:=0 to 7 do CountRepNum(I);
  ShowHelp1:=False;
  SetupMelScreen;
  Repeat
    WriteMelScreen;

{Left}  If Key[75]=True then
        Begin
          While Key[75]=True do WaitButton(75);
          If MelSelectX0>0 then Dec(MelSelectX0);
          If MelSelectX2=0 then If MelSelectX1>0 then Dec(MelSelectX1);
          If MelSelectX2>0 then Dec(MelSelectX2);
          SetupMelScreen;
        End;

{Right} If Key[77]=True then
        Begin
          While Key[77]=True do WaitButton(77);
          If MelSelectX0<2999 then Inc(MelSelectX0);
          If MelSelectX2=14 then If MelSelectX1<2985 then Inc(MelSelectX1);
          If MelSelectX2<14 then Inc(MelSelectX2);
          SetupMelScreen;
        End;

{Up}    If Key[72]=True then
        Begin
          While Key[72]=True do WaitButton(72);
          If MelSelectY>0 then Dec(MelSelectY);
          SetupMelScreen;
        End;

{Down}  If Key[80]=True then
        Begin
          While Key[80]=True do WaitButton(80);
          If MelSelectY<7 then Inc(MelSelectY);
          SetupMelScreen;
        End;

{C}     If Key[46]=True then
        Begin
          While Key[46]=True do Begin End;
          If Cis=False then
          Begin
            Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=
            Melody.Kanal[MelSelectY].DefaultOktava*12+0;
            Cis:=True;
          End else
          Begin
            Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=
            Melody.Kanal[MelSelectY].DefaultOktava*12+1;
            Cis:=False;
          End;
          For I:=0 to 7 do CountRepNum(I);
          SetupMelScreen;
        End;

{D}     If Key[32]=True then
        Begin
          While Key[32]=True do Begin End;
          If Dis=False then
          Begin
            Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=
            Melody.Kanal[MelSelectY].DefaultOktava*12+2;
            Dis:=True;
          End else
          Begin
            Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=
            Melody.Kanal[MelSelectY].DefaultOktava*12+3;
            Dis:=False;
          End;
          For I:=0 to 7 do CountRepNum(I);
          SetupMelScreen;
        End;

{E}     If Key[18]=True then
        Begin
          While Key[18]=True do Begin End;
          Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=
          Melody.Kanal[MelSelectY].DefaultOktava*12+4;
          For I:=0 to 7 do CountRepNum(I);
          SetupMelScreen;
        End;

{F}     If Key[33]=True then
        Begin
          While Key[33]=True do Begin End;
          If Fis=False then
          Begin
            Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=
            Melody.Kanal[MelSelectY].DefaultOktava*12+5;
            Fis:=True;
          End else
          Begin
            Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=
            Melody.Kanal[MelSelectY].DefaultOktava*12+6;
            Fis:=False;
          End;
          For I:=0 to 7 do CountRepNum(I);
          SetupMelScreen;
        End;

{G}     If Key[34]=True then
        Begin
          While Key[34]=True do Begin End;
          If Gis=False then
          Begin
            Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=
            Melody.Kanal[MelSelectY].DefaultOktava*12+7;
            Gis:=True;
          End else
          Begin
            Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=
            Melody.Kanal[MelSelectY].DefaultOktava*12+8;
            Gis:=False;
          End;
          For I:=0 to 7 do CountRepNum(I);
          SetupMelScreen;
        End;

{A}     If Key[30]=True then
        Begin
          While Key[30]=True do Begin End;
          If His=False then
          Begin
            Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=
            Melody.Kanal[MelSelectY].DefaultOktava*12+9;
            His:=True;
          End else
          Begin
            Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=
            Melody.Kanal[MelSelectY].DefaultOktava*12+10;
            His:=False;
          End;
          For I:=0 to 7 do CountRepNum(I);
          SetupMelScreen;
        End;

{H}     If Key[35]=True then
        Begin
          While Key[35]=True do Begin End;
          Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=
          Melody.Kanal[MelSelectY].DefaultOktava*12+11;
          For I:=0 to 7 do CountRepNum(I);
          SetupMelScreen;
        End;

{Space} If Key[57]=True then
        Begin
          While Key[57]=True do Begin End;
          If ((MelSelectY=0) and (NotDrums=0)) then
          Begin
            Mem[Melody.DataSeg:MelSelectX0]:=DrumNote;
            For I:=0 to 7 do CountRepNum(I);
            SetupMelScreen;
          End;
        End;

{del}   If Key[83]=True then
        Begin
          While Key[83]=True do Begin End;
          If Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]=121 then
          Begin
            For I:=0 to 7 do Mem[Melody.DataSeg:I*3000+MelSelectX0]:=120;
            Melody.Repetice:=0;
          End;
          Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=120;
          For I:=0 to 7 do CountRepNum(I);
          SetupMelScreen;
        End;

{P}     If Key[25]=True then
        Begin
          While Key[25]=True do Begin End;
          SetupGM;
          StartPlayScreen;
          SetupMelScreen;
        End;

{S}     If Key[31]=True then
        Begin
          While Key[31]=True do Begin End;
          StopGMPlay;
          SetupNastroju;
          SetupMelScreen;
        End;

{M}     If Key[50]=True then
        Begin
          While Key[50]=True do Begin End;
          Case MezeraCounter of
            1: Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=128+1;
            2: Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=128+3;
            3: Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=128+7;
            4: Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=128+15;
            5: Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=128+31;
            6: Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=128+63;
            7: Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=128+127;
          End; {Case End}
          For I:=0 to 7 do CountRepNum(I);
          SetupMelScreen;
        End;

{B}     If Key[48]=True then
        Begin
          While Key[48]=True do Begin End;
          StartNum:=MelSelectX0;
          For I:=0 to 7 do CountRepNum(I);
          SetupMelScreen;
        End;

{R}     If Key[19]=True then
        Begin
          While Key[19]=True do Begin End;
          If Melody.Repetice>0 then
          For I:=0 to 7 do
          If Mem[Melody.DataSeg:I*3000+Melody.Repetice]=121 then
          Mem[Melody.DataSeg:I*3000+Melody.Repetice]:=120;
          For I:=0 to 7 do Mem[Melody.DataSeg:I*3000+MelSelectX0]:=121;
          Melody.Repetice:=MelSelectX0;
          For I:=0 to 7 do CountRepNum(I);
          SetupMelScreen;
        End;

{PgUp}  If Key[73]=True then
        Begin
          While Key[73]=True do Begin End;
          If ((MelSelectY>0) and (Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]<120)) then
          If Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]<108 then
          Inc(Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0],12);
          If Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]>=128 then
          Begin
            If MezeraCounter<7 then Inc(MezeraCounter)
                               else MezeraCounter:=1;
            Case MezeraCounter of
              1: Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=128+1;
              2: Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=128+3;
              3: Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=128+7;
              4: Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=128+15;
              5: Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=128+31;
              6: Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=128+63;
              7: Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=128+127;
            End; {Case End}
          End;
          For I:=0 to 7 do CountRepNum(I);
          SetupMelScreen;
        End;

{PgDn}  If Key[81]=True then
        Begin
          While Key[81]=True do Begin End;
          If ((MelSelectY>0) and (Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]<120)) then
          If Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]>=12 then
          Dec(Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0],12);
          If Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]>=128 then
          Begin
            If MezeraCounter>1 then Dec(MezeraCounter)
                               else MezeraCounter:=7;
            Case MezeraCounter of
              1: Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=128+1;
              2: Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=128+3;
              3: Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=128+7;
              4: Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=128+15;
              5: Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=128+31;
              6: Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=128+63;
              7: Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]:=128+127;
            End; {Case End}
          End;
          For I:=0 to 7 do CountRepNum(I);
          SetupMelScreen;
        End;

{Q}     If Key[16]=True then
        Begin
          While Key[16]=True do WaitButton(16);
          If Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]>=128 then
          Begin
            If Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]>129 then
            Dec(Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]);
          End;
          For I:=0 to 7 do CountRepNum(I);
          SetupMelScreen;
        End;

{W}     If Key[17]=True then
        Begin
          While Key[17]=True do WaitButton(17);
          If Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]>=128 then
          Begin
            If Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]<255 then
            Inc(Mem[Melody.DataSeg:MelSelectY*3000+MelSelectX0]);
          End;
          For I:=0 to 7 do CountRepNum(I);
          SetupMelScreen;
        End;

{N}   If Key[49]=True then
      Begin
        While Key[49]=True do Begin End;
        If NotDrums=0 then Begin
                             NotDrums:=1;
                             ZalohaDrumNote:=DrumNote;
                             Melody.Kanal[0].Nastroj:=ZalohaNastroj0;
                             End
                      else Begin
                             NotDrums:=0;
                             DrumNote:=ZalohaDrumNote;
                             ZalohaNastroj0:=Melody.Kanal[0].Nastroj;
                           End;
        SetupMelScreen;
      End;

{F1}  If Key[59]=True then
      Begin
        While Key[59]=True do Begin End;
        If ShowHelp1=True then ShowHelp1:=False
                          else ShowHelp1:=True;
        SetupMelScreen;
        WriteMelScreen;
      End;

{F2}  If Key[60]=True then
      Begin
        While Key[60]=True do Begin End;
        CountMelodyLenght;
        SaveMELFile(FileName);
        SoundDone;
      End;

{Esc}   If Key[1]=True then
        Begin
          While Key[1]=True do Begin End;
          Ending:=True;
          StopGMPlay;
        End;

  Until Ending=True;
End;
