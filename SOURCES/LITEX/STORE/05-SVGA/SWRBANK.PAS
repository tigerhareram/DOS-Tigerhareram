procedure _SwitchRBank(bank:word); assembler;
{jako _Switchbank, ale pro cteci okno}
Asm
mov AX,bank
mul _granularity
mov DX,AX
mov BX,_cteciokno
mov AX,$4F05
call __switchbank
End;{_switchrbank}
