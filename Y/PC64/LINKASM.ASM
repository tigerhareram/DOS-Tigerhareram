;LINKASM.ASM -- Datenblîcke zum C64 Åbertragen und digitalen Joystick abfragen
;Diese Datei und der Quellcode fÅr die C64-Seite sind Public Domain

CSYNC     equ 2                         ;Kontaktaufnahme und Synchronisation
CREADY    equ 3                         ;Synchronisation erfolgreich
CSEND     equ 4                         ;PC will senden
CRECEIVE  equ 5                         ;PC will empfangen
CDATALO   equ 6                         ;EmpfangsbestÑtigung Low-Nibble
CDATAHI   equ 7                         ;EmpfangsbestÑtigung High-Nibble
COK       equ 9                         ;PrÅfsumme in Ordnung

ETIMEOUT  equ -1                        ;Fremdrechner antwortet nicht
ETRANSFER equ -2                        ;öbertragungsfehler aufgetreten

.model large,c
.data

L64Result dw ETIMEOUT                   ;Letzter RÅckgabewert
  public L64Result
L64State db 4 dup (255)                 ;ZustÑnde von BUSY/PA2 in Bit 7
  public L64State                       ;255 = nicht angesprochen oder Fehler
L64LinkWaits db 4 dup (0)               ;FÅr langsame Schnittstellen (0 bis 127)
  public L64LinkWaits
L64JoyWaits db 4 dup (0)                ;FÅr langsame Schnittstellen (0 bis 127)
  public L64JoyWaits
L64AlternateJoy db 4 dup (255)          ;1 = Alternativer Joystickadapter
  public L64AlternateJoy                ;255 = Autodetect

.code

;Gleichzeitig 4 Bits einlesen und ausgeben
;Eingabe: AH = Auszugebender Wert in den Bits 0 bis 3, Bit 7 = 0
;         CL = Letzter Zustand von BUSY/PA2 in Bit 7, Rest 0
;         DX = Portadresse der parallelen Schnittstelle
;         DS = 0
;Ausgabe: AH = Eingelesener Wert in den Bits 3 bis 6, Rest 0
;         CL = Neuer Zustand von BUSY/PA2 in Bit 7, Rest 0
;         CF = Timeout-Fehler aufgetreten
;éndert:  AL,CH

Transfer proc near
  or AH,01110000b                       ;Spitzen am Joystick vermeiden
  mov CH,DS:[046Ch]                     ;1/18 bis 2/18 Sekunden Timeout
  add CH,2
  inc DX                                ;Parallelen Statusport lesen
@@Wait:
  cmp CH,DS:[046Ch]                     ;Zeit abgelaufen?
  js @@Timeout
  in AL,DX                              ;Hat sich das Busy-Bit geÑndert?
  xor AL,CL
  jns @@Wait
  mov CH,0                              ;ZÑhler fÅr Wartezyklen laden
ReceiveWaits equ byte ptr $-1
@@ReceiveDelay:
  in AL,DX                              ;Daten nochmal lesen
  dec CH
  jns @@ReceiveDelay
  dec DX                                ;BestÑtigung abschicken
  xchg AL,AH
  or AL,10000000b                       ;Flankentrigger zurÅcksetzen
  mov CH,0                              ;ZÑhler fÅr Wartezyklen laden
SendWaits equ byte ptr $-1
@@SendDelay:
  out DX,AL                             ;Daten anlegen, Trigger zurÅcksetzen
  jmp $+2
  dec CH
  jns @@SendDelay
  and AX,0111100001111111b              ;Unrelevante Bits ausblenden + triggern
  out DX,AL                             ;BestÑtigung losschicken
  jmp $+2
  xor CL,10000000b                      ;Neuen Busy-Status sichern
  ret                                   ;Mit gelîschtem CF zurÅck
@@Timeout:
  dec DX                                ;Auf Datenport zurÅckschalten
  stc                                   ;Timeout-Fehler zurÅckgeben
  ret
Transfer endp

;PC und C64 synchronisieren
;Eingabe: DX = Portadresse parallele Schnittstelle
;         DS:046C = ZÑhler fÅr Systemuhr 18 mal pro Sekunde
;Ausgabe: CL = Neuer Status von BUSY/PA2 in Bit 8, Rest 0
;         CF = Timeout-Fehler aufgetreten
;éndert:  AX,BX,CH

