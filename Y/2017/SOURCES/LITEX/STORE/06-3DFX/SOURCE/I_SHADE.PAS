(*
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
                     Inertia Realtime 3D Rendering Engine
            Copyright (c) 1997, Alex Chalfin. All Rights Reserved.
                       Inertia/16 Source Code Release.
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*)

Unit i_Shade;

Interface

Uses i_Types,
     i_Memory;

Procedure AddPolygonToRenderList(Var Obj : VectorObject; Idx : Integer; T : Integer);

Implementation

Procedure AddPolygonToRenderList(Var Obj : VectorObject; Idx : Integer; T : Integer);

Var
  TmpPtr  : pSortList;
  TempPtr1 : Pointer;
  TempPtr2 : Pointer;
  DivCount, ModCount : Integer;
  NewCount, NewCount2 : Integer;
  A, B, C : Integer;
  JIndex, KIndex : Integer;

Begin
  if (RenderList.Count > MAXPOLYGONS)
    Then Exit;

  if (RenderList.Count >= RenderList.Allocated)
    Then Begin
      TmpPtr := Realloc(RenderList.SortList, Word(RenderList.Allocated + 64) * sizeof(SortRec));

      if (TmpPtr = Nil)
        Then Exit;

      RenderList.SortList := TmpPtr;

      DivCount := RenderList.Allocated Div POLYLISTSIZE;
      ModCount := RenderList.Allocated Mod POLYLISTSIZE;

      if ((ModCount + 64) >= POLYLISTSIZE)
        Then Begin
          NewCount  := POLYLISTSIZE;
          NewCount2 := ModCount + 64 - POLYLISTSIZE;

          TempPtr1 := Realloc(RenderList.PolygonList[DivCount], Word(POLYLISTSIZE) * sizeof(tPolygonRec));
          TempPtr2 := Realloc(RenderList.PolygonList[DivCount+1], Word(NewCount2) * sizeof(tPolygonRec));
          if (TempPtr1 = Nil) or (TempPtr2 = Nil)
            Then Exit;

          RenderList.PolygonList[DivCount]   := TempPtr1;
          RenderList.PolygonList[DivCount+1] := TempPtr2;
        End
        Else Begin
          TempPtr1 := Realloc(RenderList.PolygonList[DivCount], Word(ModCount+64)*sizeof(tPolygonRec));

          if (TempPtr1 = Nil)
            Then Exit;

          RenderList.PolygonList[DivCount] := TempPtr1;
        End;

      Inc(RenderList.Allocated, 64);
    End;

  A := Obj.Polygons^[Idx].a;
  B := Obj.Polygons^[Idx].b;
  C := Obj.Polygons^[Idx].c;

  With RenderList.SortList^[RenderList.Count] do
    Begin
      Next := Nil;
      Index := RenderList.Count;
      ZMid := (Obj.World_Coords^[a].z +
               Obj.World_Coords^[b].z +
               Obj.World_Coords^[c].z) Shr 1;
    End;

  JIndex := RenderList.Count Div POLYLISTSIZE;
  KIndex := RenderList.Count Mod POLYLISTSIZE;

  With RenderList.PolygonList[JIndex]^[KIndex] do
    Begin
      PType := T;

      Case (T) of
        UNSHADED or SMOOTH, TRANSPARENT or UNSHADED or SMOOTH  : Begin
                              V1 := Obj.Screen_Coords^[a];
                              V2 := Obj.Screen_Coords^[b];
                              V3 := Obj.Screen_Coords^[c];
                              Color := Obj.Polygons^[Idx].Color;
                            End;
        AMBIENT or SMOOTH, TRANSPARENT or AMBIENT or SMOOTH,
        LAMBERT or SMOOTH, TRANSPARENT or LAMBERT or SMOOTH : Begin
                              V1 := Obj.Screen_Coords^[a];
                              V2 := Obj.Screen_Coords^[b];
                              V3 := Obj.Screen_Coords^[c];
                              Color := IntensityTable^[(Obj.CullList^[Idx].Color Shl 8) + Obj.Polygons^[Idx].Color];
                            End;
        GOURAUD or SMOOTH, TRANSPARENT or GOURAUD or SMOOTH : Begin
                              V1 := Obj.Screen_Coords^[a];
                              V2 := Obj.Screen_Coords^[b];
                              V3 := Obj.Screen_Coords^[c];
                              Color := Obj.CullList^[Idx].Color;
                              I1 := Obj.RotateList^[a].b2;
                              I2 := Obj.RotateList^[b].b2;
                              I3 := Obj.RotateList^[c].b2;
                            End;
        PHONG or SMOOTH, TRANSPARENT or PHONG or SMOOTH : Begin
                              Color := Obj.Polygons^[Idx].Color;
                              IBuffer := Obj.IBuffer;
                              V1 := Obj.Screen_Coords^[a];
                              V2 := Obj.Screen_Coords^[b];
                              V3 := Obj.Screen_Coords^[c];
                              UV1 := UVCoord(Obj.RotateList^[a].w2);
                              UV2 := UVCoord(Obj.RotateList^[b].w2);
                              UV3 := UVCoord(Obj.RotateList^[c].w2);
                            End;

        UNSHADED or TEXTURE, TRANSPARENT or UNSHADED or TEXTURE : Begin
                              V1 := Obj.Screen_Coords^[a];
                              V2 := Obj.Screen_Coords^[b];
                              V3 := Obj.Screen_Coords^[c];
                              UV1 := Obj.Texture_Coords^[Idx].uv1;
                              UV2 := Obj.Texture_Coords^[Idx].uv2;
                              UV3 := Obj.Texture_Coords^[Idx].uv3;
                              Tex := Obj.Polygons^[Idx].Texture;
                            End;
        AMBIENT or TEXTURE, TRANSPARENT or AMBIENT or TEXTURE,
        LAMBERT or TEXTURE, TRANSPARENT or LAMBERT or TEXTURE : Begin
                              Intensity := Obj.CullList^[Idx].Color;
                              V1 := Obj.Screen_Coords^[a];
                              V2 := Obj.Screen_Coords^[b];
                              V3 := Obj.Screen_Coords^[c];
                              UV1 := Obj.Texture_Coords^[Idx].uv1;
                              UV2 := Obj.Texture_Coords^[Idx].uv2;
                              UV3 := Obj.Texture_Coords^[Idx].uv3;
                              Tex := Obj.Polygons^[Idx].Texture;
                            End;
        GOURAUD or TEXTURE, TRANSPARENT or GOURAUD or TEXTURE : Begin
                              V1 := Obj.Screen_Coords^[a];
                              V2 := Obj.Screen_Coords^[b];
                              V3 := Obj.Screen_Coords^[c];
                              I1 := Obj.RotateList^[a].b2;
                              I2 := Obj.RotateList^[b].b2;
                              I3 := Obj.RotateList^[c].b2;
                              UV1 := Obj.Texture_Coords^[Idx].uv1;
                              UV2 := Obj.Texture_Coords^[Idx].uv2;
                              UV3 := Obj.Texture_Coords^[Idx].uv3;
                              Tex := Obj.Polygons^[Idx].Texture;
                            End;
        PHONG or TEXTURE, TRANSPARENT or PHONG or TEXTURE : Begin
                              V1 := Obj.Screen_Coords^[a];
                              V2 := Obj.Screen_Coords^[b];
                              V3 := Obj.Screen_Coords^[c];
                              UV1 := Obj.Texture_Coords^[Idx].uv1;
                              UV2 := Obj.Texture_Coords^[Idx].uv2;
                              UV3 := Obj.Texture_Coords^[Idx].uv3;
                              PT1 := UVCoord(Obj.RotateList^[a].w2);
                              PT2 := UVCoord(Obj.RotateList^[b].w2);
                              PT3 := UVCoord(Obj.RotateList^[c].w2);
                              Tex := Obj.Polygons^[Idx].Texture;
                              IBuffer := Obj.IBuffer;
                            End;
      UNSHADED or REFLECTION, TRANSPARENT or UNSHADED or REFLECTION : Begin
                              V1 := Obj.Screen_Coords^[a];
                              V2 := Obj.Screen_Coords^[b];
                              V3 := Obj.Screen_Coords^[c];
                              UV1 := UVCoord(Obj.RotateList^[a].w2);
                              UV2 := UVCoord(Obj.RotateList^[b].w2);
                              UV3 := UVCoord(Obj.RotateList^[c].w2);
                              Tex := Obj.Polygons^[Idx].Texture;
                            End;
        AMBIENT or REFLECTION, TRANSPARENT or AMBIENT or REFLECTION,
        LAMBERT or REFLECTION, TRANSPARENT or LAMBERT or REFLECTION : Begin
                              Intensity := Obj.CullList^[Idx].Color;
                              V1 := Obj.Screen_Coords^[a];
                              V2 := Obj.Screen_Coords^[b];
                              V3 := Obj.Screen_Coords^[c];
                              UV1 := UVCoord(Obj.RotateList^[a].w2);
                              UV2 := UVCoord(Obj.RotateList^[b].w2);
                              UV3 := UVCoord(Obj.RotateList^[c].w2);
                              Tex := Obj.Polygons^[Idx].Texture;
                            End;
        GOURAUD or REFLECTION, TRANSPARENT or GOURAUD or REFLECTION : Begin
                              V1 := Obj.Screen_Coords^[a];
                              V2 := Obj.Screen_Coords^[b];
                              V3 := Obj.Screen_Coords^[c];
                              I1 := Obj.RotateList^[a].b2;
                              I2 := Obj.RotateList^[b].b2;
                              I3 := Obj.RotateList^[c].b2;
                              UV1 := UVCoord(Obj.RotateList^[a].w2);
                              UV2 := UVCoord(Obj.RotateList^[b].w2);
                              UV3 := UVCoord(Obj.RotateList^[c].w2);
                              Tex := Obj.Polygons^[Idx].Texture;
                            End;
        PHONG or REFLECTION, TRANSPARENT or PHONG or REFLECTION : Begin
                              V1 := Obj.Screen_Coords^[a];
                              V2 := Obj.Screen_Coords^[b];
                              V3 := Obj.Screen_Coords^[c];
                              UV1 := UVCoord(Obj.RotateList^[a].w2);
                              UV2 := UVCoord(Obj.RotateList^[b].w2);
                              UV3 := UVCoord(Obj.RotateList^[c].w2);
                              PT1 := UVCoord(Obj.RotateList^[a].w2);
                              PT2 := UVCoord(Obj.RotateList^[b].w2);
                              PT3 := UVCoord(Obj.RotateList^[c].w2);
                              Tex := Obj.Polygons^[Idx].Texture;
                              IBuffer := Obj.IBuffer;
                            End;
    End;
  End;

  Inc(RenderList.Count);
End;

End.
