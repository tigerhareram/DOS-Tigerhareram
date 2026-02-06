// CBMText.cpp (Visual C++ 1.00) -- Convert CBM text files into PC format

#if MASTER
  #ifdef _DEBUG
    #error Please set the Build Options to RELEASE!
  #endif
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio.h>
#include <dos.h>
#include <graph.h>
#include <io.h>
#include <fcntl.h>
#include <direct.h>
#include <malloc.h>

typedef unsigned char byte;
typedef unsigned short word;
typedef unsigned int uint;
typedef unsigned long dword;
typedef int flag;
const int TRUE = 1;
const int FALSE = 0;

int print(char* pcFormat, ...) {
  char ac[256];
  int iLength = vsprintf(ac, pcFormat, (char*)(&pcFormat + 1));
  _outtext(ac);
  return iLength;
}

const char gacBig[256] = {
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,   // 00
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  ' ','!','"','#','$','%','&',39, '(',')','*','+',',','-','.','/', // 20
  '0','1','2','3','4','5','6','7','8','9',':',';','<','=','>','?',
  '@','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O', // 40
  'P','Q','R','S','T','U','V','W','X','Y','Z','[','ú',']','^','Æ',
  'ƒ','˛','≥','ƒ','ƒ','ƒ','ƒ','≥','≥','ø','¿','Ÿ','¿',92, '/','⁄', // 60
  'ø','˛','ƒ','˛','≥','⁄','X','O','˛','≥','˛','≈','±','≥','„',92,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,   // 80
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  ' ','›','‹','ƒ','_','≥','±','≥','±','/','≥','√','‹','¿','ø','ƒ', // A0
  '⁄','¡','¬','¥','≥','≥','≥','ƒ','ƒ','ƒ','Ÿ','‹','ﬂ','Ÿ','ﬂ','≤',
  'ƒ','˛','≥','ƒ','ƒ','ƒ','ƒ','≥','≥','ø','¿','Ÿ','¿',92, '/','⁄', // C0
  'ø','˛','ƒ','˛','≥','⁄','X','O','˛','≥','˛','≈','±','≥','„',92,
  ' ','›','‹','ƒ','_','≥','±','≥','±','/','≥','√','‹','¿','ø','ƒ', // E0
  '⁄','¡','¬','¥','≥','≥','≥','ƒ','ƒ','ƒ','Ÿ','‹','ﬂ','Ÿ','ﬂ','≤'
};

const char gacSmall[256] = {
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,   // 00
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  ' ','!','"','#','$','%','&',39, '(',')','*','+',',','-','.','/', // 20
  '0','1','2','3','4','5','6','7','8','9',':',';','<','=','>','?',
  '@','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o', // 40
  'p','q','r','s','t','u','v','w','x','y','z','[','ú',']','^','Æ',
  'ƒ','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O', // 60
  'P','Q','R','S','T','U','V','W','X','Y','Z','≈','±','≥','±',92,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,   // 80
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  ' ','›','‹','ƒ','_','≥','±','≥','±','/','≥','√','‹','¿','ø','ƒ', // A0
  '⁄','¡','¬','¥','≥','≥','≥','ƒ','ƒ','ƒ','˚','‹','ﬂ','Ÿ','ﬂ','≤',
  'ƒ','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O', // C0
  'P','Q','R','S','T','U','V','W','X','Y','Z','≈','±','≥','±',92,
  ' ','›','‹','ƒ','_','≥','±','≥','±','/','≥','√','‹','¿','ø','ƒ', // E0
  '⁄','¡','¬','¥','≥','≥','≥','ƒ','ƒ','ƒ','˚','‹','ﬂ','Ÿ','ﬂ','≤'
};

const char gacGood[256] = {
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,
  0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,
  1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
};

byte* gpbInBuf;
byte* gpbInEnd;
byte* gpbOutBuf;
byte* gpbOutEnd;
long glGood;
int giFormat;
int giLine;
int giRow;

