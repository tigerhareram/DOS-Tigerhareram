Procedure SVGA_WaitRetrace; Assembler;
Asm
    Mov dx,3DAh
@l1:            {\  Tenhle cyklus ceka na konec prave probihajici         }
    In  al,dx   { \ synchronizace, pokud uz ji cast probehla. VGA je dost }
    And al,08h  { / rychla na to, aby to nebylo potreba - muzes vyradit,  }
    Jnz @l1     {/  trochu se to tim zrychli.                             }
@l2:              {\                                                     }
    In al,dx      { \ Tenhle cyklus ceka na zacatek pristi synchronizace }
    And al,08h    { / (nutne, nemazat).                                  }
    Jz  @l2       {/                                                     }
End;