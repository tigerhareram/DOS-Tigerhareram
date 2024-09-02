(*
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
                     Inertia Realtime 3D Rendering Engine
            Copyright (c) 1997, Alex Chalfin. All Rights Reserved.
                       Inertia/16 Source Code Release.
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*)

Var
  JIndex, KIndex : Integer;
  A, B, C : Integer;


Procedure ZClip(Var Obj : VectorObject; Var View : ViewObject);

Var
  i : Integer;
  Flag1, Flag2, Flag3 : Boolean;

Begin
  For i := 0 to (Obj.Num_Polygons - 1) do
    Begin
      If Obj.CullList^[i].Visible = 1
        Then Begin
          A := Obj.Polygons^[i].a;
          B := Obj.Polygons^[i].b;
          C := Obj.Polygons^[i].c;

          Flag1 := (Obj.World_Coords^[a].z < View.FustrumMinZ);
          Flag2 := (Obj.World_Coords^[b].z < View.FustrumMinZ);
          Flag3 := (Obj.World_Coords^[c].z < View.FustrumMinZ);

          If (Flag1 or Flag2) or (Flag3)
            Then Obj.CullList^[i].Visible := 0;
        End;
    End;
End;

