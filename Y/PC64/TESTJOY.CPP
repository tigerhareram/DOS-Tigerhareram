// TESTJOY.CPP (Visual C++ 1.00) -- Test for analog IBM joystick A

#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include <string.h>
#include <dos.h>

#if MASTER
  #ifndef NDEBUG
    #error Bitte schalten Sie die Build Options auf RELEASE!
  #endif
#endif

typedef unsigned char byte;
typedef unsigned short word;
typedef unsigned int uint;
typedef unsigned long dword;
typedef enum {FALSE, TRUE} flag;

void Delay(int iTicks) {
  iTicks += *(int __far*)0x0040006C;
  while (iTicks - *(int __far*)0x0040006C > 0);
}

word wAX, wAY, wBX, wBY, wFire;

#pragma optimize("leg", off)
void BIOSJoy() {
  __asm {
    mov AH,84h
    mov DX,1
    int 15h
    mov wAX,AX
    mov wAY,BX
    mov wBX,CX
    mov wBY,DX
    mov AH,84h
    mov DX,0
    int 15h
    xor AH,AH
    mov wFire,AX
  }
}
#pragma optimize("", on)

#pragma optimize("leg", off)
void DirectJoy() {
  __asm {
    cli
    mov DX,0201h
    in AL,DX
    xor AH,AH
    mov wFire,AX
    and AL,00001111b
    mov BL,AL
    xor CX,CX
    mov AH,00001111b
    out DX,AL
    in AL,DX
    in AL,DX
    in AL,DX
  Next:
    inc CX
    je TimeOut
    in AL,DX
    and AL,00001111b
    xor AL,AH
    je Next
    test AL,0001b
    je NoAX
    mov wAX,CX
  NoAX:
    test AL,0010b
    je NoAY
    mov wAY,CX
  NoAY:
    test AL,0100b
    je NoBX
    mov wBX,CX
  NoBX:
    test AL,1000b
    je NoBY
    mov wBY,CX
  NoBY:
    xor AH,AL
    cmp AH,BL
    jne Next
    sti
    jmp Return
  TimeOut:
    sti
    mov wAX,65535
    mov wAY,65535
    mov wBX,65535
    mov wBY,65535
  Return:
  }
}
#pragma optimize("", on)

#pragma optimize("leg", off)
void Cursor(flag fOn) {
  __asm {
    mov AH,03h
    int 10h
    or CH,20h
    cmp fOn,0
    je Off
    and CH,not 20h
  Off:
    mov AH,01h
    int 10h
  }
}
#pragma optimize("", on)

int main(int, char**) {
  #ifdef DEBUG
    _bdos(0x0D, 0, 0);
  #endif
  int i = _inp(0x0201);
  printf("Start  = %02X", i);
  if (i == 0xFC || i == 0xF0) {
    printf(" (OK)\n");
  } else {
    #if GERMAN
      printf(" (stimmt nicht, ist ein Joystick angeschlossen?)\n");
    #else
      printf(" (that's wrong, is a joystick connected?)\n");
    #endif
  }
  _outp(0x0201, 0);
  i = _inp(0x0201);
  printf("Output = %02X", i);
  if (i == 0xFF) {
    printf(" (OK)\n");
  } else {
    #if GERMAN
      printf(" (stimmt nicht, ist ein Gameport-Adapter vorhanden?)\n");
    #else
      printf(" (that's wrong, is a gameport adapter present?)\n");
    #endif
  }
  Delay(18);
  i = _inp(0x0201);
  printf("Delay  = %02X", i);
  if (i == 0xFC || i == 0xF0) {
    printf(" (OK)\n");
  } else {
    #if GERMAN
      printf(" (stimmt nicht, ist ein Joystick angeschlossen?)\n");
    #else
      printf(" (that's wrong, is a joystick connected?)\n");
    #endif
  }
  DirectJoy();
  if ((wAX | wAY) == 65535) {
    #if GERMAN
      printf("Timeout-Fehler in DirectJoy(), Joystick kann nicht gelesen werden!\n");
    #else
      printf("timeout error in DirectJoy(), cannot read joystick!\n");
    #endif
    exit(1);
  }
  word wDX = (word)((dword)wAX * 5 / 16);
  word wDY = (word)((dword)wAY * 5 / 16);
  word wOben   = wAY - wDY;
  word wUnten  = wAY + wDY;
  word wLinks  = wAX - wDX;
  word wRechts = wAX + wDX;
  #if GERMAN
    printf("\n\
Berechne Schwellwerte fÅr Joystick A. Ruhestellung X=%u Y=%u, mal 5/16 macht\n\
dX=%u dY=%u. Ruhestellung plus/minus Schwellwerte ergeben die Grenzwerte fÅr\n\
die Umwandlung von analog nach digital:\n\
\n\
       Y<%u\n\
\n\
  X<%-5u   X>%u\n\
\n\
       Y>%u\n\
\n\
Bitte bewegen Sie jetzt den Joystick A. Die Werte X= und Y= mÅssen sich bei\n\
Bewegungen in Richtung links oben verringern, und bei rechts unten vergrî·ern.\n\
Wenn die errechneten Grenzwerte Åberschritten werden, wird die digitale\n\
RichtungsÑnderung erkannt. Mit einer beliebigen Taste abbrechen.\n\
\n", wAX, wAY, wDX, wDY, wOben, wLinks, wRechts, wUnten);
  #else
    printf("\n\
Calculating thresholds for joystick A. Off position X=%u Y=%u multiplied by\n\
5/16 makes dX=%u dY=%u. Off position plus/minus thresholds results in border\n\
values for analog to digital conversion:\n\
\n\
       Y<%u\n\
\n\
  X<%-5u   X>%u\n\
\n\
       Y>%u\n\
\n\
Now move joystick A, please. The current values X= and Y= must decrease when\n\
moving to the upper left direction and increase when moving to the lower right\n\
direction. If the border values are crossed, the digital direction will be\n\
recognized. Press any key to abort.\n\
\n", wAX, wAY, wDX, wDY, wOben, wLinks, wRechts, wUnten);
  #endif
  Cursor(FALSE);
  while (!_kbhit()) {
    DirectJoy();
    #if GERMAN
      const char cOben = 'O';
      const char cUnten = 'U';
    #else
      const char cOben = 'U';
      const char cUnten = 'D';
    #endif
    printf("\rX=%-3u Y=%-3u F=%02Xh  -->  digital %c%c%c%c%-40c", wAX, wAY, wFire, wAY < wOben ? cOben : '-', wAY > wUnten ? cUnten : '-', wAX < wLinks ? 'L' : '-', wAX > wRechts ? 'R' : '-', ~wFire & 0x30 ? 'F' : '-');
  }
  _bdos(0x0C, 0, 0);
  Cursor(TRUE);
  #if GERMAN
    printf("\n\n\
Wenn einzelne Richtungen nicht erkannt wurden oder geflackert haben, dann\n\
verstellen Sie bitte die kleinen Trimmregler an der Seite des Joysticks und\n\
starten Sie TESTJOY.EXE neu.\n");
  #else
    printf("\n\n\
If some directions aren't recognized or flash, please adjust the trimmers on\n\
the joystick and restart TESTJOY.EXE.\n");
  #endif
  return 0;
}
