(*
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
                     Inertia Realtime 3D Rendering Engine
     Copyright (c) 1996, Alex Chalfin, Jeroen Bouwens. All Rights Reserved.
                     Inertia/16 Source Code Release.
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*)


{$IFDEF SMOOTHUNSHADED}
Procedure SmoothUnshaded(Var View : ViewObject; Var Obj : VectorObject; M : Matrix4x3);
{ Shade, Rotate, and Project a Smooth unshaded object }

Var
  i : Integer;

Begin
  XForm(Obj, M);
  ZClip(Obj, View);
  Project(View, Obj);

  For i := 0 to (Obj.Num_Polygons - 1) do
    Begin
      If (Obj.CullList^[i].Visible = 1)
        Then AddPolygonToRenderList(Obj, i, Obj.RenderMask);
    End;
End;
{$ENDIF}

{$IFDEF SMOOTHAMBIENT}
Procedure SmoothAmbient(Var View : ViewObject; Var Obj : VectorObject; M : Matrix4x3);
{ Shade, Rotate, and Project a Smooth surfaced Ambient shaded object }

Var
  i : Integer;

Begin
  AmbientShade(Obj);
  XForm(Obj, M);

  ZClip(Obj, View);
  Project(View, Obj);

  For i := 0 to (Obj.Num_Polygons - 1) do
    Begin
      If (Obj.CullList^[i].Visible = 1)
        Then AddPolygonToRenderList(Obj, i, Obj.RenderMask);
    End;
End;
{$ENDIF}


{$IFDEF SMOOTHLAMBERT}
Procedure SmoothLambert(Var View : ViewObject; Var Obj : VectorObject; M : Matrix4x3);

Var
  i : Integer;

Begin
  LambertShade(Obj);
  XForm(Obj, M);

  ZClip(Obj, View);

  Project(View, Obj);

  For i := 0 to (Obj.Num_Polygons - 1) do
    Begin
      If (Obj.CullList^[i].Visible = 1)
        Then AddPolygonToRenderList(Obj, i, Obj.RenderMask);
    End;
End;
{$ENDIF}

{$IFDEF SMOOTHGOURAUD}
Procedure SmoothGouraud(Var View : ViewObject; Var Obj : VectorObject; M : Matrix4x3);

Var
  i : Integer;

Begin
  GouraudShade(Obj);
  XForm(Obj, M);

  ZClip(Obj, View);

  Project(View, Obj);

  For i := 0 to (Obj.Num_Polygons - 1) do
    Begin
      If (Obj.CullList^[i].Visible = 1)
        Then AddPolygonToRenderList(Obj, i, Obj.RenderMask);
    End;
End;
{$ENDIF}

{$IFDEF SMOOTHPHONG}
Procedure SmoothPhong(Var View : ViewObject; Var Obj : VectorObject; M : Matrix4x3);

Var
  i : Integer;
  XAxis : Vertex3d;
  YAxis : Vertex3d;
  CenterX, CenterY : Integer;

Begin
  XAxis.x := Obj.Orientation[0] Div 256;
  XAxis.y := Obj.Orientation[3] Div 256;
  XAxis.z := Obj.Orientation[6] Div 256;

  YAxis.x := Obj.Orientation[1] Div 256;
  YAxis.y := Obj.Orientation[4] Div 256;
  YAxis.z := Obj.Orientation[7] Div 256;

  CenterX := 127 - Lights.Light[0].x Div 2;
  CenterY := 127 - Lights.Light[0].y Div 2;

  PhongShade(Obj, xAxis, yAxis, CenterX, CenterY);
  XForm(Obj, M);

  ZClip(Obj, View);

  Project(View, Obj);

  For i := 0 to (Obj.Num_Polygons - 1) do
    Begin
      If (Obj.CullList^[i].Visible = 1)
        Then AddPolygonToRenderList(Obj, i, Obj.RenderMask);
    End;
End;
{$ENDIF}

{$IFDEF TEXTUREUNSHADED}
Procedure TextureUnshaded(Var View : ViewObject; Var Obj : VectorObject; M : Matrix4x3);

Var
  i : Integer;

