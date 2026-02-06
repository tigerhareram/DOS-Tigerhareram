// T64TOP00.CPP (Visual C++ 1.00) -- T64-Dateien in das PC64-Format umwandeln

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio.h>
#include <fcntl.h>
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

struct {
  char acTag[8];
  char acName[17];
  byte bRecord;
} C64Header;

struct T64EntryStruct {
  byte bType;
  byte bSecAdr;
  word wStartAdr;
  word wEndAdr;
  word wReserved;
  long lOffset;
  long lReserved;
  char acName[17];
} T64Entry;

struct {
  char acTag[32];
  word wVersion;
  word wEntries;
  word wUsedEntries;
  word wReserved;
  char acName[24];
  T64EntryStruct Dummy;
} T64Header;

byte abUnfixed[96] = {
  0x43,0x36,0x34,0x53,0x20,0x74,0x61,0x70,0x65,0x20,0x66,0x69,0x6C,0x65,0x0D,0x0A,
  0x44,0x65,0x6D,0x6F,0x20,0x74,0x61,0x70,0x65,0x1A,0x2E,0x2E,0x2E,0x2E,0x2E,0x2E,
  0x00,0x01,0x1E,0x00,0x00,0x00,0x00,0x00,0x44,0x45,0x4D,0x4F,0x20,0x54,0x41,0x50,
  0x45,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,
  0x01,0x44,0x01,0x08,0xC6,0xC3,0x00,0x00,0x00,0x04,0x00,0x00,0x00,0x00,0x00,0x00,
  0x46,0x49,0x4C,0x45,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
};

// Auf gro·geschriebenen Vokal prÅfen
static inline flag isvocal(char c) {
  return (flag)(memchr("AEIOU", c, 5) != NULL);
}

// Dateinamen von 16 Zeichen auf 8 Zeichen reduzieren
flag ReduceName(const char* sC64Name, char* pDosName) {
  int iStart;
  // LÑnge ÅberprÅfen
  int iLen = strlen(sC64Name);
  if (iLen > 16) {
    return FALSE;
  }
  // Bei einem Jokerzeichen alle Dateien durchsuchen
  if (strpbrk(sC64Name, "*?")) {
    strcpy(pDosName, "*");
    return TRUE;
  }
  // In Puffer umkopieren
  char sBuf[16 + 1];
  memset(sBuf, 0, 16);
  strcpy(sBuf, sC64Name);
  // GÅltige Zeichen holen
  for (int i = 0; i <= 15; i++) {
    switch (sBuf[i]) {
    case ' ':
    case '-':
      // Leerzeichen durch Unterstrich ersetzen
      sBuf[i] = '_';
      break;
    default:
      // Kleinbuchstaben gro· machen
      if (islower((byte)sBuf[i])) {
        sBuf[i] -= 32;
        break;
      }
      // Gro·buchstaben und Ziffern sind OK
      if (isalnum((byte)sBuf[i])) {
        break;
      }
      // UngÅltige Zeichen entfernen
      if (sBuf[i]) {
        sBuf[i] = 0;
        iLen--;
      }
    }
  }
  // Namen auf 8 Zeichen bringen
  if (iLen <= 8) {
    goto Copy;
  }
  // Unterstriche entfernen
  for (i = 15; i >= 0; i--) {
    if (sBuf[i] == '_') {
      sBuf[i] = 0;
      if (--iLen <= 8) {
        goto Copy;
      }
    }
  }
  // Ersten Nicht-Vokal suchen
  for (iStart = 0; iStart < 15; iStart++) {
    if (sBuf[iStart] && !isvocal(sBuf[iStart])) {
      break;
    }
  }
  // Vokale entfernen
  for (i = 15; i >= iStart; i--) {
    if (isvocal(sBuf[i])) {
      sBuf[i] = 0;
      if (--iLen <= 8) {
        goto Copy;
      }
    }
  }
  // Konsonanten entfernen
  for (i = 15; i >= 0; i--) {
    if (isalpha(sBuf[i])) {
      sBuf[i] = 0;
      if (--iLen <= 8) {
        goto Copy;
      }
    }
  }
  // öbriggebliebene Ziffern entfernen
  for (i = 0; i <= 15; i++) {
    if (sBuf[i]) {
      sBuf[i] = 0;
      if (--iLen <= 8) {
        goto Copy;
      }
    }
  }
Copy:
  // Dummy-Namen bei LÑnge = 0 erfinden
  if (!iLen) {
    strcpy(pDosName, "_");
    return TRUE;
  }
  // Dateinamen umkopieren
  char* p = pDosName;
  for (i = 0; i <= 15; i++) {
    if (sBuf[i]) {
      *p++ = sBuf[i];
    }
  }
  *p = 0;
  // Dos-Namen auf GerÑt prÅfen
  int hFile = _open(pDosName, _O_BINARY | _O_RDONLY);
  if (hFile == -1) {
    return TRUE;
  }
  // Wenn es ein GerÑtename ist, dann '_' als letztes Zeichen anhÑngen
  if (isatty(hFile)) {
    if (iLen < 8) {
      strcat(pDosName, "_");
    } else if (pDosName[7] != '_') {
      pDosName[7] = '_';
    } else {
      pDosName[7] = 'X';
    }
  }
  // Zur Probe geîffnetes GerÑt wird nicht mehr gebraucht
  _close(hFile);
  return TRUE;
}