void CBMBigLetters() {
  byte* pbIn = gpbInBuf;
  byte* pbOut = gpbOutBuf;
  glGood = 0;
  while (pbIn < gpbInEnd) {
    switch (*pbIn) {
    case 13:
    case 141:
      *pbOut++ = '\n';
      if (pbIn[1] == 10) {
        pbIn++;
      }
      break;
    default:
      if (gacBig[*pbIn]) {
        *pbOut = gacBig[*pbIn];
        glGood += gacGood[*pbOut++];
      } else {
        sprintf((char*)pbOut, "<%02X>", *pbIn);
        pbOut += 4;
        glGood -= 5;
        break;
      }
    }
    pbIn++;
  }
  gpbOutEnd = pbOut;
}

void CBMSmallLetters() {
  byte* pbIn = gpbInBuf;
  byte* pbOut = gpbOutBuf;
  glGood = 0;
  while (pbIn < gpbInEnd) {
    switch (*pbIn) {
    case 13:
    case 141:
      *pbOut++ = '\n';
      if (pbIn[1] == 10) {
        pbIn++;
      }
      break;
    default:
      if (gacSmall[*pbIn]) {
        *pbOut = gacSmall[*pbIn];
        glGood += gacGood[*pbOut++];
      } else {
        sprintf((char*)pbOut, "<%02X>", *pbIn);
        pbOut += 4;
        glGood -= 5;
        break;
      }
    }
    pbIn++;
  }
  gpbOutEnd = pbOut;
}

void Vizawrite() {
  byte* pbIn = gpbInBuf + 0x0110;
  while (*pbIn != 0xDC) {
    pbIn++;
    if (pbIn - gpbInBuf > 0x01B0) {
      pbIn = gpbInBuf + 0x0110;
      break;
    }
  }
  byte* pbOut = gpbOutBuf;
  glGood = 0;
  while (pbIn < gpbInEnd) {
    switch (*pbIn) {
    case 121:
      *pbOut++ = 'é';
      glGood++;
      break;
    case 122:
    case 29:
      *pbOut++ = 'ô';
      glGood++;
      break;
    case 123:
      *pbOut++ = 'ö';
      glGood++;
      break;
    case 124:
    case 28:
      *pbOut++ = '·';
      glGood++;
      break;
    case 101:
    case 60:
      *pbOut++ = 'Ñ';
      glGood++;
      break;
    case 118:
    case 27:
      *pbOut++ = 'î';
      glGood++;
      break;
    case 120:
    case 0:
      *pbOut++ = 'Å';
      glGood++;
      break;
    case 0xDC: // New Line
      *pbOut++ = '\n';
      break;
    case 0xDB: // Tab
    case 0xDD: // Numeric Tab
    case 0xEB: // Indent
    case 0xE9: // Merge
    case 0xEA: // Don't Merge
      *pbOut++ = '\t';
      break;
    case 0xDF: // Center
    case 0xED: // Bold
    case 0xEE: // Underline
    case 0xEC: // Subscript
    case 0xEF: // Superscript
    case 0xF1: // Form Feed
      break;
    default:
      if (*pbIn >= 1 && *pbIn <= 26) {
        *pbOut = (byte)(96 + (*pbIn & 31));
        glGood += gacGood[*pbOut++];
      } else if (*pbIn >= 65 && *pbIn <= 90) {
        *pbOut = (byte)(64 + (*pbIn & 31));
        glGood += gacGood[*pbOut++];
      } else if (*pbIn >= 32 && *pbIn <= 63) {
        *pbOut = *pbIn;
        glGood += gacGood[*pbOut++];
      } else {
        sprintf((char*)pbOut, "<%02X>", *pbIn);
        pbOut += 4;
        glGood -= 10;
        break;
      }
    }
    pbIn++;
  }
  gpbOutEnd = pbOut;
}