Sync proc near
  mov AL,CSYNC or 10000000b             ;Flankentrigger initialisieren
  out DX,AL
  jmp $+2
  inc DX                                ;Zustand von BUSY/PA2 holen
  in AL,DX
  and AL,10000000b
  mov CL,AL
  dec DX
  xor CL,10000000b                      ;Beim ersten Mal nicht warten
@@Reset:
  mov BX,5                              ;FÅnf DurchlÑufe sind nîtig
@@Next:
  mov AH,CSYNC                          ;Auf Reaktion warten
  call Transfer
  jc @@Timeout
  cmp AH,CSYNC shl 3                    ;Alles au·er SYNC ignorieren
  jne @@Reset
  dec BX                                ;Kamen 5 SYNCs hintereinander?
  jne @@Next
  mov AH,CREADY                         ;Synchronisation abschlie·en
  call Transfer
  jc @@Timeout
  cmp AH,CSYNC shl 3                    ;BestÑtigung ÅberprÅfen
  jne @@Reset
@@Timeout:
  ret
Sync endp

;Byte ausgeben
;Eingabe: AH = auszugebender Wert
;         CL = Letzter Status von BUSY/PA2 in Bit 8, Rest 0
;         DX = Portadresse parallele Schnittstelle
;         DS = 0
;Ausgabe: CL = Neuer Status von BUSY/PA2 in Bit 8, Rest 0
;         CF = Fehler aufgetreten
;éndert:  AX,CH

PutByte proc near
  mov CS:PutSave,AH                     ;Wert fÅr spÑter retten
  and AH,00001111b                      ;Unteres Halbbyte ausgeben
  call Transfer
  jc @@Timeout
  cmp AH,CDATALO shl 3                  ;BestÑtigung ÅberprÅfen
  jne @@Error
  mov AH,-1                             ;Wert zurÅckholen
PutSave equ byte ptr $-1                ;Selbstmodifizierender Code
  shr AH,1                              ;Oberes Halbbyte ausgeben
  shr AH,1
  shr AH,1
  shr AH,1
  call Transfer
  jc @@Timeout
  cmp AH,CDATAHI shl 3                  ;BestÑtigung ÅberprÅfen
  jne @@Error
  ret                                   ;Mit gelîschtem CF zurÅck
@@Error:
  stc                                   ;Fehler zurÅckgeben
@@Timeout:
  ret
PutByte endp

;Byte einlesen
;Eingabe: CL = Letzter Status von BUSY/PA2 in Bit 8, Rest 0
;         DX = Portadresse parallele Schnittstelle
;         DS = 0
;Ausgabe: AH = Eingelesener Wert
;         CL = Neuer Status von BUSY/PA2 in Bit 8, Rest 0
;         CF = Fehler aufgetreten
;éndert:  AL,CH

GetByte proc near
  mov AH,CDATAHI                        ;Unteres Halbbyte einlesen
  call Transfer
  jc @@Timeout
  shr AH,1
  shr AH,1
  shr AH,1
  mov CS:GetSave,AH                     ;Wert fÅr spÑter sichern
  mov AH,CDATALO                        ;Oberes Halbbyte einlesen
  call Transfer
  jc @@Timeout
  shl AH,1                              ;Halbbytes miteinander verknÅpfen
  or AH,-1
GetSave equ byte ptr $-1                ;Selbstmodifizierender Code
@@Timeout:
  ret
GetByte endp

;Datenblock an den C64 senden
L64Send proc uses SI DI,wLpt:word,lpBuffer:dword,iCount:word
  public L64Send
  mov BX,wLpt                           ;Status von BUSY/PA2 holen
  mov CL,L64State[BX]
  mov AL,L64LinkWaits[BX]               ;Wartezyklen Åbertragen
  mov CS:ReceiveWaits,AL
  mov CS:SendWaits,AL
  push DS                               ;Zugriff auf BIOS-Variablen
  xor DX,DX
  mov DS,DX
  shl BX,1                              ;Portadresse holen
  mov DX,DS:[0408h+BX]
  cmp DX,0100h                          ;Schnittstelle vorhanden?
  jb @@Timeout
  test DX,0003h
  jne @@Timeout
  cmp CL,255                            ;Trat letztes Mal ein Fehler auf?
  je @@Reset
@@SyncOk:
  mov AH,CSEND                          ;Auf empfangsbereiten C64 prÅfen
  call Transfer
  jc @@Timeout
  cmp AH,CREADY shl 3
  jne @@Error
  mov BX,iCount                         ;LÑnge des Datenblocks senden
  mov AH,BL
  call PutByte
  jc @@Error
  mov AH,BH
  call PutByte
  jc @@Error
  xor SI,SI                             ;PrÅfsumme initialisieren
  and BX,BX                             ;Sind Daten vorhanden?
  je @@Ready
  les DI,lpBuffer                       ;Pufferadresse holen
