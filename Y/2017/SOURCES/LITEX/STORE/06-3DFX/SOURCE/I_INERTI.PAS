(*
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
                     Inertia Realtime 3D Rendering Engine
     Copyright (c) 1996, Alex Chalfin, Jeroen Bouwens. All Rights Reserved.
                         Inertia/16 Source code.
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*)

{$I ..\SOURCES\Litex\STORE\06-3DFX\SOURCE\DEFINE.INC}
Unit i_Inerti;

Interface

Uses
  i_Types,     { Type definitions for everyting    }
  i_Polygo;    { Polygon fill routines             }


{$IFDEF USE8087}
Type
  Real = Single;
{$ENDIF}

Const
  I_OK = 0;
  I_MEMERR = 1;
  I_FILEERR = 2;
  I_FORMATERR = 3;

Var
  GlobalPalette  : Palette;                  { Global Palette          }
  TextureList : Array[0..MAXTEXTURES-1] of TextureRec; { Global list of Textures }

Procedure InitInertia;
Procedure ShutdownInertia;
Procedure SetAspectRatio(AspectRatio : Real);

{$IFDEF TRANSPARENCY}
Function  LoadTransparencyTable(Filename : String; FOfs : Longint) : Integer;
Procedure FreeTransparencyTable;
{$ENDIF}

{ Color Table Management Routines }
Function LoadIntensityTable(Filename : String; FOfs : Longint) : Integer;
Function LoadPalette(Filename : String; FOfs : Longint) : Integer;
Function MakePhongMap(Index : Integer) : Integer;
Procedure FreeIntensityTable;

{ View Management Routines }
Procedure InitView(Var View : ViewObject);
Procedure FreeView(Var View : ViewObject);
Procedure GetObjectAsCamera(Var View : ViewObject; Obj : VectorObject);
Procedure SetViewPort(Var View: ViewObject; X1, Y1, X2, Y2 : Integer; Update : Boolean);
Procedure AddtoRenderList(Var View : ViewObject; Obj : VectorObject);
Procedure Render(Var View : ViewObject; VPage : Pointer);
Procedure PushLightSource(X, Y, Z : Real);
Procedure PopLightSource;
Procedure RotateLightSource(Index, Xa, Ya, Za : Integer);
Procedure SetViewFustrum(Var View : ViewObject; MinZ, MaxZ : Longint);
Procedure SetFocalLength(Var View : ViewObject; Fl : Real);
Procedure SetFieldOfView(Var View : ViewObject; FOV : Real);

{ Object Management Routines }
Function  LoadGVO(Var Obj : VectorObject; Filename : String; FOfs : Longint) : Integer;
Function  AllocObject(Var Obj : VectorObject; NumVert, NumPoly : Integer) : Integer;
Function  CopyVectorObject(Var Source, Dest : VectorObject) : Integer;
Procedure InitVectorObject(Var Obj : VectorObject);
Procedure FreeVectorObject(Var Obj : VectorObject);
Procedure SetBaseColor(Var Obj : VectorObject; C : Integer);
Procedure SetPolygonColor(Var Obj : VectorObject; Poly : Integer; C : Integer);
Procedure SetObjectTexture(Var Obj : VectorObject; C : Integer);
Procedure SetPolygonTexture(Var Obj : VectorObject; Poly : Integer; C : Integer);
Procedure SetObjectPhongMap(Var Obj : VectorObject; C : Integer);
Procedure CalcBoundaryVolume(Var Obj : VectorObject);
Procedure SetRenderMask(Var Obj : VectorObject; Mask : Integer);
Procedure SetCull(Var Obj : VectorObject; Cull : Boolean);

{ Object Control Routines }
Procedure SetAbsoluteRotation(Var Obj : VectorObject; rx, ry, rz : Integer);
Procedure SetDeltaRotation(Var Obj : VectorObject; dx, dy, dz : Integer);
Procedure SetAbsoluteLocation(Var Obj : VectorObject; tx, ty, tz : Longint);
Procedure SetDeltaLocation(Var Obj : VectorObject; dx, dy, dz : Longint);

{ Camera Control Routines }
Procedure SetFocusPoint(Var View : ViewObject; TargetX, TargetY, TargetZ, Roll : Longint);
Procedure SetViewLocation(Var View : ViewObject; X, Y, Z : Longint);

{ Texture and Capture routines }
Procedure GetTexturePalette(Index : Integer);
Function  LoadPCXTexture(Index : Integer; Filename : String; FOfs : Longint) : Integer;
Procedure FreeTexture(Index : Integer);


Implementation

Uses
  i_Memory, { Memory manager }
  i_PCX,    { PCX routines }
  i_Bufio,  { Buffered File IO routines }
  i_Shade;

Const
  FUSTRUM_MIN_Z = 100;    { Minimum depth }
  FUSTRUM_MAX_Z = 64000;  { Maximum depth }
  FUSTRUM_MIN_X = 160;
  FUSTRUM_MIN_Y = 100;
  FUSTRUM_MAX_X = (FUSTRUM_MIN_X * FUSTRUM_MAX_Z) Div PERSPECTIVE;
  FUSTRUM_MAX_Y = (FUSTRUM_MIN_Y * FUSTRUM_MAX_Z) Div PERSPECTIVE;
  FUSTRUM_X_POINT_SLOPE = (FUSTRUM_MAX_X-FUSTRUM_MIN_X) / (FUSTRUM_MAX_Z-FUSTRUM_MIN_Z);
  FUSTRUM_Y_POINT_SLOPE = (FUSTRUM_MAX_Y-FUSTRUM_MIN_Y) / (FUSTRUM_MAX_Z-FUSTRUM_MIN_Z);
  MIN_Z = FUSTRUM_MIN_Z;
  CORRECTRES = 256;  { correct the matrix after every 256 frames }
  FileNumber : Word = 0;

Procedure Clip(Var Val : Integer; Lower, Higher : Integer);
{ Clips an integer into the range Low..High }

Begin
  If Val > Higher
    Then Begin
      Val := Higher;
      Exit;
    End;
  If Val < Lower
    Then Begin
      Val := Lower;
      Exit;
    End;
End;

Function PointSlope(x1, x2, y1, y2, y : Longint) : Longint; Assembler;

Asm
  db 66h; Mov  ax,Word Ptr [y]  { Mov eax,[y]   }
  db 66h; Mov  dx,Word Ptr [x2] { Mov edx,[x2]  }
  db 66h; Mov  cx,Word Ptr [y2] { Mov ecx,[y2]  }
  db 66h; Sub  ax,Word Ptr [y1] { Sub eax,[y1]  }
  db 66h; Sub  dx,Word Ptr [x1] { Sub edx,[x1]  }
  db 66h; Sub  cx,Word Ptr [y1] { Sub ecx,[y1]  }
  db 66h; IMul dx               { IMul edx      }
  db 66h; IDiv cx               { IDiv ecx      }
  db 66h; Add  ax,Word Ptr [x1] { Add  eax,[x1] }
  Mov  bx,ax                    { Mov  bx,ax    }
  db 66h; Shr  ax,16            { Shr  eax,16   }
  Mov  dx,ax                    { Mov  dx,ax    }
  Mov  ax,bx                    { Mov  ax,bx    }
End;

Procedure VarSwap(Var A, B; Size : Integer); Assembler;

Asm
  Push  ds
  Les   di,B
  Lds   si,A
  Mov   cx,Size
 @Looper:
  Mov   al,[si]
  XChg  al,es:[di]
  Mov   [si],al
  Inc   di
  Inc   si
  Dec   cx
  Jnz  @Looper
  Pop   ds
End;

Function FIXMUL(A, B : Longint) : Longint; Assembler;

Asm
  db 66h; Mov  ax,Word Ptr [A]   { Mov  eax,[A]    }
  db 66h; Mov  dx,Word Ptr [B]   { Mov  edx,[B]    }
  db 66h; IMul dx                { IMul edx        }
  db 66h, 0fh, 0ach, 0d0h, 10h   { Shrd eax,edx,16 }
  Mov  bx,ax                     { Mov  bx,ax      }
  db 66h; Shr  ax,16             { Shr  eax,16     }
  Mov  dx,ax                     { Mov  dx,ax      }
  Mov  ax,bx                     { Mov  ax,bx      }
