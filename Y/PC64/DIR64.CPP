// DIR64.CPP (Visual C++ 1.00) -- Shows C64 files (PC64/P00, D64 and T64)

#if MASTER
  #ifndef NDEBUG
    #error Set the Build Options to RELEASE!
  #endif
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio.h>
#include <fcntl.h>
#include <direct.h>
#include <errno.h>
#include <io.h>
#include <sys\types.h>
#include <sys\stat.h>
#include <dos.h>
#include <ctype.h>

typedef unsigned char byte;
typedef unsigned short word;
typedef unsigned int uint;
typedef unsigned long dword;
typedef enum { FALSE, TRUE } flag;

flag gfDOSAlso = FALSE;
flag gfRecurse = FALSE;
const flag gfSmallLetters = TRUE;
#pragma warning(disable: 4127)

void Stop(char* pcMessage = NULL) {
  if (pcMessage) {
    fprintf(stderr, pcMessage);
  } else {
    perror(NULL);
  }
  exit(1);
}

void Header(char* pcName) {
  char acName[80];
  _fullpath(acName, pcName, 80);
  _strupr(acName);
  printf("\n…Õ");
  for (int i = strlen(acName); i; i--) {
    putchar('Õ');
  }
  printf("Õª\n∫ %s ∫\n»Õ", acName);
  for (i = strlen(acName); i; i--) {
    putchar('Õ');
  }
  printf("Õº\n");
}

void CBMtoASCII(char* pcDest, byte* pbSource, int iCount) {
  for (int i = 0; i < iCount; i++) {
    byte b = pbSource[i];
    switch (b & ~0x1F) {
    case 0x00:
    case 0x40:
      if (gfSmallLetters) {
        pcDest[i] = "@abcdefghijklmnopqrstuvwxyz[ú]"[b & 0x1F];
      } else {
        pcDest[i] = "@ABCDEFGHIJKLMNOPQRSTUVWXYZ[ú]"[b & 0x1F];
      }
      break;
    case 0x60:
    case 0x80:
    case 0xC0:
      if (gfSmallLetters) {
        pcDest[i] = "ƒABCDEFGHIJKLMNOPQRSTUVWXYZ≈±≥±\\"[b & 0x1F];
      } else {
        pcDest[i] = "ƒ˛≥ƒƒƒƒ≥≥ø¿Ÿ¿\\/⁄ø˛ƒ˛≥⁄XO˛≥˛≈±≥„\\"[b & 0x1F];
      }
      break;
    case 0xA0:
    case 0xE0:
      if (gfSmallLetters) {
        pcDest[i] = " ›‹ƒ_≥±≥±/≥√‹¿øƒ⁄¡¬¥≥≥≥ƒƒƒ˚‹ﬂŸﬂ≤"[b & 0x1F];
      } else {
        pcDest[i] = " ›‹ƒ_≥±≥±/≥√‹¿øƒ⁄¡¬¥≥≥≥ƒƒƒŸ‹ﬂŸﬂ≤"[b & 0x1F];
      }
      break;
    default:
      pcDest[i] = (char)b;
      break;
    }
  }
  pcDest[i] = 0;
}

char* GetType(char cType) {
  if (gfSmallLetters) {
    switch (cType) {
    case 0:
    case 'd':
    case 'D':
      return "del";
    case 1:
    case 's':
    case 'S':
      return "seq";
    case 2:
    case 'p':
    case 'P':
      return "prg";
    case 3:
    case 'u':
    case 'U':
      return "usr";
    case 4:
    case 'r':
    case 'L':
      return "rel";
    case 5:
    case 'c':
    case 'C':
      return "cbm";
    default:
      return "???";
    }
  } else {
    switch (cType) {
    case 0:
    case 'd':
    case 'D':
      return "DEL";
    case 1:
    case 's':
    case 'S':
      return "SEQ";
    case 2:
    case 'p':
    case 'P':
      return "PRG";
    case 3:
    case 'u':
    case 'U':
      return "USR";
    case 4:
    case 'r':
    case 'L':
      return "REL";
    case 5:
    case 'c':
    case 'C':
      return "CBM";
    default:
      return "???";
    }
  }
}

