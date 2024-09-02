Comment *
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
                     Inertia Realtime 3D Rendering Engine
     Copyright (c) 1996, Alex Chalfin, Jeroen Bouwens. All Rights Reserved.
                     Inertia/16 Source Code Release.
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*


.Model Large,Pascal

Jumps   ; Have TASM resolve any out of range jumps
.386    ; Enable 386 code
.Data

Include ..\..\SOURCES\Litex\STORE\06-3DFX\SOURCE\Sine.dd

 Cos_X dd ?
 Cos_Y dd ?
 Cos_Z dd ?
 Sin_X dd ?
 Sin_Y dd ?
 Sin_Z dd ?


.Code


Public SingleRotate

SingleRotate Proc Uses es di,Vector:DWord,XA:Word,YA:Word,ZA:Word

  Mov  bx,XA
  Shl  bx,2
  Mov  eax,[Sine+bx]
  Mov  Sin_X,eax
  Mov  eax,[CoSine+bx]
  Mov  Cos_X,eax

  Mov  bx,YA
  Shl  bx,2
  Mov  eax,[Sine+bx]
  Mov  Sin_Y,eax
  Mov  eax,[CoSine+bx]
  Mov  Cos_Y,eax

  Mov  bx,ZA
  Shl  bx,2
  Mov  eax,[Sine+bx]
  Mov  Sin_Z,eax
  Mov  eax,[CoSine+bx]
  Mov  Cos_Z,eax

  Les  di,Vector

;;   x = (x * cz) - (y * sz)
;;   y = (x * sz) + (y * cz)
;;   z = z


;; ZRotation
   Mov  eax,es:[di]
   Mov  edx,Cos_Z
   IMul edx
   Shrd eax,edx,16
   Mov  ebx,eax
   Mov  eax,es:[di+4]
   Mov  edx,Sin_Z
   IMul edx
   Shrd eax,edx,16
   Sub  ebx,eax
   Mov  esi,ebx  ; Save new X value

   Mov  eax,es:[di]
   Mov  edx,Sin_Z
   IMul edx
   Shrd eax,edx,16
   Mov  ebx,eax
   Mov  eax,es:[di+4]
   Mov  edx,Cos_Z
   IMul edx
   Shrd eax,edx,16
   Add  ebx,eax

   Mov  es:[di+4],ebx  ; Store new Y value
   Mov  es:[di],esi    ; Store new X value


;;   x = (x * cy) + (z * sy)
;;   y = y
;;   z = (z * cy) - (x * sy)

;; YRotation
   Mov  eax,es:[di]
   Mov  edx,Cos_Y
   IMul edx
   Shrd eax,edx,16
   Mov  ebx,eax
   Mov  eax,es:[di+8]
   Mov  edx,Sin_Y
   IMul edx
   Shrd eax,edx,16
   Add  ebx,eax
   Mov  esi,ebx  ;; Save new X value

   Mov  eax,es:[di+8]
   Mov  edx,Cos_Y
   IMul edx
   Shrd eax,edx,16
   Mov  ebx,eax
   Mov  eax,es:[di]
   Mov  edx,Sin_Y
   IMul edx
   Shrd eax,edx,16
   Sub  ebx,eax

   Mov  es:[di+8],ebx  ; Store new Z value
   Mov  es:[di],esi  ; Store new X value

;;   x = x
;;   y = (y * cx) - (z * sx)
;;   z = (y * sx) + (z * cx)
;; XRotation
   Mov  eax,es:[di+4]
   Mov  edx,Cos_X
   IMul edx
   Shrd eax,edx,16
   Mov  ebx,eax

   Mov  eax,es:[di+8]
   Mov  edx,Sin_X
   IMul edx
   Shrd eax,edx,16
   Sub  ebx,eax
   Mov  esi,ebx   ;; save new Y value in esi

   Mov  eax,es:[di+4]
   Mov  edx,Sin_X
   IMul edx
   Shrd eax,edx,16
   Mov  ebx,eax
   Mov  eax,es:[di+8]
   Mov  edx,Cos_X
   IMul edx
   Shrd eax,edx,16
   Add  ebx,eax   ;; ebx is new Z value

   Mov  es:[di+8],ebx  ; Store new Z value
   Mov  es:[di+4],esi  ; Store new Y value

   Ret
Endp SingleRotate


Public SetRotationMatrix

SetRotationMatrix Proc Uses eax,Matrix:DWord,Xan:Word,Yan:Word,Zan:Word