End;

Procedure SetAspectRatio(AspectRatio : Real);
{ This is a dummy function to keep the API's consistant }
{ in Inertia/16, the aspect ratio is fixed              }

Begin
End;

Procedure SetFocalLength(Var View : ViewObject; Fl : Real);
{ This is a dummy function to keep the API's consistant }
{ in Inertia/16, the focal length is fixed              }

Begin
End;

Procedure SetFieldOfView(Var View : ViewObject; FOV : Real);
{ This is a dummy function to keep the API's consistant }
{ in Inertia/16, the field of view is fixed             }

Begin
End;


Procedure InitInertia;

Var
  i : Integer;
  Ptr : Pointer;

Begin
  RenderList.Allocated      := 0;
  RenderList.Count          := 0;
  RenderList.SortList       := Nil;
  RenderList.PolygonList[0] := Nil;
  RenderList.PolygonList[1] := Nil;
  RenderList.PolygonList[2] := Nil;
  RenderList.PolygonList[3] := Nil;

  Lights.NumLights          := 0;

  For i := 0 to (MAXTEXTURES-1) do
    Begin
      TextureList[i].Texture := Nil;
      TextureList[i].Pal := Nil;
    End;
  FillChar(GlobalPalette, Sizeof(GlobalPalette), 0);
  IntensityTable := Nil;
  TT := Nil;

  { Init the polygon fillers function array }

  Ptr := Addr(UnshadedPolygon); TriFillers[UNSHADED or SMOOTH] := PolygonFunction(Ptr);
  Ptr := Addr(AmbientPolygon);  TriFillers[AMBIENT  or SMOOTH] := PolygonFunction(Ptr);
  Ptr := Addr(LambertPolygon);  TriFillers[LAMBERT  or SMOOTH] := PolygonFunction(Ptr);
  Ptr := Addr(GouraudPolygon);  TriFillers[GOURAUD  or SMOOTH] := PolygonFunction(Ptr);
  Ptr := Addr(PhongPolygon);    TriFillers[PHONG    or SMOOTH] := PolygonFunction(Ptr);
  Ptr := Addr(UnshadedTexturePolygon); TriFillers[UNSHADED or TEXTURE] := PolygonFunction(Ptr);
  Ptr := Addr(AmbientTexturePolygon); TriFillers[AMBIENT  or TEXTURE] := PolygonFunction(Ptr);
  Ptr := Addr(LambertTexturePolygon); TriFillers[LAMBERT  or TEXTURE] := PolygonFunction(Ptr);
  Ptr := Addr(GouraudTexturePolygon); TriFillers[GOURAUD  or TEXTURE] := PolygonFunction(Ptr);
  Ptr := Addr(PhongTexturePolygon);   TriFillers[PHONG    or TEXTURE] := PolygonFunction(Ptr);
  Ptr := Addr(UnshadedReflectionPolygon); TriFillers[UNSHADED or REFLECTION] := PolygonFunction(Ptr);
  Ptr := Addr(AmbientReflectionPolygon); TriFillers[AMBIENT  or REFLECTION] := PolygonFunction(Ptr);
  Ptr := Addr(LambertReflectionPolygon); TriFillers[LAMBERT  or REFLECTION] := PolygonFunction(Ptr);
  Ptr := Addr(GouraudReflectionPolygon); TriFillers[GOURAUD  or REFLECTION] := PolygonFunction(Ptr);
  Ptr := Addr(PhongReflectionPolygon); TriFillers[PHONG    or REFLECTION] := PolygonFunction(Ptr);

  Ptr := Addr(TransUnshadedPolygon); TriFillers[TRANSPARENT or UNSHADED or SMOOTH] := PolygonFunction(Ptr);
  Ptr := Addr(TransAmbientPolygon);  TriFillers[TRANSPARENT or AMBIENT  or SMOOTH] := PolygonFunction(Ptr);
  Ptr := Addr(TransLambertPolygon);  TriFillers[TRANSPARENT or LAMBERT  or SMOOTH] := PolygonFunction(Ptr);
  Ptr := Addr(TransGouraudPolygon);  TriFillers[TRANSPARENT or GOURAUD  or SMOOTH] := PolygonFunction(Ptr);
  Ptr := Addr(TransPhongPolygon);    TriFillers[TRANSPARENT or PHONG    or SMOOTH] := PolygonFunction(Ptr);
  Ptr := Addr(TransUnshadedTexturePolygon); TriFillers[TRANSPARENT or UNSHADED or TEXTURE] := PolygonFunction(Ptr);
  Ptr := Addr(TransAmbientTexturePolygon); TriFillers[TRANSPARENT or AMBIENT  or TEXTURE] := PolygonFunction(Ptr);
  Ptr := Addr(TransLambertTexturePolygon); TriFillers[TRANSPARENT or LAMBERT  or TEXTURE] := PolygonFunction(Ptr);
  Ptr := Addr(TransGouraudTexturePolygon); TriFillers[TRANSPARENT or GOURAUD  or TEXTURE] := PolygonFunction(Ptr);
  Ptr := Addr(TransPhongTexturePolygon);   TriFillers[TRANSPARENT or PHONG    or TEXTURE] := PolygonFunction(Ptr);
  Ptr := Addr(TransUnshadedReflectionPolygon); TriFillers[TRANSPARENT or UNSHADED or REFLECTION] := PolygonFunction(Ptr);
  Ptr := Addr(TransAmbientReflectionPolygon); TriFillers[TRANSPARENT or AMBIENT  or REFLECTION] := PolygonFunction(Ptr);
  Ptr := Addr(TransLambertReflectionPolygon); TriFillers[TRANSPARENT or LAMBERT  or REFLECTION] := PolygonFunction(Ptr);
  Ptr := Addr(TransGouraudReflectionPolygon); TriFillers[TRANSPARENT or GOURAUD  or REFLECTION] := PolygonFunction(Ptr);
  Ptr := Addr(TransPhongReflectionPolygon); TriFillers[TRANSPARENT or PHONG    or REFLECTION] := PolygonFunction(Ptr);

  Ptr := Addr(UnshadedClipPolygon); ClipTriFillers[UNSHADED or SMOOTH] := PolygonFunction(Ptr);
  Ptr := Addr(AmbientClipPolygon);  ClipTriFillers[AMBIENT  or SMOOTH] := PolygonFunction(Ptr);
  Ptr := Addr(LambertClipPolygon);  ClipTriFillers[LAMBERT  or SMOOTH] := PolygonFunction(Ptr);
  Ptr := Addr(GouraudClipPolygon);  ClipTriFillers[GOURAUD  or SMOOTH] := PolygonFunction(Ptr);
  Ptr := Addr(PhongClipPolygon);    ClipTriFillers[PHONG    or SMOOTH] := PolygonFunction(Ptr);
  Ptr := Addr(UnshadedTextureClipPolygon); ClipTriFillers[UNSHADED or TEXTURE] := PolygonFunction(Ptr);
  Ptr := Addr(AmbientTextureClipPolygon); ClipTriFillers[AMBIENT  or TEXTURE] := PolygonFunction(Ptr);
  Ptr := Addr(LambertTextureClipPolygon); ClipTriFillers[LAMBERT  or TEXTURE] := PolygonFunction(Ptr);
  Ptr := Addr(GouraudTextureClipPolygon); ClipTriFillers[GOURAUD  or TEXTURE] := PolygonFunction(Ptr);
  Ptr := Addr(PhongTextureClipPolygon);   ClipTriFillers[PHONG    or TEXTURE] := PolygonFunction(Ptr);
  Ptr := Addr(UnshadedReflectionClipPolygon); ClipTriFillers[UNSHADED or REFLECTION] := PolygonFunction(Ptr);
  Ptr := Addr(AmbientReflectionClipPolygon); ClipTriFillers[AMBIENT  or REFLECTION] := PolygonFunction(Ptr);
  Ptr := Addr(LambertReflectionClipPolygon); ClipTriFillers[LAMBERT  or REFLECTION] := PolygonFunction(Ptr);
  Ptr := Addr(GouraudReflectionClipPolygon); ClipTriFillers[GOURAUD  or REFLECTION] := PolygonFunction(Ptr);
  Ptr := Addr(PhongReflectionClipPolygon); ClipTriFillers[PHONG    or REFLECTION] := PolygonFunction(Ptr);

  Ptr := Addr(TransUnshadedClipPolygon); ClipTriFillers[TRANSPARENT or UNSHADED or SMOOTH] := PolygonFunction(Ptr);
  Ptr := Addr(TransAmbientClipPolygon);  ClipTriFillers[TRANSPARENT or AMBIENT  or SMOOTH] := PolygonFunction(Ptr);
  Ptr := Addr(TransLambertClipPolygon);  ClipTriFillers[TRANSPARENT or LAMBERT  or SMOOTH] := PolygonFunction(Ptr);
  Ptr := Addr(TransGouraudClipPolygon);  ClipTriFillers[TRANSPARENT or GOURAUD  or SMOOTH] := PolygonFunction(Ptr);
  Ptr := Addr(TransPhongClipPolygon);    ClipTriFillers[TRANSPARENT or PHONG    or SMOOTH] := PolygonFunction(Ptr);
  Ptr := Addr(TransUnshadedTextureClipPolygon); ClipTriFillers[TRANSPARENT or UNSHADED or TEXTURE] := PolygonFunction(Ptr);
  Ptr := Addr(TransAmbientTextureClipPolygon); ClipTriFillers[TRANSPARENT or AMBIENT  or TEXTURE] := PolygonFunction(Ptr);
  Ptr := Addr(TransLambertTextureClipPolygon); ClipTriFillers[TRANSPARENT or LAMBERT  or TEXTURE] := PolygonFunction(Ptr);
  Ptr := Addr(TransGouraudTextureClipPolygon); ClipTriFillers[TRANSPARENT or GOURAUD  or TEXTURE] := PolygonFunction(Ptr);
  Ptr := Addr(TransPhongTextureClipPolygon);   ClipTriFillers[TRANSPARENT or PHONG    or TEXTURE] := PolygonFunction(Ptr);
  Ptr := Addr(TransUnshadedReflectionClipPolygon);
      ClipTriFillers[TRANSPARENT or UNSHADED or REFLECTION] := PolygonFunction(Ptr);
  Ptr := Addr(TransAmbientReflectionClipPolygon);
      ClipTriFillers[TRANSPARENT or AMBIENT  or REFLECTION] := PolygonFunction(Ptr);
  Ptr := Addr(TransLambertReflectionClipPolygon);
      ClipTriFillers[TRANSPARENT or LAMBERT  or REFLECTION] := PolygonFunction(Ptr);
  Ptr := Addr(TransGouraudReflectionClipPolygon);
      ClipTriFillers[TRANSPARENT or GOURAUD  or REFLECTION] := PolygonFunction(Ptr);
  Ptr := Addr(TransPhongReflectionClipPolygon); ClipTriFillers[TRANSPARENT or PHONG    or REFLECTION] := PolygonFunction(Ptr);
End;

Procedure ShutDownInertia;

Begin
  Free(RenderList.SortList);

  if (RenderList.PolygonList[0] <> Nil)
    Then Free(RenderList.PolygonList[0]);
  if (RenderList.PolygonList[1] <> Nil)
    Then Free(RenderList.PolygonList[1]);
  if (RenderList.PolygonList[2] <> Nil)
    Then Free(RenderList.PolygonList[2]);
  if (RenderList.PolygonList[3] <> Nil)
    Then Free(RenderList.PolygonList[3]);
End;


{$I ..\..\SOURCES\Litex\STORE\06-3DFX\SOURCE\EXTERN.INC}
{$I ..\..\SOURCES\Litex\STORE\06-3DFX\SOURCE\MATRIX.INC}
{$I ..\..\SOURCES\Litex\STORE\06-3DFX\SOURCE\ZCLIP.INC}
{$I ..\..\SOURCES\Litex\STORE\06-3DFX\SOURCE\SHADE.INC}
{$I ..\..\SOURCES\Litex\STORE\06-3DFX\SOURCE\CULL.INC}

Procedure BClip(Var Val : Byte; Lower, Higher : Byte);
{ Clips an integer into the range Low..High }

Begin
  If Val > Higher
    Then Begin
      Val := Higher;
      Exit;
    End;
  If Val < Lower
    Then Begin
      Val := Lower;
      Exit;
    End;
End;

Procedure ByteSort;

Var
  i, Index : Integer;
  TempPtr  : pSortRec;

Begin
  For i := 0 to 255 do
    Begin
      RenderList.LSBList[i] := NIL;
      RenderList.MSBList[i] := NIL;
    End;

  For i := 0 to RenderList.Count - 1 do
    Begin
      Index := RenderList.SortList^[i].ZMid And $ff;
      RenderList.SortList^[i].Next := RenderList.LSBList[Index];
      RenderList.LSBList[Index] := @RenderList.SortList^[i];
    End;

  For i := 0 to 255 do
    Begin
      while (RenderList.LSBList[i] <> NIL) do
        Begin
          Index   := (RenderList.LSBList[i]^.ZMid Shr 8) And $ff;
          TempPtr := RenderList.MSBList[Index];
          RenderList.MSBList[Index] := RenderList.LSBList[i];
          RenderList.LSBList[i]     := RenderList.LSBList[i]^.Next;
          RenderList.MSBList[Index]^.Next := TempPtr;
        End;
    End;
End;


Procedure Render(Var View : ViewObject; VPage : Pointer);
{ Sorting and rendering process }

Var
  i : Integer;
  v1, v2, v3 : Vertex2d;
  Flag1, Flag2, Flag3 : Boolean;
  j, k : Word;
  P : tPolygonRec;

Begin
  ByteSort;

  GlobalScreen := VPage;
  IT := Pointer(IntensityTable);
  MINX := View.WinMinX Shl 4;
  MINY := View.WinMinY Shl 4;
  MAXX := View.WinMaxX Shl 4;
  MAXY := View.WinMaxY Shl 4;

  With View do Begin
  For i := 255 downto 0 do
    Begin
      While RenderList.MSBList[i] <> Nil do
        Begin
          j := RenderList.MSBList[i]^.Index;
          k := j And $7ff;
          j := j Shr 11;
          P := RenderList.PolygonList[j]^[k];
          v1 := P.v1;
          v2 := P.v2;
          v3 := P.v3;
          Flag1 := ((v1.X > MinX) and (v1.x < MaxX)) and ((v1.Y > MinY) and (v1.Y < MaxY));
          Flag2 := ((v2.X > MinX) and (v2.x < MaxX)) and ((v2.Y > MinY) and (v2.Y < MaxY));
          Flag3 := ((v3.X > MinX) and (v3.x < MaxX)) and ((v3.Y > MinY) and (v3.Y < MaxY));

          If (Flag1 and Flag2) and (Flag3)
             Then TriFillers[P.PType](P, TextureList[P.Tex].Texture, TextureList[P.IBuffer].Texture)
             Else ClipTriFillers[P.PType](P, TextureList[P.Tex].Texture, TextureList[P.IBuffer].Texture);

          RenderList.MSBList[i] := RenderList.MSBList[i]^.Next;
        End;
    End;
  End;
  RenderList.Count := 0;     { Reset the sort list count }
End;

Function ObjectVisible(Var Obj : VectorObject; Var View : ViewObject; O : Matrix4x3) : Boolean;
{ Use the point-slope equation and the Object's radius to see if it is }
{ within the current view fustrum                                      }

Var
  Temp : Vertex3d;
  ClipLoc : Real;

Begin
  Temp.x := O[XLOC];
  Temp.y := O[YLOC];
  Temp.z := O[ZLOC];

  { Check to see of the object is completely behind the viewer }
  If (Temp.Z + Obj.Radius) < View.FustrumMinZ
    Then Begin
      ObjectVisible := False;
      Exit;
    End;

  { Check to see if object is pase the MaxZ plane }
  If ((Temp.Z - Obj.Radius) > View.FustrumMaxZ)
    Then Begin
      ObjectVisible := False;
      Exit;
    End;

  { Since view Fustrum is symetric to the left and right, and symetric to }
  { the top and bottom, only one compare is necessary for each axis       }

  { Check the Left and Right sides }
  { Use a floating point numbers to avoid overflow }
  ClipLoc := (Temp.Z - FUSTRUM_MIN_Z) * FUSTRUM_X_POINT_SLOPE + FUSTRUM_MIN_X;
  If (Abs(Temp.X) - Obj.Radius) > ClipLoc
    Then Begin
      ObjectVisible := False;
      Exit;
    End;

  { Check the Top and Bottom }
  ClipLoc := (Temp.Z - FUSTRUM_MIN_Z) * FUSTRUM_Y_POINT_SLOPE + FUSTRUM_MIN_Y;
  If (Abs(Temp.Y) - Obj.Radius) > ClipLoc
    Then Begin
      ObjectVisible := False;
      Exit;
    End;

  { se if we cross the z-clipping plane }
  If (Abs(Temp.Z) - Obj.Radius) <= View.FustrumMinZ
    Then Obj.zClip := True
    Else Obj.zClip := False;

  ObjectVisible := True;
End;

Procedure AddToRenderList(Var View : ViewObject; Obj : VectorObject);
{ Add an object to the view's render list }

Var
  CullVector : Vertex3d;
  i : Integer;
  SCount : Word;
  TempMat : Matrix4x3;
  Temp : Vertex3d;

Begin
  { The new origin based on camera translation }
  Temp.x := Obj.Orientation[XLOC] + View.Camera[XLOC];
  Temp.y := Obj.Orientation[YLOC] + View.Camera[YLOC];
  Temp.z := Obj.Orientation[ZLOC] + View.Camera[ZLOC];

  { Store point based on camera rotation }
  With View do
    Begin
      TempMat[XLOC] := FixMul(Camera[0], Temp.X) + FixMul(Camera[3], Temp.Y) + FixMul(Camera[6], Temp.Z);
      TempMat[YLOC] := FixMul(Camera[1], Temp.X) + FixMul(Camera[4], Temp.Y) + FixMul(Camera[7], Temp.Z);
      TempMat[ZLOC] := FixMul(Camera[2], Temp.X) + FixMul(Camera[5], Temp.Y) + FixMul(Camera[8], Temp.Z);
    End;

  If Not(ObjectVisible(Obj, View, TempMat))
    Then Exit;

{$IFNDEF DELTAROTATIONS}
  SetRotationMatrix(Obj.Orientation, Obj.xAngle, Obj.yAngle, Obj.zAngle);
{$ENDIF}

  { Concatenate object space matrix with camera matrix }
  MatrixMul(TempMat, Obj.Orientation, View.Camera);

  { Make culling vector }
  CullVector.x := -TempMat[XLOC]*256;
  CullVector.y := -TempMat[YLOC]*256;
  CullVector.z := -TempMat[ZLOC]*256;

  { If culling vector is zero, use the z-axis vector }
  { in rotation matrix to perform culling            }
  If ((CullVector.x = 0) and (CullVector.y = 0)) and (CullVector.z = 0)
    Then Begin
      CullVector.x := -TempMat[2];
      CullVector.y := -TempMat[5];
      CullVector.z := -TempMat[8];
    End
    Else InvXForm(CullVector, TempMat);

  { Inversely transform the light positions }
  i := 0;
  While (i < Lights.NumLights) do
    Begin
      Lights.TempLight[i] := Lights.Light[i];
      InvXForm(Lights.TempLight[i], Obj.Orientation);
      Inc(i);
    End;

  If (Obj.Cull)
    Then Begin
      FillChar(Obj.RotateList^, Obj.Num_Verticies * Sizeof(Register), 0);
      FillChar(Obj.CullList^, Obj.Num_Polygons * Sizeof(CullRec), 0);
      { Cull the object }
      CullPolys(Obj, CullVector);
    End
    Else Begin
      For i := 0 to (Obj.Num_Verticies - 1) do Obj.RotateList^[i].w1 := 1;
      For i := 0 to (Obj.Num_Polygons - 1) do  Obj.CullList^[i].Visible := 1;
    End;

  For i := 0 to (Obj.Num_Polygons - 1) do
    Obj.CullList^[i].Color := Obj.Polygons^[i].Color;

  { shade, transform and project the object }
  Case (Obj.RenderMask and SURFACE_MASK) of
{$IFDEF SMOOTHCASE}
    SMOOTH : Begin
          Case (Obj.RenderMask and SHADE_MASK) of
{$IFDEF SMOOTHUNSHADED}
            UNSHADED: SmoothUnshaded(View, Obj, TempMat);
{$ENDIF}
{$IFDEF SMOOTHAMBIENT}
            AMBIENT : SmoothAmbient(View, Obj, TempMat);
{$ENDIF}
{$IFDEF SMOOTHLAMBERT}
            LAMBERT : SmoothLambert(View, Obj, TempMat);
{$ENDIF}
{$IFDEF SMOOTHGOURAUD}
            GOURAUD : SmoothGouraud(View, Obj, TempMat);
{$ENDIF}
{$IFDEF SMOOTHPHONG}
            PHONG   : SmoothPhong(View, Obj, TempMat);
{$ENDIF}
          End;
        End;
{$ENDIF}
{$IFDEF TEXTURECASE}
    TEXTURE : Begin
          Case (Obj.RenderMask And SHADE_MASK) of
{$IFDEF TEXTUREUNSHADED}
            UNSHADED: TextureUnshaded(View, Obj, TempMat);
{$ENDIF}
{$IFDEF TEXTUREAMBIENT}
            AMBIENT : TextureAmbient(View, Obj, TempMat);
{$ENDIF}
{$IFDEF TEXTURELAMBERT}
            LAMBERT : TextureLambert(View, Obj, TempMat);
{$ENDIF}
{$IFDEF TEXTUREGOURAUD}
            GOURAUD : TextureGouraud(View, Obj, TempMat);
{$ENDIF}
{$IFDEF TEXTUREPHONG}
            PHONG   : TexturePhong(View, Obj, TempMat);
{$ENDIF}
          End;
       End;
{$ENDIF}
{$IFDEF REFLECTIONCASE}
    REFLECTION : Begin
          Case (Obj.RenderMask And SHADE_MASK) of
{$IFDEF REFLECTIONUNSHADED}
            UNSHADED: ReflectionUnshaded(View, Obj, TempMat);
{$ENDIF}
{$IFDEF REFLECTIONAMBIENT}
            AMBIENT : ReflectionAmbient(View, Obj, TempMat);
{$ENDIF}
{$IFDEF REFLECTIONLAMBERT}
            LAMBERT : ReflectionLambert(View, Obj, TempMat);
{$ENDIF}
{$IFDEF REFLECTIONGOURAUD}
            GOURAUD : ReflectionGouraud(View, Obj, TempMat);
{$ENDIF}
{$IFDEF REFLECTIONPHONG}
            PHONG   : ReflectionPhong(View, Obj, TempMat);
{$ENDIF}
          End;
       End;
{$ENDIF}
  End;
End;

Procedure InitView(Var View : ViewObject);
{ Initializes a View                                }

Begin
  With View do
    Begin
      Lights.NumLights := 0;
      InitMatrix(Camera);
      WinMinX := 0;
      WinMinY := 0;
      WinMaxX := 319;
      WinMaxY := 199;
      CenterX := 319 Div 2;
      CenterY := 199 Div 2;

      FustrumMinZ := FUSTRUM_MIN_Z;
      FustrumMaxZ := FIXONE;
    End;
End;

Procedure FreeView(Var View : ViewObject);
{ This is here for compatibility sake.                }
{ Nothing in the view structure is allocated any more }

Begin
End;

Procedure GetObjectAsCamera(Var View : ViewObject; Obj : VectorObject);

Begin
  MatrixCopy(Obj.Orientation, View.Camera);
  SetRotationMatrix(View.Camera, Obj.xAngle, Obj.yAngle, Obj.zAngle);
  InverseMatrix(View.Camera);
End;

Procedure SetViewPort(Var View: ViewObject; X1, Y1, X2, Y2 : Integer; Update : Boolean);

Begin
  Clip(X1, 0, 319);
  Clip(X2, 0, 319);
  Clip(Y1, 0, 199);
  Clip(Y2, 0, 199);

  If (X1 > X2) Then VarSwap(X1, X2, Sizeof(X1));
  If (Y1 > Y2) Then VarSwap(Y1, Y2, Sizeof(Y1));

  View.WinMinX := X1;
  View.WinMinY := Y1;
  View.WinMaxX := X2;
  View.WinMaxY := Y2;

  If UpDate
    Then Begin
      View.CenterX := (X2+X1) Shr 1;
      View.CenterY := (Y2+Y1) Shr 1;
    End;
End;

Procedure SetAbsoluteRotation(Var Obj : VectorObject; rx, ry, rz : Integer);

Begin
  Obj.xAngle := rx And 1023;
  Obj.yAngle := ry And 1023;
  Obj.zAngle := rz And 1023;
{$IFDEF DELTAROTATIONS}
  SetRotationMatrix(Obj.Orientation, Obj.xAngle, Obj.yAngle, Obj.zAngle);
  Obj.CorrectCount := 0;
{$ENDIF}
End;

Procedure SetDeltaRotation(Var Obj : VectorObject; dx, dy, dz : Integer);

{$IFDEF DELTAROTATIONS}
Var
  TempMat : Matrix4x3;
  TempMat2 : Matrix4x3;
  xx, xy, xz : Real;
  yx, yy, yz : Real;
  zx, zy, zz : Real;
  dot1, dot2 : Real;
  len : Real;
{$ENDIF}

Begin
{$IFDEF DELTAROTATIONS}
  SetRotationMatrix(TempMat, dx And 1023, dy And 1023, dz And 1023);
  MatrixCopy(Obj.Orientation, TempMat2);
  MatrixMul(Obj.Orientation, TempMat, TempMat2);

  Inc(Obj.CorrectCount);
  If (Obj.CorrectCount >= CORRECTRES)
    Then Begin
      xx := Obj.Orientation[0]/FIXONE;
      xy := Obj.Orientation[3]/FIXONE;
      xz := Obj.Orientation[6]/FIXONE;
      yx := Obj.Orientation[1]/FIXONE;
      yy := Obj.Orientation[4]/FIXONE;
      yz := Obj.Orientation[7]/FIXONE;
      zx := Obj.Orientation[2]/FIXONE;
      zy := Obj.Orientation[5]/FIXONE;
      zz := Obj.Orientation[8]/FIXONE;

      { Correct X axis vector }
      dot1 := (xx*yx) + (xy*yy) + (xz*yz);
      dot2 := (xx*zx) + (xy*zy) + (xz*zz);
      xx := xx - dot1*yx;
      xx := xx - dot2*zx;
      xy := xy - dot1*yy;
      xy := xy - dot2*zy;
      xz := xz - dot1*yz;
      xz := xz - dot2*zz;
      len := sqrt(xx*xx + xy*xy + xz*xz);
      xx := xx/len;
      xy := xy/len;
      xz := xz/len;

      { Correct Y axis vecotor }
      dot1 := (yx*xx) + (yy*xy) + (yz*xz);
      dot2 := (yx*zx) + (yy*zy) + (yz*zz);
      yx := yx - dot1*xx;
      yx := yx - dot2*zx;
      yy := yy - dot1*xy;
      yy := yy - dot2*zy;
      yz := yz - dot1*xz;
      yz := yz - dot2*zz;
      len := sqrt(yx*yx + yy*yy + yz*yz);
      yx := yx/len;
      yy := yy/len;
      yz := yz/len;

      { do x cross y to get z axis }
      zx := xy*yz - xz*yy;
      zy := xz*yx - xx*yz;
      zz := xx*yy - xy*yx;

      Obj.Orientation[0] := Round(xx*FIXONE);
      Obj.Orientation[3] := Round(xy*FIXONE);
      Obj.Orientation[6] := Round(xz*FIXONE);
      Obj.Orientation[1] := Round(yx*FIXONE);
      Obj.Orientation[4] := Round(yy*FIXONE);
      Obj.Orientation[7] := Round(yz*FIXONE);
      Obj.Orientation[2] := Round(zx*FIXONE);
      Obj.Orientation[5] := Round(zy*FIXONE);
      Obj.Orientation[8] := Round(zz*FIXONE);
      Obj.CorrectCount := 0;
    End;
{$ENDIF}
  Obj.xAngle := (Obj.xAngle + dx) And 1023;
  Obj.yAngle := (Obj.yAngle + dy) And 1023;
  Obj.zAngle := (Obj.zAngle + dz) And 1023;
End;

Procedure SetAbsoluteLocation(Var Obj : VectorObject; tx, ty, tz : Longint);

Begin
  Obj.Orientation[XLOC] := tx;
  Obj.Orientation[YLOC] := ty;
  Obj.Orientation[ZLOC] := tz;
End;

Procedure SetDeltaLocation(Var Obj : VectorObject; dx, dy, dz : Longint);

Begin
  Inc(Obj.Orientation[XLOC], dx);
  Inc(Obj.Orientation[YLOC], dy);
  Inc(Obj.Orientation[ZLOC], dz);
End;

Procedure SetViewFustrum(Var View : ViewObject; MinZ, MaxZ : Longint);

Begin
  View.FustrumMinZ := MinZ;
  View.FustrumMaxZ := MaxZ;
End;

Procedure SetBaseColor(Var Obj : VectorObject; C : Integer);

Var
  i : Integer;

Begin
  Clip(C, 0, 255);
  For i := 0 to (Obj.Num_Polygons - 1) do
    Obj.Polygons^[i].Color := C;
End;

Procedure SetPolygonColor(Var Obj : VectorObject; Poly : Integer; C : Integer);

Var
  i : Integer;

Begin
  Clip(Poly, 0, Obj.Num_Polygons - 1);
  Obj.Polygons^[Poly].Color := C;
End;

Procedure SetObjectTexture(Var Obj : VectorObject; C : Integer);

Var
  i : Integer;

Begin
  Clip(C, 0, MAXTEXTURES-1);
  For i := 0 to (Obj.Num_Polygons - 1) do
    Obj.Polygons^[i].Texture := C;
End;


Procedure SetPolygonTexture(Var Obj : VectorObject; Poly : Integer; C : Integer);

Var
  i : Integer;

Begin
  Clip(Poly, 0, Obj.Num_Polygons - 1);
  Clip(C, 0, MaxTextures-1);
  Obj.Polygons^[Poly].Texture := C;
End;


Procedure SetObjectPhongMap(Var Obj : VectorObject; C : Integer);

Var
  i : Integer;

Begin
  Clip(C, 0, MAXTEXTURES-1);
  Obj.IBuffer := C;
End;

Procedure InitVectorObject(Var Obj : VectorObject);

Begin
  With Obj do
    Begin
      Cull := True;
      RenderMask := AMBIENT or SMOOTH;
      Num_Verticies := 0;
      Num_Polygons  := 0;
      Object_Definition := Nil;
      World_Coords      := Nil;
      Screen_Coords     := Nil;
      Vertex_Normals    := Nil;
      Polygon_Normals   := Nil;
      Polygons          := Nil;
      RotateList        := Nil;
      Texture_Coords    := Nil;
      xAngle            := 0;
      yAngle            := 0;
      zAngle            := 0;
      Radius            := 0;
      InitMatrix(Orientation);
      CorrectCount := 0;
    End;
End;

Procedure FreeVectorObject(Var Obj : VectorObject);

Begin
  If (Obj.Object_Definition <> Nil) Then Free(Obj.Object_Definition);
  If (Obj.World_Coords <> Nil)      Then Free(Obj.World_Coords);
  If (Obj.Screen_Coords <> Nil)     Then Free(Obj.Screen_Coords);
  If (Obj.Vertex_Normals <> Nil)    Then Free(Obj.Vertex_Normals);
  If (Obj.Polygon_Normals <> Nil)   Then Free(Obj.Polygon_Normals);
  If (Obj.Polygons <> Nil)          Then Free(Obj.Polygons);
  If (Obj.RotateList <> Nil)        Then Free(Obj.RotateList);
  If (Obj.CullList <> Nil)          Then Free(Obj.CullList);
  If (Obj.Texture_Coords <> Nil)    Then Free(Obj.Texture_Coords);
  Obj.Num_Verticies := 0;
  Obj.Num_Polygons := 0;
  Obj.Radius := 0;
  Obj.Texture_Coords := Nil;
End;

Procedure CalcBoundaryVolume(Var Obj : VectorObject);

Var
  Error, Temp : Real;
  x, y, z : Real;
  i : Word;

Begin
  If Obj.Num_Verticies = 0
    Then Exit;
  Error := 0;    { set to the absolute maximum }
  For i := 0 to (Obj.Num_Verticies - 1) do
    Begin
      x := Obj.Object_Definition^[i].x;
      y := Obj.Object_Definition^[i].y;
      z := Obj.Object_Definition^[i].z;
      Temp := Sqr(x) + Sqr(y) + Sqr(z);
      If Temp > Error
        Then Error := Temp;
    End;
  Obj.Radius := Round(Sqrt(Error)+1);
End;

Procedure SetRenderMask(Var Obj : VectorObject; Mask : Integer);

Begin
  Obj.RenderMask := Mask;
End;

Procedure SetViewLocation(Var View : ViewObject; X, Y, Z : Longint);

Begin
  View.Camera[XLOC] := -X;
  View.Camera[YLOC] := -Y;
  View.Camera[ZLOC] := -Z;
End;

Procedure SetCull(Var Obj : VectorObject; Cull : Boolean);

Begin
  Obj.Cull := Cull;
End;


Procedure SetFocusPoint(Var View : ViewObject; TargetX, TargetY, TargetZ, Roll : Longint);
{ Targets the camera at the specified point with a roll around the axis  }
{ as specified by Roll parameter.                                        }
{ If target point and camera point, the procedure exits without changing }
{ the previous target orientation                                        }

Var
  Len, X, Y, Z : Real;
  ViewMat : Matrix4x3;
  RollMat : Matrix4x3;
  zx, zy, zz : Real;
  yx, yy, yz : Real;
  xx, xy, xz : Real;
  gx, gy, gz : Real;

Begin
  { Add because View locations are stored as inverses }
  zx :=  TargetX + View.Camera[XLOC];
  zy :=  TargetY + View.Camera[YLOC];
  zz :=  TargetZ + View.Camera[ZLOC];

  If ((zx = 0) And (zy = 0)) And (zz = 0) { Make sure there is something to do }
    Then Exit;

  Len := Sqrt(Sqr(zx) + Sqr(zy) + Sqr(zz));

  zx := (zx/Len);  { Use floating point for possible _very_ large numbers }
  zy := (zy/Len);
  zz := (zz/Len);

  If (zx = 0) And (zz = 0)
    Then Begin
      gx := -zy;
      gy := 0;
      gz := 0;
    End
    Else Begin
      gx := 0;
      gy := -1;
      gz := 0;
    End;

  { cross G vector with Z vector }
  xx := gy*zz - gz*zy;
  xy := gz*zx - gx*zz;
  xz := gx*zy - gy*zx;
  Len := Sqrt(Sqr(xx) + Sqr(xy) + Sqr(xz));
  xx := xx/Len;
  xy := xy/Len;
  xz := xz/Len;

  yx := xy*zz - xz*zy;
  yy := xz*zx - xx*zz;
  yz := xx*zy - xy*zx;
  Len := Sqrt(Sqr(yx) + Sqr(yy) + Sqr(yz));
  yx := yx/Len;
  yy := yy/Len;
  yz := yz/Len;

  ViewMat[0] := Round(xx*FIXONE);
  ViewMat[3] := Round(xy*FIXONE);
  ViewMat[6] := Round(xz*FIXONE);
  ViewMat[1] := Round(yx*FIXONE);
  ViewMat[4] := Round(yy*FIXONE);
  ViewMat[7] := Round(yz*FIXONE);
  ViewMat[2] := Round(zx*FIXONE);
  ViewMat[5] := Round(zy*FIXONE);
  ViewMat[8] := Round(zz*FIXONE);

  { Note: this can be made a bit faster using dedicated z-rotation formulation }
  SetRotationMatrix(RollMat, 0, 0, Roll);

  { Note: This multiplication can be made faster using a dedicated multiplier }
  MatrixMul(View.Camera, ViewMat, RollMat);

End;

Function LoadGVO(Var Obj : VectorObject; Filename : String; FOfs : Longint) : Integer;
{ Loads a GVO data file into the OBJ variable.      }
{ in: Obj - VectorObject data member                }
{     Filename - Name of VO file on disk            }
{ returns:  0 - Load Successful                     }
{           1 - Couldn't open file                  }
{           2 - Error reading from file             }
{           3 - Not enough memory for object        }
{           5 - Not a valid GVO file                }

Var
  Flag, InRead : Word;
  tw : Word;
  i : Integer;
  Diskfile : bFile;
  FileBuffer : PFileBuffer;
  Tag : Array[0..2] of Char;
  Size : Longint;


Begin
  InitVectorObject(Obj);

  New(FileBuffer);

  FAssign(Diskfile, Filename);
  FSetBuffer(Diskfile, FileBuffer^, Sizeof(TFilebuffer));
  FReset(Diskfile);

{$IFDEF IO_CHECKS}
  If IOResult <> 0
    Then Begin
      Dispose(FileBuffer);
      LoadGVO := I_FILEERR;
      Exit;
    End;
{$ENDIF}
  FSeek(Diskfile, FOfs);


  InRead := FRead(Diskfile, Tag, Sizeof(Tag));
  If ((Tag[0] <> 'G') and (Tag[1] <> 'V')) And (Tag[2] <> 'O')
    Then Begin
      FClose(Diskfile);
      Dispose(FileBuffer);
      LoadGVO := I_FORMATERR;
      Exit;
    End;

  InRead := FRead(Diskfile, Flag, Sizeof(Flag));
{$IFDEF IO_CHECKS}
  If (IOResult <> 0)
    Then Begin
      FClose(Diskfile);
      Dispose(FileBuffer);
      LoadGVO := I_FILEERR;
      Exit;
    End;
{$ENDIF}

  If (((Flag And $01) <> 0) and ((Flag And $02) <> 0))
    Then Begin
      InRead := FRead(Diskfile, Obj.Num_Verticies, Sizeof(Obj.Num_Verticies));
      Size := bFilePos(Diskfile);
      FSeek(Diskfile, Size + (Obj.Num_Verticies * Sizeof(ShortVertex3d)));
      InRead := FRead(Diskfile, Obj.Num_Polygons, Sizeof(Obj.Num_Polygons));
      FSeek(Diskfile, Size);
      Size := bFilePos(Diskfile);
{$IFDEF IO_CHECKS}
      If (IOResult <> 0)
        Then Begin
          FClose(Diskfile);
          Dispose(FileBuffer);
          LoadGVO := I_FILEERR;
          Exit;
        End;
{$ENDIF}
    End
    Else Begin
      FClose(Diskfile);
      Dispose(FileBuffer);
      LoadGVO := I_FILEERR;
      Exit;
    End;

  if (AllocObject(Obj, Obj.Num_Verticies, Obj.Num_Polygons) <> I_OK)
    Then Begin
      FClose(Diskfile);
      FreeVectorObject(Obj);
      Dispose(FileBuffer);
      LoadGVO := I_MEMERR;
      Exit;
    End;

  If (Flag And 1) <> 0
    Then Begin
      InRead := FRead(Diskfile, Obj.Object_Definition^, Obj.Num_Verticies * Sizeof(ShortVertex3d));
{$IFDEF IO_CHECKS}
      If (IOResult <> 0)
        Then Begin
          FClose(Diskfile);
          FreeVectorObject(Obj);
          Dispose(FileBuffer);
          LoadGVO := I_FILEERR;
          Exit;
        End;
{$ENDIF}
    End;

  If (Flag And 2) <> 0
    Then Begin
     InRead := FRead(Diskfile, tw, Sizeof(tw));
{$IFDEF IO_CHECKS}
      If (IOResult <> 0)
        Then Begin
          FClose(Diskfile);
          FreeVectorObject(Obj);
          Dispose(FileBuffer);
          LoadGVO := I_FILEERR;
          Exit;
        End;
{$ENDIF}
      For i := 0 to (Obj.Num_Polygons - 1) do
        Begin
          InRead := FRead(Diskfile, Obj.Polygons^[i].a, 2);
          InRead := FRead(Diskfile, Obj.Polygons^[i].b, 2);
          InRead := FRead(Diskfile, Obj.Polygons^[i].c, 2);
{$IFDEF IO_CHECKS}
          If (IOResult <> 0)
            Then Begin
              FClose(Diskfile);
              Dispose(FileBuffer);
              FreeVectorObject(Obj);
              LoadGVO := I_FILEERR;
              Exit;
            End;
{$ENDIF}
        End;
    End;

  If (Flag And 4) <> 0
    Then Begin
      InRead := FRead(Diskfile, Obj.Polygon_Normals^, Obj.Num_Polygons * Sizeof(ShortVertex3d));
{$IFDEF IO_CHECKS}
      If (IOResult <> 0)
        Then Begin
          FClose(Diskfile);
          FreeVectorObject(Obj);
          Dispose(FileBuffer);
          LoadGVO := I_FILEERR;
          Exit;
        End;
{$ENDIF}
    End;

  { Load Vertex normals }
  If (Flag And 8) <> 0
    Then Begin
      InRead := FRead(Diskfile, Obj.Vertex_Normals^, Obj.Num_Verticies * Sizeof(ShortVertex3d));
{$IFDEF IO_CHECKS}
      If (IOResult <> 0)
        Then Begin
          FClose(Diskfile);
          FreeVectorObject(Obj);
          Dispose(FileBuffer);
          LoadGVO := I_FILEERR;
          Exit;
        End;
{$ENDIF}
    End;

  { Texture Coords }
  If (Flag And 16) <> 0
    Then Begin
      InRead := FRead(Diskfile, Obj.Texture_Coords^, Obj.Num_Polygons * Sizeof(TextureCoord));
{$IFDEF IO_CHECKS}
      If (IOResult <> 0)
        Then Begin
          FClose(Diskfile);
          FreeVectorObject(Obj);
          Dispose(FileBuffer);
          LoadGVO := I_FILEERR;
          Exit;
        End;
{$ENDIF}
    End;

{ Color Map }
  If (Flag And 32) = 32
    Then Begin
      For i := 0 to (Obj.Num_Polygons-1) do
        Begin
          FRead(Diskfile, Obj.Polygons^[i].Color, 1);
{$IFDEF IO_CHECKS}
          If IOResult <> 0
            Then Begin
              FClose(Diskfile);
              FreeVectorObject(Obj);
              Dispose(FileBuffer);
              LoadGVO := I_FILEERR;
              Exit;
            End;
{$ENDIF}
        End;
    End
    Else SetBaseColor(Obj, 0);

  FClose(Diskfile);
  Dispose(FileBuffer);
  CalcBoundaryVolume(Obj);
  LoadGVO := I_OK;
End;

Function AllocObject(Var Obj : VectorObject; NumVert, NumPoly : Integer) : Integer;

Var
  Size : Longint;

Begin
  InitVectorObject(Obj);

  Obj.Num_Verticies     := NumVert;
  Obj.Num_Polygons      := NumPoly;

  Obj.Object_Definition := Malloc(Obj.Num_Verticies * Sizeof(ShortVertex3d));
  Obj.World_Coords      := Malloc(Obj.Num_Verticies * Sizeof(Vertex3d));
  Obj.Screen_Coords     := Malloc(Obj.Num_Verticies * Sizeof(Vertex2d));
  Obj.RotateList        := Malloc(Obj.Num_Verticies * Sizeof(Register));
  Obj.Polygons          := Malloc(Obj.Num_Polygons * Sizeof(Triangle));
  Obj.CullList          := Malloc(Obj.Num_Polygons * Sizeof(CullRec));
  Obj.Polygon_Normals   := Malloc(Obj.Num_Polygons * Sizeof(ShortVertex3d));
  Obj.Vertex_Normals    := Malloc(Obj.Num_Verticies * Sizeof(ShortVertex3d));
  Obj.Texture_Coords    := Malloc(Obj.Num_Polygons * Sizeof(TextureCoord));

  If ((((Obj.Object_Definition = NIL) or (Obj.World_Coords = Nil))     or
       ((Obj.Screen_Coords = NIL)     or (Obj.RotateList = NIL)))      or
      (((Obj.Polygons = NIL)          or (Obj.CullList = NIL))         or
       ((Obj.Polygon_Normals = NIL)   or (Obj.Vertex_Normals = NIL)))) or
       (Obj.Texture_Coords = NIL)
    Then Begin
      FreeVectorObject(Obj);
      AllocObject := I_MEMERR;
    End
    Else AllocObject := I_OK;
End;

Function  CopyVectorObject(Var Source, Dest : VectorObject) : Integer;

Begin
  if (AllocObject(Dest, Source.Num_Verticies, Source.Num_Polygons) <> I_OK)
    Then Begin
      CopyVectorObject := I_MEMERR;
      Exit;
    End;

  Dest.RenderMask    := Source.RenderMask;
  Dest.IBuffer       := Source.IBuffer;
  Dest.Radius        := Source.Radius;
  Dest.xAngle        := Source.xAngle;
  Dest.yAngle        := Source.yAngle;
  Dest.zAngle        := Source.zAngle;
  Dest.zClip         := Source.zClip;
  Dest.Cull          := Source.Cull;
  Dest.CorrectCount  := Source.CorrectCount;

  MatrixCopy(Source.Orientation, Dest.Orientation);

  Move(Source.Object_Definition^, Dest.Object_Definition^, sizeof(ShortVertex3d) * Dest.Num_Verticies);
  Move(Source.World_Coords^, Dest.World_Coords^, sizeof(Vertex3d) * Dest.Num_Verticies);
  Move(Source.Screen_Coords^, Dest.Screen_Coords^, sizeof(Vertex2d) * Dest.Num_Verticies);
  Move(Source.Vertex_Normals^, Dest.Vertex_Normals^, sizeof(ShortVertex3d) * Dest.Num_Verticies);
  Move(Source.RotateList^, Dest.RotateList^, sizeof(Register) * Dest.Num_Verticies);

  Move(Source.Polygons^, Dest.Polygons^, sizeof(Triangle) * Dest.Num_Polygons);
  Move(Source.Polygon_Normals^, Dest.Polygon_Normals^, sizeof(ShortVertex3d) * Dest.Num_Polygons);
  Move(Source.CullList^, Dest.CullList^, sizeof(CullRec) * Dest.Num_Polygons);
  Move(Source.Texture_Coords^, Dest.Texture_Coords^, sizeof(TextureCoord) * Dest.Num_Polygons);

  CopyVectorObject := I_OK;
End;

{$IFDEF TRANSPARENCY}
Function LoadTransparencyTable(Filename : String; FOfs : Longint) : Integer;

Var
  Diskfile : bFile;
  FileBuffer : PFileBuffer;
  Size : Longint;

Begin
  TT := Malloc(65535);
  if (TT = NIL)
    Then Begin
      LoadTransparencyTable := I_MEMERR;
      Exit;
    End;

  FAssign(Diskfile, Filename);
  New(FileBuffer);
  FSetBuffer(Diskfile, FileBuffer^, Sizeof(TFilebuffer));
  FReset(Diskfile);
{$IFDEF IO_CHECKS}
  If IOResult <> 0
    Then Begin
      Dispose(FileBuffer);
      LoadTransparencyTable := I_FILEERR;
      Exit;
    End;
{$ENDIF}
  FSeek(Diskfile, FOfs);
  FRead(Diskfile, TT^, 65535);
  FClose(Diskfile);
  Dispose(FileBuffer);
  LoadTransparencyTable := I_OK;
End;

Procedure FreeTransparencyTable;

Begin
  If TT <> Nil
    Then Free(TT);
End;
{$ENDIF}

Function LoadIntensityTable(Filename : String; FOfs : Longint) : Integer;
{ Loads an intensity table from the disk         }
{ in: Filename - filename of the intensity table }
{ returns: 0 - Operation successful              }
{          1 - Not Enough memory                 }
{          2 - File not found                    }
{          3 - Error reading file                }

Var
  InRead : Word;
  i : Integer;
  Diskfile : bFile;
  FileBuffer : PFileBuffer;
  Size : Longint;

Begin
{$IFDEF DPMI}
  IntensityTable := Malloc(65535);
{$ELSE}
  IntensityTable := Malloc(256*64 + $f);
{$ENDIF}

  if (IntensityTable = NIL)
    Then Begin
      LoadIntensityTable := I_MEMERR;
      Exit;
    End;

  If ((Longint(IntensityTable) and $ffff) <> 0)
    Then IntensityTable := Pointer((Longint(IntensityTable) + $10000) And $ffff0000);

  New(FileBuffer);
  FAssign(Diskfile, Filename);
  FSetBuffer(Diskfile, FileBuffer^, Sizeof(TFileBuffer));
  FReset(Diskfile);
{$IFDEF IO_CHECKS}
  If IOResult <> 0
    Then Begin
      Free(IntensityTable);

      Dispose(FileBuffer);
      LoadIntensityTable := I_FILEERR;
      Exit;
    End;
{$ENDIF}
  FSeek(Diskfile, FOfs);
  For i := 63 downto 0 do
    Begin
      InRead := FRead(Diskfile, IntensityTable^[i*256], 256);
{$IFDEF IO_CHECKS}
      If IOResult <> 0
        Then Begin
          FClose(Diskfile);
          Free(IntensityTable);
          Dispose(FileBuffer);
          LoadIntensityTable := I_FILEERR;
          Exit;
        End;
{$ENDIF}
    End;
  FClose(Diskfile);
  Dispose(FileBuffer);
  LoadIntensityTable := I_OK;
End;

Procedure FreeIntensityTable;

Begin
  If (IntensityTable <> Nil)
    Then Free(IntensityTable);
End;

Function LoadPalette(FileName : String; FOfs : Longint) : Integer;
{ Returns:  0 - load successful    }
{           1 - File not found     }
{           2 - Error Reading file }

Var
  InRead : Word;
  Diskfile : bFile;

Begin
  FAssign(Diskfile, Filename);
  FReset(Diskfile);
{$IFDEF IO_CHECKS}
  If IOResult <> 0
    Then Begin
      LoadPalette := I_FILEERR;
      Exit;
    End;
{$ENDIF}
  FSeek(Diskfile, FOfs);
  InRead := FRead(Diskfile, GlobalPalette, Sizeof(Palette));
{$IFDEF IO_CHECKS}
  If IOResult <> 0
    Then Begin
      FClose(Diskfile);
      LoadPalette := I_FILEERR;
      Exit;
    End;
{$ENDIF}
  FClose(Diskfile);
  LoadPalette := I_OK;
End;

Procedure GetTexturePalette(Index : Integer);

Begin
  Clip(Index, 0, MAXTEXTURES-1);
  Move(TextureList[Index].Pal^, GlobalPalette, Sizeof(Palette));
End;

Procedure PushLightSource(X, Y, Z : Real);
{ Adds a light source to the LightSource stack }

Var
  Len : Real;
  Index : Integer;

Begin
  If Lights.NumLights >= MAXLIGHTS Then Exit;
  Len := Sqr(x) + Sqr(y) + Sqr(z);
  If (Len <= 0) Then Exit;
  Len := Sqrt(Len);
  Index := Lights.NumLights;
  Lights.Light16[Index].x := Round((X/Len)*65536);
  Lights.Light16[Index].y := Round((Y/Len)*65536);
  Lights.Light16[Index].z := Round((Z/Len)*65536);
  Lights.Light[Index].X := Lights.Light16[Index].X Div 256;
  Lights.Light[Index].Y := Lights.Light16[Index].Y Div 256;
  Lights.Light[Index].Z := Lights.Light16[Index].Z Div 256;
  Lights.NumLights := Lights.NumLights + 1;
End;

Procedure PopLightSource;
{ Removes a light source from the View              }

Begin
  If Lights.NumLights > 0
    Then Lights.NumLights := Lights.NumLights - 1;
End;

Procedure RotateLightSource(Index, Xa, Ya, Za : Integer);

Var
  X, Y, Z : Real;
  Len : Real;
  TaylorLen : Longint;

Begin
  Clip(Index, 0, 7);
  If Index >= Lights.NumLights
    Then Exit;
  Xa := Xa And 1023;
  Ya := Ya And 1023;
  Za := Za And 1023;

  SingleRotate(Lights.Light16[Index], Xa, Ya, Za);

  X := Lights.Light16[Index].X / 65536;
  Y := Lights.Light16[Index].Y / 65536;
  Z := Lights.Light16[Index].Z / 65536;
  Len := Sqrt(X*X + Y*Y + Z*Z);

  Lights.Light16[Index].X := Round((X/Len)*65536);
  Lights.Light16[Index].Y := Round((Y/Len)*65536);
  Lights.Light16[Index].Z := Round((Z/Len)*65536);

  Lights.Light[Index].X := Lights.Light16[Index].X Div 256;
  Lights.Light[Index].Y := Lights.Light16[Index].Y Div 256;
  Lights.Light[Index].Z := Lights.Light16[Index].Z Div 256;
End;


Function MakePhongMap(Index : Integer) : Integer;
{ Returns:  0 - successsful      }
{           1 - Not enough mmory }

Var
  P : PMap;
  t, x, y : Integer;
  tx, ty : Real;

Begin
  Clip(Index, 0, MaxTextures - 1);
  TextureList[Index].Texture := Malloc($ffff);
  if (TextureList[Index].Texture = Nil)
    Then Begin
      MakePhongMap := I_MEMERR;
      Exit;
    End;

  P := TextureList[Index].Texture;

  FillChar(P^[0], 65535, 0);
  TextureList[Index].Size := 65535;

  For y := 0 to 255 do
    For x := 0 to 255 do
      Begin
        tx := 127-x;
        ty := 127-y;
        t := Round(Sqrt(sqr(tx) + Sqr(ty))) Div 2;
        Clip(t, 0, 63);
        P^[(y Shl 8) + x] := 63 - t;
      End;

  MakePhongMap := I_OK;
End;

Function LoadPCXTexture(Index : Integer; Filename : String; FOfs : Longint) : Integer;

Var
  RawPic : Pointer;
  Pal : Palette;
  RetCode : Integer;
  Size : Word;

Begin
  RetCode := LoadPCXFile(Filename, RawPic, Pal, Size, FOfs);
  If RetCode <> 0
    Then Begin
      LoadPCXTexture := RetCode;
      Exit;
    End;
  Clip(Index, 0, MAXTEXTURES);

  TextureList[Index].Size := Size;
  TextureList[Index].Texture := RawPic;

  New(TextureList[Index].Pal);

  Move(Pal, TextureList[Index].Pal^, Sizeof(Palette));

  LoadPCXTexture := I_OK;
End;

Procedure FreeTexture(Index : Integer);

Begin
  Clip(Index, 0, MAXTEXTURES);
  If TextureList[Index].Texture <> Nil
    Then Free(TextureList[Index].Texture);
  If TextureList[Index].Pal <> Nil
    Then Dispose(TextureList[Index].Pal);
End;

Begin
  InitInertia;
End.
