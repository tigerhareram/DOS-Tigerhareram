(*
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
                     Inertia Realtime 3D Rendering Engine
            Copyright (c) 1997, Alex Chalfin. All Rights Reserved.
                       Inertia/16 Source Code Release.
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*)

Unit i_Memory;
{
  Stupid TP memory manager can't handle things properly (the way we want)
  so lets write a new one :)

  How does this thing work? Any of you that have used C memory functions
  will find this nice.

  Malloc() - allocates a block of the specified size.
  Free()   - frees a memory block. No need to keep the size (unlike the
             totally lame GetMem/FreeMem stuff).
  Realloc()- reallocates a block of memory (changes size).
}

Interface

Function  Malloc(Size : Longint) : Pointer;
Procedure Free(P : Pointer);
Function  Realloc(P : Pointer; Size : Longint) : Pointer;

Implementation

Type
  pMemoryRec = ^MemoryRec;
  MemoryRec = Record
    Size : Longint;
    Loc  : Pointer;
    Next : pMemoryRec;
  End;

Const
  MemList : pMemoryRec = NIL;

{$IFDEF DPMI}
Procedure SetSelectorLimit(Selector : Word; Limit : Word); Assembler;
{ A stupid hack to get around BP7's lame Getmem() function }

Asm
  Mov  ax,008h
  Mov  bx,Selector
  Xor  cx,cx
  Mov  dx,Limit
  Int  31h
End;
{$ENDIF}


Function  Malloc(Size : Longint) : Pointer;

Var
  TempMemRec    : pMemoryRec;
  TempPtr       : Pointer;

Begin
  if ((Size And $ffff) = 0)
    Then Size := $ffff;

  Getmem(TempPtr, Size);

  if (TempPtr = NIL)
    Then Begin
      Malloc := NIL;
      Exit;
    End;

  New(TempMemRec);

  if (TempMemRec = NIL)
    Then Begin
      Freemem(TempPtr, Size);
      Malloc := NIL;
      Exit;
    End;

{$IFDEF DPMI}
  { another stupid hack to get around TP's mem manager }
  if (Size = $ffff)
    Then SetSelectorLimit(Seg(TempPtr^), $ffff);
{$ENDIF}

  TempMemRec^.Size := Size;
  TempMemRec^.Loc  := TempPtr;
  TempMemRec^.Next := MemList;

  MemList := TempMemRec;

  Malloc := TempPtr;
End;

Procedure Free(P : Pointer);

Var
  Traverse : pMemoryRec;
  Prev     : pMemoryRec;

Begin
  Traverse := MemList;
  Prev     := MemList;

  While (Traverse <> NIL) do
    Begin
      if (Traverse^.Loc = P)
        Then Begin
          Freemem(Traverse^.Loc, Traverse^.Size);

          if (Prev = Traverse)
            Then Begin
              MemList := Traverse^.Next;
              Dispose(Traverse);
            End
            Else Begin
              Prev^.Next := Traverse^.Next;
              Dispose(Traverse);
            End;

          Exit;
        End;

      Prev     := Traverse;
      Traverse := Traverse^.Next;
    End;
End;

Function  Realloc(P : Pointer; Size : Longint) : Pointer;

Var
  Traverse : pMemoryRec;
  TempPtr : Pointer;

Begin
  Traverse := MemList;

  if (P = Nil)
    Then Begin
      Realloc := Malloc(Size);
      Exit;
    End;

  While (Traverse <> NIL) do
    Begin
      if (Traverse^.Loc = P)
        Then Begin
          TempPtr := Malloc(Size); { allocate new area }

          if (TempPtr = NIL)       { check to see if it allocated }
            Then Begin
              Realloc := NIL;
              Exit;
            End;

          if (Size < Traverse^.Size)
            Then Move(Traverse^.Loc^, TempPtr^, Size)   { copy the data over }
            Else Move(Traverse^.Loc^, TempPtr^, Traverse^.Size);

          Freemem(Traverse^.Loc, Traverse^.Size); { free the old data }
          Traverse^.Loc  := TempPtr;              { assign to new size and location }
          Traverse^.Size := Size;

          Realloc := TempPtr;
          Exit;
        End;

      Traverse := Traverse^.Next;
    End;
  Realloc := NIL;
End;

Function MemoryHeapError(Size : Word) : Integer; Far;

Begin
  MemoryHeapError := 1;  { Cause Getmem or New to return a NIL pointer }
End;

Begin
  HeapError := @MemoryHeapError;
End.