void CopyFile(int hSource, char* pcDosPath, char* pcDosName) {
  int i;
  char* pcNum;
  int hFile;
  printf("  %-18s", T64Entry.acName);
  if (T64Entry.bType != 1) {
    printf("(Memory Snapshot)\n");
    return;
  }
  ReduceName(T64Entry.acName, pcDosName);
  strcat(pcDosName, ".P*");
  _find_t find;
  uint uFind = _dos_findfirst(pcDosPath, _A_NORMAL, &find);
  while (!uFind) {
    strcpy(pcDosName, find.name);
    hFile = _open(pcDosPath, _O_BINARY | _O_RDONLY);
    if (hFile == -1) {
      goto Error;
    }
    if (_read(hFile, &C64Header, 26) == 26 && !strcmp(C64Header.acTag, "C64File")) {
      if (!strcmp(C64Header.acName, T64Entry.acName)) {
        if (_close(hFile) == -1) {
          goto Error;
        }
        goto Found;
      }
    }
    if (_close(hFile) == -1) {
      goto Error;
    }
    uFind = _dos_findnext(&find);
  }
  if (uFind != 0x12) {
    goto Error;
  }
  pcNum = strchr(pcDosName, '.') + 2;
  for (i = 0; i < 100; i++) {
    sprintf(pcNum, "%02d", i);
    if (_access(pcDosPath, 0)) {
      goto Found;
    }
  }
  #if GERMAN
    printf("Keine Ziffern fÅr Erweiterung mehr frei\n");
  #else
    printf("No more numbers available\n");
  #endif
  return;
Found:
  printf("ƒƒ>  %s  ", pcDosName);
  hFile = _open(pcDosPath, _O_BINARY | _O_RDWR | _O_CREAT | _O_TRUNC, _S_IREAD | _S_IWRITE);
  if (hFile == -1) {
    goto Error;
  }
  memset(&C64Header, 0, 26);
  strcpy(C64Header.acTag, "C64File");
  strcpy(C64Header.acName, T64Entry.acName);
  errno = ENOSPC;
  if (_write(hFile, &C64Header, 26) != 26) {
    goto Error;
  }
  if (_write(hFile, &T64Entry.wStartAdr, 2) != 2) {
    goto Error;
  }
  {
    _lseek(hSource, T64Entry.lOffset, SEEK_SET);
    static byte abBuffer[16384];
    long lSize = T64Entry.wEndAdr - T64Entry.wStartAdr;
    while (lSize > 0) {
      int iBytes;
      if (lSize > 16384) {
        iBytes = 16384;
      } else {
        iBytes = (int)lSize;
      }
      int iError = _read(hSource, abBuffer, iBytes);
      if (iError == -1) {
        goto Error;
      }
      if (_write(hFile, abBuffer, iError) != iError) {
        goto Error;
      }
      if (iError != iBytes) {
        if (_close(hFile) == -1) {
          goto Error;
        }
        #if GERMAN
          fprintf(stderr, "Lesen Åber das Dateiende hinaus!\n");
        #else
          fprintf(stderr, "End of file encountered!\n");
        #endif
        return;
      }
      lSize -= iBytes;
    }
  }
  if (_close(hFile) == -1) {
    goto Error;
  }
  printf("\n");
  return;
Error:
  perror(NULL);
  exit(1);
}

