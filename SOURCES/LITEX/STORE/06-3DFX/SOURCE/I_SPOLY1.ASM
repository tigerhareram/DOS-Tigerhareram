Comment *
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
                     Inertia Realtime 3D Rendering Engine
            Copyright (c) 1997, Alex Chalfin. All Rights Reserved.
                       Inertia/16 Source Code Release.
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*

Include ..\SOURCES\Litex\STORE\06-3DFX\SOURCE\PDEFINES.INC  ;; polygon defines

.386
LOCALS
JUMPS

_Data Segment Para Public Use16
     Assume DS:_Data

     Extrn GlobalScreen : DWord
     Extrn IT           : DWord
     Extrn TT           : DWord
     Extrn XL           : DWord
     Extrn XR           : DWord
     Extrn ID           : DWord
     Extrn PD           : DWord
     Extrn UD           : DWord
     Extrn VD           : DWord


;     XL    dd 200 dup (0)
;     XR    dd 200 dup (0)
;     ID    dd 200 dup (0)  ; Intensity data. Use dwords for indexing purposes
;     PD    dd 200 dup (0)
;     UD    dd 200 dup (0)
;     VD    dd 200 dup (0)

     X1         dw 0
     Y1         dw 0
     I1         dw 0
     P1         dw 0
     U1         dw 0
     V1         dw 0
     X2         dw 0
     Y2         dw 0
     I2         dw 0
     P2         dw 0
     U2         dw 0
     V2         dw 0
     X3         dw 0
     Y3         dw 0
     I3         dw 0
     P3         dw 0
     U3         dw 0
     V3         dw 0
     Colour     db 0
     DeltaI     dd 0
     DeltaP     dd 0
     DeltaU     dd 0
     DeltaV     dd 0
     TopHeight    dw 0
     BottomHeight dw 0
     TotalHeight  dw 0
     LongX        dd 0
     LongDX       dd 0
     ShortX       dd 0
     ShortDX      dd 0
     lSide        db 0   ; Left Side is long side flag
     ExitFlag     db 0
     SaveSS       dw 0
     SaveDS       dw 0
     SaveGS       dw 0
     TTSeg        dw 0
     Temp1        dd 0
     Temp2        dd 0
     Temp3        dd 0
     Temp4        dd 0
     TexSeg       dw 0

P_V1 EQU 0
P_V2 EQU 4
P_V3 EQU 8
P_COLOR EQU 12

P_UV1 EQU 16
P_UV2 EQU 18
P_UV3 EQU 20
P_I1 EQU 22
P_I2 EQU 23
P_I3 EQU 24
P_PT1 EQU 22
P_PT2 EQU 24
P_PT3 EQU 26

_Data EndS

Code Segment Para Public Use16
     Assume CS:Code,DS:_Data

     Public FlatPoly
     Public GouraudPoly
     Public PhongPoly
     Public TexturePoly
     Public FlatTexturePoly
     Public GouraudTexturePoly
     Public PhongTexturePoly
     Public TransparentFlatPoly
     Public TransparentGouraudPoly
     Public TransparentPhongPoly
     Public TransparentTexturePoly
     Public TransparentFlatTexturePoly
     Public TransparentGouraudTexturePoly
     Public TransparentPhongTexturePoly

SWAP Macro N1, N2
     Mov   di,N1
     XChg  di,N2
     Mov   N1,di
EndM

SUBDELTA Macro A1,A2,B1,B2,vSTART,vDELTA

;; calc delta
   Push  cx
   Mov   ax,A2
   Mov   cx,B2
   Sub   ax,A1
   Sub   cx,B1
   Movsx eax,ax
   Movsx ecx,cx
   Mov   edx,eax
   Shl   eax,8
   Sar   edx,15   ;; edx:eax = (A2-A1) Shl 8

   IDiv  ecx
   Mov   ecx,eax    ;; esi = delta value
   Mov   vDELTA,eax

   Mov   ax,B1
   Mov   bx,ax
   Add   ax,15
   Movsx ebx,bx
   Sar   ax,4
   Movsx eax,ax
   Shl   ebx,4
   Shl   eax,8

   Sub   eax,ebx   ;; eax = (ceil(y1) Shl 8) - (y1 Shl 4);
   IMul  ecx       ;; ecx = delta value
   Shrd  eax,edx,8 ;; sub correcting factor

   Mov   bx,A1
   Movsx ebx,bx
   Shl   ebx,4
   Add   ebx,eax
   Mov   vSTART,ebx
   Pop   cx
EndM

CEIL Macro v
  Add v,15
  Sar v,4
EndM

PlanarDelta Macro A1, A2, A3, B1, B2, B3, C1, C2, C3, Answer
Local @@B,@@C,@@D,@@E,@@F,@@G
     Mov  ExitFlag,0

;;     crMid := (yMid-yTop)*(cBot-cTop) Div (yBot-yTop) + cTop;

     Mov   ax,C2  ;; ymid
     Mov   cx,A3  ;; _bot
     Sub   ax,C1  ;; ytop
     Sub   cx,A1  ;; _mid
     Movsx eax,ax
     Movsx ecx,cx

     Mov   bx,C3  ;; ybot
     Sub   bx,C1  ;; ytop
     Jle  @@G
     Movsx ebx,bx
     Mov   Temp2,ebx  ;; Temp2 = ybot - ytop

     IMul ecx     ;; (yMid-yTop)*(cBot-cTop)
     IDiv ebx     ;; div (ybot - ytop);

     Add  ax,A1  ;; eax is the whatever answer in 28.4
     Movsx eax,ax
     Mov  Temp1,eax  ;; color value mid point on long side

     Mov   ax,C2  ;; ymid
     Mov   cx,B3  ;; xbot
     Sub   ax,C1  ;; ytop
     Sub   cx,B1  ;; xmid
     Movsx eax,ax
     Movsx ecx,cx
     Mov   ebx,Temp2

     IMul ecx    ;; (yMid-yTop)*(xBot-xTop)
     IDiv ebx    ;; div (ybot - ytop);

     Add  ax,B1  ;; X value mid point on long side

     Sub  ax,B2  ;; eax = xrMid - x2
     Mov  ebx,Temp1
     Sub  bx,A2  ;; ebx = crMid - c2
     XChg ax,bx

     Movsx eax,ax
     Mov   edx,eax
     Movsx ebx,bx
     Sar   edx,31

     Cmp   ebx,0
     Je  @@G

     Shl  eax,8
     IDiv ebx

     Mov    Answer,eax
     Jmp  @@B
    @@G:
      Mov ExitFlag,1
    @@B:
EndM

XEdges Proc Near

;; calculates the framework of the polygon
;; and stores it in the XR/XL tables
   Mov  lSide,0   ;; default to long side on the right

;;  TotalHeight := ceil(y3) - ceil(y1);
;;  TopHeight := ceil(y2) - ceil(y1);
;;  BottomHeight := TotalHeight - TopHeight;

   Mov  ax,Y1
   Mov  bx,Y2
   Mov  cx,Y3
   CEIL ax
   CEIL bx
   CEIL cx

   Mov  dx,cx
   Sub  dx,ax
   Mov  TotalHeight,dx
   Jle @@Nothing

   Mov  di,bx
   Sub  di,ax
   Mov  TopHeight,di
   Sub  dx,di
   Mov  BottomHeight,dx

   Mov  si,ax  ;; get ceil(y1) value
   Shl  si,2       ;; set si to index X tables

   SUBDELTA X1,X3,Y1,Y3,LongX,LongDX

   Mov   ax,TopHeight
   Cmp   ax,0
   Jle  @@SkipTop
     ;; make sure there is a top part to the polygon
     SUBDELTA X1,X2,Y1,Y2,ShortX,ShortDX

     Mov  cx,TopHeight
     Mov  eax,LongX
     Mov  ebx,ShortX
     Mov  edx,LongDX
     Mov  edi,ShortDX
     Cmp  edx,edi
     Jge  @@ShortLeft1 ;; if LongDX >= ShortDX Goto @@ShortLeft1
       ;; Long side is on the left
       Mov  lSide,1   ;; long side is on the left
      @@TopYLooper1:
       Mov  DWord Ptr [XL + si],eax  ;; store short side on the left
       Mov  DWord Ptr [XR + si],ebx  ;; store long side on the right
       Add  ebx,edi
       Add  eax,edx
       Add  si,4   ;; advance to next index
       Dec  cx
       Jnz @@TopYLooper1
       Mov  LongX,eax    ;; store Long side position
     Jmp  @@SkipTop
     @@ShortLeft1:
       ;; Long side is on the right
      @@TopYLooper2:
       Mov  DWord Ptr [XL + si],ebx  ;; store long side on the left
       Mov  DWord Ptr [XR + si],eax  ;; store short side on the right
       Add  ebx,edi
       Add  eax,edx
       Add  si,4   ;; advance to next index
       Dec  cx
       Jnz @@TopYLooper2
       Mov  LongX,eax    ;; store long side position

 @@SkipTop:

   Mov cx,BottomHeight
   Cmp cx,0
   Jle @@Nothing
     SUBDELTA X2,X3,Y2,Y3,ShortX,ShortDX
     Mov  eax,LongX
     Mov  ebx,ShortX
     Mov  edx,LongDX
     Mov  edi,ShortDX
     Cmp  edx,edi
     Jge   @@ShortLeft2      ;; if LongDX >= ShortDX
       ;; Long side is on the right
     @@BottomYLooper1:
       Mov  DWord Ptr [XL + si],ebx  ;; store short side on the left
       Mov  DWord Ptr [XR + si],eax  ;; store long side on the right
       Add  ebx,edi
       Add  eax,edx
       Add  si,4   ;; advance to next index
       Dec  cx
       Jnz @@BottomYLooper1
     Jmp  @@Nothing
     @@ShortLeft2:
       ;; Long side is on the left
       Mov  lSide,1    ;; long side is on the left
      @@BottomYLooper2:
       Mov  DWord Ptr [XL + si],eax  ;; store long side on the left
       Mov  DWord Ptr [XR + si],ebx  ;; store short side on the right
       Add  ebx,edi
       Add  eax,edx
       Add  si,4   ;; advance to next index
       Dec  cx
       Jnz @@BottomYLooper2

 @@Nothing:
   Ret
