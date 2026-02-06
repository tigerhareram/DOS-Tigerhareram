procedure Timer_Init;
Var I: Byte;
    N: Byte;
begin
  { Do some initialization }
  clock_ticks := 0;
  counter := $1234DD div 8000;

  { User function initialization }
  clock1:=0;
  clock2:=0;
  clock3:=0;
  clock4:=0;
  clock5:=0;
  clock6:=0;

  blinking:=False;
  For I:=0 to 255 do
  Begin
    For N:=1 to 3 do Tmp[I,N]:=0;
  End;

  { color blinking }
  blinkFreq:=128;

  { Store the current BIOS handler and set up our own }
  GetIntVec($1C, @BIOSTimerHandler);
  SetIntVec($1C, Addr(TimerHandler));

  { Set the PIT channel 0 frequency }
  Port[$43] := $34;
  Port[$40] := counter mod 256;
  Port[$40] := counter div 256;
end;