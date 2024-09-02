(*
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
                     Inertia Realtime 3D Rendering Engine
            Copyright (c) 1997, Alex Chalfin. All Rights Reserved.
                       Inertia/16 Source Code Release.
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*)
Unit i_Matrix;
{$I ..\SOURCE\Litex\STORE\06-3DFX\SOURCE\DEFINE.INC}

Interface

Uses
  Misc,
  i_Types;

Procedure MatrixCopy(Var Source, Dest : Matrix4x3);
Procedure InitMatrix(Var M : Matrix4x3);
Procedure SetRotationMatrix(Var M : Matrix4x3; xa, ya, za : Single);
Procedure SetScaleMatrix(Var M : Matrix4x3; sx, sy, sz : Single);
Procedure MatrixMul(Var Result, A, B : Matrix4x3);
Procedure MatrixOrthoNormalize(Var M : Matrix4x3);
Procedure AxisRotate(Var M : Matrix4x3; angle, x, y, z : Single);

Implementation

Procedure MatrixCopy(Var Source, Dest : Matrix4x3);

Begin
  Move(Source, Dest, sizeof(Matrix4x3));
End;

Procedure InitMatrix(Var M : Matrix4x3);

Begin
  FillChar(M, sizeof(Matrix4x3), 0);

  M[0] := FIXONE; M[4] := FIXONE; M[8] := FIXONE;
End;

Procedure SetScaleMatrix(Var M : Matrix4x3; sx, sy, sz : Single);

Begin
  FillChar(M, sizeof(Matrix4x3), 0);
  M[0] := Round(sx * FIXONE);
  M[4] := Round(sy * FIXONE);
  M[8] := Round(sz * FIXONE);
End;

{$F+}
{$L I_MATRIX.OBJ}
Procedure MatrixMul(Var Result, A, B : Matrix4x3); External;
{$F-}

Procedure SetRotationMatrix(Var M : Matrix4x3; xa, ya, za : Single);

Var
  sx, sy, sz : Real;
  cx, cy, cz : Real;

Begin
  sx := sin(xa); sy := sin(ya); sz := sin(za);
  cx := cos(xa); cy := cos(ya); cz := cos(za);

  M[0] := Round(((cz * cy) + (sx * sz * sy)) * FIXONE);
  M[3] := Round(((cy * -sz) + (cz * sx * sy)) * FIXONE);
  M[6] := Round((cx * sy) * FIXONE);
  M[1] := Round((sz * cx) * FIXONE);
  M[4] := Round((cz * cx) * FIXONE);
  M[7] := Round((-sx) * FIXONE);
  M[2] := Round(((-sy * cz) + (sz * sx * cy)) * FIXONE);
  M[5] := Round(((sz * sy) + (cz * sx * cy)) * FIXONE);
  M[8] := Round((cx * cy) * FIXONE);
End;


Procedure MatrixOrthoNormalize(Var M : Matrix4x3);

Begin
End;

Procedure AxisRotate(Var M : Matrix4x3; angle, x, y, z : Single);

Var
  cosa, sina : Real;
  dot, dx, dy, dz : Real;
  rx, ry, rz : Real;
  cx, cy, cz : Real;
  i : Integer;

Begin
  cosa := cos(angle);
  sina := sin(angle);

  For i := 0 to 2 do
    Begin
      dot := (x * M[i+0] + y * M[i+3] + z * M[i+6]);

      dx := dot * x * (1.0 - cosa);
      dy := dot * y * (1.0 - cosa);
      dz := dot * z * (1.0 - cosa);

      rx := M[i+0] * cosa;
      ry := M[i+3] * cosa;
      rz := M[i+6] * cosa;

      cx := (y * M[i+6] - z * M[i+3]) * sina;
      cy := (z * M[i+0] - x * M[i+6]) * sina;
      cz := (x * M[i+3] - y * M[i+0]) * sina;

      M[i+0] := Round(rx + dx + cx);
      M[i+3] := Round(ry + dy + cy);
      M[i+6] := Round(rz + dz + cz);
    End;
End;


End.
