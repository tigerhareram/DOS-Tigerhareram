procedure _Chcipni(NaCo:byte);
{pomocna procedura pro zobrazovani chybovych hlasek (usetri psani i pamet)}
var txt:string;
Begin
case NaCo of
 0:txt:='Vase graficka karta nema VESA rozhrani, ktere je pro spusteni tohoto programu potreba. /'
       +' Your graphic card doesn''t support VESA interface needed by this program.';
 1:txt:='Neni dost zakladni pameti na pomocny buffer. / Not enough memory for a temporary buffer.';
 2:txt:='Vase graficka karta nepodporuje pozadovany rezim. / Your graphic card doesn''t support the desired graphic mode.';
 3:txt:='Nepodarilo se spustit pozadovany graficky rezim. / The desired graphic mode couldn''t be started.';
 end;
writeln;
writeln('Stiskni Enter / Press Enter');
readln;
halt;
End;{_chcipni}
