Procedure FPSTrigg;
Begin
  If FPS2s=True then Inc(fps.frame)
                else Begin
                       If fps.frame>0 then fps.fps:=fps.frame;
                       fps.frame:=0;
                     End;
  fps.trvani:=Stopky_GetNumber;
  If fps.trvani>fps.trvaniTarget
  then begin
         If fps.prodleva>0 then Dec(fps.prodleva);
       end
  else begin
         If fps.prodleva<65535 then Inc(fps.prodleva);
       end;
End;