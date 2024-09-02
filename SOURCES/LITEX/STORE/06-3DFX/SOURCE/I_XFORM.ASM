Comment *
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
                     Inertia Realtime 3D Rendering Engine
     Copyright (c) 1996, Alex Chalfin, Jeroen Bouwens. All Rights Reserved.
           DISTRIBUTION OF THIS SOURCE CODE IS STRICTLY PROHIBITED
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*

.Model Large,Pascal

Jumps   ; Have TASM resolve any out of range jumps
.386    ; Enable 386 code
.Data

Vx dd ?
Vy dd ?
Vz dd ?
Matrix dd ?,?,?,?,?,?,?,?,?,?,?,?

DivFactor dd 33554432      ;; PERSPECTIVE * FIXONE = 256 * 65536
AspectRatio EQU 54613      ;; aspect ratio correction 0.8333 * 65536

.Code


Public InvXForm

InvXForm Proc Uses es di,Vector:DWord,XMatrix:DWord

  Les  di,Vector
  Mov  eax,es:[di]
  Mov  Vx,eax
  Mov  eax,es:[di+4]
  Mov  Vy,eax
  Mov  eax,es:[di+8]
  Mov  Vz,eax
  Lfs  si,XMatrix

  Mov  eax,fs:[si]
  Mov  edx,Vx
  IMul edx
  Shrd eax,edx,16
  Mov  ecx,eax
  Mov  eax,fs:[si+4]
  Mov  edx,Vy
  IMul edx
  Shrd eax,edx,16
  Add  ecx,eax
  Mov  eax,fs:[si+8]
  Mov  edx,Vz
  IMul edx
  Shrd eax,edx,16
  Add  eax,ecx
  Mov  es:[di],eax

  Mov  eax,fs:[si+12]
  Mov  edx,Vx
  IMul edx
  Shrd eax,edx,16
  Mov  ecx,eax
  Mov  eax,fs:[si+16]
  Mov  edx,Vy
  IMul edx
  Shrd eax,edx,16
  Add  ecx,eax
  Mov  eax,fs:[si+20]
  Mov  edx,Vz
  IMul edx
  Shrd eax,edx,16
  Add  eax,ecx
  Mov  es:[di+4],eax

  Mov  eax,fs:[si+24]
  Mov  edx,Vx
  IMul edx
  Shrd eax,edx,16
  Mov  ecx,eax
  Mov  eax,fs:[si+28]
  Mov  edx,Vy
  IMul edx
  Shrd eax,edx,16
  Add  ecx,eax
  Mov  eax,fs:[si+32]
  Mov  edx,Vz
  IMul edx
  Shrd eax,edx,16
  Add  eax,ecx
  Mov  es:[di+8],eax

  Ret
EndP InvXForm

CalcX Macro
  Movsx  eax,Word Ptr es:[di+0]
  Mov    edx,[Matrix+0]
  Imul   edx
  Shrd   eax,edx,16
  Mov    ecx,eax
  Movsx  eax,Word Ptr es:[di+2]
  Mov    edx,[Matrix+12]
  IMul   edx
  Shrd   eax,edx,16
  Add    ecx,eax
  Movsx  eax,Word Ptr es:[di+4]
  Mov    edx,[Matrix+24]
  IMul   edx
  Shrd   eax,edx,16
  Add    eax,ecx
  Add    eax,[Matrix+36]
  Mov    fs:[si+0],eax
EndM

CalcY Macro
  Movsx  eax,Word Ptr es:[di+0]
  Mov    edx,[Matrix+4]
  Imul   edx
  Shrd   eax,edx,16
  Mov    ecx,eax
  Movsx  eax,Word Ptr es:[di+2]
  Mov    edx,[Matrix+16]
  IMul   edx
  Shrd   eax,edx,16
  Add    ecx,eax
  Movsx  eax,Word Ptr es:[di+4]
  Mov    edx,[Matrix+28]
  IMul   edx
  Shrd   eax,edx,16
  Add    eax,ecx
  Add    eax,[Matrix+40]
  Mov    fs:[si+4],eax
EndM

CalcZ Macro
  Movsx  eax,Word Ptr es:[di+0]
  Mov    edx,[Matrix+8]
  Imul   edx
  Shrd   eax,edx,16
  Mov    ecx,eax
  Movsx  eax,Word Ptr es:[di+2]
  Mov    edx,[Matrix+20]
  IMul   edx
  Shrd   eax,edx,16
  Add    ecx,eax
  Movsx  eax,Word Ptr es:[di+4]
  Mov    edx,[Matrix+32]
  IMul   edx
  Shrd   eax,edx,16
  Add    eax,ecx
  Add    eax,[Matrix+44]
  Mov    fs:[si+8],eax
EndM


Public  XForm

XForm Proc Uses es ds si di,VecObj:DWord, XMatrix:DWord

  Push ds

