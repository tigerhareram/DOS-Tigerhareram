function setRecNode(adrStr: string): boolean;
 { Vraci: TRUE=OK, recNode nastaveno; FALSE=Chyba syntaxe }
 var
     i: byte;
     s: string;
     r,value: integer;
 begin
   adrStr:=adrStr+'.';
   for i:=0 to 5 do
    begin
      s:=copy(adrStr,1,Pos('.',adrStr)-1);
      Val(s,value,r);
      if (r<>0) or (value<0) or (value>255) then
       begin setRecNode:=FALSE; Exit; end;
      recNode[i]:=value;
      delete(adrStr,1,Length(s)+1);
    end;
   setRecNode:=TRUE;
 end;
