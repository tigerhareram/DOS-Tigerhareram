procedure TimerHandler; Interrupt;
Var r,g,b:byte; {xxx takhle se zbavime veskereho rizika kolize}
begin
{zaloha 32bitovych registru - nutne, protoze pracujeme s longinty:}
asm
db $66; push AX
db $66; push BX
db $66; push CX
db $66; push DX
end;

  { DO WHATEVER WE WANT TO DO IN HERE }

  {(8000 div 1000) , Wait ?? ms}
  If wait_enable then
  Begin
    Inc(clock1);
    if clock1 >= 8 then
    Begin
      Inc(wait_counter);
      clock1:=0;
    End;
  End;

  {(8000 div 1000) , 1kHz Stopky counter}
  If timeStops_enable then
  Begin
    Inc(clock2);
    if clock2 >= 8 then
    Begin
      Inc(timeStops_cnt);
      clock2:=0;
    End;
  End;

  {(8000 div ??) , ?? blink color [0..255] , tempo: Byte }
  Inc(clock3);
  if clock3 >= blinkFreq then
  Begin
       If blinking=True then
       Begin
          P16_GetPal(blinkCol,r,g,b);
          Case blinkFade of
            0: Begin
                 if r>0 then dec(r);
                 if g>0 then dec(g);
                 if b>0 then dec(b);
                 If n64<63 then inc(n64);
                 if n64>=63 then blinkFade:=1;
               End;
            1: Begin
                 If r<PalBack[blinkCol].R then inc(r);
                 If g<PalBack[blinkCol].G then inc(g);
                 If b<PalBack[blinkCol].B then inc(b);
                 If n64>0 then dec(n64);
                 if n64=0 then blinkFade:=0;
               End;
          End; {Case End}
          P16_SetPal(blinkCol,r,g,b);
          {xxx tohle bude zpusobovat poblikavani obrazu, protoze to jede nezavisle na vsync}
       End;
    clock3:=0;
  End;

  {(8000 div 1) , 1Hz FlipFlop = Boolean}
  Inc(clock4);
  if clock4 >= 8000 then
  Begin
    flipflop1sec:=not flipflop1sec;
    clock4:=0;
  End;

  {Loading Phase}
  If InitLoading=True then
  Begin
    Inc(clock5);
    If clock5 >= 400 then
    Begin
      SVGA_BarZ(60,8,85,21,ColX[0]);
      Case LoadingPhase of
        0: Begin
             SVGA_Pixel(60,8,ColX[1]);
             SVGA_Pixel(61,9,ColX[1]);
             SVGA_Pixel(62,10,ColX[1]);
             SVGA_Pixel(63,11,ColX[1]);
             SVGA_Pixel(64,12,ColX[1]);
           End;
        1: Begin
             SVGA_Pixel(60,10,ColX[1]);
             SVGA_Pixel(61,10,ColX[1]);
             SVGA_Pixel(62,10,ColX[1]);
             SVGA_Pixel(63,10,ColX[1]);
             SVGA_Pixel(64,10,ColX[1]);
           End;
        2: Begin
             SVGA_Pixel(60,12,ColX[1]);
             SVGA_Pixel(61,11,ColX[1]);
             SVGA_Pixel(62,10,ColX[1]);
             SVGA_Pixel(63,9,ColX[1]);
             SVGA_Pixel(64,8,ColX[1]);
           End;
        3: Begin
             SVGA_Pixel(62,8,ColX[1]);
             SVGA_Pixel(62,9,ColX[1]);
             SVGA_Pixel(62,10,ColX[1]);
             SVGA_Pixel(62,11,ColX[1]);
             SVGA_Pixel(62,12,ColX[1]);
           End;
      End; {Case End}
      If LoadingPhase<3 then Inc(LoadingPhase) else LoadingPhase:=0;
      Text_WriteDefaultFont(270,180,ColX[1],ColX[0],Buffer[2],SVGA);
      Text_WriteText(Buffer[2],270,180,5,5,1,8,8, 'loading ',Buffer[4],SVGA);
      Text_WriteText(Buffer[2],270,180,5,5,1,8,16,'time    ',Buffer[4],SVGA);
      Text_WriteNumber(Buffer[2],270,195,5,5,1,60,16,1+(Timer_Watch_GetTime div 100),Buffer[4],SVGA);
      SVGA_FlipPage;
      clock5:=0;
    End;
  End;

  {(8000 div GenFreq) , ??Hz Generator}
  If Generator=True then
  Begin
    Inc(clock6);
    if clock6 >= ((8000 div GenFreq) div 48) then
    Begin
      clock6:=0;
      Spkr_Silence;
      If GenSmer=1
      then Begin
             If GenPhase<11 then Inc(GenPhase);
             If GenPhase=11 then GenSmer:=0;
           End
      else Begin
             If GenPhase>0 then Dec(GenPhase);
             If GenPhase=0 then GenSmer:=1;
           End;
      Case GenPhase of
        0: Spkr_Sound(262);
        1: Spkr_Sound(277-GenFreq*4);
        2: Spkr_Sound(294);
        3: Spkr_Sound(311);
        4: Spkr_Sound(330);
        5: Spkr_Sound(349-GenFreq*4);
        6: Spkr_Sound(370);
        7: Spkr_Sound(392);
        8: Spkr_Sound(415);
        9: Spkr_Sound(440-GenFreq*4);
       10: Spkr_Sound(466);
       11: Spkr_Sound(494);
       12: Spkr_Sound(523);
       13: Spkr_Sound(554-GenFreq*4);
       14: Spkr_Sound(587);
       15: Spkr_Sound(622);
       16: Spkr_Sound(659);
       17: Spkr_Sound(698-GenFreq*4);
       18: Spkr_Sound(740);
       19: Spkr_Sound(784);
       20: Spkr_Sound(831);
       21: Spkr_Sound(880-GenFreq*4);
       22: Spkr_Sound(932);
       23: Spkr_Sound(988);
      End; {Case End}
    End;
  End;

  {(8000 div 100) , PC Speaker Sound}
  If sndpl_enable=True then
  Begin
    Inc(clock7);
    if clock7 >= 80 then
    Begin
      Spkr_Silence;
      Spkr_Sound(memW[BufferSND:(SND_I*200)+(sndpl_counter*2)]);
      Inc(sndpl_counter);
      clock7:=0;
      If sndpl_counter=sndpl_stopcount then
      Begin
        Spkr_Silence;
        SND_I:=0;
        clock7:=0;
        sndpl_counter:=0;
        sndpl_stopcount:=0;
        sndpl_enable:=False;
      End;
    End;
  End;

  {playback raws}
  If RAW_play=True then
  Begin
    If mem[BufferSPR:RAW_pos]>$80 then Spkr_Silence
                                  else Spkr_Sound(22000);
    If RAW_pos<RAW_lenght-1 then Inc(RAW_pos)
                            else Begin
                                   Spkr_Silence;
                                   If RAW_repeat=False then RAW_play:=False
                                                       else RAW_pos:=0;
                                 End;
  End;

  { XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX }

  { Adjust the count of clock ticks }
  clock_ticks := clock_ticks + counter;

  { Is it time for the BIOS handler to do it's thang? }
  if clock_ticks >= $10000 then
    begin

      { Yep! So adjust the count and call the BIOS handler }
      clock_ticks := clock_ticks - $10000;

      asm pushf end;
      BIOSTimerHandler;
    end;

  {acknowledge the interrupt }
  Port[$20] := $20;

asm {obnova zalohy}
db $66; pop DX
db $66; pop CX
db $66; pop BX
db $66; pop AX
end;
end;
