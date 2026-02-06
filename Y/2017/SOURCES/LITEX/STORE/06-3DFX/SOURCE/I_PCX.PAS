(*
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
                     Inertia Realtime 3D Rendering Engine
            Copyright (c) 1997, Alex Chalfin. All Rights Reserved.
                       Inertia/16 Source Code Release.
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*)


Unit i_PCX;
{$I-}

Interface

Type
  RGB = Record
   r, g, b : Byte;
  End;
  Palette = Array[0..255] of RGB;


Function LoadPCXFile(Filename : String; Var BitMap : Pointer; Var Pal : Palette; Var Size : Word; FOfs : Longint) : Integer;
Procedure SavePCXFile(Filename : String; XSize, YSize : Word; Screen : Pointer; Pal : Palette);

Implementation

Uses
  i_Memory,
  i_BufIO;

Type
  PCXHeaderType = Record
    Manufacturer : Byte;
    Version      : Byte;
    Encoding     : Byte;
    BitsPerPixel : Byte;
    XMin, YMin, XMax, YMax : Integer;
    HDpi, VDpi   : Integer;
    ColorMap     : Array[0..47] of Byte;
    Reserved     : Byte;
    NPlanes      : Byte;
    BytesPerLine : Integer;
    PaletteInfo  : Integer;
    HScreenSize  : Integer;
    VScreenSize  : Integer;
    Filler       : Array[0..53] of Byte;
  End;


Procedure SavePCXFile(Filename : String; XSize, YSize : Word; Screen : Pointer; Pal : Palette);

Var
  Header : PCXHeaderType;
  RunLen : Byte;
  Value : Byte;
  TempB : Byte;
  FileBuffer : Array[0..255] of Byte;
  Diskfile : bFile;
  SSeg, SOfs : Word;
  ScrOfs : Longint;
  Size : Longint;
  x, y : Integer;

Begin
  Header.Manufacturer := 10;
  Header.Version := 5;
  Header.Encoding := 1;
  Header.BitsPerPixel := 8;
  Header.XMin := 0;
  Header.YMin := 0;
  Header.XMax := XSize - 1;
  Header.YMax := YSize - 1;
  Header.HDpi := 320;
  Header.VDpi := 200;
  Header.Reserved := 0;
  Header.NPlanes := 1;
  Header.BytesPerLine := XSize;
  Header.PaletteInfo := 1;
  Header.HScreenSize := XSize;
  Header.VScreenSize := YSize;
  FillChar(Header.ColorMap, Sizeof(Header.ColorMap), 0);
  FillChar(Header.Filler, Sizeof(Header.Filler), 0);

  SSeg := Seg(Screen^);
  SOfs := Ofs(Screen^);

  FAssign(Diskfile, Filename);
  FSetBuffer(Diskfile, FileBuffer, Sizeof(FileBuffer));
  FReWrite(Diskfile);
  FWrite(Diskfile, Header, Sizeof(Header));

  For y := 0 to (YSize - 1) do
    Begin
{      ScrOfs := y*320;}
      x := 0;
      While (x < XSize) do
        Begin
          RunLen := 1;
          Value := Mem[SSeg:SOfs];
          Inc(x);
          While ((Mem[SSeg:SOfs + RunLen] = Value) And (RunLen < 63)) And (x < XSize) do
            Begin
              Inc(RunLen);
              Inc(x);
            End;
          If (RunLen = 1) and ((value and $c0) <> $c0)
            Then FWrite(Diskfile, Value, 1)
            Else Begin
              TempB := RunLen Or $C0;
              FWrite(Diskfile, TempB, 1);
              FWrite(Diskfile, Value, 1);
            End;
          Inc(SOfs, RunLen);
        End;
    End;

  TempB := $0C;

  For y := 0 to 255 do
    Begin
      Pal[y].r := Pal[y].r * 4;
      Pal[y].g := Pal[y].g * 4;
      Pal[y].b := Pal[y].b * 4;
    End;
  FWrite(Diskfile, TempB, 1);
  FWrite(Diskfile, Pal, Sizeof(Pal));
  Flush(Diskfile);
  FClose(Diskfile);
End;

Function LoadPCXFile(Filename : String; Var BitMap : Pointer; Var Pal : Palette; Var Size : Word; FOfs : Longint) : Integer;
{ Returns:  0 - Operation successful    }
{           1 - File not found          }
{           2 - Error reading from file }
{           3 - Not enough memory       }
{           4 - Not a 256 color file    }

Var
  Header : PCXHeaderType;
  TempPtr : Pointer;
  pSize : Longint;
  TextureOffset : Longint;
  RunLen : Byte;
  Value : Byte;
  InRead : Word;
  Buffer : Array[0..255] of Byte;
  Diskfile : bFile;

Begin
  FAssign(Diskfile, FileName);
  FSetBuffer(Diskfile, Buffer, Sizeof(Buffer));
  FReset(Diskfile);
  If IOResult <> 0
    Then Begin
      LoadPCXFile := 1;
      Exit;
    End;
  FSeek(Diskfile, FOfs);
  InRead := FRead(Diskfile, Header, Sizeof(Header));
  If IOResult <> 0
    Then Begin
      FClose(Diskfile);
      LoadPCXFile := 2;
      Exit;
    End;
  If (Header.BitsPerPixel <> 8)
    Then Begin
      FClose(Diskfile);
      LoadPCXFile := 4;
      Exit;
    End;
  pSize := Longint(Header.XMax-Header.XMin+1)*Longint(Header.yMax-Header.YMin+1);

  TempPtr := Malloc(pSize);

  TextureOffset := 0;
  While TextureOffset < pSize do
    Begin
      InRead := FRead(Diskfile, RunLen, 1);
      If IOResult <> 0
        Then Begin
          FClose(Diskfile);
          Free(TempPtr);
          LoadPCXFile := 2;
          Exit;
        End;
      If (RunLen and $C0) = $C0
        Then Begin
          RunLen := RunLen And $3f;
          InRead := FRead(Diskfile, Value, 1);
          If IOResult <> 0
            Then Begin
              FClose(Diskfile);
              Free(TempPtr);
              LoadPCXFile := 2;
              Exit;
            End;
        End
        Else Begin
          Value := RunLen;
          RunLen := 1;
        End;
      While (RunLen >= 1) and (TextureOffset < pSize) do
        Begin
          Mem[Seg(TempPtr^):Ofs(TempPtr^)+TextureOffset] := Value;
          TextureOffset := TextureOffset + 1;
          RunLen := RunLen - 1;
        End;
    End;
  Repeat
    InRead := FRead(Diskfile, Value, 1);
    If IOResult <> 0
      Then Begin
        FClose(Diskfile);
        Free(TempPtr);
        LoadPCXFile := 2;
        Exit;
      End;
  Until (Value = 12);
  InRead := FRead(Diskfile, Pal, Sizeof(Palette));
  If IOResult <> 0
    Then Begin
      FClose(Diskfile);
      Free(TempPtr);
      LoadPCXFile := 2;
      Exit;
    End;
  FClose(Diskfile);

  For Value := 0 to 255 do
    Begin
      Pal[Value].r := Pal[Value].r Div 4;
      Pal[Value].g := Pal[Value].g Div 4;
      Pal[Value].b := Pal[Value].b Div 4;
    End;
  Size := pSize;
  BitMap := TempPtr;
  LoadPCXFile := 0;
End;

End.
