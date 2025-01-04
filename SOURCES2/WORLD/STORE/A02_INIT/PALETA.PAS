Procedure SetPalette;
Begin
  {paleta fixy}
  P16_SetPal(ColX[0],0,0,0);         { ColX[0]  = black }
  P16_SetPal(ColX[1],57,5,3);        { ColX[1]  = red   }
  P16_SetPal(ColX[2],45,50,39);      { ColX[2]  = gray  }

  P16_SetPal(ColX[5],63,63,0);       { ColX[]  = slunce }
  P16_SetPal(ColX[6],55,10,3);       { ColX[]  = merkur }
  P16_SetPal(ColX[7],55,25,40);      { ColX[]  = venuse }
  P16_SetPal(ColX[8],5,7,60);        { ColX[]  = zeme   }
  P16_SetPal(ColX[9],30,49,12);      { ColX[]  = mars   }
  P16_SetPal(ColX[10],63,25,15);     { ColX[]  = jupiter }
  P16_SetPal(ColX[11],60,27,12);     { ColX[]  = saturn }
  P16_SetPal(ColX[12],15,23,48);     { ColX[]  = uran }
  P16_SetPal(ColX[13],11,20,55);     { ColX[]  = neptun }
  P16_SetPal(ColX[14],30,35,27);     { ColX[]  = mesic }

  P16_SetPal(ColX[15],12,35,7);      { ColX[15] = text  }
End;