(*
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
                     Inertia Realtime 3D Rendering Engine
            Copyright (c) 1997, Alex Chalfin. All Rights Reserved.
                       Inertia/16 Source Code Release.
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*)

{$I ..\SOURCES\Litex\STORE\06-3DFX\SOURCE\DEFINE.INC}
Unit i_Polygo;

Interface

Uses i_Types;

Var
  GlobalScreen : Pointer;
  IT : pIntensityTable;
  TT : pMap;
  MAXX, MAXY, MINX, MINY : Integer;

Procedure UnshadedPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure AmbientPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure LambertPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure GouraudPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure PhongPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Procedure UnshadedTexturePolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure AmbientTexturePolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure LambertTexturePolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure GouraudTexturePolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure PhongTexturePolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Procedure UnshadedReflectionPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure AmbientReflectionPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure LambertReflectionPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure GouraudReflectionPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure PhongReflectionPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Procedure TransUnshadedPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure TransAmbientPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure TransLambertPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure TransGouraudPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure TransPhongPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Procedure TransUnshadedTexturePolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure TransAmbientTexturePolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure TransLambertTexturePolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure TransGouraudTexturePolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure TransPhongTexturePolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Procedure TransUnshadedReflectionPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure TransAmbientReflectionPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure TransLambertReflectionPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure TransGouraudReflectionPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure TransPhongReflectionPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Procedure UnshadedClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure AmbientClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure LambertClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure GouraudClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure PhongClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Procedure UnshadedTextureClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure AmbientTextureClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure LambertTextureClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure GouraudTextureClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure PhongTextureClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Procedure UnshadedReflectionClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure AmbientReflectionClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure LambertReflectionClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure GouraudReflectionClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure PhongReflectionClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Procedure TransUnshadedClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure TransAmbientClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure TransLambertClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure TransGouraudClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure TransPhongClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Procedure TransUnshadedTextureClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure TransAmbientTextureClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure TransLambertTextureClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure TransGouraudTextureClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure TransPhongTextureClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Procedure TransUnshadedReflectionClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure TransAmbientReflectionClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure TransLambertReflectionClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure TransGouraudReflectionClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);
Procedure TransPhongReflectionClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);


Implementation

Var
  XL, XR, ID, PD, UD, VD : Array[0..199] of Longint;

{$F+}
{$L I_SPOLY1.OBJ}
Procedure FlatPoly(Var S : tPolygonRec); External;
Procedure GouraudPoly(Var S : tPolygonRec); External;
Procedure PhongPoly(Var S : tPolygonRec; IBuffer : pMap); External;
Procedure TexturePoly(Var S : tPolygonRec; Texture : pMap); External;
Procedure FlatTexturePoly(Var S : tPolygonRec; Texture : pMap); External;
Procedure GouraudTexturePoly(Var S : tPolygonRec; Texture : pMap); External;
Procedure PhongTexturePoly(Var S : tPolygonRec; Texture : pMap; IBuffer : pMap); External;
Procedure TransparentFlatPoly(Var S : tPolygonRec); External;
Procedure TransparentGouraudPoly(Var S : tPolygonRec); External;
Procedure TransparentPhongPoly(Var S : tPolygonRec; IBuffer : pMap); External;
Procedure TransparentTexturePoly(Var S : tPolygonRec; Texture : pMap); External;
Procedure TransparentFlatTexturePoly(Var S : tPolygonRec; Texture : pMap); External;
Procedure TransparentGouraudTexturePoly(Var S : tPolygonRec; Texture : pMap); External;
Procedure TransparentPhongTexturePoly(Var S : tPolygonRec; Texture : pMap; IBuffer : pMap); External;

{$L I_SPOLY2.OBJ}
Procedure FlatClipPoly(Var S : tPolygonRec); External;
Procedure GouraudClipPoly(Var S : tPolygonRec); External;
Procedure PhongClipPoly(Var S : tPolygonRec; IBuffer : pMap); External;
Procedure TextureClipPoly(Var S : tPolygonRec; Texture : pMap); External;
Procedure FlatTextureClipPoly(Var S : tPolygonRec; Texture : pMap); External;
Procedure GouraudTextureClipPoly(Var S : tPolygonRec; Texture : pMap); External;
Procedure PhongTextureClipPoly(Var S : tPolygonRec; Texture, IBuffer : pMap); External;
Procedure TransparentFlatClipPoly(Var S : tPolygonRec); External;
Procedure TransparentGouraudClipPoly(Var S : tPolygonRec); External;
Procedure TransparentPhongClipPoly(Var S : tPolygonRec; IBuffer : pMap); External;
Procedure TransparentTextureClipPoly(Var S : tPolygonRec; Texture : pMap); External;
Procedure TransparentFlatTextureClipPoly(Var S : tPolygonRec; Texture : pMap); External;
Procedure TransparentGouraudTextureClipPoly(Var S : tPolygonRec; Texture : pMap); External;
Procedure TransparentPhongTextureClipPoly(Var S : tPolygonRec; Texture : pMap; IBuffer : pMap); External;
{$F-}

Procedure AmbientPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  FlatPoly(P);
End;


