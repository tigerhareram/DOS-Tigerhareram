// SETJOY.CPP (Visual C++ 1.00) -- Joysticks in PC64.PDB und PC64.CFG umschalten

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dos.h>
#include <conio.h>
#include <fcntl.h>
#include <io.h>
#include <sys\types.h>
#include <sys\stat.h>

typedef unsigned char byte;
typedef unsigned short word;
typedef unsigned int uint;
typedef unsigned long dword;
typedef enum {FALSE, TRUE} flag;

#pragma pack(1)

struct FILEOPT {
  word wSaveName;
};

struct ROMS {
  char aacName[4][13];
};

struct KEYBOARD {
  flag fNationalKeys;
  flag fTabSwitch;
};

struct JOYSTICK {
  word awPort[2];
  word awFire[2];
  long alStart[2];
  long alCount[2];
  word awFlags[2];
};

struct TIMING {
  word wRefresh;
  word wPerformance;
  word wAlgorithm;
  int iClocksPerInt;
  word wNewLine;
  flag fVICDelay;
  flag fNTSC;
  word wRealTime;
};

struct SOUND {
  byte abVolume[5];
  byte abEnable[2];
};

struct PDB {
  FILEOPT fileopt;
  ROMS roms;
  KEYBOARD keyboard;
  JOYSTICK joystick;
  TIMING timing;
  SOUND sound;
} pdb;

char* pcFile;
void Stop() {
  perror(pcFile);
  exit(1);
}