void Convert(char acName[80]) {
  char* pcName = strrchr(acName, '\\');
  if (pcName == NULL) {
    pcName = acName;
  } else {
    pcName++;
  }
  int hFile = _open(acName, _O_BINARY | _O_RDONLY);
  if (hFile != -1) {
    if (_read(hFile, &T64Header, 96) == 96 && strstr(T64Header.acTag, "C64") && strstr(T64Header.acTag, "tape")) {
      T64Entry.wStartAdr = T64Header.Dummy.wStartAdr;
      T64Header.Dummy.wStartAdr = 0x0801;
      if (!memcmp(&T64Header, abUnfixed, 96)) {
        #if GERMAN
          printf("%s (fÅr C64S ist FIXTAPE.EXE nîtig)\n", acName);
        #else
          printf("%s (use FIXTAPE.EXE for C64S)\n", acName);
        #endif
        T64Entry.bType = 1;
        T64Entry.bSecAdr = 1;
        T64Entry.wEndAdr = T64Entry.wStartAdr + (word)(_filelength(hFile)) - 1024;
        T64Entry.lOffset = 1024;
        memset(T64Entry.acName, 0, 16);
        memcpy(T64Entry.acName, pcName, strlen(pcName) - 4);
        CopyFile(hFile, acName, pcName);
      } else {
        printf("%s\n", acName);
        for (word wEntry = 0; wEntry < T64Header.wEntries; wEntry++) {
          _lseek(hFile, 64 + wEntry * 32, SEEK_SET);
          if (_read(hFile, &T64Entry, 32) != 32) {
            #if GERMAN
              fprintf(stderr, "Lesen Åber das Dateiende hinaus!\n");
            #else
              fprintf(stderr, "End of file encountered!\n");
            #endif
            goto NextFile;
          }
          if (T64Entry.bType) {
            int i = 15;
            while (i && T64Entry.acName[i] == ' ') {
              T64Entry.acName[i--] = 0;
            }
            if (!strcmp(T64Entry.acName, "FILE")) {
              memset(T64Entry.acName, 0, 16);
              memcpy(T64Entry.acName, pcName, strlen(pcName) - 4);
            }
            CopyFile(hFile, acName, pcName);
          }
        }
      }
    }
  NextFile:
    if (_close(hFile) != -1) {
      return;
    }
  }
  perror(NULL);
  exit(1);
}

void ConvertDir(char* pcDir) {
  printf("%-79s\r", pcDir);
  char acName[80];
  strcpy(acName, pcDir);
  char* pcName = acName + strlen(acName);
  if (pcName[-1] != '\\') {
    *pcName++ = '\\';
  }
  strcpy(pcName, "*.*");
  _find_t find;
  uint uFind = _dos_findfirst(acName, _A_NORMAL | _A_SUBDIR, &find);
  while (!uFind) {
    strcpy(pcName, find.name);
    if (find.attrib & _A_SUBDIR) {
      if (find.name[0] != '.') {
        ConvertDir(acName);
      }
    } else {
      char* pcExt = strchr(pcName, '.');
      if (pcExt && strcmpi(pcExt, ".T64") == 0) {
        Convert(acName);
      }
    }
    uFind = _dos_findnext(&find);
  }
  if (uFind == 0x12) {
    return;
  }
  perror(NULL);
  exit(1);
}

int main(int argc, char** argv) {
  #ifdef _DEBUG
    _bdos(0x0D, 0, 0);
  #endif
  #if GERMAN
    printf("T64-Dateien des C64S in das PC64-Format umwandeln\n");
  #else
    printf("Converting T64 files from C64S into the PC64 format\n");
  #endif
  char acDir[80];
  if (argc < 2) {
    _fullpath(acDir, ".", 80);
  } else {
    _fullpath(acDir, argv[1], 80);
    _strupr(acDir);
  }
  int hTest = _open(acDir, _O_BINARY | _O_RDONLY);
  if (hTest != -1) {
    _close(hTest);
    Convert(acDir);
    return 0;
  }
  char* pcExt = strchr(acDir, '.');
  if (pcExt == 0) {
    pcExt = acDir + strlen(acDir);
    strcpy(pcExt, ".T64");
    hTest = _open(acDir, _O_BINARY | _O_RDONLY);
    if (hTest != -1) {
      _close(hTest);
      Convert(acDir);
      return 0;
    }
    *pcExt = 0;
  }
  #if GERMAN
    printf("Startverzeichnis ist %s\n", acDir);
  #else
    printf("Start directory is %s\n", acDir);
  #endif
  ConvertDir(acDir);
  printf("\r%80c", '\r');
  return 0;
}
