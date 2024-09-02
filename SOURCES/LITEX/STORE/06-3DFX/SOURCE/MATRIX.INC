(*
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
                     Inertia Realtime 3D Rendering Engine
     Copyright (c) 1996, Alex Chalfin, Jeroen Bouwens. All Rights Reserved.
                     Inertia/16 Source Code Release.
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*)

Procedure MatrixCopy(Var Source, Dest : Matrix4x3);

Begin
  Move(Source, Dest, Sizeof(Matrix4x3));
End;

Procedure InverseMatrix(Var M : Matrix4x3);

Var
  Temp : Matrix4x3;

Begin
  Temp[0] := M[0];  Temp[1] := M[3];    Temp[2] := M[6];
  Temp[3] := M[1];  Temp[4] := M[4];    Temp[5] := M[7];
  Temp[6] := M[2];  Temp[7] := M[5];    Temp[8] := M[8];
  Temp[9] := -M[9]; Temp[10] := -M[10]; Temp[11] := -M[11];
  MatrixCopy(Temp, M);
End;

Procedure InitMatrix(Var M : Matrix4x3);

Begin
  FillChar(M, Sizeof(M), 0);
  M[0] := FIXONE; M[4] := FIXONE; M[8] := FIXONE;
End;
