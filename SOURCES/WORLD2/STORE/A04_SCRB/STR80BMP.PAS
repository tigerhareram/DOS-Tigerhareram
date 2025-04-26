Procedure Str80BMP(Cesta:String;x,y,x1size,y1size,x2size,y2size:Word);
Begin
  If Scan_Toggle=True then MAP_WriteSVGAComplet(Buffer[3]);
  If Scan_Toggle=True then SVGA_SprZ(ScanX,ScanY,ScanSizeX1,ScanSizeY1,ScanSizeX2,ScanSizeY2,0,Buffer[2]);

  LoadBMPFile(Cesta,0,0,0,0,Buffer[3]);
  VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[2]);
  SVGA_SprZ(x,y,x1size,y1size,x2size,y2size,1,Buffer[2]);
End;