EndP

Intensity Proc Near
       Mov  si,Y1
       CEIL si
       Shl  si,2
       Mov  al,lSide
       Cmp  al,1
       Jne @@TwoStep
         SUBDELTA I1,I3,Y1,Y3,LongX,LongDX
         Mov  cx,TotalHeight
         Mov  eax,LongX
         Mov  ebx,LongDX
        @@LongLooper:
         Mov  [ID+si],eax
         Add  eax,ebx
         Add  si,4
         Dec  cx
         Jnz @@LongLooper
         Jmp @@Exit
      @@TwoStep:
         Mov  ax,TopHeight
         Cmp  ax,0
         Jle  @@SkipTop
         SUBDELTA I1,I2,Y1,Y2, LongX, LongDX
         Mov  cx,TopHeight
         Mov  eax,LongX
         Mov  ebx,LongDX
        @@TopLooper:
         Mov  [ID+si],eax
         Add  eax,ebx
         Add  si,4
         Dec  cx
         Jnz @@TopLooper
       @@SkipTop:
         Mov  ax,BottomHeight
         Cmp  ax,0
         Jle  @@Exit
         SUBDELTA I2,I3,Y2,Y3, LongX, LongDX
         Mov  cx,BottomHeight
         Mov  eax,LongX
         Mov  ebx,LongDX
        @@BottomLooper:
         Mov  [ID+si],eax
         Add  eax,ebx
         Add  si,4
         Dec  cx
         Jnz @@BottomLooper
      @@Exit:
       Ret
EndP

Texture Proc Near
       Mov  si,Y1
       CEIL si
       Shl  si,2
       Mov  al,lSide
       Cmp  al,1
       Jne @@TwoStep
         SUBDELTA U1,U3,Y1,Y3,LongX,LongDX
         SUBDELTA V1,V3,Y1,Y3,ShortX,ShortDX
         Mov  cx,TotalHeight
         Mov  eax,LongX
         Mov  ebx,LongDX
         Mov  edx,ShortX
         Mov  edi,ShortDX
        @@LongLooper:
         Mov  [UD+si],eax
         Mov  [VD+si],edx
         Add  eax,ebx
         Add  edx,edi
         Add  si,4
         Dec  cx
         Jnz @@LongLooper
         Jmp @@Exit
      @@TwoStep:
         Mov  ax,TopHeight
         Cmp  ax,0
         Jle  @@SkipTop
         SUBDELTA U1,U2,Y1,Y2, LongX, LongDX
         SUBDELTA V1,V2,Y1,Y2, ShortX, ShortDX
         Mov  cx,TopHeight
         Mov  eax,LongX
         Mov  ebx,LongDX
         Mov  edx,ShortX
         Mov  edi,ShortDX
        @@TopLooper:
         Mov  [UD+si],eax
         Mov  [VD+si],edx
         Add  eax,ebx
         Add  edx,edi
         Add  si,4
         Dec  cx
         Jnz @@TopLooper
       @@SkipTop:
         Mov  ax,BottomHeight
         Cmp  ax,0
         Jle  @@Exit
         SUBDELTA U2, U3, Y2, Y3, LongX, LongDX
         SUBDELTA V2, V3, Y2,Y3, ShortX, ShortDX
         Mov  cx,BottomHeight
         Mov  eax,LongX
         Mov  ebx,LongDX
         Mov  edx,ShortX
         Mov  edi,ShortDX
        @@BottomLooper:
         Mov  [UD+si],eax
         Mov  [VD+si],edx
         Add  eax,ebx
         Add  edx,edi
         Add  si,4
         Dec  cx
         Jnz @@BottomLooper
      @@Exit:
       Ret
EndP

Phong Proc Near
       Mov  si,Y1
       CEIL si
       Shl  si,2
       Mov  al,lSide
       Cmp  al,1
       Jne @@TwoStep
         SUBDELTA I1,I3,Y1,Y3,LongX,LongDX
         SUBDELTA P1,P3,Y1,Y3,ShortX,ShortDX
         Mov  cx,TotalHeight
         Mov  eax,LongX
         Mov  ebx,LongDX
         Mov  edx,ShortX
         Mov  edi,ShortDX
        @@LongLooper:
         Mov  [ID+si],eax
         Mov  [PD+si],edx
         Add  eax,ebx
         Add  edx,edi
         Add  si,4
         Dec  cx
         Jnz @@LongLooper
         Jmp @@Exit
      @@TwoStep:
         Mov  ax,TopHeight
         Cmp  ax,0
         Jle @@SkipTop
         SUBDELTA I1,I2,Y1,Y2, LongX, LongDX
         SUBDELTA P1,P2,Y1,Y2, ShortX, ShortDX
         Mov  cx,TopHeight
         Mov  eax,LongX
         Mov  ebx,LongDX
         Mov  edx,ShortX
         Mov  edi,ShortDX
        @@TopLooper:
         Mov  [ID+si],eax
         Mov  [PD+si],edx
         Add  eax,ebx
         Add  edx,edi
         Add  si,4
         Dec  cx
         Jnz @@TopLooper
       @@SkipTop:
         Mov  ax,BottomHeight
         Cmp  ax,0
         Jle @@Exit
         SUBDELTA I2, I3, Y2,Y3, LongX, LongDX
         SUBDELTA P2, P3, Y2,Y3, ShortX, ShortDX
         Mov  cx,BottomHeight
         Mov  eax,LongX
         Mov  ebx,LongDX
         Mov  edx,ShortX
         Mov  edi,ShortDX
        @@BottomLooper:
         Mov  [ID+si],eax
         Mov  [PD+si],edx
         Add  eax,ebx
         Add  edx,edi
         Add  si,4
         Dec  cx
         Jnz @@BottomLooper
      @@Exit:
       Ret
EndP


FlatPoly Proc Far

     Arg CoordPointer:DWord = RetBytes

IFDEF SMOOTHAMBIENT

     Push  bp
     Mov   bp,sp

     Les  di,CoordPointer
     Mov  eax,es:[di+P_V1]
     Mov  DWord Ptr [X1],eax
     Mov  eax,DWord Ptr es:[di+P_V2]
     Mov  DWord Ptr [X2],eax
     Mov  eax,DWord Ptr es:[di+P_V3]
     Mov  DWord Ptr [X3],eax
     Mov  al,Byte Ptr es:[di+P_COLOR]
     Mov  Colour,al

     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipFirstSwap
     XChg  ax,bx
     SWAP  X1,X2
   @@SkipFirstSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Mov  ax,Y2
     Mov  bx,Y3
     Cmp  ax,bx
     Jle @@SkipSecondSwap
     XChg  ax,bx
     SWAP  X2, X3
   @@SkipSecondSwap:
     Mov   Y2,ax
     Mov   Y3,bx

     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipThirdSwap
     XChg  ax,bx
     SWAP  X1, X2
   @@SkipThirdSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Call  XEdges

     Mov   ax,TotalHeight
     Cmp   ax,0
     Jle  @@Exit

     Mov   cx,TotalHeight
     Les   di,GlobalScreen

     Mov   si,Y1
     CEIL  si
     Mov   dx,si
     Mov   ax,320
     Mul   dx
     Add   di,ax
     Shl   si,2
     Xor   eax,eax
     Mov   al,Colour
     IMul  eax,01010101h
    @@DrawLoop:
     Push  cx
     Push  di
     Mov   ecx,DWord Ptr [XR+si]
     Mov   ebx,DWord Ptr [XL+si]
     Add   ebx,255
     Dec   ecx
     Sar   ebx,8
     Sar   ecx,8
     Add   di,bx
     Sub   cx,bx
     Inc   cx
     Jle  @Skip

     Mov   bx,cx
     Shr   cx,2
     Rep   Stosd
     Mov   cx,bx
     And   cx,3
     Rep   Stosb

    @Skip:
     Add   si,4
     Pop   di
     Add   di,320
     Pop   cx
     Dec   cx
     Jnz  @@DrawLoop

    @@Exit:
     Pop   bp
ENDIF
     Ret   RetBytes
EndP

TransparentFlatPoly Proc Far

     Arg CoordPointer:DWord = RetBytes

