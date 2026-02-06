Procedure KresliValce2;
Begin
  If WinConf.Symbol[1]=1 then WriteSymbol(0,Valec[0].Scroll,Valec[0].Symbol[1],False,0,0)
                         else WriteSymbol(0,Valec[0].Scroll,Valec[0].Symbol[1],True,0,0);
  If WinConf.Symbol[2]=1 then WriteSymbol(40,Valec[1].Scroll,Valec[1].Symbol[1],False,0,0)
                         else WriteSymbol(40,Valec[1].Scroll,Valec[1].Symbol[1],True,0,0);
  If WinConf.Symbol[3]=1 then WriteSymbol(80,Valec[2].Scroll,Valec[2].Symbol[1],False,0,0)
                         else WriteSymbol(80,Valec[2].Scroll,Valec[2].Symbol[1],True,0,0);
  If WinConf.Symbol[4]=1 then WriteSymbol(0,Valec[0].Scroll+32,Valec[0].Symbol[2],False,0,0)
                         else WriteSymbol(0,Valec[0].Scroll+32,Valec[0].Symbol[2],True,0,0);
  If WinConf.Symbol[5]=1 then WriteSymbol(40,Valec[1].Scroll+32,Valec[1].Symbol[2],False,0,0)
                         else WriteSymbol(40,Valec[1].Scroll+32,Valec[1].Symbol[2],True,0,0);
  If WinConf.Symbol[6]=1 then WriteSymbol(80,Valec[2].Scroll+32,Valec[2].Symbol[2],False,0,0)
                         else WriteSymbol(80,Valec[2].Scroll+32,Valec[2].Symbol[2],True,0,0);
  If WinConf.Symbol[7]=1 then WriteSymbol(0,Valec[0].Scroll+64,Valec[0].Symbol[3],False,0,0)
                         else WriteSymbol(0,Valec[0].Scroll+64,Valec[0].Symbol[3],True,0,0);
  If WinConf.Symbol[8]=1 then WriteSymbol(40,Valec[1].Scroll+64,Valec[1].Symbol[3],False,0,0)
                         else WriteSymbol(40,Valec[1].Scroll+64,Valec[1].Symbol[3],True,0,0);
  If WinConf.Symbol[9]=1 then WriteSymbol(80,Valec[2].Scroll+64,Valec[2].Symbol[3],False,0,0)
                         else WriteSymbol(80,Valec[2].Scroll+64,Valec[2].Symbol[3],True,0,0);
End;