int main(int, char**) {
  #ifdef DEBUG
    _bdos(0x0D, 0, 0);
  #endif
#if GERMAN
  printf("\n\
Dieses Programm schaltet die eingestellten Joysticks in den Dateien PC64.PDB\n\
und PC64.CFG um. Hierdurch mÅssen Sie bei einem Wechsel der Hardware nicht fÅr\n\
jedes Spiel das Dialogfeld <Optionen / Joysticks> aufrufen.\n\
\n\
Die Umstellung betrifft alle C64-Programme, die Åber <Emulator / Neu> und\n\
<Manager / AusfÅhren> gestartet werden. Die abgespeicherten EmulatorzustÑnde\n\
*.C64 mÅssen jedoch nach <Emulator / ôffnen> von Hand umgestellt werden.\n\
\n\
  Esc - Abbruch         <1> - LPT1:\n\
  <T> - Tastatur        <2> - LPT2:\n\
  <A> - Analog A        <3> - LPT3:\n\
  <B> - Analog B        <4> - LPT4:\n\
\n\
Wie wollen Sie Ihre Spiele in Zukunft steuern? ");
#else
  printf("\n\
This program switches the joystick settings in PC64.PDB and PC64.CFG. It\n\
allows you to change the hardware without changing the settings for each game\n\
separately in <Options / Joysticks>.\n\
\n\
The modification is valid for all C64 programs which are executed with\n\
<Emulator / New> and <Manager / Run>. Saved emulator windows *.C64 must be\n\
changed by hand.\n\
\n\
  Esc - Abort           <1> - LPT1:\n\
  <K> - Keyboard        <2> - LPT2:\n\
  <A> - Analog A        <3> - LPT3:\n\
  <B> - Analog B        <4> - LPT4:\n\
\n\
How do you want to control your games in the future? ");
#endif
  word wSetJoy;
GetKey:
  char cKey = (char)_getch();
  switch (cKey) {
  case 't':
  case 'T':
  case 'k':
  case 'K':
    wSetJoy = 1;
    #if GERMAN
      printf("öber die Tastatur\n\n");
    #else
      printf("By keyboard\n\n");
    #endif
    break;
  case 'a':
  case 'A':
    wSetJoy = 2;
    #if GERMAN
      printf("Mit dem IBM-Joystick A\n\n");
    #else
      printf("By IBM joystick A\n\n");
    #endif
    break;
  case 'b':
  case 'B':
    wSetJoy = 3;
    #if GERMAN
      printf("Mit dem IBM-Joystick B\n\n");
    #else
      printf("By IBM joystick B\n\n");
    #endif
    break;
  case '1':
    wSetJoy = 4;
    #if GERMAN
      printf("Mit dem C64-Joystick an LPT1:\n\n");
    #else
      printf("By C64 joystick on LPT1:\n\n");
    #endif
    break;
  case '2':
    wSetJoy = 5;
    #if GERMAN
      printf("Mit dem C64-Joystick an LPT2:\n\n");
    #else
      printf("By C64 joystick on LPT2:\n\n");
    #endif
    break;
  case '3':
    wSetJoy = 6;
    #if GERMAN
      printf("Mit dem C64-Joystick an LPT3:\n\n");
    #else
      printf("By C64 joystick on LPT3:\n\n");
    #endif
    break;
  case '4':
    wSetJoy = 7;
    #if GERMAN
      printf("Mit dem C64-Joystick an LPT4:\n\n");
    #else
      printf("By C64 joystick on LPT4:\n\n");
    #endif
    break;
  case 27:
    #if GERMAN
      printf("Wie bisher\n");
    #else
      printf("Same as now\n");
    #endif
    return 1;
  default:
    goto GetKey;
  }
  _bdos(0x0C, 0, 0);
  pcFile = "PC64.PDB";
  int hFile = _open(pcFile, _O_BINARY | _O_RDWR);
  if (hFile == -1) {
    Stop();
  }
  long lGames = 0;
  long lStart = 16384;
  for (;;) {
    for (long lIndex = 0; lIndex < 1024L; lIndex++) {
      if (_lseek(hFile, lStart + lIndex * sizeof PDB, SEEK_SET) == -1) {
        Stop();
      }
      int i = _read(hFile, &pdb, sizeof PDB);
      if (i == -1) {
        Stop();
      }
      if (i != sizeof PDB) {
        goto End;
      }
      if (pdb.joystick.awPort[0] || pdb.joystick.awPort[1]) {
        if (pdb.joystick.awPort[0] != 0) {
          pdb.joystick.awPort[0] = wSetJoy;
        }
        if (pdb.joystick.awPort[1] != 0) {
          pdb.joystick.awPort[1] = wSetJoy;
        }
        if (_lseek(hFile, lStart + lIndex * sizeof PDB, SEEK_SET) == -1) {
          Stop();
        }
        if (_write(hFile, &pdb, sizeof PDB) == -1) {
          Stop();
        }
        lGames++;
      }
    }
    lStart += 1024L * sizeof PDB + 16384;
  }
End:
  if (_close(hFile) == -1) {
    Stop();
  }
  #if GERMAN
    printf("In der Datei PC64.PDB wurden %lu Spiele umgestellt.\n", lGames);
  #else
    printf("%lu games have been converted in PC64.PDB.\n", lGames);
  #endif
  pcFile = "PC64.CFG";
  hFile = _open(pcFile, _O_BINARY | _O_RDWR);
  if (hFile == -1) {
    Stop();
  }
  int i = _read(hFile, &pdb, sizeof PDB);
  if (i == -1) {
    Stop();
  }
  if (i != sizeof PDB) {
    #if GERMAN
      printf("Die Datei PC64.CFG ist zu kurz!\n");
    #else
      printf("PC64.CFG is too short!\n");
    #endif
    return 1;
  }
  pdb.joystick.awPort[0] = pdb.joystick.awPort[1] = wSetJoy;
  // Die Formate von PC64.PDB und PC64.CFG stimmen nur bis zur
  // struct JOYSTICK Åberein!
  if (_lseek(hFile, 0, SEEK_SET) == -1) {
    Stop();
  }
  if (_write(hFile, &pdb, sizeof PDB) == -1) {
    Stop();
  }
  if (_close(hFile) == -1) {
    Stop();
  }
  #if GERMAN
    printf("Die Vorgabe fÅr neue Emulatorfenster in PC64.CFG wurde ebenfalls umgestellt.\n");
  #else
    printf("Default setting for new emulator windows in PC64.CFG has also been changed.\n");
  #endif
  return 0;
}