flag gfPC64Header = FALSE;
void ShowPC64(char* pcName) {
  int hFile = _open(pcName, _O_BINARY | _O_RDONLY);
  if (hFile == -1) {
    Stop();
  }
  char acTag[8];
  if (_read(hFile, acTag, 8) == 8 && !strcmp(acTag, "C64File")) {
    if (gfPC64Header) {
      Header("*.PC64");
      gfPC64Header = FALSE;
    }
    byte abName[17];
    if (_read(hFile, abName, 16) != 16) {
      Stop();
    }
    abName[16] = 0;
    long lBlocks = (_filelength(hFile) - 26 + 253) / 254;
    char acName[18];
    CBMtoASCII(acName, abName, strlen((char*)abName));
    strcat(acName, "\"");
    char* pcType = GetType(strchr(pcName, '.')[1]);
    printf("%-4ld \"%-17s %s   %s\n", lBlocks, acName, pcType, pcName);
  }
  if (_close(hFile) == -1) {
    Stop();
  }
}

void DirD64(char* pcName) {
  Header(pcName);
  int hFile = _open(pcName, _O_BINARY | _O_RDONLY);
  if (hFile == -1) {
    Stop();
  }
  if (_filelength(hFile) == 683 * 256L + 683) {
    #if GERMAN
      printf("Diskette enthÑlt Lesefehler!\n");
    #else
      printf("Disk has read errors!\n");
    #endif
  }
  const long lTrack18 = 17 * 21 * 256L;
  _lseek(hFile, lTrack18, SEEK_SET);
  byte abSector[256];
  if (_read(hFile, abSector, 256) != 256) {
    Stop();
  }
  char acName[18];
  CBMtoASCII(acName, abSector + 144, 16);
  char acID[6];
  CBMtoASCII(acID, abSector + 162, 5);
  printf("0 \"%s\" %s\n", acName, acID);
  word wFree = 0;
  for (int i = 1; i <= 35; i++) {
    if (i != 18) {
      wFree += (word)abSector[i * 4];
    }
  }
  flag afUsed[20];
  afUsed[0] = TRUE;
  for (i = 1; i < 20; i++) {
    afUsed[i] = FALSE;
  }
  while (abSector[0]) {
    if (abSector[0] != 18 || abSector[1] >= 20 || afUsed[abSector[1]]) {
      #if GERMAN
        printf("Verkettung der Verzeichnissektoren stimmt nicht!\n");
      #else
        printf("Illegal directory sector chaining!\n");
      #endif
      goto Return;
    }
    afUsed[i] = TRUE;
    _lseek(hFile, lTrack18 + abSector[1] * 256, SEEK_SET);
    if (_read(hFile, abSector, 256) != 256) {
      Stop();
    }
    for (i = 2; i < 256; i += 32) {
      if (abSector[i]) {
        char* pcType = GetType((byte)(abSector[i] & 0x0F));
        abSector[i + 3 + 16] = (byte)0xA0;
        byte* pb = abSector + i + 3;
        while (*pb != '"' && *pb != (byte)0xA0) {
          pb++;
        }
        *pb = '"';
        CBMtoASCII(acName, abSector + i + 3, 17);
        printf("%-4d \"%s%c%s%c\n", *(word*)(abSector + i + 28), acName, abSector[i] & 0x80 ? ' ' : '*', pcType, abSector[i] & 0x40 ? '<' : ' ');
      }
    }
  }
Return:
  if (gfSmallLetters) {
    printf("%u blocks free.\n", wFree);
  } else {
    printf("%u BLOCKS FREE.\n", wFree);
  }
  if (_close(hFile) == -1) {
    Stop();
  }
}

