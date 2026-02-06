// TESTCABL.CPP (Visual C++ 1.00) -- Personal C64 cable test program

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio.h>
#include <dos.h>

typedef unsigned char byte;
typedef unsigned short word;
typedef unsigned int uint;
typedef unsigned long dword;
typedef enum {FALSE, TRUE} flag;

char __far* pcScreen = (char __far*)0xB8000000L;

void Show(int iPos, int iVal) {
  for (int iMask = 0x01; iMask <= 0x10; iMask <<= 1) {
    if (iVal & iMask) {
      pcScreen[iPos] = 'ş';
    } else {
      pcScreen[iPos] = ' ';
    }
    iPos += 320;
  }
}

int main(int, char**) {
  #ifdef DEBUG
    _bdos(0x0D, 0, 0);
  #endif
  printf("\n\n\n\n\
           PC                 C64\n\
\n\
     ( )   D0  2 ( ) ÄÄÄÄ> H  PB4       Run TESTCABLE on the C64 (L64 disk):\n\
                                        ------------------------------------\n\
     ( )   D1  3 ( ) ÄÄÄÄ> J  PB5       +/-      = LPT  (    )\n\
                                        1 to 5   = output pin x on/off\n\
     ( )   D2  4 ( ) ÄÄÄÄ> K  PB6       Space    = blinking on/off\n\
                                        Esc      = end\n\
     ( )   D3  5 ( ) ÄÄÄÄ> L  PB7\n\
                                        The FLAG pin on the C64 blinks with\n\
     ( )   D7  9 ( ) ÄÄÄÄ> B  FLAG      half the frequency (falling edge\n\
                                        triggered).\n\
          GND 25 ÄÄÄÄÄÄÄÄÄ A  GND\n\
\n\
          ERR 15 ( ) <ÄÄÄÄ C  PB0\n\
\n\
          SEL 13 ( ) <ÄÄÄÄ D  PB1\n\
\n\
           PE 12 ( ) <ÄÄÄÄ E  PB2\n\
\n\
          ACK 10 ( ) <ÄÄÄÄ F  PB3\n\
\n\
         BUSY 11 ( ) <ÄÄÄÄ M  PA2\n");
  int iLPT = 0;
SwitchLPT:
  int iPort = ((int __far*)0x00000408L)[iLPT];
  pcScreen[908] = (char)('1' + iLPT);
  char ac[5];
  sprintf(ac, "%04X", iPort);
  for (int i = 0; i < 4; i++) {
    pcScreen[914 + i * 2] = ac[i];
  }
  flag fBlink = FALSE;
SwitchBlink:
  int iOut = 0;
Blink:
  int iTime = *(int __far*)0x0000046CL + 18;
Output:
  _outp(iPort, iOut & 0x0F | (iOut << 3) & 0x80);
  Show(492, iOut);
  int iIn = _inp(iPort);
  Show(516, iIn & 0x0F | (iIn >> 3) & 0x10);
  iIn = _inp(iPort + 1);
  Show(2436, (iIn ^ 0x80) >> 3);
  if (_kbhit()) {
    switch (_getch()) {
    case '+':
      iLPT = iLPT + 1 & 3;
      goto SwitchLPT;
    case '-':
      iLPT = iLPT - 1 & 3;
      goto SwitchLPT;
    case ' ':
      fBlink = (flag)!fBlink;
      goto SwitchBlink;
    case '1':
      iOut ^= 0x01;
      break;
    case '2':
      iOut ^= 0x02;
      break;
    case '3':
      iOut ^= 0x04;
      break;
    case '4':
      iOut ^= 0x08;
      break;
    case '5':
      iOut ^= 0x10;
      break;
    case 27:
      return 0;
      break;
    }
    goto Output;
  }
  if (!fBlink) {
    goto Output;
  }
  if (iTime - *(int __far*)0x0000046CL > 0) {
    goto Output;
  }
  iOut = iOut & 1 ? 0x00 : 0x1F;
  goto Blink;
}