;  Matrix[0] := ((cz * cy) + ((sx * sz) Sar 12) * sy) Sar 12;
;  Matrix[1] := ((cy * -sz) + ((cz * sx) Sar 12) * sy) Sar 12;
;  Matrix[2] := (cx * sy) Sar 12;
;  Matrix[3] := (sz * cx) Sar 12;
;  Matrix[4] := (cz * cx) Sar 12;
;  Matrix[5] := (-sx);
;  Matrix[6] := ((-sy * cz) + ((sz * sx) Sar 12) * cy) Sar 12;
;  Matrix[7] := ((-sz * -sy) + ((cz * sx) Sar 12) * cy) Sar 12;
;  Matrix[8] := (cx * cy) Sar 12;

  Mov   bx,Xan  ; Set up XAngle variables
  Shl   bx,2
  Mov   eax,DWord Ptr [CoSine + bx]
  Mov   Cos_X,eax
  Mov   eax,DWord Ptr [Sine + bx]
  Mov   Sin_X,eax

  Mov   bx,Yan  ; Set up YAngle variables
  Shl   bx,2
  Mov   eax,DWord Ptr [CoSine + bx]
  Mov   Cos_Y,eax
  Mov   eax,DWord Ptr [Sine + bx]
  Mov   Sin_Y,eax

  Mov   bx,Zan ; Set up ZAngle variables
  Shl   bx,2
  Mov   eax,DWord Ptr [CoSine + bx]
  Mov   Cos_Z,eax
  Mov   eax,DWord Ptr [Sine + bx]
  Mov   Sin_Z,eax

  Les   di,Matrix

; Calculate first index, Matrix[0]
  Mov  eax,Cos_Z
  Mov  edx,Cos_Y
  IMul edx
  Shrd eax,edx,16
  Mov  ecx,eax
  Mov  eax,Sin_X
  Mov  edx,Sin_Z
  IMul edx
  Shrd eax,edx,16
  Mov  edx,Sin_Y
  IMul edx
  Shrd eax,edx,16
  Add  eax,ecx
  Mov  es:[di+0],eax

; Second index, Matrix[1]
  Mov  eax,Cos_Y
  Mov  edx,Sin_Z
  Neg  edx
  IMul edx
  Shrd eax,edx,16
  Mov  ecx,eax

  Mov  eax,Cos_Z
  Mov  edx,Sin_X
  IMul edx
  Shrd eax,edx,16
  Mov  edx,Sin_Y
  IMul edx
  Shrd eax,edx,16
  Add  eax,ecx

  Mov  es:[di+4],eax

; Third index, Matrix[2]
  Mov  eax,Cos_X
  Mov  edx,Sin_Y
  IMul edx
  Shrd eax,edx,16
  Mov  es:[di+8],eax

; fourth index, Matrix[3]
  Mov  eax,Sin_Z
  Mov  edx,Cos_X
  IMul edx
  Shrd eax,edx,16
  Mov  es:[di+12],eax

; Matrix[4]
  Mov  eax,Cos_Z
  Mov  edx,Cos_X
  IMul edx
  Shrd eax,edx,16
  Mov  es:[di+16],eax

; Matrix[5]
  Mov  eax,Sin_X
  Neg  eax
  Mov  es:[di+20],eax

; Matrix[6]
  Mov  eax,Sin_Z
  Mov  edx,Sin_X
  IMul edx
  Shrd eax,edx,16
  Mov  edx,Cos_Y
  IMul edx
  Shrd eax,edx,16
  Mov  ecx,eax

  Mov  eax,Sin_Y
  Mov  edx,Cos_Z
  IMul edx
  Shrd eax,edx,16
  Sub  ecx,eax

  Mov  es:[di+24],ecx

; Matrix[7]
  Mov  eax,Sin_Z
  Mov  edx,Sin_Y
  IMul edx
  Shrd eax,edx,16
  Mov  ecx,eax

  Mov  eax,Cos_Z
  Mov  edx,Sin_X
  IMul edx
  Shrd eax,edx,16
  Mov  edx,Cos_Y
  IMul edx
  Shrd eax,edx,16
  Add  eax,ecx

  Mov  es:[di+28],eax

; Matrix[8]
  Mov  eax,Cos_X
  Mov  edx,Cos_Y
  IMul edx
  Shrd eax,edx,16
  Mov  es:[di+32],eax
  Ret
EndP SetRotationMatrix

Public MatrixMul

MatrixMul Proc Uses ds es si di,Result:DWord,AMatrix:DWord,BMatrix:DWord
  Push ds
  Les  di,AMatrix
  Lfs  bx,Result
  Lds  si,BMatrix

  ;; Result[0]
  Mov  eax,es:[di]
  Mov  edx,ds:[si]
  IMul edx
  Shrd eax,edx,16
  Mov  ecx,eax
  Mov  eax,es:[di+4]
  Mov  edx,ds:[si+12]
  IMul edx
  Shrd eax,edx,16
  Add  ecx,eax
  Mov  eax,es:[di+8]
  Mov  edx,ds:[si+24]
  IMul edx
  Shrd eax,edx,16
  Add  ecx,eax

  Mov  fs:[bx],ecx


