Procedure XVGA_DoneImage(ObjectNumber: Word);
begin
clearimage(Img[ObjectNumber].Point);
closeimage(Img[ObjectNumber].Point);
end;