void EasyScript() {
  byte* pbIn = gpbInBuf;
  byte* pbOut = gpbOutBuf;
  glGood = 0;
  if (pbIn[0] == 0x80 && pbIn[1] == '*') {
    glGood = 100;
  }
  while (pbIn < gpbInEnd) {
    switch (*pbIn) {
    case 13:
      *pbOut++ = '\n';
      break;
    case 163:
      *pbOut++ = '\xFF';
      glGood++;
      break;
    case 0x5B:
      *pbOut++ = (byte)'Ñ';
      glGood++;
      break;
    case 0x5C:
      *pbOut++ = (byte)'î';
      glGood++;
      break;
    case 0x5D:
      *pbOut++ = (byte)'Å';
      glGood++;
      break;
    case 0x5E:
      *pbOut++ = (byte)'·';
      glGood++;
      break;
    case 0xDB:
      *pbOut++ = (byte)'é';
      glGood++;
      break;
    case 0xDC:
      *pbOut++ = (byte)'ô';
      glGood++;
      break;
    case 0xDD:
      *pbOut++ = (byte)'ö';
      glGood++;
      break;
    case 0xBC:
    case 0xBE:
    case 0xAD:
    case 0xBD:
    case 0xA9:
    case 0xDF:
    case 0xB9:
    case 0xA6:
    case 0xB8:
      break;
    case 0x80:
      switch (*++pbIn) {
      case '0':
      case '1':
        glGood += 2;
        break;
      case 0xA3: // -
        *pbOut++ = ' ';
        glGood += 2;
        break;
      case 0xC5: // E
        switch (*++pbIn) {
        case 0xD7: // W
        case 'W':
        case 'X':
        case 'K':
          pbIn++;
          glGood += 10;
          break;
        }
        break;
      case '*':
        while (pbIn < gpbInEnd && *pbIn != 13 && *pbIn != ';') {
          if (pbIn[0] == '*' || pbIn[0] == ':') {
            if (pbIn[1] == 'L' && pbIn[2] == 'N' || (pbIn[1] == 'F' || pbIn[1] == 'S') && pbIn[2] == 'P') {
              *pbOut++ = '\n';
              glGood += 10;
            }
          }
          pbIn++;
        }
        break;
      }
      break;
    default:
      if (*pbIn >= 65 && *pbIn <= 90) {
        *pbOut = (byte)(96 + (*pbIn & 31));
        glGood += gacGood[*pbOut++];
      } else if (*pbIn >= 193 && *pbIn <= 218) {
        *pbOut = (byte)(64 + (*pbIn & 31));
        glGood += gacGood[*pbOut++];
      } else if (*pbIn >= 32 && *pbIn <= 63) {
        *pbOut = *pbIn;
        glGood += gacGood[*pbOut++];
      } else {
        sprintf((char*)pbOut, "<%02X>", *pbIn);
        pbOut += 4;
        glGood -= 10;
      }
    }
    pbIn++;
  }
  gpbOutEnd = pbOut;
}

void StarTexter() {
  const byte abConvert[256] = { // Table from Convert 64, 64'er magazine 7'87
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x20,0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,0x2E,0x2F,
    0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,0x3E,0x3F,
    0x60,0x61,0x62,0x63,0x64,0x65,0x66,0x67,0x68,0x69,0x6A,0x6B,0x6C,0x6D,0x6E,0x6F,
    0x70,0x71,0x72,0x73,0x74,0x75,0x76,0x77,0x78,0x79,0x7A,0x5C,0x5D,0x5E,0x5F,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x84,0x94,0x81,0xE1,0x8E,0x99,0x9A,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48,0x49,0x4A,0x4B,0x4C,0x4D,0x4E,0x4F,
    0x50,0x51,0x52,0x53,0x54,0x55,0x56,0x57,0x58,0x59,0x5A,0x00,0x2D,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
  };
  byte* pbIn = gpbInBuf;
  byte* pbOut = gpbOutBuf;
  glGood = 0;
  while (pbIn < gpbInEnd) {
    byte b = abConvert[*pbIn];
    if (b != 0) {
      *pbOut++ = b;
      glGood += gacGood[b];
    } else {
      sprintf((char*)pbOut, "<%02X>", *pbIn);
      pbOut += 4;
      glGood -= 10;
    }
    pbIn++;
  }
  gpbOutEnd = pbOut;
}