Begin
  XForm(Obj, M);

  ZClip(Obj, View);

  Project(View, Obj);

  For i := 0 to (Obj.Num_Polygons - 1) do
    Begin
      If (Obj.CullList^[i].Visible = 1)
        Then AddPolygonToRenderList(Obj, i, Obj.RenderMask);
    End;
End;
{$ENDIF}

{$IFDEF TEXTUREAMBIENT}
Procedure TextureAmbient(Var View : ViewObject; Var Obj : VectorObject; M : Matrix4x3);

Var
  i : Integer;

Begin
  AmbientShade(Obj);
  XForm(Obj, M);

  ZClip(Obj, View);

  Project(View, Obj);

  For i := 0 to (Obj.Num_Polygons - 1) do
    Begin
      If (Obj.CullList^[i].Visible = 1)
        Then AddPolygonToRenderList(Obj, i, Obj.RenderMask);
    End;
End;
{$ENDIF}


{$IFDEF TEXTURELAMBERT}
Procedure TextureLambert(Var View : ViewObject; Var Obj : VectorObject; M : Matrix4x3);

Var
  i : Integer;

Begin
  LambertShade(Obj);
  XForm(Obj, M);

  ZClip(Obj, View);

  Project(View, Obj);

  For i := 0 to (Obj.Num_Polygons - 1) do
    Begin
      If (Obj.CullList^[i].Visible = 1)
        Then AddPolygonToRenderList(Obj, i, Obj.RenderMask);
    End;
End;
{$ENDIF}

{$IFDEF TEXTUREGOURAUD}
Procedure TextureGouraud(Var View : ViewObject; Var Obj : VectorObject; M : Matrix4x3);

Var
  i : Integer;

Begin
  GouraudShade(Obj);
  XForm(Obj, M);
  ZClip(Obj, View);
  Project(View, Obj);

  For i := 0 to (Obj.Num_Polygons - 1) do
    Begin
      If (Obj.CullList^[i].Visible = 1)
        Then AddPolygonToRenderList(Obj, i, Obj.RenderMask);
    End;
End;
{$ENDIF}

{$IFDEF TEXTUREPHONG}
Procedure TexturePhong(Var View : ViewObject; Var Obj : VectorObject; M : Matrix4x3);

Var
  i : Integer;
  CenterX, CenterY : Integer;
  XAxis : Vertex3d;
  YAxis : Vertex3d;

Begin
  XAxis.x := M[0] Div 256;
  XAxis.y := M[3] Div 256;
  XAxis.z := M[6] Div 256;

  YAxis.x := M[1] Div 256;
  YAxis.y := M[4] Div 256;
  YAxis.z := M[7] Div 256;
  CenterX := 127 - Lights.Light[0].x Div 2;
  CenterY := 127 - Lights.Light[0].y Div 2;

  PhongShade(Obj, xAxis, yAxis, CenterX, CenterY);
  XForm(Obj, M);

  ZClip(Obj, View);

  Project(View, Obj);

  For i := 0 to (Obj.Num_Polygons - 1) do
    Begin
      If (Obj.CullList^[i].Visible = 1)
        Then AddPolygonToRenderList(Obj, i, Obj.RenderMask);
    End;
End;
{$ENDIF}

{$IFDEF REFLECTIONUNSHADED}
Procedure ReflectionUnshaded(Var View : ViewObject; Var Obj : VectorObject; M : Matrix4x3);

Var
  i : Integer;
  XAxis : Vertex3d;
  YAxis : Vertex3d;

Begin
  XAxis.x := M[0] Div 256;
  XAxis.y := M[3] Div 256;
  XAxis.z := M[6] Div 256;

  YAxis.x := -M[1] Div 256;
  YAxis.y := -M[4] Div 256;
  YAxis.z := -M[7] Div 256;

  PhongShade(Obj, xAxis, yAxis, 127, 127);

  XForm(Obj, M);

  ZClip(Obj, View);

  Project(View, Obj);

  For i := 0 to (Obj.Num_Polygons - 1) do
    Begin
      If (Obj.CullList^[i].Visible = 1)
        Then AddPolygonToRenderList(Obj, i, Obj.RenderMask);
    End;
End;
{$ENDIF}

