Comment *
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
                     Inertia Realtime 3D Rendering Engine
            Copyright (c) 1997, Alex Chalfin. All Rights Reserved.
                       Inertia/16 Source Code Release.
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*

;; Just comment out these lines to UNDEF them

DPMI           EQU 0
;; DPMI *must* be defined if running in protected mode using the SMC fillers
;; otherwise you will get General Protection Faults all of the time
;; (Runtime error 216). This value *must* be commented out when compiling for
;; real mode or you will lock up your system. Don't forget to re-assemble!!!


;; See the DEFINES.INC file for an explination of these values. They
;; work the same way, but effect the ASM fillers

SMOOTHAMBIENT  EQU 0
SMOOTHLAMBERT  EQU 0
SMOOTHGOURAUD  EQU 0
SMOOTHPHONG    EQU 0

TEXTUREAMBIENT EQU 0
TEXTURELAMBERT EQU 0
TEXTUREGOURAUD EQU 0
TEXTUREPHONG   EQU 0

TRANSPARENCY   EQU 0