void Textomat() {
  const byte abConvert[256] = { // Table from Convert 64, 64'er magazine 7'87
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x20,0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,0x2E,0x2F,
    0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,0x3E,0x3F,
    0x60,0x61,0x62,0x63,0x64,0x65,0x66,0x67,0x68,0x69,0x6A,0x6B,0x6C,0x6D,0x6E,0x6F,
    0x70,0x71,0x72,0x73,0x74,0x75,0x76,0x77,0x78,0x79,0x7A,0x5B,0x5C,0x5D,0x5E,0x0A,
    0x60,0x61,0x62,0x63,0x64,0x65,0x66,0x67,0x68,0x69,0x6A,0x6B,0x6C,0x6D,0x6E,0x6F,
    0x70,0x71,0x72,0x73,0x74,0x75,0x76,0x77,0x78,0x79,0x7A,0x7B,0x7C,0x7D,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x20,0x94,0x00,0x00,0x00,0x84,0x81,0xE1,0x99,0x8E,0x9A,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x3F,
    0x40,0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48,0x49,0x4A,0x4B,0x4C,0x4D,0x4E,0x4F,
    0x50,0x51,0x52,0x53,0x54,0x55,0x56,0x57,0x58,0x59,0x5A,0xDB,0x2D,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
  };
  byte* pbIn = gpbInBuf;
  byte* pbOut = gpbOutBuf;
  glGood = 0;
  while (pbIn < gpbInEnd) {
    byte b = abConvert[*pbIn];
    if (b != 0) {
      *pbOut++ = b;
      glGood += gacGood[b];
    } else {
      sprintf((char*)pbOut, "<%02X>", *pbIn);
      pbOut += 4;
      glGood -= 10;
    }
    pbIn++;
  }
  gpbOutEnd = pbOut;
}

void MasterText() {
  const byte abConvert[256] = { // Table from Convert 64, 64'er magazine 7'87
    0x60,0x61,0x62,0x63,0x64,0x65,0x66,0x67,0x68,0x69,0x6A,0x6B,0x6C,0x6D,0x6E,0x6F,
    0x70,0x71,0x72,0x73,0x74,0x75,0x76,0x77,0x78,0x79,0x7A,0x84,0x94,0x81,0xE1,0x00,
    0x20,0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,0x2E,0x2F,
    0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,0x3E,0x3F,
    0x40,0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48,0x49,0x4A,0x4B,0x4C,0x4D,0x4E,0x4F,
    0x50,0x51,0x52,0x53,0x54,0x55,0x56,0x57,0x58,0x59,0x5A,0x8E,0x99,0x9A,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x0A,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
  };
  byte* pbIn = gpbInBuf;
  byte* pbOut = gpbOutBuf;
  glGood = 0;
  while (pbIn < gpbInEnd) {
    byte b = abConvert[*pbIn];
    if (b != 0) {
      *pbOut++ = b;
      glGood += gacGood[b];
    } else {
      sprintf((char*)pbOut, "<%02X>", *pbIn);
      pbOut += 4;
      glGood -= 10;
    }
    pbIn++;
  }
  gpbOutEnd = pbOut;
}

void Protext128() {
  byte* pbIn = gpbInBuf + 0x0110;
  byte* pbOut = gpbOutBuf;
  glGood = 0;
  while (pbIn < gpbInEnd) {
    byte bLength = *pbIn++;
    while (bLength > 0) {
      switch (*pbIn) {
      case 0x5B:
        *pbOut++ = 'é';
        glGood++;
        break;
      case 0x5C:
        *pbOut++ = 'ô';
        glGood++;
        break;
      case 0x5D:
        *pbOut++ = 'ö';
        glGood++;
        break;
      case 0x7B:
        *pbOut++ = 'Ñ';
        glGood++;
        break;
      case 0x7C:
      case 0x1C:
        *pbOut++ = 'î';
        glGood++;
        break;
      case 0x7D:
        *pbOut++ = 'Å';
        glGood++;
        break;
      case 0x7E:
      case 0x1E:
        *pbOut++ = '·';
        glGood++;
        break;
      case 0x00:
        *pbOut++ = '`';
        break;
      case 0x1B:
      case 0x1D:
      case 0x1F:
        break;
      default:
        if (*pbIn >= 1 && *pbIn <= 26) {
          *pbOut = (byte)(96 + (*pbIn & 31));
          glGood += gacGood[*pbOut++];
        } else if (*pbIn >= 65 && *pbIn <= 90) {
          *pbOut = (byte)(64 + (*pbIn & 31));
          glGood += gacGood[*pbOut++];
        } else if (*pbIn >= 32 && *pbIn <= 63) {
          *pbOut = *pbIn;
          glGood += gacGood[*pbOut++];
        } else {
          sprintf((char*)pbOut, "<%02X>", *pbIn);
          pbOut += 4;
          glGood -= 10;
          break;
        }
      }
      pbIn++;
      bLength--;
    }
    *pbOut++ = '\n';
    glGood++;
  }
  if (pbIn == gpbInEnd) {
    glGood += 100;
  }
  gpbOutEnd = pbOut;
}

