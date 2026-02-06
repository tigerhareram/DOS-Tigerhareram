procedure _SwitchBank(bank:word); assembler;
{Prepne do zadane banky (cislovani zacina od 0, kazda dalsi banka zacina vzdy
za koncem te predchozi). Obvykle se o bankovani nemusite vubec starat, protoze
ho maji vsechny kreslici procedury zabudovane.
Pouze pro zapisovaci okno.}
Asm
mov AX,bank            {AX:=pozadovana banka}
mov _curbank,AX        {pro priste}
mul _granularity       {vynasobeni AX granularitou - ted je tam skutecne cislo banky}
mov DX,AX              {do DX s nim (__switchbank ho chce prave tam)}
mov BX,_zapisovaciokno {podkod sluzby - "nastav banku" a cislo okna, do ktereho kreslime}
mov AX,$4F05           {kod sluzby - "ovladani pristupu k obrazovce"}
call __switchbank      {do toho!}
End;{_switchbank}