void DirT64(char* pcName) {
  Header(pcName);
  int hFile = _open(pcName, _O_BINARY | _O_RDONLY);
  if (hFile == -1) {
    Stop();
  }
  struct {
    char acTag[32];
    word wVersion;
    word wEntries;
    word wUsedEntries;
    word wReserved;
    byte abName[24];
  } T64Header;
  struct {
    byte bType;
    byte bSecAdr;
    word wStartAdr;
    word wEndAdr;
    word wReserved;
    long lOffset;
    long lReserved;
    byte abName[16];
  } T64Entry;
  if (_read(hFile, &T64Header, sizeof T64Header) != sizeof T64Header) {
    Stop();
  }
  T64Header.acTag[31] = 0;
  if (strstr(T64Header.acTag, "C64") && strstr(T64Header.acTag, "tape")) {
    if (T64Header.wUsedEntries == 0) {
      T64Header.wUsedEntries = T64Header.wEntries;
    }
    for (word w = 0; w < T64Header.wUsedEntries; w++) {
      if (_read(hFile, &T64Entry, sizeof T64Entry) != sizeof T64Entry) {
        Stop();
      }
      if (T64Entry.bType) {
        char acName[18];
        CBMtoASCII(acName, T64Entry.abName, 16);
        for (int i = 16; i > 0; i--) {
          if (acName[i - 1] != ' ') {
            break;
          }
        }
        strcpy(acName + i, "\"");
        char* pcType;
        word wBlocks;
        if (T64Entry.bType == 1) {
          pcType = GetType('P');
          wBlocks = (T64Entry.wEndAdr - T64Entry.wStartAdr + 253) / 254;
        } else {
          pcType = "memory snapshot";
          wBlocks = 275;
        }
        printf("%-4u \"%-17s %s\n", wBlocks, acName, pcType);
      }
    }
  } else {
    #if GERMAN
      printf("Keine gÅltige T64-Datei!\n");
    #else
      printf("Not a valid T64 file!\n");
    #endif
  }
  if (_close(hFile) == -1) {
    Stop();
  }
}

void RecurseSubDir() {
  if (gfDOSAlso) {
    fflush(stdout);
    system("dir");
  }
  gfPC64Header = TRUE;
  _find_t find;
  uint uFind = _dos_findfirst("*.*", _A_NORMAL, &find);
  while (!uFind) {
    char* pcExt = strchr(find.name, '.');
    if (pcExt) {
      if (strchr("DSPUR", pcExt[1]) && isdigit(pcExt[2]) && isdigit(pcExt[3])) {
        ShowPC64(find.name);
      }
    }
    uFind = _dos_findnext(&find);
  }
  if (uFind != 0x12) {
    Stop();
  }
  uFind = _dos_findfirst("*.?64", _A_NORMAL, &find);
  while (!uFind) {
    char* pcExt = strchr(find.name, '.');
    if (pcExt) {
      if (!strcmp(pcExt, ".D64")) {
        DirD64(find.name);
      } else if (!strcmp(pcExt, ".T64")) {
        DirT64(find.name);
      }
    }
    uFind = _dos_findnext(&find);
  }
  if (uFind != 0x12) {
    Stop();
  }
  if (gfRecurse) {
    uFind = _dos_findfirst("*.*", _A_SUBDIR, &find);
    while (!uFind) {
      if ((find.attrib & _A_SUBDIR) && find.name[0] != '.') {
        if (_chdir(find.name) == -1) {
          Stop();
        }
        RecurseSubDir();
        if (_chdir("..") == -1) {
          Stop();
        }
      }
      uFind = _dos_findnext(&find);
    }
    if (uFind != 0x12) {
      Stop();
    }
  }
}

int giOldDrive;
char gacOldDir[80];
void __cdecl RestoreDir() {
  _chdir(gacOldDir);
  _chdrive(giOldDrive);
}

int main(int iArg, char** ppcArg) {
  #ifdef _DEBUG
    _bdos(0x0D, 0, 0);
  #endif
  char acDir[80];
  _fullpath(acDir, ".", 80);
  for (int i = 1; i < iArg; i++) {
    switch (ppcArg[i][0]) {
    case '/':
    case '-':
      switch (ppcArg[i][1]) {
      case 'd':
      case 'D':
        gfDOSAlso = TRUE;
        break;
      case 's':
      case 'S':
        gfRecurse = TRUE;
        break;
      default:
        #if GERMAN
          Stop("\
Syntax ist: DIR64 [Verzeichnis] [/d] [/s]\n\
  /d = Auch DOS-Dateien anzeigen (Original DIR-Befehl wird aufgerufen)\n\
  /s = Unterverzeichnisse durchsuchen\n");
        #else
          Stop("\
usage: DIR64 [directory] [/d] [/s]\n\
  /d = show DOS files too (spawns original DIR command)\n\
  /s = recurse into subdirectories\n");
        #endif
      }
      break;
    default:
      _fullpath(acDir, ppcArg[i], 80);
      break;
    }
  }
  giOldDrive = _getdrive();
  if (_chdrive(acDir[0] & 0x1F)) {
    Stop();
  }
  _getcwd(gacOldDir, 80);
  atexit(RestoreDir);
  if (_chdir(acDir) == -1) {
    Stop();
  }
  RecurseSubDir();
  return 0;
}
