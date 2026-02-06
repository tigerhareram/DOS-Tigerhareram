procedure _NouzovySwitchbank; far; assembler; {nouzovka pro pripad, kdy od karty nedostaneme adresu bankovaci procedury}
Asm
int $10 {nastaveni registru je stejne jako pro tu specialni proceduru}
End;{_nouzovyswitchbank}
