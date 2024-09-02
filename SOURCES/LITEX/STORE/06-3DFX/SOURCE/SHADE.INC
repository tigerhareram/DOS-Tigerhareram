(*
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
                     Inertia Realtime 3D Rendering Engine
            Copyright (c) 1997, Alex Chalfin. All Rights Reserved.
                       Inertia/16 Source Code Release.
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*)

Procedure AmbientShade(Var Obj : VectorObject);

Var
  i      : Integer;
  LDot   : Integer;
  LCount : Integer;
  Dot    : Integer;

Begin
  With Obj do
    Begin
      For i := 0 to (Num_Polygons - 1) do
        Begin
          If CullList^[i].Visible = 1
            Then CullList^[i].Color := 16;
        End;
    End;
End;


Procedure LambertShade(Var Obj : VectorObject);

Var
  i      : Integer;
  LDot   : Integer;
  LCount : Integer;
  Dot    : Integer;

Begin
  With Obj do
    Begin
      For i := 0 to (Num_Polygons - 1) do
        Begin
          If CullList^[i].Visible = 1
            Then Begin
              LDot := 0;
              For LCount := 0 to (Lights.NumLights - 1) do
                Begin
                  Dot := DotProduct8(Lights.TempLight[LCount], Polygon_Normals^[i]);
                  If Dot > 0 Then Inc(LDot, Dot);
                End;
              LDot := LDot Shr 2;
              Clip(LDot, 0, 63);
              CullList^[i].Color := LDot;
            End;
        End;
    End;
End;

Procedure GouraudShade(Var Obj : VectorObject);

Var
  i : Integer;
  LDot : Integer;
  LCount : Integer;
  Dot : Integer;
  CullSeg, CullOfs : Word;


Begin
  With Obj do
    Begin
      For i := 0 to (Num_Verticies - 1) do
        Begin
          If RotateList^[i].b1 = 1
            Then Begin
              LDot := 0;
              For LCount := 0 to (Lights.NumLights - 1) do
                Begin
                  Dot := DotProduct8(Lights.TempLight[LCount], Vertex_Normals^[i]);
                  If Dot > 0 Then LDot := LDot + Dot;
                End;
              If LDot < 1 Then LDot := 1;
              If LDot > 255 Then LDot := 255;

              RotateList^[i].b2 := LDot;
            End;
        End;
    End;
End;

Procedure PhongShade(Var Obj : VectorObject; xAxis, yAxis : Vertex3d; CenterX, CenterY : Integer);

Var
  i : Integer;
  Temp : Integer;

Begin
  With Obj do
    Begin
      For i := 0 to (Num_Verticies - 1) do
        Begin
          If RotateList^[i].b1 = 1
            Then Begin
              Temp := DotProduct8(xAxis, Vertex_Normals^[i]) Div 2 + CenterX;
              If Temp < 0 Then Temp := 0;
              If Temp > 255 Then Temp := 255;
              RotateList^[i].b3 := Temp;
              Temp := DotProduct8(yAxis, Vertex_Normals^[i]) Div 2 + CenterY;
              If Temp < 0 Then Temp := 0;
              If Temp > 255 Then Temp := 255;
              RotateList^[i].b4 := Temp;
            End;
        End;
    End;
End;

