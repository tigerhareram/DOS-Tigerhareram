procedure _SetActivePage(kterou:byte);
{Presmeruje kresleni na danou stranku. Parametr je pocitany od nuly a muze byt
jenom tak velky, aby na to vystacila videopamet (obvykle se stejne pouzivaji
jenom stranky 0 a 1).}
Begin
__lhy:=(_maxy+1)*kterou;
End;{_setactivepage}