/*
void BasicV2() {
  byte* pbIn = gpbInBuf + 2;
  byte* pbOut = gpbOutBuf;
  glGood = 0;
  if (gpbInBuf[0] == 1) {
    glGood = 100;
    if (gpbInBuf[1] == 8) {
      glGood = 200;
    }
  }
  while (pbIn < gpbInEnd) {
    pbOut += sprintf((char*)pbOut, "%u ", pbIn[2] | pbIn[3] * 256);
    pbIn += 4;
    while (pbIn < gpbInEnd && *pbIn != 0) {
      const char* apcCmd[128] = {
        "END", "FOR", "NEXT", "DATA", "INPUT#", "INPUT", "DIM", "READ",
        "LET", "GOTO", "RUN", "IF", "RESTORE", "GOSUB", "RETURN", "REM",
        "STOP", "ON", "WAIT", "LOAD", "SAVE", "VERIFY", "DEF", "POKE",
        "PRINT#", "PRINT", "CONT", "LIST", "CLR", "CMD", "SYS", "OPEN",
        "CLOSE", "GET", "NEW", "TAB(", "TO", "SPC(", "THEN", "NOT",
        "STOP", "+", "-", "*", "/", "^", "AND", "OR",
        "<", "=", ">", "SGN", "INT", "ABS", "USR", "FRE",
        "POS", "SQR", "RND", "LOG", "EXP", "COS", "SIN", "TAN",
        "ATN", "PEEK", "LEN", "STR$", "VAL", "ASC", "CHR$", "LEFT$",
        "RIGHT$", "MID$", "GO"
      };
      if (*pbIn == '"') {
        *pbOut++ = '"';
        while (*++pbIn != '"') {
          if (*pbIn == 0) {
            pbIn--;
            break;
          }
          if (gacSmall[*pbIn] != 0) {
            *pbOut++ = gacSmall[*pbIn];
            glGood++;
          } else {
            pbOut += sprintf((char*)pbOut, "<%02X>", *pbIn);
          }
        }
        *pbOut++ = '"';
      } else if (*pbIn < 128) {
        if (gacSmall[*pbIn] != 0) {
          *pbOut++ = gacSmall[*pbIn];
          glGood++;
        } else {
          pbOut += sprintf((char*)pbOut, "<%02X>", *pbIn);
        }
      } else {
        pbOut += sprintf((char*)pbOut, "%s", apcCmd[*pbIn - 128]);
      }
      pbIn++;
    }
    *pbOut++ = '\n';
  }
  if (pbIn == gpbInEnd) {
    glGood += 100;
  }
  gpbOutEnd = pbOut;
}
*/

struct {
  char* pc;
  void (*pfn)();
} gaConvert[] = {
  "CBM Big Letters", CBMBigLetters,
  "CBM Small Letters", CBMSmallLetters,
  "Vizawrite", Vizawrite,
  "Easy Script", EasyScript,
  "Star Texter (untested)", StarTexter,
  "Textomat (untested)", Textomat,
  "Master Text (untested)", MasterText,
  "Protext-128", Protext128,
  //"Basic V2", BasicV2,
  NULL, NULL
};

void DetectFormat() {
  int iBest = 0;
  long lBest = 0;
  int iFormat = 0;
  while (gaConvert[iFormat].pfn != NULL) {
    gaConvert[iFormat].pfn();
    if (glGood > lBest) {
      lBest = glGood;
      iBest = iFormat;
    }
    iFormat++;
  }
  giFormat = iBest;
}

