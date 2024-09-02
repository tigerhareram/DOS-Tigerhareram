Comment *
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
                     Inertia Realtime 3D Rendering Engine
            Copyright (c) 1997, Alex Chalfin. All Rights Reserved.
                       Inertia/16 Source Code Release.
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*

JUMPS

.Model Large,Pascal
.386
.Data

Temp dd ?   ;; Temporary swap place holder


.Code


  ;; Offsets into the pointer for Short integer 3d coordinates
SHORTX EQU 0
SHORTY EQU 2
SHORTZ EQU 4

  ;; Offests into the pointer for Long Integer 3d coordinates
LONGX EQU 0
LONGY EQU 4
LONGZ EQU 8



Public DotProduct8

DotProduct8 Proc Uses es fs di si,LongVec:DWord,ShortVec:DWord

  Lfs  si,LongVec
  Les  di,ShortVec

  Mov   eax,DWord Ptr fs:[si+LONGX]
  Movsx edx,Word Ptr  es:[di+SHORTX]
  IMul  edx                           ;; do a 24.8 fixedpoint mul
  Shrd  eax,edx,8
  Mov   ecx,eax

  Mov   eax,DWord Ptr fs:[si+LONGY]
  Movsx edx,Word Ptr  es:[di+SHORTY]
  IMul  edx                           ;; do a 24.8 fixedpoint mul
  Shrd  eax,edx,8
  Add   ecx,eax

  Mov   eax,DWord Ptr fs:[si+LONGZ]
  Movsx edx,Word Ptr  es:[di+SHORTZ]
  IMul  edx                           ;; do a 24.8 fixedpoint mul
  Shrd  eax,edx,8
  Add   eax,ecx      ;; return result is in ax

  Ret
EndP DotProduct8



Public CullPolys

CullPolys Proc Uses es di,Object:DWord,CullVector:DWord
;; Culls the backfacing polygons
;; this routine is chock full of pipeline stalls :(
  Local  Vx:DWord, Vy:DWord, Vz :DWord

  Les  di,CullVector
  Mov  eax,es:[di+LONGX]
  Mov  Vx,eax
  Mov  eax,es:[di+LONGY]
  Mov  Vy,eax
  Mov  eax,es:[di+LONGZ]
  Mov  Vz,eax

  Les  di,Object
  Mov  cx,es:[di+2]   ;; Move Num_Polygons into CX
  Jcxz @NoCulling

  Mov  edx,es:[di+4]  ;; RotateList
  Mov  ebx,es:[di+24] ;; Polygon_Normals
  Mov  eax,es:[di+28] ;; Polygons
  Mov  esi,es:[di+32] ;; CullList

  Push ds

  Mov  Temp,edx
  Les  dx,Temp   ;; es:dx points to rotatelist
  Mov  Temp,ebx
  Lfs  bx,Temp   ;; fs:bx points to Polygon_Normals
  Mov  Temp,eax
  Lgs  di,Temp   ;; gs:di points to Polygons
  Mov  Temp,esi
  Lds  si,Temp   ;; ds:si points to CullList

 @CullLooper:
  Push  cx
  Push  dx

  Movsx  eax,Word Ptr fs:[bx+SHORTX]  ;; get X part of polygon normal
  Mov    edx,Vx
  IMul   edx
  Shrd   eax,edx,8
  Mov    ecx,eax
  Movsx  eax,Word Ptr fs:[bx+SHORTY]  ;; get Y part of polygon normal
  Mov    edx,Vy
  IMul   edx
  Shrd   eax,edx,8
  Add    ecx,eax
  Movsx  eax,Word Ptr fs:[bx+SHORTZ]  ;; get Z part of polygon normal
  Mov    edx,Vz
  IMul   edx
  Shrd   eax,edx,8
  Add    ecx,eax
  Cmp    ecx,0        ;; check if Dot <  0
  Jl     @SkipMark    ;; if so, don't mark the various flags

  Pop    dx   ;; restore dx
  Push   dx   ;; and re-save it

  Mov    al,1
  Mov    ds:[si],al   ;; Mark in CullList
  Push   bx
  Mov    bx,dx        ;; put RotateList base address in addressable register
  Push   si

  Mov    si,gs:[di]         ;; get the first vertex in polygon
  Shl    si,2               ;; adjust for dword addressing
  Mov    es:[si+bx],al      ;; mark the vertex

  Mov    si,gs:[di+2]       ;; get the second vertex in polygon
  Shl    si,2               ;; adjust for dword addressing
  Mov    es:[si+bx],al      ;; mark the vertex

  Mov    si,gs:[di+4]       ;; get the third vertex in polygon
  Shl    si,2               ;; Adjust for dword addressing
  Mov    es:[si+bx],al      ;; mark the vertex

  Pop    si
  Pop    bx
 @SkipMark:
  Pop   dx
  Pop   cx
  Add   di,8     ;; Increment Polygons Offset
  Add   si,2     ;; Increment CullList offset
  Add   bx,6     ;; Inctement Polygon_Normals offset
  Dec   cx
  Jnz  @CullLooper

  Pop  ds
 @NoCulling:
  Ret
EndP  CullPolys

End
