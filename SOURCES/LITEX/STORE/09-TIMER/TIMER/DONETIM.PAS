procedure Timer_Done;
begin
  { Restore the normal clock frequency }
  Port[$43] := $34;
  Port[$40] := 0;
  Port[$40] := 0;

  { Restore the normal ticker handler }
  SetIntVec($1C, @BIOSTimerHandler);
end;