@@Next:
  mov AL,ES:[DI]                        ;PrÅfsumme aktualisieren
  add SI,AX
  mov AH,AL                             ;Byte ausgeben
  call PutByte
  jc @@Error
  inc DI                                ;NÑchstes Byte behandeln
  dec BX
  jne @@Next
@@Ready:
  mov AX,SI                             ;PrÅfsumme Åbermitteln
  mov AH,AL
  call PutByte
  jc @@Error
  mov AH,CREADY                         ;Auf BestÑtigung der PrÅfsumme warten
  call Transfer
  jc @@Error
  cmp AH,COK shl 3
  jne @@Error
  mov AX,iCount                         ;Alles in Ordnung
@@Return:
  pop DS                                ;Zustand von BUSY/PA2 sichern
  mov BX,wLpt
  mov L64State[BX],CL
  mov L64Result,AX                      ;RÅckgabewert speichern
  ret
@@Reset:
  call Sync                             ;Neue Synchronisation durchfÅhren
  jnc @@SyncOk
  mov CL,255
@@Timeout:
  mov AX,ETIMEOUT                       ;C64 ist beschÑftigt
  jmp @@Return
@@Error:
  mov CL,255                            ;Neusynchronisation nîtig
  mov AX,ETRANSFER                      ;öbertragungsfehler zurÅckgeben
  jmp @@Return
L64Send endp

;Datenblock vom C64 empfangen
L64Receive proc uses SI DI,wLpt:word,lpBuffer:dword,iCount:word
  public L64Receive
  mov BX,wLpt                           ;Status von BUSY/PA2 holen
  mov CL,L64State[BX]
  mov AL,L64LinkWaits[BX]               ;Wartezyklen Åbertragen
  mov CS:ReceiveWaits,AL
  mov CS:SendWaits,AL
  push DS                               ;Zugriff auf BIOS-Variablen
  xor DX,DX
  mov DS,DX
  shl BX,1                              ;Portadresse holen
  mov DX,DS:[0408h+BX]
  cmp DX,0100h                          ;Schnittstelle vorhanden?
  jb @@Timeout
  test DX,0003h
  jne @@Timeout
  cmp CL,255                            ;Trat letztes Mal ein Fehler auf?
  je @@Reset
@@SyncOk:
  mov AH,CRECEIVE                       ;Auf sendebereiten C64 prÅfen
  call Transfer
  jc @@Timeout
  cmp AH,CREADY shl 3
  jne @@Error
  call GetByte                          ;LÑnge des Datenblocks empfangen
  jc @@Error
  mov BL,AH
  call GetByte
  jc @@Error
  mov BH,AH
  cmp BX,iCount                         ;Mit Puffergrî·e vergleichen
  ja @@Error
  mov iCount,BX                         ;LÑnge fÅr spÑter sichern
  xor SI,SI                             ;PrÅfsumme initialisieren
  and BX,BX                             ;Sind Daten vorhanden?
  je @@Ready
  les DI,lpBuffer                       ;Pufferadresse holen
  clc
@@Next:
  call GetByte                          ;Byte einlesen
  jc @@Error
  mov AL,AH
  stosb
  add SI,AX                             ;PrÅfsumme aktualisieren
  dec BX                                ;NÑchstes Byte behandeln
  jne @@Next
@@Ready:
  call GetByte                          ;PrÅfsumme holen
  jc @@Error
  mov BX,SI                             ;und vergleichen
  cmp AH,BL
  jne @@Error
  mov AH,CREADY                         ;Korrekte PrÅfsumme bestÑtigen
  call Transfer
  jc @@Error
  cmp AH,COK shl 3
  jne @@Error
  mov AX,iCount                         ;Alles in Ordnung
@@Return:
  pop DS                                ;Zustand von BUSY/PA2 sichern
  mov BX,wLpt
  mov L64State[BX],CL
  mov L64Result,AX                      ;RÅckgabewert speichern
  ret
@@Reset:
  call Sync                             ;Neue Synchronisation durchfÅhren
  jnc @@SyncOk
  mov CL,255
@@Timeout:
  mov AX,ETIMEOUT                       ;C64 ist beschÑftigt
  jmp @@Return
@@Error:
  mov CL,255                            ;Neusynchronisation nîtig
  mov AX,ETRANSFER                      ;öbertragungsfehler zurÅckgeben
  jmp @@Return