void Display() {
  _settextcolor(0);
  _setbkcolor(7);
  _settextposition(1, 50);
  print("≥ %-30s", gaConvert[giFormat].pc);
  _settextcolor(7);
  _setbkcolor(0);
  if (giLine < 0) {
    giLine = 0;
  }
Again:
  int iY = 1 - giLine;
  byte* pbLine = gpbOutBuf;
  byte* pb = gpbOutBuf;
  do {
    flag fCR = pb >= gpbOutEnd || *pb == '\n';
    int iLength = pb - pbLine;
    if (iLength >= 80) {
      while (pb > pbLine && *pb != ' ') {
        pb--;
      }
      if (pb == pbLine) {
        pb = pbLine + iLength;
      } else {
        iLength = pb++ - pbLine;
      }
      fCR = TRUE;
    }
    if (fCR) {
      if (++iY >= 2) {
        _settextposition((short)iY, 1);
        _outmem((char*)pbLine, (short)iLength);
        _outmem("                                                                                ", (short)(80 - iLength));
        if (iY >= 24) {
          return;
        }
      }
      if (*pb == '\n') {
        pbLine = pb + 1;
      } else {
        pbLine = pb--;
      }
    }
  } while (++pb < gpbOutEnd);
  if (iY < 2) {
    int iLine = giLine + iY - 2;
    if (iLine < 0) {
      iLine = 0;
    }
    if (iLine != giLine) {
      giLine = iLine;
      goto Again;
    }
    iY = 1;
  }
  _settextwindow((short)(iY + 1), 1, 24, 80);
  _clearscreen(_GWINDOW);
  _settextwindow(1, 1, 25, 80);
}

flag Write(char* pcFile) {
  char acDest[80];
  _fullpath(acDest, pcFile, 80);
  char* pcExt = strrchr(acDest, '.');
  if (pcExt == NULL) {
    pcExt = acDest + strlen(acDest);
  }
  strcpy(pcExt, ".txt");
  if (access(acDest, 0) == 0) {
    _settextposition(25, 1);
    _settextcolor(0);
    _setbkcolor(7);
    #if GERMAN
      int iLength = print(" %s gibt es schon. öberschreiben? ", acDest);
    #else
      int iLength = print(" %s exists. Overwrite? ", acDest);
    #endif
    print("                                                            ");
    _settextposition(25, (short)(1 + iLength));
    int iKey;
    do {
      _displaycursor(_GCURSORON);
      iKey = _getch();
      _displaycursor(_GCURSOROFF);
      if (strchr("Nn\x1B", iKey) != NULL) {
        return FALSE;
      }
    } while (strchr("YyJjSsDdOo\x0D", iKey) == NULL);
  }
  FILE* pFile = fopen(acDest, "w");
  fwrite(gpbOutBuf, 1, gpbOutEnd - gpbOutBuf, pFile);
  fclose(pFile);
  return TRUE;
}

