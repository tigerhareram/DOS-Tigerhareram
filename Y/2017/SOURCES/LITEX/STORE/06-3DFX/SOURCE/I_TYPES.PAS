(*
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
                     Inertia Realtime 3D Rendering Engine
            Copyright (c) 1997, Alex Chalfin. All Rights Reserved.
                       Inertia/16 Source Code Release.
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*)

{$I ..\SOURCES\Litex\STORE\06-3DFX\SOURCE\DEFINE.INC}
Unit i_Types;

{$IFDEF DEBUGGING}
{$D+,L+}
{$ELSE}
{$D-,L-}
{$ENDIF}

{$S-}
{$R-}

Interface

Const
  MAXLIGHTS = 8;      { up to 8 light sources                     }
  XLOC = 9;           { Index in matrix for object X location     }
  YLOC = 10;          { Index in matrix for object Y location     }
  ZLOC = 11;          { Index in matrix for object Z location     }
  PERSPECTIVE = 512;  { Perspective distance value for projection }
  FIXONE = 65536;     { Use 16.16 fixed point                     }
  MAXTEXTURES = 128;        { Maximum number of textures available at one time }
  POLYLISTSIZE = 2048;
  MAXPAGES = 8;  { maximum of 8 video pages }

{$IFDEF SHAREWARE}
  MAXPOLYGONS = 500;
{$ELSE}
  MAXPOLYGONS = 6500;
{$ENDIF}

Const
  AMBIENT      = $00;
  LAMBERT      = $01;
  GOURAUD      = $02;
  PHONG        = $03;
  UNSHADED     = $04;

  SMOOTH       = $00;
  TEXTURE      = $10;
  REFLECTION   = $20;
  PERSPTEXTURE = $30;

  TRANSPARENT  = $80;

  SHADE_MASK    = $0f;
  SURFACE_MASK  = $70;