IFDEF TRANSPARENCY
IFDEF SMOOTHAMBIENT

     Push  bp
     Mov   bp,sp

     Les  di,CoordPointer
     Mov  eax,es:[di+P_V1]
     Mov  DWord Ptr [X1],eax
     Mov  eax,DWord Ptr es:[di+P_V2]
     Mov  DWord Ptr [X2],eax
     Mov  eax,DWord Ptr es:[di+P_V3]
     Mov  DWord Ptr [X3],eax

     Xor  ax,ax
     Mov  al,Byte Ptr es:[di+P_COLOR]
     Mov  Colour,al

     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipFirstSwap
     XChg  ax,bx
     SWAP  X1,X2
   @@SkipFirstSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Mov  ax,Y2
     Mov  bx,Y3
     Cmp  ax,bx
     Jle @@SkipSecondSwap
     XChg  ax,bx
     SWAP  X2, X3
   @@SkipSecondSwap:
     Mov   Y2,ax
     Mov   Y3,bx

     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipThirdSwap
     XChg  ax,bx
     SWAP  X1, X2
   @@SkipThirdSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Call  XEdges

     Mov   cx,TotalHeight
     Cmp   cx,0
     Jle @@Exit

     Les   di,GlobalScreen
     Lgs   bx,TT
     Mov   si,Y1
     CEIL  si
     Mov   ax,320
     Mul   si
     Add   di,ax  ;; set DI to point to proper Y scanline
     Shl   si,2
     Mov   dh,Colour

    @@DrawLoop:
     Push  cx
     Push  di
     Push  si
     Mov   ecx,[XR+si]
     Mov   eax,[XL+si]
     Add   eax,255
     Dec   ecx
     Sar   ecx,8
     Sar   eax,8
     Add   di,ax
     Sub   ecx,eax  ;; ecx is horizontal line count
     Inc   ecx
     Cmp   cx,0
     Jle @@Nothing
     Mov   bh,Colour  ;; get intensity
    @@XLoop:
     Mov   bl,es:[di]   ;; get screen color
     Inc   di
     Mov   dl,gs:[bx]   ;; transparency color
     Mov   es:[di-1],dl
     Dec   cx
     Jnz  @@XLoop
    @@Nothing:
     Pop   si
     Add   si,4
     Pop   di
     Add   di,320
     Pop   cx
     Dec   cx
     Jnz  @@DrawLoop

    @@Exit:
     Pop   bp

ENDIF
ENDIF
     Ret   RetBytes
EndP


GouraudPoly Proc Far

     Arg CoordPointer:DWord = RetBytes

IFDEF SMOOTHGOURAUD
     Push  bp
     Mov   bp,sp

     Les  di,CoordPointer
     Mov  eax,es:[di+P_V1]
     Mov  DWord Ptr [X1],eax
     Mov  eax,DWord Ptr es:[di+P_V2]
     Mov  DWord Ptr [X2],eax
     Mov  eax,DWord Ptr es:[di+P_V3]
     Mov  DWord Ptr [X3],eax

     Xor  ax,ax
     Mov  al,Byte Ptr es:[di+P_COLOR]
     Mov  Colour,al
     Mov  al,Byte Ptr es:[di+P_I1]
     Shl  ax,2
     Mov  I1,ax
     Mov  al,Byte Ptr es:[di+P_I2]
     Xor  ah,ah
     Shl  ax,2
     Mov  I2,ax
     Mov  al,Byte Ptr es:[di+P_I3]
     Xor  ah,ah
     Shl  ax,2
     Mov  I3,ax

     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipFirstSwap
     XChg  ax,bx
     SWAP  X1,X2
     SWAP  I1,I2
   @@SkipFirstSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Mov  ax,Y2
     Mov  bx,Y3
     Cmp  ax,bx
     Jle @@SkipSecondSwap
     XChg  ax,bx
     SWAP  X2, X3
     SWAP  I2, I3
   @@SkipSecondSwap:
     Mov   Y2,ax
     Mov   Y3,bx

     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipThirdSwap
     XChg  ax,bx
     SWAP  X1, X2
     SWAP  I1, I2
   @@SkipThirdSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Call  XEdges

     Mov   cx,TotalHeight
     Cmp   cx,0
     Jle  @@Exit

     Call  Intensity

     PlanarDelta I1,I2,I3,X1,X2,X3,Y1,Y2,Y3,DeltaI
     Mov   al,ExitFlag
     Cmp   al,1
     Je  @@Exit

     Mov   cx,TotalHeight
     Cmp   cx,0
     Jle  @@Exit

     Les   di,GlobalScreen
     Lfs   bx,IT           ;; Get IntensityTable
     Mov   si,Y1
     CEIL  si
     Mov   ax,320
     Mul   si
     Add   di,ax  ;; set DI to point to proper Y scanline
     Shl   si,2
     Mov   bl,Colour

    @@DrawLoop:
     Push  cx
     Push  di
     Push  si
     Mov   ecx,[XR+si]
     Mov   eax,[XL+si]
     Add   eax,255
     Dec   ecx
     Sar   ecx,8
     Sar   eax,8
     Add   di,ax
     Sub   ecx,eax  ;; ecx is horizontal line count
     Inc   ecx
     Cmp   cx,0
     Jle @@Nothing
     Mov   eax,[ID+si]  ;; get intensity
     Mov   esi,DeltaI
    @@XLoop:
     Mov   bh,ah
     Inc   di
     Mov   dl,fs:[bx]
     Add   ax,si
     Mov   es:[di-1],dl
     Dec   cx
     Jnz  @@XLoop
    @@Nothing:
     Pop   si
     Add   si,4
     Pop   di
     Add   di,320
     Pop   cx
     Dec   cx
     Jnz  @@DrawLoop

    @@Exit:
     Pop   bp
ENDIF
     Ret   RetBytes
EndP

TransparentGouraudPoly Proc Far

     Arg CoordPointer:DWord = RetBytes

IFDEF TRANSPARENCY
IFDEF SMOOTHGOURAUD

     Push  bp
     Mov   bp,sp

     Les  di,CoordPointer
     Mov  eax,es:[di+P_V1]
     Mov  DWord Ptr [X1],eax
     Mov  eax,DWord Ptr es:[di+P_V2]
     Mov  DWord Ptr [X2],eax
     Mov  eax,DWord Ptr es:[di+P_V3]
     Mov  DWord Ptr [X3],eax

     Xor  ax,ax
     Mov  al,Byte Ptr es:[di+P_COLOR]
     Mov  Colour,al
     Mov  al,Byte Ptr es:[di+P_I1]
     Shl  ax,2
     Mov  I1,ax
     Mov  al,Byte Ptr es:[di+P_I2]
     Xor  ah,ah
     Shl  ax,2
     Mov  I2,ax
     Mov  al,Byte Ptr es:[di+P_I3]
     Xor  ah,ah
     Shl  ax,2
     Mov  I3,ax

     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipFirstSwap
     XChg  ax,bx
     SWAP  X1,X2
     SWAP  I1,I2
   @@SkipFirstSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Mov  ax,Y2
     Mov  bx,Y3
     Cmp  ax,bx
     Jle @@SkipSecondSwap
     XChg  ax,bx
     SWAP  X2, X3
     SWAP  I2, I3
   @@SkipSecondSwap:
     Mov   Y2,ax
     Mov   Y3,bx

     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipThirdSwap
     XChg  ax,bx
     SWAP  X1, X2
     SWAP  I1, I2
   @@SkipThirdSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Call  XEdges
     Mov   cx,TotalHeight
     Cmp   cx,0
     Jle  @@Exit

     Call  Intensity

     PlanarDelta I1,I2,I3,X1,X2,X3,Y1,Y2,Y3,DeltaI
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit

     Mov   cx,TotalHeight
     Les   di,GlobalScreen
     Lfs   bx,IT           ;; Get IntensityTable
     Lgs   bx,TT
     Mov   si,Y1
     CEIL  si
     Mov   ax,320
     Mul   si
     Add   di,ax  ;; set DI to point to proper Y scanline
     Shl   si,2
     Mov   dh,Colour

    @@DrawLoop:
     Push  cx
     Push  di
     Push  si
     Mov   ecx,[XR+si]
     Mov   eax,[XL+si]
     Add   eax,255
     Dec   ecx
     Sar   ecx,8
     Sar   eax,8
     Add   di,ax
     Sub   ecx,eax  ;; ecx is horizontal line count
     Inc   ecx
     Cmp   cx,0
     Jle @@Nothing
     Mov   eax,[ID+si]  ;; get intensity
     Mov   esi,DeltaI
    @@XLoop:
     Mov   bh,ah
     Mov   bl,dh
     Inc   di
     Mov   dl,fs:[bx]   ;; intensity color
     Mov   bl,es:[di-1]   ;; get screen color
     Mov   bh,dl        ;; intensity color
     Add   ax,si
     Mov   dl,gs:[bx]   ;; transparency color
     Dec   cx
     Mov   es:[di-1],dl
     Jnz  @@XLoop
    @@Nothing:
     Pop   si
     Add   si,4
     Pop   di
     Add   di,320
     Pop   cx
     Dec   cx
     Jnz  @@DrawLoop

    @@Exit:
     Pop   bp

ENDIF
ENDIF
     Ret   RetBytes
EndP

TexturePoly Proc Far

     Arg TexPointer:DWord,CoordPointer:DWord = RetBytes

