Unit IffUnit;
{****************************************************************************
 * Author           : Thomas Koos, Germany                                  *
 * Version          : unofficial 0.1c                                       *
 *******                                                                    *
 * my mail-adress   : Muetze1@gmx.de                                        *
 ****** HISTORY *************************************************************
 * Version 0.1     : -base code                                             *
 *                   -problems with original Amiga ILBMs (function of the   *
 *                     CAMG Chunk ???)                                      *
 *         0.1a    : -Now I know the function of CAMG - but it doesn't help *
 *                   *cOutBuffer static -> cOutBuffer runtime alloc         *
 *                   *changed for-to-do constructs to FillByte              *
 *         0.1b    : -removed unused vars                                   *
 *                   *moved public vars into proc                           *
 *         0.1c    : +Stefan Goehler (stefan.goehler@gmx.de) added a read   *
 *                    buffer (ThanX!)                                       *
 *                   -SaveIFF runs not yet correctly: it seems, that the    *
 *                    pixel rows have to be filled with "spaces"            *
 *                    (LoadIFF can't load saved pix, but PV/QPV etc can)    *
 *                   *all comments now complete in english                  *
 *         0.2     : *saveiff routine bugfixed                              *
 *                   *speed of pbm-loader improved (uncompressed images)    *
 *                   *some parts rewritten to asm... not the best asm, but  *
 *                    it's noticeable faster                                *
 ****************************************************************************}

Interface

Uses GrafX, Gr_Vars, FCache;

Function LoadIFF(px, py : Integer; Name: String) : Byte;
         { * loads an IFF/ILBM picture "Name" to the position [px,py]
           * }
Function SaveIFF(x1, y1, x2, y2 : Integer; Name : String) : Byte;
         { * saves the rectangle [x1,y1]-[x2,y2] from screen to file
           * "Name" - caution! the saved file can't yet be read by LoadIFF!
           * }
Function Info_IFF(Name : String; Var Image_Info : TImage_Info) : Byte;
         { * checks the file "Name" for an IFF/ILBM pix and fills the
           * Image_Info record according to the file info of the IFF
           * }

Implementation

Type    fFormHdr = Record
          Sign     : Array[0..3] of Char;
          nLen     : LongInt;
          cDataTyp : Array[0..3] of Char;
        End;
        fChunkHdr = Record
          cName    : Array[0..3] of Char;
          nLen     : LongInt;
        End;
        fBMHD = Record
          nImageWidth        : Word;
          nImageHeight       : Word;
          unused1            : LongInt;
          nNumberOfBitplanes : Byte;
          unused2            : Byte;
          nCompress          : ByteBool;
          unused3            : Array[0..8] Of Byte;
        End;
        Buffer = Array[0..2047] of Byte;

Const   _FORM : Array[0..3] of Char = 'FORM'; { surrounds an pic }
        _ILBM : Array[0..3] of Char = 'ILBM'; { Amiga format }
        _PBM  : Array[0..3] of Char = 'PBM '; { PC format }
        _BMHD : Array[0..3] of Char = 'BMHD'; { Bitmap header }
        _CMAP : Array[0..3] of Char = 'CMAP'; { Colormap }
        _BODY : Array[0..3] of Char = 'BODY'; { picture data }
{        nMask : Array[0..7] of Byte = ($01, $02, $04, $08, $10, $20, $40, $80);}

Var     fh              : tfilerec;     { filehandle }
        BMHD            : fBMHD;
        cOutBuffer      : ^Buffer;
        bpp             : byte;

Function  SwapW(a : Word): Word; Assembler;
Asm
 mov  ax, a
 xchg ah, al
End;

Function  SwapL(a : LongInt): LongInt; Assembler;
Asm
 mov  ax, word ptr [a+02]
 mov  dx, word ptr [a+00]
 xchg ah, al
 xchg dh, dl
End;

Procedure DecodePBM(px, py : Integer);
Var   nMask2        : Byte;
      i, j, nCol    : Word;
      nSteuer       : Byte;
      nPixel        : Byte;
      nNoBytePerRow : Word;
      cLine         : word;
Begin
  cLine := 0;
  nNoBytePerRow := (BMHD.nImageWidth+7) shr 3;
  Inc(nNoBytePerRow, nNoBytePerRow and 1);
  if not BMHD.nCompress Then
  while ((not EndOfFile(fh)) and (cLine < BMHD.nImageHeight)) do
  Begin
    if (fh.fpos < fh.fsize)and
       (fh.bufpos+nNoBytePerRow*BMHD.nNumberOfBitplanes > fh.bufsize) then
         refillbuffer(fh);
    Image_PutLine(px, py + cLine, BMHD.nImageWidth, bpp,
                  ptr(seg(fh.loadbuf^),ofs(fh.loadbuf^)+fh.bufpos));
    inc(fh.bufpos,nNoBytePerRow*BMHD.nNumberOfBitplanes);
    Inc(cLine);
  End else
  while ((not EndOfFile(fh)) and (cLine < BMHD.nImageHeight)) do
  Begin
    nCol := 0;
    While (nCol < nNoBytePerRow*BMHD.nNumberOfBitplanes) Do
    Begin
      nSteuer := GetByte(fh);
      If (nSteuer > $80) Then
      Begin
        FillByte(cOutBuffer^[nCol], Byte(-nSteuer)+1, GetByte(fh));
        Inc(nCol, Byte(-nSteuer)+1);
      End;
      If (nSteuer < $80) Then
      Begin
        Inc(nSteuer);
        BufferRead(fh, cOutBuffer^[nCol], nSteuer);
        Inc(nCol, nSteuer);
      End;
    End;
    Image_PutLine(px, py + cLine, BMHD.nImageWidth, bpp, cOutBuffer);
    Inc(cLine);
  End;
End;

Procedure DecodeILBM(px, py : Integer);
Var   nMask2        : Byte;
      i, j, nCol    : Word;
      nSteuer       : Byte;
      nPixel        : Byte;
      nNoBytePerRow : Word;
      ILBMBuf       : Array[0..7, 0..127] of Byte;
      cLine         : word;
Begin
  cLine := 0;
  nNoBytePerRow := (BMHD.nImageWidth+7) shr 3;
  Inc(nNoBytePerRow, nNoBytePerRow and 1);

  if not BMHD.nCompress Then
  While ((Not EndOfFile(fh)) and (cLine < BMHD.nImageHeight)) do
  Begin
    for i := 0 to (BMHD.nNumberOfBitplanes-1) do
    BufferRead(fh, ILBMBuf[i, 0], nNoBytePerRow);
    asm
      xor   dx,dx
      les   di,coutbuffer
    @lp:
      mov   cx,dx
      and   cx,111b
      xor   cx,111b
      mov   bh,1
      shl   bh,cl
      mov   si,dx
      shr   si,3
      mov   bl,1
      mov   cl,BMHD.nNumberOfBitplanes
      xor   ax,ax
      @lp2:
        mov   al,ilbmbuf[si].byte
        and   al,bh
        jz    @next
          or   ah,bl
        @next:
        add   bl,bl
        add   si,128
      dec   cl
      jnz   @lp2
      mov   es:[di],ah
      inc   di
      inc   dx
      cmp   dx,BMHD.nImageWidth
      jne   @lp
    end;
    Image_PutLine(px, py + cLine, BMHD.nImageWidth, bpp, cOutBuffer);
    Inc(cLine);
  end else
  While ((Not EndOfFile(fh)) and (cLine < BMHD.nImageHeight)) do
  Begin
    for i := 0 to (BMHD.nNumberOfBitPlanes-1) do
    Begin
      nCol := 0;
      while (nCol < nNoBytePerRow) do
      Begin
        nSteuer := GetByte(fh);
        if (nSteuer < $80) Then
        Begin
          BufferRead(fh, ILBMBuf[i, nCol], nSteuer+1);
          Inc(nCol, nSteuer+1);
        End;
        if nSteuer > $80 Then
        Begin
          FillByte(ILBMBuf[i, nCol], Byte(-nSteuer)+1, GetByte(fh));
          Inc(nCol, Byte(-nSteuer)+1);
        End;
      End;
    End;
    if (nCol <> nNoBytePerRow) Then
    Exit;
    asm
      xor   dx,dx
      les   di,coutbuffer
    @lp:
      mov   cx,dx
      and   cx,111b
      xor   cx,111b
      mov   bh,1
      shl   bh,cl
      mov   si,dx
      shr   si,3
      mov   bl,1
      mov   cl,BMHD.nNumberOfBitplanes
      xor   ax,ax
      @lp2:
        mov   al,ilbmbuf[si].byte
        and   al,bh
        jz    @next
          or   ah,bl
        @next:
        add   bl,bl
        add   si,128
      dec   cl
      jnz   @lp2
      mov   es:[di],ah
      inc   di
      inc   dx
      cmp   dx,BMHD.nImageWidth
      jne   @lp
    end;
    Image_PutLine(px, py + cLine, BMHD.nImageWidth, bpp, cOutBuffer);
    Inc(cLine);
  End;
End;

Function Info_IFF(Name: String; Var Image_Info : TImage_Info) : Byte;
Var FormHeader      : fFormHdr;
    ChunkHeader     : fChunkHdr;
    PBM             : Boolean;
    ifh             : File;

Procedure Info_Error;
Begin
  Info_IFF := Image_FalseFormat;
  Close(ifh);
  Exit;
End;

Begin
  Info_IFF := Image_FileNotFound;
  {$I-}
  FileMode := $40;
  Assign(ifh, Name);
  Reset(ifh, 1);
  {$I+}
  If IOResult <> 0 Then
    Exit;

  BlockRead(ifh, FormHeader, SizeOf(FormHeader));
  Inc(FormHeader.nLen, FormHeader.nLen and 1); { no odd length! }
  If FormHeader.Sign <> _FORM Then
    Info_Error;
  If FormHeader.cDataTyp = _PBM Then
    PBM := True;
  If FormHeader.cDataTyp = _ILBM Then
    PBM := False;
  If ((FormHeader.cDataTyp <> _PBM) and (FormHeader.cDataTyp <> _ILBM)) Then
    Info_Error;

  Repeat
    If EOF(ifh) Then
      Info_Error;

    BlockRead(ifh, ChunkHeader, SizeOf(ChunkHeader));
    ChunkHeader.nLen := SwapL(ChunkHeader.nLen);
    Inc(ChunkHeader.nLen, ChunkHeader.nLen and 1); { odd length get even }
    If ChunkHeader.cName = _BMHD Then
    Begin
      If ChunkHeader.nLen >= 20 Then
      Begin
        BlockRead(ifh, BMHD, SizeOf(BMHD));
        With Image_Info Do
        Begin
          Size.X       := SwapW(BMHD.nImageWidth);
          Size.Y       := SwapW(BMHD.nImageHeight);
          BPP          := BMHD.nNumberOfBitplanes;
          GreyScale    := False;
          AlphaChannel := False;
          Transparency := False;
          Compressed   := BMHD.nCompress;
          If BMHD.nCompress Then
            CompType := 'RLE'
          Else
            CompType := 'none';
          Interlaced   := False;
          Frames       := 1;
          Speed        := 0;
          MemSize      := (LongInt(Size.X) * Size.Y * Bpp shr 3) + ImageDataSize;
          DiskSize     := FileSize(ifh);
          Trans_Color  := 0;
          Supported    := True;
          Version      := 1;
        End;
        If ChunkHeader.nLen - SizeOf(BMHD) > 0 Then
          Seek(ifh, FilePos(ifh) + ChunkHeader.nLen - SizeOf(BMHD));
      End
      Else
        Info_Error;  { BitMapHeader is too short }
    End;
  Until ChunkHeader.cName = _BODY;
End;

Function LoadIFF(px, py : Integer; Name: String) : Byte;
Var  CMAPfound       : Boolean;
     FormHeader      : fFormHdr;
     ChunkHeader     : fChunkHdr;
     PBM             : Boolean;
     BODYPos         : LongInt;
     i               : integer;

Procedure Load_Error;
Begin
  LoadIFF := Image_FalseFormat;
  CloseFile(fh);
  Exit;
End;

Begin
  PBM     := False;
  LoadIFF := Image_FileNotFound;
  If OpenFile(Name, fm_ro OR fm_DenyNone, 32768, fh) <> 0 Then  { fnf }
    Exit;

  BufferRead(fh, FormHeader, SizeOf(FormHeader));
  Inc(FormHeader.nLen, FormHeader.nLen and 1);
  If FormHeader.Sign <> _FORM Then
    Load_Error;
  If FormHeader.cDataTyp = _PBM Then
    PBM := True;
  If ((FormHeader.cDataTyp <> _PBM) and (FormHeader.cDataTyp <> _ILBM)) Then
    Load_Error;

  CMAPFound := False;
  BODYPos   := 0;

  Repeat
    If EndOfFile(fh) Then
      Load_Error;

    BufferRead(fh, ChunkHeader, SizeOf(ChunkHeader));
    ChunkHeader.nLen := SwapL(ChunkHeader.nLen);
    Inc(ChunkHeader.nLen, ChunkHeader.nLen and 1);

    If ChunkHeader.cName = _BMHD Then
    Begin
      If ChunkHeader.nLen >= 20 Then
      Begin
        BufferRead(fh, BMHD, SizeOf(BMHD));
        BMHD.nImageWidth   := SwapW(BMHD.nImageWidth);
        BMHD.nImageHeight  := SwapW(BMHD.nImageHeight);
        case BMHD.nNumberOfBitPlanes of
          4..8 : bpp := 8;
          else bpp := BMHD.nNumberOfBitPlanes;
        end;
        If ChunkHeader.nLen - SizeOf(BMHD) > 0 Then
          BufferSeek(fh, BufferFilePos(fh) + ChunkHeader.nLen - SizeOf(BMHD));
      End
      Else
        Load_Error; { BODY is too short }
    End;
    If ChunkHeader.cName = _BODY Then
    Begin
      If CMAPFound = False Then
      Begin
        BODYpos := BufferFilePos(fh);
        BufferSeek(fh, BufferFilePos(fh) + ChunkHeader.nLen);
      End
      Else
      Begin
       New(cOutBuffer);
       if PBM Then
         DecodePBM(px, py)
       Else
         DecodeILBM(px, py);
       Dispose(cOutBuffer);

       LoadIFF := Image_NoError;
       CloseFile(fh);
       Exit;
      End;
    End;
    If ChunkHeader.cName = _CMAP Then
    Begin
      BufferRead(fh, Pal^, ChunkHeader.nLen);
{      if ChunkHeader.nLen div 3 = 256 then SetPal
      else begin
        for i := 0 to ChunkHeader.nLen div 3-1 do
        setrgbpalette(i,pal^[i].r,pal^[i].g,pal^[i].b);
      end;}
      setpal;
      CMAPfound := True;
      If BODYpos > 0 Then
      Begin
       BufferSeek(fh, BODYpos);
       New(cOutBuffer);
       If PBM Then
         DecodePBM(px, py)
       Else
         DecodeILBM(px, py);
       Dispose(cOutBuffer);
       CloseFile(fh);
       LoadIFF := Image_NoError;
       Exit;
      End;
    End;
    if ((ChunkHeader.cName <> _BODY) and
        (ChunkHeader.cName <> _CMAP) and
        (ChunkHeader.cName <> _BMHD)) Then
    Begin
      BufferSeek(fh, bufferFilepos(fh) + ChunkHeader.nLen);
    End;
  Until EndOfFile(fh);

  CloseFile(fh);
  LoadIFF := Image_NoError;
End;

Function SaveIFF(x1, y1, x2, y2 : Integer; Name : String) : Byte;
Const TextInfo     : String = 'written with '+GrafX_Version+' ';
Var   FormHeader   : fFormHdr;
      ChunkHeader  : fChunkHdr;
      BitmapHeader : fBMHD;
      ret          : Word;
      y            : Integer;
      LineSize     : Word;
      Line         : Pointer;
      sf           : File;
Begin
  SaveIFF := Image_FileError;
  {$I-}
  FileMode := $40;
  Assign(sf, Name);
  ReWrite(sf, 1);
  {$I+}
  If IOResult <> 0 Then
    Exit;
  SaveIFF := Image_NoDiskMem;

  LineSize := x2-x1+1;
  if CurrentMode.bpp > 8 Then
    LineSize := LineSize * 3;

  FormHeader.Sign     := 'FORM';
  FormHeader.nLen     := LineSize*(y2-y1) + 36 + Length(TextInfo);
  If CurrentMode.bpp <= 8 Then
    Inc(FormHeader.nLen, 3*(LongInt(1) shl CurrentMode.bpp) + 8);
  FormHeader.cDataTyp := 'PBM ';
  BlockWrite(sf, FormHeader, SizeOf(FormHeader), ret);
  if ret <> SizeOf(FormHeader) Then
    Exit;

  if x1 > x2 then gr_vars.swapw(x1,x2);
  if y1 > y2 then gr_vars.swapw(y1,y2);

  ChunkHeader.cName := 'BMHD';
  ChunkHeader.nLen  := SwapL(20);
  BlockWrite(sf, ChunkHeader, SizeOf(ChunkHeader), ret);
  if ret <> SizeOf(ChunkHeader) Then
    Exit;
  FillByte(BitMapHeader, SizeOf(BitMapHeader), 0);
  BitMapHeader.nImageWidth        := SwapW(x2-x1+1);
  BitMapHeader.nImageHeight       := SwapW(y2-y1+1);
  BitMapHeader.nNumberOfBitplanes := CurrentMode.bpp;
  BitMapHeader.nCompress          := False;
  BlockWrite(sf, BitMapHeader, SizeOf(BitMapHeader), ret);
  If ret <> SizeOf(BitMapHeader) Then
    Exit;

  ChunkHeader.cName := 'TEXT';
  ChunkHeader.nLen  := SwapL(Length(TextInfo) + (Length(TextInfo) and 1));
  BlockWrite(sf, ChunkHeader, SizeOf(ChunkHeader), ret);
  If ret <> SizeOf(ChunkHeader) Then
    Exit;
  BlockWrite(sf, TextInfo[1], SwapL(ChunkHeader.nLen), ret);
  If ret <> SwapL(ChunkHeader.nLen) Then
    Exit;

  If CurrentMode.bpp <= 8 Then
  Begin
    ChunkHeader.cName := 'CMAP';
    ChunkHeader.nLen  := SwapL(3*(LongInt(1) shl CurrentMode.bpp));
    BlockWrite(sf, ChunkHeader, SizeOf(ChunkHeader), ret);
    if ret <> SizeOf(ChunkHeader) Then
      Exit;
    GetPal;
    BlockWrite(sf, pal^, 3*(LongInt(1) shl CurrentMode.bpp), ret);
    if ret <> 3*(LongInt(1) shl CurrentMode.bpp) Then
      Exit;
  End;

  ChunkHeader.cName := 'BODY';
  ChunkHeader.nLen  := SwapL(LineSize*(y2-y1+1));
  BlockWrite(sf, ChunkHeader, SizeOf(ChunkHeader), ret);
  If ret <> SizeOf(ChunkHeader) Then
    Exit;

  GetMem(Line, LineSize);
  For y := y1 To y2 Do
  Begin
    Image_GetLine(x1, y, x2-x1+1, CurrentMode.bpp, Line);
    BlockWrite(sf, Line^, LineSize, ret);
    If ret <> LineSize Then
    Begin
      FreeMem(Line, LineSize);
      Exit;
    End;
  End;
  FreeMem(Line, LineSize);
  SaveIFF := Image_NoError;
  Close(sf);
End;

Begin
End.
