Procedure UpdateTlacitka;
Var I: Byte;
Begin
  For I:=0 to 4 do
  If Button[I].Phase=0 then WriteBlok(8+I*42,184,160,I*16,199,I*16+15,Buffer[1],Buffer[3])
                       else WriteBlok(8+I*42,184,200,I*16,239,I*16+15,Buffer[1],Buffer[3]);
  {FlipTlacitka;}
  WriteBlok(0,184,0,184,215,199,Buffer[3],Buffer[4]);
End;