{$IFDEF REFLECTIONAMBIENT}
Procedure ReflectionAmbient(Var View : ViewObject; Var Obj : VectorObject; M : Matrix4x3);

Var
  i : Integer;
  XAxis : Vertex3d;
  YAxis : Vertex3d;

Begin
  XAxis.x := M[0] Div 256;
  XAxis.y := M[3] Div 256;
  XAxis.z := M[6] Div 256;

  YAxis.x := -M[1] Div 256;
  YAxis.y := -M[4] Div 256;
  YAxis.z := -M[7] Div 256;

  PhongShade(Obj, xAxis, yAxis, 127, 127);
  AmbientShade(Obj);

  XForm(Obj, M);

  ZClip(Obj, View);

  Project(View, Obj);

  For i := 0 to (Obj.Num_Polygons - 1) do
    Begin
      If (Obj.CullList^[i].Visible = 1)
        Then AddPolygonToRenderList(Obj, i, Obj.RenderMask);
    End;
End;
{$ENDIF}


{$IFDEF REFLECTIONLAMBERT}
Procedure ReflectionLambert(Var View : ViewObject; Var Obj : VectorObject; M : Matrix4x3);

Var
  i : Integer;
  XAxis : Vertex3d;
  YAxis : Vertex3d;

Begin
  XAxis.x := M[0] Div 256;
  XAxis.y := M[3] Div 256;
  XAxis.z := M[6] Div 256;

  YAxis.x := -M[1] Div 256;
  YAxis.y := -M[4] Div 256;
  YAxis.z := -M[7] Div 256;

  LambertShade(Obj);
  PhongShade(Obj, xAxis, yAxis, 127, 127);

  XForm(Obj, M);

  ZClip(Obj, View);

  Project(View, Obj);

  For i := 0 to (Obj.Num_Polygons - 1) do
    Begin
      If (Obj.CullList^[i].Visible = 1)
        Then AddPolygonToRenderList(Obj, i, Obj.RenderMask);
    End;
End;
{$ENDIF}

{$IFDEF REFLECTIONGOURAUD}
Procedure ReflectionGouraud(Var View : ViewObject; Var Obj : VectorObject; M : Matrix4x3);

Var
  i : Integer;
  XAxis : Vertex3d;
  YAxis : Vertex3d;

Begin
  XAxis.x := M[0] Div 256;
  XAxis.y := M[3] Div 256;
  XAxis.z := M[6] Div 256;

  YAxis.x := -M[1] Div 256;
  YAxis.y := -M[4] Div 256;
  YAxis.z := -M[7] Div 256;

  GouraudShade(Obj);
  PhongShade(Obj, xAxis, yAxis, 127, 127);
  XForm(Obj, M);
  ZClip(Obj, View);

  Project(View, Obj);

  For i := 0 to (Obj.Num_Polygons - 1) do
    Begin
      If (Obj.CullList^[i].Visible = 1)
        Then AddPolygonToRenderList(Obj, i, Obj.RenderMask);
    End;
End;
{$ENDIF}

{$IFDEF REFLECTIONPHONG}
Procedure ReflectionPhong(Var View : ViewObject; Var Obj : VectorObject; M : Matrix4x3);

Var
  i : Integer;
  CenterX, CenterY : Integer;
  XAxis : Vertex3d;
  YAxis : Vertex3d;

Begin
  XAxis.x := M[0] Div 256;
  XAxis.y := M[3] Div 256;
  XAxis.z := M[6] Div 256;

  YAxis.x := -M[1] Div 256;
  YAxis.y := -M[4] Div 256;
  YAxis.z := -M[7] Div 256;

  CenterX := 127 - Lights.Light[0].x Div 2;
  CenterY := 127 - Lights.Light[0].y Div 2;

  PhongShade(Obj, xAxis, yAxis, 127, 127);
  XForm(Obj, M);
  ZClip(Obj, View);
  Project(View, Obj);

  For i := 0 to (Obj.Num_Polygons - 1) do
    Begin
      If (Obj.CullList^[i].Visible = 1)
        Then AddPolygonToRenderList(Obj, i, Obj.RenderMask);
    End;
End;
{$ENDIF}


