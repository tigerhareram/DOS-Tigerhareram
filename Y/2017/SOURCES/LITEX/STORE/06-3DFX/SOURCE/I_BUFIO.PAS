(*
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
                           Buffered File I/O
           Copyright (c) 1997, Alex Chalfin. All Rights Reserved.
                    Inertia/16 Source Code Release.
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*)

Unit i_BufIO;
{$I-}      { Disable IO checking }

Interface

Type
  tBufferArray = Array[0..511] of Byte;
  pBufferArray = ^tBufferArray;
  bFile = Record
    Diskfile : File;
    Buffer : pBufferArray;
    BufferSize : Word;
    BufferPos : Word;
    FileLoc : Longint;
    R : Boolean
  End;

Procedure FAssign(Var D : bFile; Filename : String);
Procedure FSetBuffer(Var D : bFile; Var Buffer; Size : Word);
Procedure FReset(Var D : bFile);
Function  FRead(Var D : bFile; Var Dest; Count : Word) : Word;
Procedure FClose(Var D : bFile);
Procedure FSeek(Var D : bFile; Location : Longint);
Function bFileSize(D : bFile) : Longint;
Function bFilePos(D : bFile) : Longint;
Function bEOF(D : bFile) : Boolean;
Procedure bReadLn(Var D : bFile; Var S : String);
Procedure FReWrite(Var D : bFile);
Procedure FWrite(Var D : bFile; Var Buf; Count : Word);
Procedure Flush(Var D : bFile);

Implementation

Procedure FAssign(Var D : bFile; Filename : String);

Begin
  Assign(D.Diskfile, Filename);
  D.Buffer := Nil;
  D.BufferSize := 0;
  D.BufferPos := 0;
End;

Procedure FClose(Var D : bFile);

Begin
  Close(D.Diskfile);
End;

Procedure FReWrite(Var D : bFile);

Begin
  ReWrite(D.Diskfile, 1);
  D.BufferPos := 0;
  D.FileLoc := 0;
  D.R := False;
End;

Procedure FSetBuffer(Var D : bFile; Var Buffer; Size : Word);

Begin
  D.Buffer     := @Buffer;
  D.BufferSize := Size;
  D.BufferPos  := Size;
End;

Procedure FReset(Var D : bFile);

Begin
  Reset(D.Diskfile, 1);
  D.FileLoc := 0;
  D.R := True;
End;

Procedure FSeek(Var D : bFile; Location : Longint);

Begin
  Seek(D.Diskfile, Location);
  D.BufferPos := D.BufferSize;
  D.FileLoc := Location;
End;

Function bFileSize(D : bFile) : Longint;

Begin
  bFileSize := FileSize(D.Diskfile);
End;

Function bFilePos(D : bFile) : Longint;

Begin
  bFilePos := D.FileLoc;
End;

Function bEOF(D : bFile) : Boolean;

Begin
  bEOF := (D.FileLoc >= FileSize(D.Diskfile));
End;

Function FRead(Var D : bFile; Var Dest; Count : Word) : Word;

Var
  InRead : Word;
  i, j : Word;
  Temp : pBufferArray;

Begin
  Temp := @Dest;
  If D.BufferSize = 0
    Then Begin
      BlockRead(D.Diskfile, Dest, Count, InRead);
      Inc(D.FileLoc, Count);
      FRead := InRead;
    End
    Else Begin
      For i := 0 to (Count - 1) do
        Begin
          If D.BufferPos >= D.BufferSize
            Then Begin
              BlockRead(D.Diskfile, D.Buffer^, D.BufferSize, InRead);
              If InRead < D.BufferSize
                Then Begin
                  D.BufferPos := 1;
                  Temp^[i] := D.Buffer^[0];
                End
                Else Begin
                  For j := 0 to (InRead - 1) do
                    Begin
                      D.Buffer^[D.BufferSize - InRead + j] := D.Buffer^[j];
                      Temp^[i] := D.Buffer^[0];
                      D.BufferPos := D.BufferSize - InRead + 1;
                    End;
                End;

            End
            Else Begin
              Temp^[i] := D.Buffer^[D.BufferPos];
              Inc(D.BufferPos);
            End;
        End;
      Inc(D.FileLoc, Count);
    End;
  FRead := Count;
End;

Procedure FWrite(Var D : bFile; Var Buf; Count : Word);

Var
  i : Word;
  BS, BO : Word;

Begin
  If D.BufferSize = 0
    Then Begin
      BlockWrite(D.Diskfile, Buf, Count);
      Inc(D.FileLoc);
      Exit;
    End;
  BS := Seg(Buf);
  BO := Ofs(Buf);
  For i := 0 to (Count - 1) do
    Begin
      If (D.BufferPos >= D.BufferSize)
        Then Begin
          BlockWrite(D.Diskfile, D.Buffer^, D.BufferSize);
          D.BufferPos := 0;
        End;
      D.Buffer^[D.BufferPos] := Mem[BS:BO];
      Inc(D.BufferPos);
      Inc(BO);
      Inc(D.FileLoc);
    End;
End;


Procedure Flush(Var D : bFile);

Begin
  If Not(D.R)
    Then BlockWrite(D.Diskfile, D.Buffer^, D.BufferPos);
End;


Procedure bReadLn(Var D : bFile; Var S : String);

Var
  C : Char;
  InRead : Word;

Begin
  S := '';
  Repeat
    InRead := FRead(D, C, 1);
    If (C <> #13) and (C <> #10) { check for carrige return and line feed }
      Then S := S + C;
  Until C = #13;
End;

End.