L64Receive endp

;Stellung des Joysticks abfragen
L64Joystick proc wLpt:word
  public L64Joystick
  xor AX,AX                             ;Zugriff auf BIOS-Variablen
  mov ES,AX
  mov BX,wLpt                           ;Portadresse holen
  shl BX,1
  mov DX,ES:[0408h+BX]
  cmp DX,0100h                          ;Schnittstelle vorhanden?
  jb @@Error
  test DX,0003h
  jne @@Error
  mov BX,wLpt                           ;Auf alternativen Joystickadapter prÅfen
  cmp L64AlternateJoy[BX],1
  jb @@StandardJoy
  je @@AlternateJoy
@@AutoScan:
  in AL,DX                              ;D5/D6 auf 0, ohne Link zu beeinflussen
  and AL,10011111b
  out DX,AL
  jmp $+2
  inc DX                                ;Stellung lesen
  mov CL,L64JoyWaits[BX]
@@Delay5:
  in AL,DX
  dec CL
  jns @@Delay5
  dec DX
  test AL,01100000b                     ;Links/Rechts mÅssen beide 0 sein
  jne @@Standard
  in AL,DX                              ;D5/D6 auf 1, ohne Link zu beeinflussen
  or AL,01100000b
  out DX,AL
  jmp $+2
  inc DX                                ;Stellung lesen
  mov CL,L64JoyWaits[BX]
@@Delay6:
  in AL,DX
  dec CL
  jns @@Delay6
  dec DX
  test AL,01100000b                     ;Links oder Rechts mu· jetzt 1 sein
  je @@Standard
  mov L64AlternateJoy[BX],1
@@AlternateJoy:
  mov AL,11110001b                      ;Pull-Up-WiderstÑnde hochziehen
  out DX,AL
  jmp $+2
  inc DX                                ;Stellung lesen
  in AL,DX
  xor AL,01111000b                      ;Alle au·er Busy sind Low-aktiv
  shr AL,1                              ;Bits an die richtige Stelle schieben
  shr AL,1
  shr AL,1
  xor AH,AH
@@Error:
  mov L64Result,AX                      ;Ergebnisvariable setzen
  ret
@@Standard:
  mov L64AlternateJoy[BX],0
@@StandardJoy:
  mov CH,L64JoyWaits[BX]                ;Wartezyklen holen
  in AL,DX                              ;Links/Rechts/Feuer zurÅcksetzen
  or AL,01110000b
  mov AH,AL
  and AL,10111111b                      ;Feuer abfragen
  out DX,AL
  jmp $+2
  add DL,2                              ;Oben/Unten zurÅcksetzen
  mov AL,00000000b
  out DX,AL
  jmp $+2
  mov CL,CH
@@Delay0:
  in AL,DX                              ;Feuer-Bit holen
  dec CL
  jns @@Delay0
  mov BL,AL
  sub DL,2                              ;Rechts abfragen
  mov AL,AH
  and AL,11011111b
  out DX,AL
  jmp $+2
  add DL,2
  mov CL,CH
@@Delay1:
  in AL,DX                              ;Rechts-Bit holen
  dec CL
  jns @@Delay1
  shr AL,1
  rcl BL,1
  sub DL,2                              ;Links abfragen
  mov AL,AH
  and AL,11101111b
  out DX,AL
  jmp $+2
  add DL,2
  mov CL,CH
@@Delay2:
  in AL,DX                              ;Links-Bit holen
  dec CL
  jns @@Delay2
  shr AL,1
  rcl BL,1
  sub DL,2                              ;Links/Rechts/Feuer zurÅcksetzen
  mov AL,AH
  out DX,AL
  jmp $+2
  add DL,2                              ;Unten abfragen
  mov AL,00001000b
  out DX,AL
  jmp $+2
  mov CL,CH
@@Delay3:
  in AL,DX                              ;Unten-Bit holen
  dec CL
  jns @@Delay3
  shr AL,1
  rcl BL,1
  mov AL,00000010b                      ;Oben abfragen
  out DX,AL
  jmp $+2
@@Delay4:
  in AL,DX                              ;Oben-Bit holen
  dec CH
  jns @@Delay4
  shr AL,1
  rcl BL,1
  mov AL,00000000b                      ;Oben/Unten zurÅcksetzen
  out DX,AL
  jmp $+2
  mov AX,BX                             ;Ergebnis zurÅckliefern
  and AX,0000000000011111b
  mov L64Result,AX                      ;Ergebnisvariable setzen
  ret
L64Joystick endp

end