;; Make a copy of the matrix
  Les  di,XMatrix
  Mov  esi,es:[di]
  Mov  [Matrix+0],esi
  Mov  esi,es:[di+4]
  Mov  [Matrix+4],esi
  Mov  esi,es:[di+8]
  Mov  [Matrix+8],esi
  Mov  esi,es:[di+12]
  Mov  [Matrix+12],esi
  Mov  esi,es:[di+16]
  Mov  [Matrix+16],esi
  Mov  esi,es:[di+20]
  Mov  [Matrix+20],esi
  Mov  esi,es:[di+24]
  Mov  [Matrix+24],esi
  Mov  esi,es:[di+28]
  Mov  [Matrix+28],esi
  Mov  esi,es:[di+32]
  Mov  [Matrix+32],esi
  Mov  esi,es:[di+36]
  Mov  [Matrix+36],esi

  Mov  esi,es:[di+40]
  Mov  [Matrix+40],esi

  Mov  esi,es:[di+44]
  Mov  [Matrix+44],esi

  Les  di,VecObj

  Mov  cx,es:[di]  ;; Get the Numver of verticies
  Jcxz @Nothing    ;; Make sure there is somehthing to do

  Mov  ebx,es:[di+4]   ;; RotateList
  Mov  eax,es:[di+8]   ;; Object_Definition
  Mov  edx,es:[di+12]  ;; World_Coords

  Mov  Vx,ebx
  Lgs  bx,Vx    ;; gs:bx points to RotateList

  Mov  Vx,eax
  Les  di,Vx    ;; es:di points to Object_Definition

  Mov  Vx,edx
  Lfs  si,Vx    ;; fs:si points to World_Coords

 @XFormLooper:
  Mov   eax,gs:[bx]
  Cmp   al,1
  Jne  @SkipXForm
  Push  cx

  CalcX
  CalcY
  CalcZ

  Pop   cx
 @SkipXForm:
  Add   bx,4
  Add   di,6
  Add   si,12
  Dec   cx
  Jnz  @XFormLooper

 @Nothing:
  Pop  ds
  Ret
EndP XForm



Public  Project

Project Proc Uses es ds si di,ViewObj:DWord, VecObj:DWord

  Les    di,ViewObj              ;; Get the CenterX and CenterY values
  Movsx  eax,Word Ptr es:[di+4]
  Mov    Vx,eax
  Movsx  eax,Word Ptr es:[di+6]
  Mov    Vy,eax

  Les    di,VecObj
  Mov    cx,es:[di]  ;; Get Num_Verticies
  Jcxz  @NoProject

  Mov    ebx,es:[di+4]   ;; RotateList
  Mov    eax,es:[di+12]  ;; World_Coords
  Mov    edx,es:[di+16]  ;; Screen_Coords

  Mov    Vz,ebx
  Lgs    bx,Vz           ;; gs:bx points to RotateList
  Mov    Vz,eax
  Les    di,Vz           ;; es:di points to World_Coords
  Mov    Vz,edx
  Lfs    si,Vz           ;; fs:si points to Screen_Coords

 @ProjectLooper:
  Mov  eax,gs:[bx]
  Cmp  al,1
  Jnz @SkipProj
  Push cx

  Xor   edx,edx
  Mov   eax,DivFactor
  Mov   ecx,es:[di+8]  ;; Get Z portion of coordinate
  Cmp   ecx,0
  Jz  @@SkipDiv
  IDiv  ecx
 @@SkipDiv:
  Mov   ecx,eax

  Mov   eax,es:[di+0]  ;; X portion
  IMul  ecx
  Shrd  eax,edx,12
  Mov   edx,VX
  Shl   edx,4
  Add   eax,edx
  Mov   fs:[si],ax

  Mov   eax,AspectRatio
  IMul  ecx
  Shrd  eax,edx,16
  Mov   ecx,eax

  Mov   eax,es:[di+4]
  IMul  ecx
  Shrd  eax,edx,12
  Mov   ecx,Vy
  Shl   ecx,4
  Sub   cx,ax
  Mov   fs:[si+2],cx

  Pop  cx
 @SkipProj:
  Add  bx,4
  Add  di,12
  Add  si,4
  Dec  cx
  Jnz @ProjectLooper

 @NoProject:
  Ret
EndP Project

Public SingleProject

SingleProject Proc Uses es ds si di,X3D:DWord,Y3D:DWord,Z3D:DWord,CX1:DWord,CY:DWord,SX:DWOrd,SY:DWord

  Xor   edx,edx
  Mov   eax,DivFactor
  Mov   ecx,Z3D  ;; Get Z portion of coordinate
  Cmp   ecx,0
  Jz  @@SkipDiv1
  IDiv  ecx
 @@SkipDiv1:
  Mov   ecx,eax

  Mov   eax,X3D  ;; X portion
  IMul  ecx
  Shrd  eax,edx,12
  Mov   edx,CX1
  Shl   edx,4
  Add   eax,edx
  Les   di,SX
  Mov   es:[di],ax

  Mov   eax,AspectRatio
  IMul  ecx
  Shrd  eax,edx,16
  Mov   ecx,eax

  Mov   eax,Y3D
  IMul  ecx
  Shrd  eax,edx,12
  Mov   ecx,CY
  Shl   ecx,4
  Sub   cx,ax
  Les   di,SY
  Mov   es:[di],cx


  Ret
EndP SingleProject


End