Type
  Matrix4x3 = Array[0..11] of Longint;

  Vertex3d = Record  { 12 }
    x, y, z : Longint;
  End;
  ShortVertex3d = Record  { 6 }
    x, y, z : Integer;
  End;
  Vertex2d = Record  { 4 }
    x, y : Integer;
  End;
  Triangle = Record     { 8 }
    a, b, c : Integer;  { 6 }
    Color : Byte;       { 7 }
    Texture : Byte;     { 8 }
  End;
  UVCoord = Record
    u, v : Byte;
  End;
  tIntensityTable = Array[0..256*64-1] of Byte;
  pIntensityTable = ^tIntensityTable;
  tMap = Array[0..65534] of Byte;
  pMap = ^tMap;


  Vertex3dList       = Array[0..5460] of Vertex3d;
  Vertex2dList       = Array[0..5460] of Vertex2d;
  TriangleList       = Array[0..5460] of Triangle;
  ShortVertex3dList  = Array[0..5460] of ShortVertex3d;
  pShortVertex3dList = ^ShortVertex3dList;
  pVertex3dList      = ^Vertex3dList;
  pVertex2dList      = ^Vertex2dList;
  pTriangleList      = ^TriangleList;



  TextureCoord = Record
    UV1, UV2, UV3 : UVCoord;
  End;
  UVCoordList = Array[0..5460] of TextureCoord;
  pUVCoord = ^UVCoordList;


  pSortRec = ^SortRec;

  SortRec = Record
    ZMid  : Longint;
    Next  : pSortRec;
    Index : Word;
  End;

  tPolygonRec = Record
    V1      : Vertex2d;
    V2      : Vertex2d;
    V3      : Vertex2d;
    Color   : Byte;
    Tex     : Byte;
    IBuffer : Byte;
    PType   : Byte;
    Case Integer of  { Cases for the various polygon types }
      1 : (AB1, AB2, AB3 : UVCoord; Intensity : Byte);
      2 : (AB4, AB5, AB6 : UVCoord; I1, I2, I3 : Byte);
      3 : (AB7, AB8, AB9 : UVCoord);
      4 : (UV1, UV2, UV3 : UVCoord);
      5 : (AC1, AC2, AC3 : UVCoord; I_tensity : Byte);
      6 : (AC4, AC5, AC6 : UVCoord; I4, I5, I6 : Byte);
      7 : (AC7, AC8, AC9 : UVCoord; PT1, PT2, PT3 : UVCoord);
  End;

  tPolygonList = Array[0..POLYLISTSIZE-1] of tPolygonRec;
  tSortList    = Array[0..MAXPOLYGONS - 1] of SortRec;
  tByteArray   = Array[0..255] of pSortRec;
  PPolygonList = ^tPolygonList;
  pSortList    = ^tSortList;
  pByteArray   = ^tByteArray;

  tRenderList = Record
    Count       : Word;
    Allocated   : Word;
    SortList    : pSortList;
    MSBList     : tByteArray;
    LSBList     : tByteArray;
    PolygonList : Array[0..3] of PPolygonList;
  End;

  Register = Record
    Case Byte of
      0  : (w1, w2  : Word);
      1  : (b1, b2, b3, b4 : Byte);
  End;

  tByteList = Array[0..5460] of Register;
  pByteList = ^tByteList;

  tLightList = Record
    NumLights : Word;
    Light16   : Array[0..MAXLIGHTS-1] of Vertex3d;
    Light     : Array[0..MAXLIGHTS-1] of Vertex3d;
    TempLight : Array[0..MAXLIGHTS-1] of Vertex3d;
  End;

  CullRec = Record
    Visible : Byte;
    Color   : Byte;
  End;
  tCullList = Array[0..4680] of CullRec;
  pCullList = ^tCullList;

  VectorObject = Record
  { Fields *MUST* be in this order              }
  { the positions are hardcoded in the assembly }
    Num_Verticies     : Word;               { 0 }
    Num_Polygons      : Word;               { 2 }
    RotateList        : pByteList;          { 4 }
    Object_Definition : pShortVertex3dList; { 8 }
    World_Coords      : pVertex3dList;      { 12 }
    Screen_Coords     : pVertex2dList;      { 16 }
    Vertex_Normals    : pShortVertex3dList; { 20 }
    Polygon_Normals   : pShortVertex3dList; { 24 }
    Polygons          : pTriangleList;      { 28 }
    CullList          : pCullList;          { 32 }
    Texture_Coords    : pUVCoord;           { 36 }
    RenderMask        : Integer;
    IBuffer           : Byte;
    Radius            : Longint;
    xAngle            : Word;
    yAngle            : Word;
    zAngle            : Word;
    Orientation       : Matrix4x3;
    Cull              : Boolean;
    CorrectCount      : Integer;
    zClip             : Boolean;
  End;

  ViewObject = Record
  { Fields *MUST* be in this order              }
  { the positions are hardcoded in the assembly }
    TempHolder : Pointer;
    CenterX, CenterY : Integer;
    WinMinX, WinMinY : Integer;
    WinMaxX, WinMaxY : Integer;
    Camera : Matrix4x3;
    FustrumMinZ : Longint;
    FustrumMaxZ : Longint;
  End;


  RGBType = Record
    r, g, b : Byte;
  End;
  Palette = Array[0..255] of RGBType;
  TextureRec = Record
    Size : Word;
    Pal : ^Palette;
    Texture : Pointer;
  End;

  TFileBuffer = Array[0..1023] of Byte;
  PFileBuffer = ^TFileBuffer;

  PolygonFunction = Procedure (Poly : tPolygonRec; Tex1, Tex2 : Pointer);

Var
  RenderList     : tRenderList;
  IntensityTable : pIntensityTable;          { Intensity lookup table  }
  TriFillers     : Array[0..255] of PolygonFunction;
  ClipTriFillers : Array[0..255] of PolygonFunction;
  Lights         : tLightList;

Implementation



End.