Procedure LambertPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  FlatPoly(P);
End;

Procedure GouraudPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  GouraudPoly(P);
End;

Procedure AmbientTexturePolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  FlatTexturePoly(P, Tex1);
End;

Procedure LambertTexturePolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  FlatTexturePoly(P, Tex1);
End;

Procedure GouraudTexturePolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  GouraudTexturePoly(P, Tex1);
End;

Procedure PhongPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  PhongPoly(P, Tex2);
End;

Procedure AmbientReflectionPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  FlatTexturePoly(P, Tex1);
End;

Procedure LambertReflectionPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  FlatTexturePoly(P, Tex1);
End;

Procedure GouraudReflectionPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  GouraudTexturePoly(P, Tex1);
End;

Procedure PhongTexturePolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  PhongTexturePoly(P, Tex1, Tex2);
End;

Procedure PhongReflectionPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  PhongTexturePoly(P, Tex1, Tex2);
End;

Procedure UnshadedPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  FlatPoly(P);
End;

Procedure UnshadedTexturePolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TexturePoly(P, Tex1);
End;

Procedure UnshadedReflectionPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TexturePoly(P, Tex1);
End;

Procedure TransUnshadedPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentFlatPoly(P);
End;

Procedure TransAmbientPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentFlatPoly(P);
End;

Procedure TransLambertPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentFlatPoly(P);
End;

Procedure TransGouraudPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentGouraudPoly(P);
End;

Procedure TransPhongPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentPhongPoly(P, Tex2);
End;

Procedure TransUnshadedTexturePolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentTexturePoly(P, Tex1);
End;

Procedure TransAmbientTexturePolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentFlatTexturePoly(P, Tex1);
End;

Procedure TransLambertTexturePolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentFlatTexturePoly(P, Tex1);
End;

Procedure TransGouraudTexturePolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentGouraudTexturePoly(P, Tex1);
End;

Procedure TransPhongTexturePolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentPhongTexturePoly(P, Tex1, Tex2);
End;

Procedure TransUnshadedReflectionPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentTexturePoly(P, Tex1);
End;

Procedure TransAmbientReflectionPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentFlatTexturePoly(P, Tex1);
End;

Procedure TransLambertReflectionPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentFlatTexturePoly(P, Tex1);
End;

Procedure TransGouraudReflectionPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentGouraudTexturePoly(P, Tex1);
End;

Procedure TransPhongReflectionPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentPhongTexturePoly(P, Tex1, Tex2);
End;

Procedure AmbientClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  FlatClipPoly(P);
End;


Procedure LambertClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  FlatClipPoly(P);
End;

Procedure GouraudClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  GouraudClipPoly(P);
End;

Procedure AmbientTextureClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  FlatTextureClipPoly(P, Tex1);
End;

Procedure LambertTextureClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  FlatTextureClipPoly(P, Tex1);
End;

Procedure GouraudTextureClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  GouraudTextureClipPoly(P, Tex1);
End;

Procedure PhongClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  PhongClipPoly(P, Tex2);
End;

Procedure AmbientReflectionClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  FlatTextureClipPoly(P, Tex1);
End;

Procedure LambertReflectionClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  FlatTextureClipPoly(P, Tex1);
End;

Procedure GouraudReflectionClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  GouraudTextureClipPoly(P, Tex1);
End;

Procedure PhongTextureClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  PhongTextureClipPoly(P, Tex1, Tex2);
End;

Procedure PhongReflectionClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  PhongTextureClipPoly(P, Tex1, Tex2);
End;

Procedure UnshadedClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  FlatClipPoly(P);
End;

Procedure UnshadedTextureClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TextureClipPoly(P, Tex1);
End;

Procedure UnshadedReflectionClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TextureClipPoly(P, Tex1);
End;

Procedure TransUnshadedClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentFlatClipPoly(P);
End;

Procedure TransAmbientClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentFlatClipPoly(P);
End;

Procedure TransLambertClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentFlatClipPoly(P);
End;

Procedure TransGouraudClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentGouraudClipPoly(P);
End;

Procedure TransPhongClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentPhongClipPoly(P, Tex2);
End;

Procedure TransUnshadedTextureClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentTextureClipPoly(P, Tex1);
End;

Procedure TransAmbientTextureClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentFlatTextureClipPoly(P, Tex1);
End;

Procedure TransLambertTextureClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentFlatTextureClipPoly(P, Tex1);
End;

Procedure TransGouraudTextureClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentGouraudTextureClipPoly(P, Tex1);
End;

Procedure TransPhongTextureClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentPhongTextureClipPoly(P, Tex1, Tex2);
End;

Procedure TransUnshadedReflectionClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentTextureClipPoly(P, Tex1);
End;

Procedure TransAmbientReflectionClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentFlatTextureClipPoly(P, Tex1);
End;

Procedure TransLambertReflectionClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentFlatTextureClipPoly(P, Tex1);
End;

Procedure TransGouraudReflectionClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentGouraudTextureClipPoly(P, Tex1);
End;

Procedure TransPhongReflectionClipPolygon(Var P : tPolygonRec; Tex1, Tex2 : Pointer);

Begin
  TransparentPhongTextureClipPoly(P, Tex1, Tex2);
End;



Begin
End.