IFDEF TEXTUREAMBIENT
     Push  bp
     Mov   bp,sp

     Les  di,CoordPointer
     Mov  eax,es:[di+P_V1]
     Mov  DWord Ptr [X1],eax
     Mov  eax,DWord Ptr es:[di+P_V2]
     Mov  DWord Ptr [X2],eax
     Mov  eax,DWord Ptr es:[di+P_V3]
     Mov  DWord Ptr [X3],eax

     Mov  al,Byte Ptr es:[di+P_UV1]
     Xor  ah,ah
     Shl  ax,4
     Mov  U1,ax
     Mov  al,Byte Ptr es:[di+P_UV1+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  V1,ax
     Mov  al,Byte Ptr es:[di+P_UV2]
     Xor  ah,ah
     Shl  ax,4
     Mov  U2,ax
     Mov  al,Byte Ptr es:[di+P_UV2+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  V2,ax
     Mov  al,Byte Ptr es:[di+P_UV3]
     Xor  ah,ah
     Shl  ax,4
     Mov  U3,ax
     Mov  al,Byte Ptr es:[di+P_UV3+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  V3,ax

     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipFirstSwap
     XChg  ax,bx
     SWAP  X1,X2
     SWAP  U1,U2
     SWAP  V1,V2
   @@SkipFirstSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Mov  ax,Y2
     Mov  bx,Y3
     Cmp  ax,bx
     Jle @@SkipSecondSwap
     XChg  ax,bx
     SWAP  X2, X3
     SWAP  U2, U3
     SWAP  V2, V3
   @@SkipSecondSwap:
     Mov   Y2,ax
     Mov   Y3,bx

     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipThirdSwap
     XChg  ax,bx
     SWAP  X1, X2
     SWAP  U1, U2
     SWAP  V1, V2
   @@SkipThirdSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Mov   ax,Y3
     Sub   ax,Y1
     Jle  @@Exit

     Call  XEdges
     Mov   cx,TotalHeight
     Cmp   cx,0
     Jle  @@Exit
     Call  Texture

     PlanarDelta U1,U2,U3,X1,X2,X3,Y1,Y2,Y3,DeltaU
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit
     PlanarDelta V1,V2,V3,X1,X2,X3,Y1,Y2,Y3,DeltaV
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit

     Mov   cx,TotalHeight
     Les   di,GlobalScreen
     Lfs   bx,TexPointer           ;; Texture
     Mov   si,Y1
     CEIL  si
     Mov   ax,320
     Mul   si
     Add   di,ax  ;; set DI to point to proper Y scanline
     Shl   si,2

    @@DrawLoop:
     Push  cx
     Push  di
     Push  si
     Mov   ecx,[XR+si]
     Mov   eax,[XL+si]
     Add   eax,255
     Dec   ecx
     Sar   ecx,8
     Sar   eax,8
     Add   di,ax
     Sub   ecx,eax  ;; ecx is horizontal line count
     Inc   ecx
     Cmp   cx,0
     Jle @@Nothing
     Push  ebp
     Mov   eax,[UD+si]  ;; get U
     Mov   esi,[VD+si]  ;; get V
     Mov   edx,DeltaV
     Mov   ebp,DeltaU
    @@XLoop:
     Mov   bx,si
     Add   si,Word Ptr [DeltaV]  ;; keep as variable... it stays cached
     Mov   bl,ah
     Inc   di
     Mov   dl,fs:[bx]
     Add   ax,bp
     Mov   es:[di-1],dl
     Dec   cx
     Jnz  @@XLoop
     Pop   ebp
    @@Nothing:
     Pop   si
     Add   si,4
     Pop   di
     Add   di,320
     Pop   cx
     Dec   cx
     Jnz  @@DrawLoop

    @@Exit:
     Pop   bp
ENDIF
     Ret   RetBytes
EndP

TransparentTexturePoly Proc Far

     Arg TexPointer:DWord,CoordPointer:DWord = RetBytes

IFDEF TRANSPARENCY
IFDEF TEXTUREAMBIENT
     Push  bp
     Mov   bp,sp

     Les  di,CoordPointer
     Mov  eax,es:[di+P_V1]
     Mov  DWord Ptr [X1],eax
     Mov  eax,DWord Ptr es:[di+P_V2]
     Mov  DWord Ptr [X2],eax
     Mov  eax,DWord Ptr es:[di+P_V3]
     Mov  DWord Ptr [X3],eax

     Mov  al,Byte Ptr es:[di+P_UV1]
     Xor  ah,ah
     Shl  ax,4
     Mov  U1,ax
     Mov  al,Byte Ptr es:[di+P_UV1+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  V1,ax
     Mov  al,Byte Ptr es:[di+P_UV2]
     Xor  ah,ah
     Shl  ax,4
     Mov  U2,ax
     Mov  al,Byte Ptr es:[di+P_UV2+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  V2,ax
     Mov  al,Byte Ptr es:[di+P_UV3]
     Xor  ah,ah
     Shl  ax,4
     Mov  U3,ax
     Mov  al,Byte Ptr es:[di+P_UV3+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  V3,ax

     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipFirstSwap
     XChg  ax,bx
     SWAP  X1,X2
     SWAP  U1,U2
     SWAP  V1,V2
   @@SkipFirstSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Mov  ax,Y2
     Mov  bx,Y3
     Cmp  ax,bx
     Jle @@SkipSecondSwap
     XChg  ax,bx
     SWAP  X2, X3
     SWAP  U2, U3
     SWAP  V2, V3
   @@SkipSecondSwap:
     Mov   Y2,ax
     Mov   Y3,bx

     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipThirdSwap
     XChg  ax,bx
     SWAP  X1, X2
     SWAP  U1, U2
     SWAP  V1, V2
   @@SkipThirdSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Call  XEdges
     Mov   cx,TotalHeight
     Cmp   cx,0
     Jle  @@Exit

     Call  Texture

     PlanarDelta U1,U2,U3,X1,X2,X3,Y1,Y2,Y3,DeltaU
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit
     PlanarDelta V1,V2,V3,X1,X2,X3,Y1,Y2,Y3,DeltaV
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit

     Mov   cx,TotalHeight
     Les   di,GlobalScreen
     Lfs   bx,TexPointer           ;; Texture
     Lgs   bx,TT  ;; Transparency table
     Mov   si,Y1
     CEIL  si
     Mov   ax,320
     Mul   si
     Add   di,ax  ;; set DI to point to proper Y scanline
     Shl   si,2

    @@DrawLoop:
     Push  cx
     Push  di
     Push  si
     Mov   ecx,[XR+si]
     Mov   eax,[XL+si]
     Add   eax,255
     Dec   ecx
     Sar   ecx,8
     Sar   eax,8
     Add   di,ax
     Sub   ecx,eax  ;; ecx is horizontal line count
     Inc   ecx
     Cmp   cx,0
     Jle @@Nothing
     Push  ebp
     Mov   eax,[UD+si]  ;; get U
     Mov   esi,[VD+si]  ;; get V
     Mov   edx,DeltaV
     Mov   ebp,DeltaU

    @@XLoop:
     Mov   bx,si
     Add   esi,edx    ;; keep as variable... it stays cached
     Mov   bl,ah
     Inc   di
     Mov   ch,fs:[bx]  ;; texture color

     Mov   bh,ch
     Mov   bl,es:[di-1]  ;; background color
     Mov   ch,gs:[bx]    ;; transparent color

     Add   eax,ebp
     Mov   es:[di-1],ch
     Dec   cl
     Jnz  @@XLoop

     Pop   ebp
    @@Nothing:
     Pop   si
     Add   si,4
     Pop   di
     Add   di,320
     Pop   cx
     Dec   cx
     Jnz  @@DrawLoop

    @@Exit:
     Pop   bp
ENDIF
ENDIF
     Ret   RetBytes
EndP

FlatTexturePoly Proc Far

     Arg TexPointer:DWord,CoordPointer:DWord = RetBytes
IFDEF TEXTURELAMBERT
     Push  bp
     Mov   bp,sp

     Les  di,CoordPointer
     Mov  eax,es:[di+P_V1]
     Mov  DWord Ptr [X1],eax
     Mov  eax,DWord Ptr es:[di+P_V2]
     Mov  DWord Ptr [X2],eax
     Mov  eax,DWord Ptr es:[di+P_V3]
     Mov  DWord Ptr [X3],eax

     Mov  al,Byte Ptr es:[di+P_UV1]
     Xor  ah,ah
     Shl  ax,4
     Mov  U1,ax
     Mov  al,Byte Ptr es:[di+P_UV1+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  V1,ax
     Mov  al,Byte Ptr es:[di+P_UV2]
     Xor  ah,ah
     Shl  ax,4
     Mov  U2,ax
     Mov  al,Byte Ptr es:[di+P_UV2+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  V2,ax
     Mov  al,Byte Ptr es:[di+P_UV3]
     Xor  ah,ah
     Shl  ax,4
     Mov  U3,ax
     Mov  al,Byte Ptr es:[di+P_UV3+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  V3,ax

     Mov  al,Byte Ptr es:[di+P_I1]
     Mov  Colour,al

     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipFirstSwap
     XChg  ax,bx
     SWAP  X1,X2
     SWAP  U1,U2
     SWAP  V1,V2
   @@SkipFirstSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Mov  ax,Y2
     Mov  bx,Y3
     Cmp  ax,bx
     Jle @@SkipSecondSwap
     XChg  ax,bx
     SWAP  X2, X3
     SWAP  U2, U3
     SWAP  V2, V3
   @@SkipSecondSwap:
     Mov   Y2,ax
     Mov   Y3,bx

     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipThirdSwap
     XChg  ax,bx
     SWAP  X1, X2
     SWAP  U1, U2
     SWAP  V1, V2
   @@SkipThirdSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Call  XEdges
     Mov   cx,TotalHeight
     Cmp   cx,0
     Jle  @@Exit
     Call  Texture

     PlanarDelta U1,U2,U3,X1,X2,X3,Y1,Y2,Y3,DeltaU
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit
     PlanarDelta V1,V2,V3,X1,X2,X3,Y1,Y2,Y3,DeltaV
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit


     Mov   cx,TotalHeight
     Les   di,GlobalScreen
     Lfs   bx,TexPointer           ;; Texture
     Lgs   bx,IT  ;; Intensity Table
     Mov   si,Y1
     CEIL  si
     Mov   ax,320
     Mul   si
     Add   di,ax  ;; set DI to point to proper Y scanline
     Shl   si,2

    @@DrawLoop:
     Push  cx
     Push  di
     Push  si
     Mov   ecx,[XR+si]
     Mov   eax,[XL+si]
     Add   eax,255
     Dec   ecx
     Sar   ecx,8
     Sar   eax,8
     Add   di,ax
     Sub   ecx,eax  ;; ecx is horizontal line count
     Inc   ecx
     Cmp   cx,0
     Jle @@Nothing
     Push  ebp
     Mov   eax,[UD+si]  ;; get U
     Mov   esi,[VD+si]  ;; get V
     Mov   ebp,DeltaU
     Mov   dh,Colour
    @@XLoop:
     Mov   bx,si
     Add   esi,DeltaV    ;; keep as variable... it stays cached
     Mov   bl,ah
     Inc   di
     Mov   dl,fs:[bx]
     Mov   bx,dx
     Mov   dl,gs:[bx]
     Add   eax,ebp
     Mov   es:[di-1],dl
     Dec   cx
     Jnz  @@XLoop
     Pop   ebp
    @@Nothing:
     Pop   si
     Add   si,4
     Pop   di
     Add   di,320
     Pop   cx
     Dec   cx
     Jnz  @@DrawLoop

    @@Exit:
     Pop   bp
ENDIF
     Ret   RetBytes
EndP

TransparentFlatTexturePoly Proc Far

     Arg TexPointer:DWord,CoordPointer:DWord = RetBytes
IFDEF TRANSPARENCY
IFDEF TEXTURELAMBERT
     Push  bp
     Mov   bp,sp

     Les  di,CoordPointer
     Mov  eax,es:[di+P_V1]
     Mov  DWord Ptr [X1],eax
     Mov  eax,DWord Ptr es:[di+P_V2]
     Mov  DWord Ptr [X2],eax
     Mov  eax,DWord Ptr es:[di+P_V3]
     Mov  DWord Ptr [X3],eax

     Mov  al,Byte Ptr es:[di+P_UV1]
     Xor  ah,ah
     Shl  ax,4
     Mov  U1,ax
     Mov  al,Byte Ptr es:[di+P_UV1+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  V1,ax
     Mov  al,Byte Ptr es:[di+P_UV2]
     Xor  ah,ah
     Shl  ax,4
     Mov  U2,ax
     Mov  al,Byte Ptr es:[di+P_UV2+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  V2,ax
     Mov  al,Byte Ptr es:[di+P_UV3]
     Xor  ah,ah
     Shl  ax,4
     Mov  U3,ax
     Mov  al,Byte Ptr es:[di+P_UV3+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  V3,ax

     Mov  al,Byte Ptr es:[di+P_I1]
     Mov  Colour,al

     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipFirstSwap
     XChg  ax,bx
     SWAP  X1,X2
     SWAP  U1,U2
     SWAP  V1,V2
   @@SkipFirstSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Mov  ax,Y2
     Mov  bx,Y3
     Cmp  ax,bx
     Jle @@SkipSecondSwap
     XChg  ax,bx
     SWAP  X2, X3
     SWAP  U2, U3
     SWAP  V2, V3
   @@SkipSecondSwap:
     Mov   Y2,ax
     Mov   Y3,bx

     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipThirdSwap
     XChg  ax,bx
     SWAP  X1, X2
     SWAP  U1, U2
     SWAP  V1, V2
   @@SkipThirdSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Call  XEdges
     Mov   cx,TotalHeight
     Cmp   cx,0
     Jle  @@Exit

     Call  Texture

     PlanarDelta U1,U2,U3,X1,X2,X3,Y1,Y2,Y3,DeltaU
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit
     PlanarDelta V1,V2,V3,X1,X2,X3,Y1,Y2,Y3,DeltaV
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit


     Mov   cx,TotalHeight
     Les   di,GlobalScreen
     Lfs   bx,TexPointer           ;; Texture
     Lgs   bx,IT  ;; Intensity Table
     Mov   si,Y1
     CEIL  si
     Mov   ax,320
     Mul   si
     Add   di,ax  ;; set DI to point to proper Y scanline
     Shl   si,2

    @@DrawLoop:
     Push  cx
     Push  di
     Push  si
     Mov   ecx,[XR+si]
     Mov   eax,[XL+si]
     Add   eax,255
     Dec   ecx
     Sar   ecx,8
     Sar   eax,8
     Add   di,ax
     Sub   ecx,eax  ;; ecx is horizontal line count
     Inc   ecx
     Cmp   cx,0
     Jle @@Nothing
     Push  ebp
     Mov   eax,[UD+si]  ;; get U
     Mov   esi,[VD+si]  ;; get V
     Mov   ebp,DeltaU
     Mov   dh,Colour
     Mov   SaveSS,ss
     Lss   bx,TT
    @@XLoop:
     Mov   bx,si
     Add   esi,DeltaV    ;; keep as variable... it stays cached
     Mov   bl,ah
     Inc   di
     Mov   dl,fs:[bx]  ;; texture
     Mov   bx,dx

     Mov   bh,gs:[bx]  ;; intensity
     Mov   bl,es:[di-1] ;; screen
     Mov   dl,ss:[bx]   ;; TT

     Add   eax,ebp
     Mov   es:[di-1],dl
     Dec   cx
     Jnz  @@XLoop
     Mov   ss,SaveSS
     Pop   ebp
    @@Nothing:
     Pop   si
     Add   si,4
     Pop   di
     Add   di,320
     Pop   cx
     Dec   cx
     Jnz  @@DrawLoop

    @@Exit:
     Pop   bp
ENDIF
ENDIF
     Ret   RetBytes
EndP

PhongPoly Proc Far

     Arg PhongMap:DWord, CoordPointer:DWord = RetBytes
IFDEF SMOOTHPHONG
     Push  bp
     Mov   bp,sp

     Les  di,CoordPointer
     Mov  eax,es:[di+P_V1]
     Mov  DWord Ptr [X1],eax
     Mov  eax,DWord Ptr es:[di+P_V2]
     Mov  DWord Ptr [X2],eax
     Mov  eax,DWord Ptr es:[di+P_V3]
     Mov  DWord Ptr [X3],eax

     Xor  ax,ax
     Mov  al,Byte Ptr es:[di+P_UV1]
     Shl  ax,4
     Mov  I1,ax
     Mov  al,Byte Ptr es:[di+P_UV1+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  P1,ax
     Mov  al,Byte Ptr es:[di+P_UV2]
     Xor  ah,ah
     Shl  ax,4
     Mov  I2,ax
     Mov  al,Byte Ptr es:[di+P_UV2+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  P2,ax
     Mov  al,Byte Ptr es:[di+P_UV3]
     Xor  ah,ah
     Shl  ax,4
     Mov  I3,ax
     Mov  al,Byte Ptr es:[di+P_UV3+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  P3,ax
     Mov  al,Byte Ptr es:[di+P_COLOR]
     Mov  Colour,al


     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipFirstSwap
     XChg  ax,bx
     SWAP  X1,X2
     SWAP  I1,I2
     SWAP  P1,P2
   @@SkipFirstSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Mov  ax,Y2
     Mov  bx,Y3
     Cmp  ax,bx
     Jle @@SkipSecondSwap
     XChg  ax,bx
     SWAP  X2, X3
     SWAP  I2, I3
     SWAP  P2, P3
   @@SkipSecondSwap:
     Mov   Y2,ax
     Mov   Y3,bx

     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipThirdSwap
     XChg  ax,bx
     SWAP  X1, X2
     SWAP  I1, I2
     SWAP  P1, P2
   @@SkipThirdSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Call  XEdges
     Mov   cx,TotalHeight
     Cmp   cx,0
     Jle  @@Exit

     Call  Phong

     PlanarDelta I1,I2,I3,X1,X2,X3,Y1,Y2,Y3,DeltaI
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit
     PlanarDelta P1,P2,P3,X1,X2,X3,Y1,Y2,Y3,DeltaP
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit

     Mov   cx,TotalHeight
     Les   di,GlobalScreen
     Lfs   bx,PhongMap      ;; Texture
     Lgs   bx,IT  ;; Intensity Table
     Mov   si,Y1
     CEIL  si
     Mov   ax,320
     Mul   si
     Add   di,ax  ;; set DI to point to proper Y scanline
     Shl   si,2

    @@DrawLoop:
     Push  cx
     Push  di
     Push  si
     Mov   ecx,[XR+si]
     Mov   eax,[XL+si]
     Add   eax,255
     Dec   ecx
     Sar   ecx,8
     Sar   eax,8
     Add   di,ax
     Sub   ecx,eax  ;; ecx is horizontal line count
     Inc   ecx
     Cmp   cx,0
     Jle @@Nothing
     Push  ebp
     Mov   eax,[ID+si]  ;; get U
     Mov   esi,[PD+si]  ;; get V
     Mov   ebp,DeltaI
     Mov   dl,Colour
    @@XLoop:
     Mov   bx,si
     Add   esi,DeltaP    ;; keep as variable... it stays cached
     Mov   bl,ah
     Inc   di
     Mov   dh,fs:[bx]
     Mov   bx,dx
     Mov   dh,gs:[bx]
     Add   eax,ebp
     Mov   es:[di-1],dh
     Dec   cx
     Jnz  @@XLoop
     Pop   ebp
    @@Nothing:
     Pop   si
     Add   si,4
     Pop   di
     Add   di,320
     Pop   cx
     Dec   cx
     Jnz  @@DrawLoop

    @@Exit:
     Pop   bp
ENDIF
     Ret   RetBytes
EndP

TransparentPhongPoly Proc Far

     Arg PhongMap:DWord, CoordPointer:DWord = RetBytes
IFDEF TRANSPARENCY
IFDEF SMOOTHPHONG
     Push  bp
     Mov   bp,sp

     Les  di,CoordPointer
     Mov  eax,es:[di+P_V1]
     Mov  DWord Ptr [X1],eax
     Mov  eax,DWord Ptr es:[di+P_V2]
     Mov  DWord Ptr [X2],eax
     Mov  eax,DWord Ptr es:[di+P_V3]
     Mov  DWord Ptr [X3],eax

     Xor  ax,ax
     Mov  al,Byte Ptr es:[di+P_UV1]
     Shl  ax,4
     Mov  I1,ax
     Mov  al,Byte Ptr es:[di+P_UV1+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  P1,ax
     Mov  al,Byte Ptr es:[di+P_UV2]
     Xor  ah,ah
     Shl  ax,4
     Mov  I2,ax
     Mov  al,Byte Ptr es:[di+P_UV2+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  P2,ax
     Mov  al,Byte Ptr es:[di+P_UV3]
     Xor  ah,ah
     Shl  ax,4
     Mov  I3,ax
     Mov  al,Byte Ptr es:[di+P_UV3+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  P3,ax

     Mov  al,Byte Ptr es:[di+P_COLOR]
     Mov  Colour,al



     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipFirstSwap
     XChg  ax,bx
     SWAP  X1,X2
     SWAP  I1,I2
     SWAP  P1,P2
   @@SkipFirstSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Mov  ax,Y2
     Mov  bx,Y3
     Cmp  ax,bx
     Jle @@SkipSecondSwap
     XChg  ax,bx
     SWAP  X2, X3
     SWAP  I2, I3
     SWAP  P2, P3
   @@SkipSecondSwap:
     Mov   Y2,ax
     Mov   Y3,bx

     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipThirdSwap
     XChg  ax,bx
     SWAP  X1, X2
     SWAP  I1, I2
     SWAP  P1, P2
   @@SkipThirdSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Call  XEdges

     Mov   cx,TotalHeight
     Cmp   cx,0
     Jle  @@Exit

     Call  Phong

     PlanarDelta I1,I2,I3,X1,X2,X3,Y1,Y2,Y3,DeltaI
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit
     PlanarDelta P1,P2,P3,X1,X2,X3,Y1,Y2,Y3,DeltaP
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit

     Mov   cx,TotalHeight
     Les   di,GlobalScreen
     Lfs   bx,PhongMap      ;; Texture
     Lgs   bx,IT  ;; Intensity Table
     Mov   si,Y1
     CEIL  si
     Mov   ax,320
     Mul   si
     Add   di,ax  ;; set DI to point to proper Y scanline
     Shl   si,2

    @@DrawLoop:
     Push  cx
     Push  di
     Push  si
     Mov   ecx,[XR+si]
     Mov   eax,[XL+si]
     Add   eax,255
     Dec   ecx
     Sar   ecx,8
     Sar   eax,8
     Add   di,ax
     Sub   ecx,eax  ;; ecx is horizontal line count
     Inc   ecx
     Cmp   cx,0
     Jle @@Nothing
     Push  ebp
     Mov   eax,[ID+si]  ;; get U
     Mov   esi,[PD+si]  ;; get V
     Mov   ebp,DeltaI
     Mov   dl,Colour
     Mov   SaveSS,ss
     Lss   bx,TT
    @@XLoop:
     Mov   bx,si
     Add   esi,DeltaP    ;; keep as variable... it stays cached
     Mov   bl,ah
     Inc   di
     Mov   dh,fs:[bx]  ;; phong
     Mov   bx,dx
     Mov   bl,gs:[bx]  ;; IT
     Mov   bh,es:[di-1] ;; screen
     Mov   dh,ss:[bx]   ;; TT
     Add   eax,ebp
     Mov   es:[di-1],dh
     Dec   cx
     Jnz  @@XLoop
     Mov   ss,SaveSS
     Pop   ebp
    @@Nothing:
     Pop   si
     Add   si,4
     Pop   di
     Add   di,320
     Pop   cx
     Dec   cx
     Jnz  @@DrawLoop

    @@Exit:
     Pop   bp
ENDIF
ENDIF
     Ret   RetBytes
EndP


GouraudTexturePoly Proc Far

     Arg TePointer:DWord,CoordPointer:DWord = RetBytes
IFDEF TEXTUREGOURAUD
     Push  bp
     Mov   bp,sp

     Les  di,CoordPointer
     Mov  eax,es:[di+P_V1]
     Mov  DWord Ptr [X1],eax
     Mov  eax,DWord Ptr es:[di+P_V2]
     Mov  DWord Ptr [X2],eax
     Mov  eax,DWord Ptr es:[di+P_V3]
     Mov  DWord Ptr [X3],eax

     Mov  al,Byte Ptr es:[di+P_UV1]
     Xor  ah,ah
     Shl  ax,4
     Mov  U1,ax
     Mov  al,Byte Ptr es:[di+P_UV1+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  V1,ax
     Mov  al,Byte Ptr es:[di+P_UV2]
     Xor  ah,ah
     Shl  ax,4
     Mov  U2,ax
     Mov  al,Byte Ptr es:[di+P_UV2+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  V2,ax
     Mov  al,Byte Ptr es:[di+P_UV3]
     Xor  ah,ah
     Shl  ax,4
     Mov  U3,ax
     Mov  al,Byte Ptr es:[di+P_UV3+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  V3,ax

     Mov  al,Byte Ptr es:[di+P_I1]
     Xor  ah,ah
     Shl  ax,2
     Mov  I1,ax
     Mov  al,Byte Ptr es:[di+P_I2]
     Xor  ah,ah
     Shl  ax,2
     Mov  I2,ax
     Mov  al,Byte Ptr es:[di+P_I3]
     Xor  ah,ah
     Shl  ax,2
     Mov  I3,ax

     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipFirstSwap
     XChg  ax,bx
     SWAP  X1,X2
     SWAP  U1,U2
     SWAP  V1,V2
     SWAP  I1,I2
   @@SkipFirstSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Mov  ax,Y2
     Mov  bx,Y3
     Cmp  ax,bx
     Jle @@SkipSecondSwap
     XChg  ax,bx
     SWAP  X2, X3
     SWAP  U2, U3
     SWAP  V2, V3
     SWAP  I2, I3
   @@SkipSecondSwap:
     Mov   Y2,ax
     Mov   Y3,bx

     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipThirdSwap
     XChg  ax,bx
     SWAP  X1, X2
     SWAP  U1, U2
     SWAP  V1, V2
     SWAP  I1, I2
   @@SkipThirdSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Call  XEdges
     Mov   cx,TotalHeight
     Cmp   cx,0
     Jle  @@Exit
     Call  Intensity
     Call  Texture

     PlanarDelta I1,I2,I3,X1,X2,X3,Y1,Y2,Y3,DeltaI
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit

     PlanarDelta U1,U2,U3,X1,X2,X3,Y1,Y2,Y3,DeltaU
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit
     PlanarDelta V1,V2,V3,X1,X2,X3,Y1,Y2,Y3,DeltaV
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit

     Mov   cx,TotalHeight
     Les   di,GlobalScreen
     Lfs   bx,TePointer     ;; Texture
     Lgs   bx,IT  ;; Intensity Table
     Mov   si,Y1
     CEIL  si
     Mov   ax,320
     Mul   si
     Add   di,ax  ;; set DI to point to proper Y scanline
     Shl   si,2

    @@DrawLoop:
     Push  cx
     Push  di
     Push  si
     Mov   ecx,[XR+si]
     Mov   eax,[XL+si]
     Add   eax,255
     Dec   ecx
     Sar   ecx,8
     Sar   eax,8
     Add   di,ax
     Sub   ecx,eax  ;; ecx is horizontal line count
     Inc   ecx
     Cmp   cx,0
     Jle @@Nothing
     Push  ebp
     Mov   eax,[UD+si]  ;; get U
     Mov   edx,[ID+si]  ;; get I
     Mov   esi,[VD+si]  ;; get V
     Mov   ebp,edx

    @@XLoop:
     Mov   bx,si
     Mov   bl,ah
     Add   si,Word Ptr [DeltaV]
     Mov   dl,fs:[bx]  ;; texture color
     Mov   bx,bp
     Inc   di
     Mov   bl,dl
     Add   ax,Word Ptr [DeltaU]
     Mov   dh,gs:[bx]  ;; intensity color
     Add   bp, Word Ptr [DeltaI]
     Mov   es:[di-1],dh
     Dec   cx
     Jnz  @@XLoop
     Pop   ebp
    @@Nothing:
     Pop   si
     Add   si,4
     Pop   di
     Add   di,320
     Pop   cx
     Dec   cx
     Jnz  @@DrawLoop

    @@Exit:
     Pop   bp
ENDIF
     Ret   RetBytes
EndP

TransparentGouraudTexturePoly Proc Far

     Arg TePointer:DWord,CoordPointer:DWord = RetBytes
IFDEF TRANSPARENCY
IFDEF TEXTUREGOURAUD
     Push  bp
     Mov   bp,sp

     Les  di,CoordPointer
     Mov  eax,es:[di+P_V1]
     Mov  DWord Ptr [X1],eax
     Mov  eax,DWord Ptr es:[di+P_V2]
     Mov  DWord Ptr [X2],eax
     Mov  eax,DWord Ptr es:[di+P_V3]
     Mov  DWord Ptr [X3],eax

     Mov  al,Byte Ptr es:[di+P_UV1]
     Xor  ah,ah
     Shl  ax,4
     Mov  U1,ax
     Mov  al,Byte Ptr es:[di+P_UV1+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  V1,ax
     Mov  al,Byte Ptr es:[di+P_UV2]
     Xor  ah,ah
     Shl  ax,4
     Mov  U2,ax
     Mov  al,Byte Ptr es:[di+P_UV2+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  V2,ax
     Mov  al,Byte Ptr es:[di+P_UV3]
     Xor  ah,ah
     Shl  ax,4
     Mov  U3,ax
     Mov  al,Byte Ptr es:[di+P_UV3+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  V3,ax

     Mov  al,Byte Ptr es:[di+P_I1]
     Xor  ah,ah
     Shl  ax,2
     Mov  I1,ax
     Mov  al,Byte Ptr es:[di+P_I2]
     Xor  ah,ah
     Shl  ax,2
     Mov  I2,ax
     Mov  al,Byte Ptr es:[di+P_I3]
     Xor  ah,ah
     Shl  ax,2
     Mov  I3,ax

     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipFirstSwap
     XChg  ax,bx
     SWAP  X1,X2
     SWAP  U1,U2
     SWAP  V1,V2
     SWAP  I1,I2
   @@SkipFirstSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Mov  ax,Y2
     Mov  bx,Y3
     Cmp  ax,bx
     Jle @@SkipSecondSwap
     XChg  ax,bx
     SWAP  X2, X3
     SWAP  U2, U3
     SWAP  V2, V3
     SWAP  I2, I3
   @@SkipSecondSwap:
     Mov   Y2,ax
     Mov   Y3,bx

     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipThirdSwap
     XChg  ax,bx
     SWAP  X1, X2
     SWAP  U1, U2
     SWAP  V1, V2
     SWAP  I1, I2
   @@SkipThirdSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Call  XEdges
     Mov   cx,TotalHeight
     Cmp   cx,0
     Jle  @@Exit
     Call  Intensity
     Call  Texture

     PlanarDelta I1,I2,I3,X1,X2,X3,Y1,Y2,Y3,DeltaI
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit
     PlanarDelta U1,U2,U3,X1,X2,X3,Y1,Y2,Y3,DeltaU
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit
     PlanarDelta V1,V2,V3,X1,X2,X3,Y1,Y2,Y3,DeltaV
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit

     Mov   cx,TotalHeight
     Les   di,GlobalScreen
     Lfs   bx,TePointer     ;; Texture
     Lgs   bx,IT  ;; Intensity Table
     Mov   si,Y1
     CEIL  si
     Mov   ax,320
     Mul   si
     Add   di,ax  ;; set DI to point to proper Y scanline
     Shl   si,2

    @@DrawLoop:
     Push  cx
     Push  di
     Push  si
     Mov   ecx,[XR+si]
     Mov   eax,[XL+si]
     Add   eax,255
     Dec   ecx
     Sar   ecx,8
     Sar   eax,8
     Add   di,ax
     Sub   ecx,eax  ;; ecx is horizontal line count
     Inc   ecx
     Cmp   cx,0
     Jle @@Nothing
     Push  ebp
     Mov   eax,[UD+si]  ;; get U
     Mov   edx,[ID+si]  ;; get I
     Mov   esi,[VD+si]  ;; get V
     Mov   ebp,edx

     Mov   SaveSS,ss
     Lss   bx,TT
    @@XLoop:
     Mov   bx,si
     Mov   bl,ah
     Add   esi,DeltaV
     Mov   dl,fs:[bx]  ;; texture color
     Mov   bx,bp
     Inc   di
     Mov   bl,dl
     Add   eax,DeltaU
     Mov   bh,gs:[bx]  ;; intensity color
     Mov   bl,es:[di-1] ;; screen
     Mov   dh,ss:[bx] ;; transparent

     Add   ebp,DeltaI
     Mov   es:[di-1],dh
     Dec   cx
     Jnz  @@XLoop
     Mov   ss,SaveSS
     Pop   ebp
    @@Nothing:
     Pop   si
     Add   si,4
     Pop   di
     Add   di,320
     Pop   cx
     Dec   cx
     Jnz  @@DrawLoop

    @@Exit:
     Pop   bp
ENDIF
ENDIF
     Ret   RetBytes
EndP


PhongTexturePoly Proc Far

     Arg PhongMap:DWord,TePointer:DWord,CoordPointer:DWord = RetBytes
IFDEF TEXTUREPHONG
     Push  bp
     Mov   bp,sp

     Les  di,CoordPointer
     Mov  eax,es:[di+P_V1]
     Mov  DWord Ptr [X1],eax
     Mov  eax,DWord Ptr es:[di+P_V2]
     Mov  DWord Ptr [X2],eax
     Mov  eax,DWord Ptr es:[di+P_V3]
     Mov  DWord Ptr [X3],eax

     Mov  al,Byte Ptr es:[di+P_UV1]
     Xor  ah,ah
     Shl  ax,4
     Mov  U1,ax
     Mov  al,Byte Ptr es:[di+P_UV1+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  V1,ax
     Mov  al,Byte Ptr es:[di+P_UV2]
     Xor  ah,ah
     Shl  ax,4
     Mov  U2,ax
     Mov  al,Byte Ptr es:[di+P_UV2+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  V2,ax
     Mov  al,Byte Ptr es:[di+P_UV3]
     Xor  ah,ah
     Shl  ax,4
     Mov  U3,ax
     Mov  al,Byte Ptr es:[di+P_UV3+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  V3,ax

     Mov  al,Byte Ptr es:[di+P_PT1]
     Xor  ah,ah
     Shl  ax,4
     Mov  I1,ax
     Mov  al,Byte Ptr es:[di+P_PT1+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  P1,ax
     Mov  al,Byte Ptr es:[di+P_PT2]
     Xor  ah,ah
     Shl  ax,4
     Mov  I2,ax
     Mov  al,Byte Ptr es:[di+P_PT2+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  P2,ax
     Mov  al,Byte Ptr es:[di+P_PT3]
     Xor  ah,ah
     Shl  ax,4
     Mov  I3,ax
     Mov  al,Byte Ptr es:[di+P_PT3+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  P3,ax

     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipFirstSwap
     XChg  ax,bx
     SWAP  X1,X2
     SWAP  U1,U2
     SWAP  V1,V2
     SWAP  I1,I2
     SWAP  P1,P2
   @@SkipFirstSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Mov  ax,Y2
     Mov  bx,Y3
     Cmp  ax,bx
     Jle @@SkipSecondSwap
     XChg  ax,bx
     SWAP  X2, X3
     SWAP  U2, U3
     SWAP  V2, V3
     SWAP  I2, I3
     SWAP  P2, P3
   @@SkipSecondSwap:
     Mov   Y2,ax
     Mov   Y3,bx

     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipThirdSwap
     XChg  ax,bx
     SWAP  X1, X2
     SWAP  U1, U2
     SWAP  V1, V2
     SWAP  I1, I2
     SWAP  P1, P2
   @@SkipThirdSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Call  XEdges
     Mov   cx,TotalHeight
     Cmp   cx,0
     Jle  @@Exit

     Call  Phong
     Call  Texture

     PlanarDelta U1,U2,U3,X1,X2,X3,Y1,Y2,Y3,DeltaU
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit
     PlanarDelta V1,V2,V3,X1,X2,X3,Y1,Y2,Y3,DeltaV
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit

     PlanarDelta I1,I2,I3,X1,X2,X3,Y1,Y2,Y3,DeltaI
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit
     PlanarDelta P1,P2,P3,X1,X2,X3,Y1,Y2,Y3,DeltaP
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit

     Mov   cx,TotalHeight
     Les   di,GlobalScreen
     Lfs   bx,TePointer     ;; Texture
     Lgs   bx,IT  ;; Intensity Table

     Mov   si,Y1
     CEIL  si
     Mov   ax,320
     Mul   si
     Add   di,ax  ;; set DI to point to proper Y scanline
     Shl   si,2

    @@DrawLoop:
     Push  cx
     Push  di
     Push  si
     Mov   ecx,[XR+si]
     Mov   eax,[XL+si]
     Add   eax,255
     Dec   ecx
     Sar   ecx,8
     Sar   eax,8
     Add   di,ax
     Sub   ecx,eax  ;; ecx is horizontal line count
     Inc   ecx
     Cmp   cx,0
     Jle  @@Nothing
     Shl   ecx,16  ;; put count in upper word of ecx
     Push  ebp

     Mov   SaveSS,ss
     Mov   SaveDS,es
     Les   bx,PhongMap
     Mov   ax,es
     Mov   ss,ax
     Mov   es,SaveDS

     Mov   eax,ds:[UD+si]  ;; get U
     Mov   edx,ds:[ID+si]  ;; get I
     Mov   ebp,ds:[PD+si]  ;; get P
     Mov   esi,ds:[VD+si]  ;; get V

     ;; This absolutely HIDEOUS loop actually performs rather well
     ;; it only puts *1* pixel on the screen (told 'ya its hideous)
    @@XLoop:
     Mov   bx,bp
     Mov   bl,dh
     Add   edx,DeltaI
     Mov   ch,ss:[bx]  ;; get Phong map color
     Mov   bx,si
     Mov   bl,ah
     Add   esi,DeltaV
     Mov   cl,fs:[bx]  ;; get texture color
     Mov   bh,ch
     Mov   bl,cl
     Add   eax,DeltaU
     Mov   ch,gs:[bx]  ;; final color
     Add   ebp,DeltaP
     Mov   es:[di],ch
     Inc   di
     Xor   cx,cx          ;; clear lower word of ecx
     Sub   ecx,00010000h  ;; decrement upper word
     Jnz  @@XLoop

     Mov   ss,SaveSS
     Pop   ebp
    @@Nothing:
     Pop   si
     Add   si,4
     Pop   di
     Add   di,320
     Pop   cx
     Dec   cx
     Jnz  @@DrawLoop

    @@Exit:
     Pop   bp
ENDIF
     Ret   RetBytes
EndP

TransparentPhongTexturePoly Proc Far

     Arg PhongMap:DWord,TePointer:DWord,CoordPointer:DWord = RetBytes
IFDEF TRANSPARENCY
IFDEF TEXTUREPHONG
     Push  bp
     Mov   bp,sp

     Les  di,CoordPointer
     Mov  eax,es:[di+P_V1]
     Mov  DWord Ptr [X1],eax
     Mov  eax,DWord Ptr es:[di+P_V2]
     Mov  DWord Ptr [X2],eax
     Mov  eax,DWord Ptr es:[di+P_V3]
     Mov  DWord Ptr [X3],eax

     Mov  al,Byte Ptr es:[di+P_UV1]
     Xor  ah,ah
     Shl  ax,4
     Mov  U1,ax
     Mov  al,Byte Ptr es:[di+P_UV1+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  V1,ax
     Mov  al,Byte Ptr es:[di+P_UV2]
     Xor  ah,ah
     Shl  ax,4
     Mov  U2,ax
     Mov  al,Byte Ptr es:[di+P_UV2+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  V2,ax
     Mov  al,Byte Ptr es:[di+P_UV3]
     Xor  ah,ah
     Shl  ax,4
     Mov  U3,ax
     Mov  al,Byte Ptr es:[di+P_UV3+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  V3,ax

     Mov  al,Byte Ptr es:[di+P_PT1]
     Xor  ah,ah
     Shl  ax,4
     Mov  I1,ax
     Mov  al,Byte Ptr es:[di+P_PT1+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  P1,ax
     Mov  al,Byte Ptr es:[di+P_PT2]
     Xor  ah,ah
     Shl  ax,4
     Mov  I2,ax
     Mov  al,Byte Ptr es:[di+P_PT2+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  P2,ax
     Mov  al,Byte Ptr es:[di+P_PT3]
     Xor  ah,ah
     Shl  ax,4
     Mov  I3,ax
     Mov  al,Byte Ptr es:[di+P_PT3+1]
     Xor  ah,ah
     Shl  ax,4
     Mov  P3,ax

     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipFirstSwap
     XChg  ax,bx
     SWAP  X1,X2
     SWAP  U1,U2
     SWAP  V1,V2
     SWAP  I1,I2
     SWAP  P1,P2
   @@SkipFirstSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Mov  ax,Y2
     Mov  bx,Y3
     Cmp  ax,bx
     Jle @@SkipSecondSwap
     XChg  ax,bx
     SWAP  X2, X3
     SWAP  U2, U3
     SWAP  V2, V3
     SWAP  I2, I3
     SWAP  P2, P3
   @@SkipSecondSwap:
     Mov   Y2,ax
     Mov   Y3,bx

     Mov  ax,Y1
     Mov  bx,Y2
     Cmp  ax,bx
     Jle @@SkipThirdSwap
     XChg  ax,bx
     SWAP  X1, X2
     SWAP  U1, U2
     SWAP  V1, V2
     SWAP  I1, I2
     SWAP  P1, P2
   @@SkipThirdSwap:
     Mov   Y1,ax
     Mov   Y2,bx

     Mov   ax,Y3
     Sub   ax,Y1
     Jle  @@Exit

     Call  XEdges
     Mov   cx,TotalHeight
     Cmp   cx,0
     Jle  @@Exit

     Call  Phong
     Call  Texture

     PlanarDelta U1,U2,U3,X1,X2,X3,Y1,Y2,Y3,DeltaU
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit
     PlanarDelta V1,V2,V3,X1,X2,X3,Y1,Y2,Y3,DeltaV
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit

     PlanarDelta I1,I2,I3,X1,X2,X3,Y1,Y2,Y3,DeltaI
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit
     PlanarDelta P1,P2,P3,X1,X2,X3,Y1,Y2,Y3,DeltaP
     Mov   al,ExitFlag
     Cmp   al,1
     Jz  @@Exit


     Mov   cx,TotalHeight
     Les   di,GlobalScreen
     Lfs   bx,TePointer     ;; Texture
     Lgs   bx,IT  ;; Intensity Table

     Mov   si,Y1
     CEIL  si
     Mov   ax,320
     Mul   si
     Add   di,ax  ;; set DI to point to proper Y scanline
     Shl   si,2

    @@DrawLoop:
     Push  cx
     Push  di
     Push  si
     Mov   ecx,[XR+si]
     Mov   eax,[XL+si]
     Add   eax,255
     Dec   ecx
     Sar   ecx,8
     Sar   eax,8
     Add   di,ax
     Sub   ecx,eax  ;; ecx is horizontal line count
     Inc   ecx
     Cmp   cx,0
     Jle  @@Nothing
     Shl   ecx,16  ;; put count in upper word of ecx
     Push  ebp

     Mov   SaveSS,ss
     Mov   SaveDS,es
     Les   bx,PhongMap
     Mov   ax,es
     Mov   ss,ax
     Les   bx,TT
     Mov   TTSeg,es
     Mov   es,SaveDS

     Mov   eax,ds:[UD+si]  ;; get U
     Mov   edx,ds:[ID+si]  ;; get I
     Mov   ebp,ds:[PD+si]  ;; get P
     Mov   esi,ds:[VD+si]  ;; get V

     ;; This absolutely HIDEOUS loop actually performs rather well
     ;; it only puts *1* pixel on the screen (told 'ya its hideous)
    @@XLoop:
     Mov   bx,bp
     Mov   bl,dh
     Add   edx,DeltaI
     Mov   ch,ss:[bx]  ;; get Phong map color
     Mov   bx,si
     Mov   bl,ah
     Add   esi,DeltaV
     Mov   cl,fs:[bx]  ;; get texture color
     Mov   bh,ch
     Mov   bl,cl
     Add   eax,DeltaU
     Mov   ch,gs:[bx]  ;; final color

     Mov   SaveGS,gs  ;; need another seg reg! doh!
     Mov   gs,TTSeg
     Mov   bh,ch
     Mov   bl,es:[di]  ;; screen color
     Mov   ch,gs:[bx]
     Mov   gs,SaveGS

     Add   ebp,DeltaP
     Mov   es:[di],ch
     Inc   di
     Xor   cx,cx          ;; clear lower word of ecx
     Sub   ecx,00010000h  ;; decrement upper word
     Jnz  @@XLoop

     Mov   ss,SaveSS
     Pop   ebp
    @@Nothing:
     Pop   si
     Add   si,4
     Pop   di
     Add   di,320
     Pop   cx
     Dec   cx
     Jnz  @@DrawLoop

    @@Exit:
     Pop   bp
ENDIF
ENDIF
     Ret   RetBytes
EndP


EndS
End