;; Result[1]
  Mov  eax,es:[di]
  Mov  edx,ds:[si+4]
  IMul edx
  Shrd eax,edx,16
  Mov  ecx,eax
  Mov  eax,es:[di+4]
  Mov  edx,ds:[si+16]
  IMul edx
  Shrd eax,edx,16
  Add  ecx,eax
  Mov  eax,es:[di+8]
  Mov  edx,ds:[si+28]
  IMul edx
  Shrd eax,edx,16
  Add  ecx,eax

  Mov  fs:[bx+4],ecx

;; Result[2]
  Mov  eax,es:[di]
  Mov  edx,ds:[si+8]
  IMul edx
  Shrd eax,edx,16
  Mov  ecx,eax
  Mov  eax,es:[di+4]
  Mov  edx,ds:[si+20]
  IMul edx
  Shrd eax,edx,16
  Add  ecx,eax
  Mov  eax,es:[di+8]
  Mov  edx,ds:[si+32]
  IMul edx
  Shrd eax,edx,16
  Add  ecx,eax

  Mov  fs:[bx+8],ecx

;; Result[3]
  Mov  eax,es:[di+12]
  Mov  edx,ds:[si+0]
  IMul edx
  Shrd eax,edx,16
  Mov  ecx,eax
  Mov  eax,es:[di+16]
  Mov  edx,ds:[si+12]
  IMul edx
  Shrd eax,edx,16
  Add  ecx,eax
  Mov  eax,es:[di+20]
  Mov  edx,ds:[si+24]
  IMul edx
  Shrd eax,edx,16
  Add  ecx,eax

  Mov  fs:[bx+12],ecx

;; Result[4]
  Mov  eax,es:[di+12]
  Mov  edx,ds:[si+4]
  IMul edx
  Shrd eax,edx,16
  Mov  ecx,eax
  Mov  eax,es:[di+16]
  Mov  edx,ds:[si+16]
  IMul edx
  Shrd eax,edx,16
  Add  ecx,eax
  Mov  eax,es:[di+20]
  Mov  edx,ds:[si+28]
  IMul edx
  Shrd eax,edx,16
  Add  ecx,eax

  Mov  fs:[bx+16],ecx

;; Result[5]
  Mov  eax,es:[di+12]
  Mov  edx,ds:[si+8]
  IMul edx
  Shrd eax,edx,16
  Mov  ecx,eax
  Mov  eax,es:[di+16]
  Mov  edx,ds:[si+20]
  IMul edx
  Shrd eax,edx,16
  Add  ecx,eax
  Mov  eax,es:[di+20]
  Mov  edx,ds:[si+32]
  IMul edx
  Shrd eax,edx,16
  Add  ecx,eax

  Mov  fs:[bx+20],ecx

;; Result[6]
  Mov  eax,es:[di+24]
  Mov  edx,ds:[si+0]
  IMul edx
  Shrd eax,edx,16
  Mov  ecx,eax
  Mov  eax,es:[di+28]
  Mov  edx,ds:[si+12]
  IMul edx
  Shrd eax,edx,16
  Add  ecx,eax
  Mov  eax,es:[di+32]
  Mov  edx,ds:[si+24]
  IMul edx
  Shrd eax,edx,16
  Add  ecx,eax

  Mov  fs:[bx+24],ecx

;; Result[7]
  Mov  eax,es:[di+24]
  Mov  edx,ds:[si+4]
  IMul edx
  Shrd eax,edx,16
  Mov  ecx,eax
  Mov  eax,es:[di+28]
  Mov  edx,ds:[si+16]
  IMul edx
  Shrd eax,edx,16
  Add  ecx,eax
  Mov  eax,es:[di+32]
  Mov  edx,ds:[si+28]
  IMul edx
  Shrd eax,edx,16
  Add  ecx,eax

  Mov  fs:[bx+28],ecx

;; Result[8]
  Mov  eax,es:[di+24]
  Mov  edx,ds:[si+8]
  IMul edx
  Shrd eax,edx,16
  Mov  ecx,eax
  Mov  eax,es:[di+28]
  Mov  edx,ds:[si+20]
  IMul edx
  Shrd eax,edx,16
  Add  ecx,eax
  Mov  eax,es:[di+32]
  Mov  edx,ds:[si+32]
  IMul edx
  Shrd eax,edx,16
  Add  ecx,eax

  Mov  fs:[bx+32],ecx

  Pop  ds
  Ret
EndP MatrixMul

End
