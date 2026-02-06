{       SMIX is Copyright 1995 by Ethan Brodsky.  All rights reserved.       }
program MixTest;
  uses
    CRT,
    Detect,
    SMix;
  const
    XMSRequired   = 200;    {XMS memory required to load the sounds (KBytes) }
    SharedEMB     = true;
      {TRUE:   All sounds will be stored in a shared EMB}
      {FALSE:  Each sound will be stored in a separate EMB}
    NumSounds = 6;
  var
    BaseIO: word; IRQ, DMA, DMA16: byte;
    Sound: array[0..NumSounds-1] of PSound;
    OldExitProc: pointer;

  function HexW(W: word): string; {Word}
    const
      HexChars: array [0..$F] of Char = '0123456789ABCDEF';
    begin
      HexW :=
{        HexChars[(W and $F000) shr 12] +}
        HexChars[(W and $0F00) shr 8]  +
        HexChars[(W and $00F0) shr 4]  +
        HexChars[(W and $000F)];
    end;

  procedure OurExitProc; far;
   {If the program terminates with a runtime error before the extended memory}
   {is deallocated, then the memory will still be allocated, and will be lost}
   {until the next reboot.  This exit procedure is ALWAYS called upon program}
   {termination and will deallocate extended memory if necessary.            }
    var
      i: byte;
    begin
      for i := 0 to NumSounds-1 do
        if Sound[i] <> nil then FreeSound(Sound[i]);
      if SharedEMB then ShutdownSharing;
      ExitProc := OldExitProc; {Chain to next exit procedure}
    end;

  procedure LoadSounds;
    var
      i: integer;
    begin
      if not(InitXMS)
        then
          begin
            writeln('Error initializing extended memory');
            writeln('HIMEM.SYS must be installed');
            Halt(3); {XMS driver not installed}
          end
        else
          begin
            writeln('Extended memory succesfully initialized');
            write('Free XMS memory:  ', GetFreeXMS, 'k  ');
            if GetFreeXMS < XMSRequired
              then
                begin
                  writeln('Insufficient free XMS');
                  writeln('You are probably running MIXTEST from the protected mode IDE');
                  writeln('Run it from the command line or read the documentation');
                  Halt(4); {Insufficient XMS memory}
                end
              else
                begin
                  writeln('Loading sounds');
                  if SharedEMB then InitSharing;

                  if not(OpenSoundResourceFile('MIXTEST.SND'))
                    then
                      begin
                        writeln('Error loading sound resource file');
                        Halt(5); {Sound resource file does not exist}
                      end;


                  LoadSound(Sound[0], 'JET');
                  LoadSound(Sound[0], 'SINE');
                  LoadSound(Sound[1], 'GUN');
                  LoadSound(Sound[2], 'CRASH');
                  LoadSound(Sound[3], 'CANNON');
                  LoadSound(Sound[4], 'LASER');
                  LoadSound(Sound[5], 'GLASS');

                  CloseSoundResourceFile;

                  OldExitProc := ExitProc;
                  ExitProc := @OurExitProc;
                end
          end;
    end;

  procedure FreeSounds;
    var
      i: integer;
    begin
      for i := 0 to NumSounds-1 do
        FreeSound(Sound[i]);
      if SharedEMB then ShutdownSharing;
    end;

  procedure Init;
    begin
      writeln;
      writeln('-------------------------------------------');
      writeln('Sound Mixing Library v1.30 by Ethan Brodsky');
      if not(GetSettings(BaseIO, IRQ, DMA, DMA16))
        then
          begin
            writeln('Error initializing:  Invalid or non-existant BLASTER environment variable');
            Halt(1); {BLASTER environment variable invalid or non-existant}
          end;

      if not(InitSB(BaseIO, IRQ, DMA, DMA16))
        then
          begin
            writeln('Error initializing sound card');
            writeln('Incorrect base IO address, sound card not installed, or broken');
            Halt(2); {Sound card could not be initialized}
          end;

      writeln('BaseIO=', HexW(BaseIO), 'h     IRQ', IRQ, '     DMA8=', DMA, '     DMA16=', DMA16);
      write('DSP version ', DSPVersion shr 8, '.', DSPVersion and $FF, ':  ');

      if SixteenBit
        then write('16-bit, ')
        else write('8-bit, ');
      if AutoInit
        then writeln('Auto-initialized')
        else writeln('Single-cycle');

      InitMixing;
      writeln;
    end;

  procedure Shutdown;
    begin
      ShutdownMixing;
      ShutdownSB;

      writeln;
    end;

  var
    Counter: LongInt;
    InKey: char;
    Stop: boolean;
    Num: byte;
    Temp: integer;
    Jet: boolean;
    RandSounds: boolean;
    Rate: word;
  begin
    Randomize;

    Init;

    LoadSounds;

    writeln('Press:');
    writeln(' J  Toggle jet engine');
    writeln(' R  Toggle random sounds');
    writeln(' 1  Machine Gun');
    writeln(' 2  Crash');
    writeln(' 3  Cannon');
    writeln(' 4  Laser');
    writeln(' 5  Breaking glass');
    writeln(' <  Reduce sampling rate');
    writeln(' >  Increase sampling rate');
    writeln(' Q  Quit');

    Stop := false;
    Counter := 0;
    Jet        := false;
    RandSounds := true;
    Rate       := 22000;

    repeat
     {Display counters}
      Inc(Counter);
      write(Counter:8, IntCount:8, VoiceCount:4, Rate:8);
      GotoXY(1, WhereY);


     {Maybe start a random sound}
      if RandSounds and (Random(64000) = 0)
        then
          begin
            Num := Random(NumSounds-1)+1;
            StartSound(Sound[Num], Num, false);
          end;

     {Start a sound if a key is pressed}
      if KeyPressed
        then
          begin
            InKey := ReadKey;
              case InKey
                of
                  'J', 'j':
                    begin
                      Jet := not(Jet);
                      If Jet
                        then StartSound(Sound[0], 0, true)
                        else StopSound(0);
                    end;

                  'R', 'r':
                    RandSounds := not(RandSounds);

                  '0'..'9':
                    begin
                      Val(InKey, Num, Temp);
                      if Num < NumSounds
                        then
                          StartSound(Sound[Num], Num, false);
                    end;

                  '<', ',':
                    begin
                      Rate := Rate - 250;
                      if (Rate < 5000) then Rate := 5000;
                      SetSamplingRate(Rate);
                    end;

                  '>', '.':
                    begin
                      Rate := Rate + 250;
                      if (Rate > 48000) then Rate := 48000;
                      SetSamplingRate(Rate);
                    end;

                  else
                    Stop := true;
                end;
          end;
    until Stop;

    writeln;

    if Jet then
      StopSound(0);

    Shutdown;

    FreeSounds;
  end.