int main(int argn, char** argv) {
  #ifdef DEBUG
    _bdos(0x0D, 0, 0);
  #endif
  int iOldDrive;
  int iArg;
  if (argn < 2 || argv[1][0] == '/' || strcmp(argv[1], "?") == 0) {
    #if GERMAN
      printf("\
Bitte geben Sie eine oder mehrere C64 Textdateien in der Kommandozeile an. Es\n\
sind entweder normale DOS-Dateien oder PC64-Dateien (*.P00, *.S00) zulÑssig.\n\
Die Jokerzeichen * und ? sind ebenfalls erlaubt.\n\n");
    #else
      printf("\
Please specify one or more C64 text files on the command line. Format is either\n\
CBM raw or PC64 (*.P00, *.S00). Wildcards * and ? are OK.\n\n");
    #endif
    goto Copyright;
  }
  gpbInBuf = (byte*)_halloc(4096, 16);
  gpbOutBuf = (byte*)_halloc(4096, 16);
  if (gpbInBuf == NULL || gpbOutBuf == NULL) {
    #if GERMAN
      fprintf(stderr, "Zu wenig DOS-Speicher!\n");
    #else
      fprintf(stderr, "Not enough memory!\n");
    #endif
    return 1;
  }
  _displaycursor(_GCURSOROFF);
  _wrapon(_GWRAPOFF);
  _clearscreen(_GCLEARSCREEN);
  iOldDrive = _getdrive();
  char acOldDir[80];
  _getcwd(acOldDir, 80);
  for (iArg = 1; iArg < argn; iArg++) {
    char acDrive[_MAX_DRIVE];
    char acDir[_MAX_DIR];
    char acName[_MAX_FNAME + _MAX_EXT];
    char acExt[_MAX_EXT];
    _splitpath(argv[iArg], acDrive, acDir, acName, acExt);
    _chdrive(acDrive[0] - 64);
    if (strlen(acDir) > 1  && acDir[strlen(acDir) - 1] == '\\') {
      acDir[strlen(acDir) - 1] = 0;
    }
    _chdir(acDir);
    strcat(acName, acExt);
    _find_t Find;
    uint uFind = _dos_findfirst(acName, _A_NORMAL, &Find);
    while (uFind == 0) {
    Screen:
      char acFile[80];
      _fullpath(acFile, Find.name, 80);
      _strlwr(acFile);
      _settextposition(1, 1);
      _settextcolor(0);
      _setbkcolor(7);
      print(" %-80s", acFile);
      _settextposition(25, 1);
      #if GERMAN
        print("\
 +/- Format Ñndern   EINGABE Speichern   LEERTASTE öberspringen   ESC Beenden   ");
      #else
        print("\
 +/- change format   ENTER save file   SPACE skip file   ESC exit               ");
      #endif
      _settextcolor(7);
      _setbkcolor(0);
      int hFile = _open(acFile, _O_BINARY | _O_RDONLY);
      int iPos = 0;
      char acTag[8];
      _read(hFile, acTag, 8);
      if (strcmp(acTag, "C64File") == 0) {
        iPos = 26;
      }
      _lseek(hFile, iPos, SEEK_SET);
      int iSize = _read(hFile, gpbInBuf, 0xFFFE);
      if (iSize == -1) {
        #if GERMAN
          iSize = sprintf((char*)gpbInBuf, "Fehler beim Lesen von %s!", acFile);
        #else
          iSize = sprintf((char*)gpbInBuf, "Error reading %s!", acFile);
        #endif
      }
      _close(hFile);
      gpbInEnd = gpbInBuf + iSize;
      giLine = 0;
      giRow = 0;
      DetectFormat();
    Convert:
      gaConvert[giFormat].pfn();
    Update:
      Display();
    GetKey:
      switch (_getch()) {
      case '+':
        if (gaConvert[giFormat + 1].pc != NULL) {
          giFormat++;
          goto Convert;
        }
        break;
      case '-':
        if (giFormat > 0) {
          giFormat--;
          goto Convert;
        }
        break;
      case 13:
        if (!Write(acFile)) {
          goto Screen;
        }
        // fall through
      case ' ':
        goto Skip;
      case 27:
        goto Exit;
      case 0:
        switch (_getch()) {
        case 0x48:
          giLine--;
          goto Update;
        case 0x50:
          giLine++;
          goto Update;
        case 0x49:
          giLine -= 22;
          goto Update;
        case 0x51:
          giLine += 22;
          goto Update;
        case 0x47:
          giLine = 0;
          goto Update;
        case 0x4F:
          giLine = 32767;
          goto Update;
        }
      }
      goto GetKey;
    Skip:
      uFind = _dos_findnext(&Find);
    }
    _chdrive(iOldDrive);
    _chdir(acOldDir);
  }
Exit:
  _setvideomode(_TEXTC80);
  _displaycursor(_GCURSORON);
  _settextcursor(0x0607);
Copyright:
  #if GERMAN
    printf("\
CBMTEXT.EXE gehîrt zum Personal C64 Emulator. Mit PC64 lassen sich C64 Spiele\n\
und Anwendungen auf dem 486-PC ausfÅhren. Eine öbertragungsmîglichkeit zwischen\n\
C64 und PC ist ebenfalls vorhanden.\n\
\n\
Infos zu PC64 erhalten Sie von: Wolfgang Lorenz, Gundekarstr. 4, D-91187\n\
Rîttenbach, Tel. 09172-2885 von 10 bis 20 Uhr, E-Mail 100112.220@compuserve.com\n");
  #else
    printf("\
CBMTEXT.EXE is part of the Personal C64 emulator. With PC64, you can run C64\n\
games and applications on your 486 PC. A built-in transfer program between C64\n\
and PC is also available. Contacts:\n\
\n\
Australia: Russell Alphey R.Alphey@dce.vic.gov.au\n\
Germany, Austria and Switzerland: Wolfgang Lorenz 100112.220@compuserve.com\n\
Mexico: Roberto AndrÇs Renz Keith rkrenz@campus.mor.itesm.mx\n\
United Kingdom: Lee Taylor gbbs2df2@ibmmail.com\n\
USA and Canada: Ted Drude 71450.726@compuserve.com\n");
  #endif
  return 0;
}
