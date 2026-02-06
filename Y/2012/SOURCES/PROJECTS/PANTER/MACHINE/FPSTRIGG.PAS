Procedure FPSTrigg;
Begin
  If FPS2s=True
  then Inc(fps.frame)
  else If fps.frame>0 then
       Begin
         fps.count:=fps.frame;
         fps.frame:=0;
       End;
  If Graphics.vSync=False then
  Begin
    fps.trvani:=Stopky_GetNumber;
    If fps.trvani>fps.trvaniTarget
    then begin
           If Graphics.ShowGame=True then
           Begin
             If fps.prodleva>0 then Dec(fps.prodleva);
           End;
           If Graphics.ShowMenu=True then
           Begin
             If fps.prodlevamenu>0 then Dec(fps.prodlevamenu);
           End;
         end
    else begin
           If Graphics.ShowGame=True then
           Begin
             If fps.prodleva<65535 then Inc(fps.prodleva);
           End;
           If Graphics.ShowMenu=True then
           Begin
             If fps.prodlevamenu<65535 then Inc(fps.prodlevamenu);
           End;
         end;
  End;
End;
