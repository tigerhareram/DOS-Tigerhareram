Unit JIDctFst;

{****************************************************************************
 * This file is distributed with GrafX, (c) 1996-2001 by Stefan Goehler,    *
 * Germany - stefan.goehler@gmx.de. It's been optimized by me - you are NOT *
 * allowed to use it without in connection with GrafX and you MUST NOT      *
 * distribute it seperately without my permission.                          *
 * GrafX is available at my homepage:                                       *
 * http://crossfire.home.pages.de                                           *
 * If you are needed to use the jpeg-routines without GrafX, you must use   *
 * the original non-asm-optimized version, which is originally delivered    *
 * with the PasJPEG-package by Jacques Nomssi Nzali -                       *
 * http://www.tu-chemnitz.de/~nomssi/                                       *
 * or contact me for a personal license.                                    *
 ****************************************************************************}

{ This file contains a fast, not so accurate integer implementation of the
  inverse DCT (Discrete Cosine Transform).  In the IJG code, this routine
  must also perform dequantization of the input coefficients.

  A 2-D IDCT can be done by 1-D IDCT on each column followed by 1-D IDCT
  on each row (or vice versa, but it's more convenient to emit a row at
  a time).  Direct algorithms are also available, but they are much more
  complex and seem not to be any faster when reduced to code.

  This implementation is based on Arai, Agui, and Nakajima's algorithm for
  scaled DCT.  Their original paper (Trans. IEICE E-71(11):1095) is in
  Japanese, but the algorithm is described in the Pennebaker & Mitchell
  JPEG textbook (see REFERENCES section in file README).  The following code
  is based directly on figure 4-8 in P&M.
  While an 8-point DCT cannot be done in less than 11 multiplies, it is
  possible to arrange the computation so that many of the multiplies are
  simple scalings of the final outputs.  These multiplies can then be
  folded into the multiplications or divisions by the JPEG quantization
  table entries.  The AA&N method leaves only 5 multiplies and 29 adds
  to be done in the DCT itself.
  The primary disadvantage of this method is that with fixed-point math,
  accuracy is lost due to imprecise representation of the scaled
  quantization values.  The smaller the quantization table entry, the less
  precise the scaled value, so this implementation does worse with high-
  quality-setting files than with low-quality ones. }

{ Original : jidctfst.c ; Copyright (C) 1994-1996, Thomas G. Lane. }


interface

{$I jconfig.inc}

uses
  jmorecfg,
  jinclude,
  jpeglib,
  jdct;   		{ Private declarations for DCT subsystem }


{ Perform dequantization and inverse DCT on one block of coefficients. }

{GLOBAL}
procedure jpeg_idct_ifast (cinfo : j_decompress_ptr;
                           compptr : jpeg_component_info_ptr;
		           coef_block : JCOEFPTR;
		           output_buf : JSAMPARRAY;
                           output_col : JDIMENSION);

implementation

{ This module is specialized to the case DCTSIZE = 8. }

{$ifdef DCTSIZE <> 8}
  Sorry, this code only copes with 8x8 DCTs. { deliberate syntax err }
{$endif}

{ Scaling decisions are generally the same as in the LL&M algorithm;
  see jidctint.c for more details.  However, we choose to descale
  (right shift) multiplication products as soon as they are formed,
  rather than carrying additional fractional bits into subsequent additions.
  This compromises accuracy slightly, but it lets us save a few shifts.
  More importantly, 16-bit arithmetic is then adequate (for 8-bit samples)
  everywhere except in the multiplications proper; this saves a good deal
  of work on 16-bit-int machines.

  The dequantized coefficients are not integers because the AA&N scaling
  factors have been incorporated.  We represent them scaled up by PASS1_BITS,
  so that the first and second IDCT rounds have the same input scaling.
  For 8-bit JSAMPLEs, we choose IFAST_SCALE_BITS = PASS1_BITS so as to
  avoid a descaling shift; this compromises accuracy rather drastically
  for small quantization table entries, but it saves a lot of shifts.
  For 12-bit JSAMPLEs, there's no hope of using 16x16 multiplies anyway,
  so we use a much larger scaling factor to preserve accuracy.

  A final compromise is to represent the multiplicative constants to only
  8 fractional bits, rather than 13.  This saves some shifting work on some
  machines, and may also reduce the cost of multiplication (since there
  are fewer one-bits in the constants). }

{$ifdef BITS_IN_JSAMPLE_IS_8}
const
  CONST_BITS = 8;
  PASS1_BITS = 2;
{$else}
  CONST_BITS = 8;
  PASS1_BITS = 1;	{ lose a little precision to avoid overflow }
{$endif}


{ Convert a positive real constant to an integer scaled by CONST_SCALE. }
const
  ONE   = INT32(1);
  CONST_SCALE = INT32(ONE shl CONST_BITS);
const
  FIX_1_082392200 : INT32 = Round(CONST_SCALE*1.082392200);  {277}
  FIX_1_414213562 : INT32 = Round(CONST_SCALE*1.414213562); {362}
  FIX_1_847759065 : INT32 = Round(CONST_SCALE*1.847759065);  {473}
  FIX_2_613125930 : INT32 = Round(CONST_SCALE*2.613125930);  {669}


{ Descale and correctly round an INT32 value that's scaled by N bits.
  We assume RIGHT_SHIFT rounds towards minus infinity, so adding
  the fudge factor is correct for either sign of X. }

(*function DESCALE(x : INT32; n : int) : INT32;
var
  shift_temp : INT32;
begin
{$ifdef USE_ACCURATE_ROUNDING}
  shift_temp := x + (ONE shl (n-1));
{$else}
{ We can gain a little more speed, with a further compromise in accuracy,
  by omitting the addition in a descaling shift.  This yields an incorrectly
  rounded result half the time... }
  shift_temp := x;
{$endif}

{$ifdef RIGHT_SHIFT_IS_UNSIGNED}
  if shift_temp < 0 then
    Descale :=  (shift_temp shr n) or ((not INT32(0)) shl (32-n))
  else
{$endif}
    Descale :=  (shift_temp shr n);

end;*)


{ Multiply a DCTELEM variable by an INT32 constant, and immediately
  descale to yield a DCTELEM result. }

  {(DCTELEM( DESCALE((var) * (const), CONST_BITS))}
(*  function Multiply(Avar, Aconst: INT32):DCTELEM;assembler;
  asm
    db 66h;mov  ax,word ptr avar
    db 66h;mul  word ptr aconst
    db 66h;sar  ax,8 {CONST_BITS}
  end;*)

{  function Multiply(Avar, Aconst: Integer):DCTELEM;
  begin
    Multiply := DCTELEM( Avar*INT32(Aconst) div CONST_SCALE);
  end;}



{ Dequantize a coefficient by multiplying it by the multiplier-table
  entry; produce a DCTELEM result.  For 8-bit data a 16x16->16
  multiplication will do.  For 12-bit data, the multiplier table is
  declared INT32, so a 32-bit multiply will be used. }

{$ifdef BITS_IN_JSAMPLE_IS_8}
{  function DEQUANTIZE(coef,quantval : int) : int;assembler;
  asm
    mov  ax,coef
    mul  quantval
  end;}

{  function DEQUANTIZE(coef,quantval : int) : int;
  begin
    Dequantize := ( IFAST_MULT_TYPE(coef) * quantval);
  end;}

{$else}
#define DEQUANTIZE(coef,quantval)  \
	DESCALE((coef)*(quantval), IFAST_SCALE_BITS-PASS1_BITS)
{$endif}


{ Like DESCALE, but applies to a DCTELEM and produces an int.
  We assume that int right shift is unsigned if INT32 right shift is. }

(*function IDESCALE(x : DCTELEM; n : int) : int;
{$ifdef BITS_IN_JSAMPLE_IS_8}
const
  DCTELEMBITS = 16;	{ DCTELEM may be 16 or 32 bits }
{$else}
const
  DCTELEMBITS = 32;	{ DCTELEM must be 32 bits }
{$endif}
var
  ishift_temp : DCTELEM;
begin
{$ifndef USE_ACCURATE_ROUNDING}
  ishift_temp := x + (ONE shl (n-1));
{$else}
{ We can gain a little more speed, with a further compromise in accuracy,
  by omitting the addition in a descaling shift.  This yields an incorrectly
  rounded result half the time... }
  ishift_temp := x;
{$endif}

{$ifdef RIGHT_SHIFT_IS_UNSIGNED}
  if ishift_temp < 0 then
    IDescale :=  (ishift_temp shr n)
             or ((not DCTELEM(0)) shl (DCTELEMBITS-n))
  else
{$endif}
    IDescale :=  (ishift_temp shr n);
end;*)

(*function IDESCALE(x : INT32; n : int) : INT32;assembler;
asm
  db 66h;mov  ax,word ptr x
{$ifdef USE_ACCURATE_ROUNDING}
         mov  cl,4
  db 66h,0BBh,01h,00h,00h,00h {mov ebx,1}
  db 66h;shl  bx,cl
  db 66h;add  ax,bx
{$endif}
    db 66h;sar  ax,5
end;*)


{ Perform dequantization and inverse DCT on one block of coefficients. }

{GLOBAL}
procedure jpeg_idct_ifast(cinfo : j_decompress_ptr;
                          compptr : jpeg_component_info_ptr;
		          coef_block : JCOEFPTR;
		          output_buf : JSAMPARRAY;
                          output_col : JDIMENSION);
type
  PWorkspace = ^TWorkspace;
  TWorkspace = coef_bits_field; { buffers data between passes }
var
{  tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7 : DCTELEM;
  tmp10, tmp11, tmp12, tmp13 : DCTELEM;}
  tmp : array[0..13] of DCTELEM;
  z5, z10, z11, z12, z13 : DCTELEM;
  inptr : JCOEFPTR;
  quantptr : IFAST_MULT_TYPE_FIELD_PTR;
  wsptr : PWorkspace;
  outptr : JSAMPROW;
  range_limit : JSAMPROW;
  ctr : int;
  workspace : TWorkspace;        { buffers data between passes }
  {SHIFT_TEMPS			{ for DESCALE }
  {ISHIFT_TEMPS			{ for IDESCALE }
var
  dcval : int;
var
  dcval_ : JSAMPLE;
label
  jump2,restart,loopend;
begin
{ Each IDCT routine is responsible for range-limiting its results and
  converting them to unsigned form (0..MAXJSAMPLE).  The raw outputs could
  be quite far out of range if the input data is corrupt, so a bulletproof
  range-limiting step is required.  We use a mask-and-table-lookup method
  to do the combined operations quickly.  See the comments with
  prepare_range_limit_table (in jdmaster.c) for more info. }

  range_limit := JSAMPROW(@(cinfo^.sample_range_limit^[CENTERJSAMPLE]));
  { Pass 1: process columns from input, store into work array. }

  inptr := coef_block;
  quantptr := IFAST_MULT_TYPE_FIELD_PTR(compptr^.dct_table);
  wsptr := @workspace;
    { Due to quantization, we will usually find that many of the input
      coefficients are zero, especially the AC terms.  We can exploit this
      by short-circuiting the IDCT calculation for any column in which all
      the AC terms are zero.  In that case each output is equal to the
      DC coefficient (with scale factor as needed).
      With typical images and quantization tables, half or more of the
      column DCT calculations can be simplified this way. }

    asm
{  for ctr := pred(DCTSIZE) downto 0 do
  begin}
      mov  ax,dctsize
      mov  ctr,ax

      @loopstart:
{$ifndef NO_ZERO_ROW_TEST}
{    if ((inptr^[DCTSIZE*1]) or (inptr^[DCTSIZE*2]) or (inptr^[DCTSIZE*3]) or
        (inptr^[DCTSIZE*4]) or (inptr^[DCTSIZE*5]) or (inptr^[DCTSIZE*6]) or
        (inptr^[DCTSIZE*7]) = 0) then
    begin}
      les  di,inptr
      mov  cx,7
      mov  bx,DCTSIZE
      add  bx,bx
      xor  ax,ax
      @lp:
        add  di,bx
        cmp  word ptr es:[di],0
        jne  @jump1
      dec  cx
      jnz  @lp
      { AC terms all zero }
{      int(dcval) := int(DEQUANTIZE(inptr^[DCTSIZE*0], quantptr^[DCTSIZE*0]));}

{      wsptr^[DCTSIZE*0..7] := dcval;}
{      asm}
{        les  di,inptr}
        mov  ax,es:[di-7*16]
        les  di,quantptr
        mul  word ptr es:[di]

        les  di,wsptr
        mov  bx,dctsize
        mov  cx,8
        add  bx,bx
        @lp2:
          mov  es:[di],ax
          add  di,bx
          dec  cx
        jnz  @lp2
{      Inc(JCOEF_PTR(inptr));		{ advance pointers to next column }
        add  word ptr inptr,2
{      Inc(IFAST_MULT_TYPE_PTR(quantptr));}
        add  word ptr quantptr,2
{      Inc(int_ptr(wsptr));}
        add  word ptr wsptr,2
        jmp  @loopend
{     end;
      continue;
{    end;}
{    asm
    { Even part }
{$endif}
{    tmp[0..3] := DEQUANTIZE(inptr^[DCTSIZE*0,2,4,6], quantptr^[DCTSIZE*0,2,4,6]);}
@jump1:
      les  di,inptr
      mov  ax,es
      db   8Eh,0E8h {mov gs,ax}
      les  bx,quantptr
      xor  si,si
      mov  cx,4
      @lp3:
        db   65h,8Bh,05h {mov ax,gs:[di]}
        mul  word ptr es:[bx]
        mov  word ptr tmp[si],ax
        add  bx,32
        add  di,32
        add  si,2
      dec  cx
      jnz  @lp3

{    tmp[10] := tmp[0] + tmp[2];	{ phase 3 }
 {   tmp[11] := tmp[0] - tmp[2];}
      mov  ax,word ptr tmp[0]
      mov  cx,ax
      mov  bx,word ptr tmp[4]
      add  ax,bx
      mov  word ptr tmp[20],ax          { phase 3 }
      sub  cx,bx
      mov  word ptr tmp[22],cx
{    tmp[13] := tmp[1] + tmp[3];	{ phases 5-3 }
{    tmp[12] := MULTIPLY(tmp[1] - tmp[3], FIX_1_414213562) - tmp[13]; { 2*c4 }
      mov  cx,word ptr tmp[2]
      mov  ax,cx
      mov  bx,word ptr tmp[6]
      add  cx,bx
      mov  word ptr tmp[26],cx          { phases 5-3 }
      sub  ax,bx
      db   66h,0Fh,0BFh,0C0h            { movsx eax,ax }
      db   66h;mul  word ptr FIX_1_414213562
      db   66h;sar  ax,8
      sub  ax,word ptr tmp[26]
      mov  word ptr tmp[24],ax          { 2*c4 }
{    tmp[0] := tmp[10] + tmp[13];{ phase 2 }
{    tmp[3] := tmp[10] - tmp[13];}
      mov  ax,word ptr tmp[20]
      mov  cx,ax
      mov  bx,word ptr tmp[26]
      add  ax,bx
      mov  word ptr tmp[0],ax{ phase 2 }
      sub  cx,bx
      mov  word ptr tmp[6],cx
{    tmp[1] := tmp[11] + tmp[12];
    tmp[2] := tmp[11] - tmp[12];}
      mov  ax,word ptr tmp[22]
      mov  cx,ax
      mov  bx,word ptr tmp[24]
      add  ax,bx
      mov  word ptr tmp[2],ax
      sub  cx,bx
      mov  word ptr tmp[4],cx

    { Odd part }

{    tmp[4] := DEQUANTIZE(inptr^[DCTSIZE*1], quantptr^[DCTSIZE*1]);
    tmp[5] := DEQUANTIZE(inptr^[DCTSIZE*3], quantptr^[DCTSIZE*3]);
    tmp[6] := DEQUANTIZE(inptr^[DCTSIZE*5], quantptr^[DCTSIZE*5]);
    tmp[7] := DEQUANTIZE(inptr^[DCTSIZE*7], quantptr^[DCTSIZE*7]);}
      les  di,inptr
      add  di,16
      mov  ax,es
      db   8Eh,0E8h {mov gs,ax}
      les  bx,quantptr
      add  bx,16
      mov  si,8
      mov  cx,4
      @lp4:
        db   65h,8Bh,05h {mov ax,gs:[di]}
        mul  word ptr es:[bx]
        mov  word ptr tmp[si],ax
        add  bx,32
        add  di,32
        add  si,2
      dec  cx
      jnz  @lp4

{    z13 := tmp[6] + tmp[5];		{ phase 6 }
 {   z10 := tmp[6] - tmp[5];}
      mov  ax,word ptr tmp[12]
      mov  cx,ax
      mov  bx,word ptr tmp[10]
      add  ax,bx
      mov  si,ax{z13}
{      mov  z13,ax}
      sub  cx,bx
{      mov  z10,cx}

{    z11 := tmp[4] + tmp[7];
    z12 := tmp[4] - tmp[7];}
      mov  di,cx {z10}
      mov  ax,word ptr tmp[8]
      mov  cx,ax
      mov  bx,word ptr tmp[14]
      add  ax,bx
{      mov  z11,ax}
      sub  cx,bx
{      mov  z12,cx}
      mov  cx,ax  {z12}
      mov  bx,si  {z13}
      mov  si,ax
{    tmp[7] := z11 + z13;		{ phase 5 }
      add  cx,bx
      sub  ax,bx
      mov  word ptr tmp[14],cx          { phase 5 }
{    tmp[11] := MULTIPLY(z11 - z13, FIX_1_414213562); { 2*c4 }
      db   66h,0Fh,0BFh,0C0h            { movsx eax,ax }
      db   66h;mul  word ptr FIX_1_414213562
      db   66h;sar  ax,8
      mov  word ptr tmp[22],ax          { 2*c4 }
{    z5 := MULTIPLY(z10 + z12, FIX_1_847759065); { 2*c2 }
      db   66h,0Fh,0BFh,0FFh {movsx  edi,di}
      db   66h,0Fh,0BFh,0F6h {movsx  esi,si}
      db   66h;mov  ax,di  {z10}
      db   66h;add  ax,si  {z12}
{      db   66h,0Fh,0BFh,0C0h            { movsx eax,ax }
      db   66h;mul  word ptr FIX_1_847759065 { 2*c2 }
      db   66h;sar  ax,8

{    tmp[10] := MULTIPLY(z12, FIX_1_082392200) - z5; { 2*(c2-c6) }
      mov  cx,ax  {z5}
{      mov  z5,ax}
      db   66h;mov  ax,si  {z12}
{      db   66h,0Fh,0BFh,0C0h            { movsx eax,ax }
      db   66h;mul  word ptr FIX_1_082392200 { 2*(c2-c6) }
      db   66h;sar  ax,8
      sub  ax,cx
      mov  word ptr tmp[20],ax

{    tmp[12] := MULTIPLY(z10, - FIX_2_613125930) + z5; { -2*(c2+c6) }
      db   66h;mov  bx,word ptr FIX_2_613125930
      db   66h;mov  ax,di  {z10}
{      db   66h,0Fh,0BFh,0C0h            { movsx eax,ax }
      db   66h;neg  bx
      db   66h;mul  bx { -2*(c2+c6) }
      db   66h;sar  ax,8
      add  ax,cx
      mov  word ptr tmp[24],ax

{    tmp[6] := tmp[12] - tmp[7];	{ phase 2 }
      mov  ax,word ptr tmp[24]
      sub  ax,word ptr tmp[14]
      mov  word ptr tmp[12],ax
{    tmp[5] := tmp[11] - tmp[6];}
      mov  ax,word ptr tmp[22]
      sub  ax,word ptr tmp[12]
      mov  word ptr tmp[10],ax
{    tmp[4] := tmp[10] + tmp[5];}
      mov  ax,word ptr tmp[20]
      add  ax,word ptr tmp[10]
      mov  word ptr tmp[8],ax

      les  di,wsptr
{    wsptr^[DCTSIZE*0] := int(tmp[0] + tmp[7]);}
{    wsptr^[DCTSIZE*7] := int(tmp[0] - tmp[7]);}
      mov  ax,word ptr tmp[0]
      mov  cx,ax
      mov  bx,word ptr tmp[14]
      add  ax,bx
      mov  es:[di],ax
      sub  cx,bx
      mov  es:[di+112],cx
{    wsptr^[DCTSIZE*1] := int(tmp[1] + tmp[6]);}
{    wsptr^[DCTSIZE*6] := int(tmp[1] - tmp[6]);}
      mov  ax,word ptr tmp[2]
      mov  cx,ax
      mov  bx,word ptr tmp[12]
      add  ax,bx
      mov  es:[di+16],ax
      sub  cx,bx
      mov  es:[di+96],cx
{    wsptr^[DCTSIZE*2] := int(tmp[2] + tmp[5]);}
{    wsptr^[DCTSIZE*5] := int(tmp[2] - tmp[5]);}
      mov  ax,word ptr tmp[4]
      mov  cx,ax
      mov  bx,word ptr tmp[10]
      add  ax,bx
      mov  es:[di+32],ax
      sub  cx,bx
      mov  es:[di+80],cx
{    wsptr^[DCTSIZE*4] := int(tmp[3] + tmp[4]);}
{    wsptr^[DCTSIZE*3] := int(tmp[3] - tmp[4]);}
      mov  ax,word ptr tmp[6]
      mov  cx,ax
      mov  bx,word ptr tmp[8]
      add  ax,bx
      mov  es:[di+64],ax
      sub  cx,bx
      mov  es:[di+48],cx
{      Inc(JCOEF_PTR(inptr));		{ advance pointers to next column }
      add  word ptr inptr,2
{      Inc(IFAST_MULT_TYPE_PTR(quantptr));}
      add  word ptr quantptr,2
{      Inc(int_ptr(wsptr));}
      add  word ptr wsptr,2
@loopend:
      dec  ctr
    jnz   @loopstart
    end;
{  end;}

  { Pass 2: process rows from work array, store into output array. }
  { Note that we must descale the results by a factor of 8 == 2**3, }
  { and also undo the PASS1_BITS scaling. }

  wsptr := @workspace;
  for ctr := 0 to pred(DCTSIZE) do
  begin
    restart:
    outptr := JSAMPROW(@output_buf^[ctr]^[output_col]);
    { Rows of zeroes can be exploited in the same way as we did with columns.
      However, the column calculation has created many nonzero AC terms, so
      the simplification applies less often (typically 5% to 10% of the time).
      On machines with very fast multiplication, it's possible that the
      test takes more time than it's worth.  In that case this section
      may be commented out. }

    asm
{    outptr := JSAMPROW(@output_buf^[ctr]^[output_col]);}
{      les  di,output_buf}
{      mov  di,seg output_buf
      mov  es,di
      mov  di,offset output_buf
      add  di,ctr
      lea  ax,es:[di]
      mov  word ptr outptr,di
      mov  word ptr outptr[2],es}
{$ifndef NO_ZERO_ROW_TEST}
{    if ((wsptr^[1]) or (wsptr^[2]) or (wsptr^[3]) or (wsptr^[4]) or (wsptr^[5]) or
        (wsptr^[6]) or (wsptr^[7]) = 0) then}

      les  di,wsptr
      mov  cx,7
      add  bx,bx
      xor  ax,ax
      @lp:
        add  di,2
        cmp  word ptr es:[di],0
        jne  jump2
      dec  cx
      jnz  @lp
{    end;}

{    begin}
      { AC terms all zero }
{      asm}
{      JSAMPLE(dcval_) := range_limit^[IDESCALE(wsptr^[0], PASS1_BITS+3)
                          and RANGE_MASK];}
        les  di,wsptr
        mov  ax,es:[di]
        sar  ax,5
        les  di,range_limit
        add  di,ax
        mov  ax,es:[di]
        and  ax,range_mask

{      outptr^[0..7] := dcval_;}
        les  di,outptr
{        mov  al,dcval_}
        mov  cx,4
        mov  ah,al
        rep  stosw
{      Inc(int_ptr(wsptr), DCTSIZE);	{ advance pointer to next row }
        add  word ptr wsptr,16
{      end;
      continue;}
      mov   ax,ctr
      inc   ax
      mov   ctr,ax
      cmp   ax,dctsize
      jb    restart
      jmp   loopend

{    end;}
{$endif}
{    asm
    { Even part }
      jump2:

      les  di,wsptr
{    tmp[10] := (DCTELEM(wsptr^[0]) + DCTELEM(wsptr^[4]));
    tmp[11] := (DCTELEM(wsptr^[0]) - DCTELEM(wsptr^[4]));}
      mov  ax,es:[di]
      mov  dx,es:[di+8]
      mov  cx,ax
      add  ax,dx
      sub  cx,dx
      mov  word ptr tmp[20],ax
      mov  word ptr tmp[22],cx
{    tmp[13] := (DCTELEM(wsptr^[2]) + DCTELEM(wsptr^[6]));}

      mov  cx,es:[di+4]
      mov  dx,es:[di+12]
      mov  ax,cx
      add  cx,dx
      sub  ax,dx
      mov  word ptr tmp[26],cx

{    tmp[12] := MULTIPLY(DCTELEM(wsptr^[2]) - DCTELEM(wsptr^[6]), FIX_1_414213562)
	    - tmp[13];}
      db   66h,0Fh,0BFh,0C0h            { movsx eax,ax }
      db   66h;mul  word ptr FIX_1_414213562
      db   66h;sar  ax,8
      sub  ax,word ptr tmp[26]
      mov  word ptr tmp[24],ax
{    tmp[0] := tmp[10] + tmp[13];
    tmp[3] := tmp[10] - tmp[13];}
      mov  ax,word ptr tmp[20]
      mov  cx,ax
      mov  dx,word ptr tmp[26]
      add  ax,dx
      mov  word ptr tmp[0],ax
      sub  cx,dx
      mov  word ptr tmp[6],cx
{    tmp[1] := tmp[11] + tmp[12];
    tmp[2] := tmp[11] - tmp[12];}
      mov  ax,word ptr tmp[22]
      mov  dx,word ptr tmp[24]
      mov  cx,ax
      add  ax,dx
      sub  cx,dx
      mov  word ptr tmp[2],ax
      mov  word ptr tmp[4],cx

    { Odd part }
{    z13 := DCTELEM(wsptr^[5]) + DCTELEM(wsptr^[3]);
    z10 := DCTELEM(wsptr^[5]) - DCTELEM(wsptr^[3]);}
      mov  ax,es:[di+10]
      mov  dx,es:[di+6]
      mov  cx,ax
      add  ax,dx
      sub  cx,dx
      mov  z13,ax
      mov  si,ax
      mov  z10,cx
      mov  bx,cx
{    z11 := DCTELEM(wsptr^[1]) + DCTELEM(wsptr^[7]);
    z12 := DCTELEM(wsptr^[1]) - DCTELEM(wsptr^[7]);}
      mov  ax,es:[di+2]
      mov  dx,es:[di+14]
      mov  cx,ax
      add  ax,dx
      sub  cx,dx
      mov  z11,ax
      mov  z12,cx
{    tmp[7] := z11 + z13;		{ phase 5 }
      mov  cx,ax
      sub  ax,si
      add  cx,si
      db   66h,0Fh,0BFh,0C0h            { movsx eax,ax }
      mov  word ptr tmp[14],cx
{    tmp[11] := MULTIPLY(z11 - z13, FIX_1_414213562); { 2*c4 }
      db   66h;mul  word ptr FIX_1_414213562 { 2*c4 }
      db   66h;sar  ax,8
      mov  word ptr tmp[22],ax
{    z5 := MULTIPLY(z10 + z12, FIX_1_847759065); { 2*c2 }
      mov  si,z12
      db   66h,0Fh,0BFh,0DBh {movsx  ebx,bx}
      db   66h,0Fh,0BFh,0F6h {movsx  esi,si}
      db   66h;mov  ax,bx {z10}
      db   66h;add  ax,si {+z12}
      db   66h;mul  word ptr FIX_1_847759065 { 2*c2 }
      db   66h;sar  ax,8
      mov  z5,ax
      mov  cx,ax
{    tmp[10] := MULTIPLY(z12, FIX_1_082392200) - z5; { 2*(c2-c6) }
      db   66h;mov  ax,si {z12}
      db   66h;mul  word ptr FIX_1_082392200 { 2*(c2-c6) }
      db   66h;sar  ax,8
      sub  ax,cx {-z5}
      mov  word ptr tmp[20],ax
{    tmp[12] := MULTIPLY(z10, - FIX_2_613125930) + z5; { -2*(c2+c6) }
      db   66h;mov  ax,bx {z10}
      db   66h;mov  bx,word ptr FIX_2_613125930
      db   66h;neg  bx
      db   66h;mul  bx                          { -2*(c2+c6) }
      db   66h;sar  ax,8
      add  ax,cx {+z5}
      mov  word ptr tmp[24],ax
{    tmp[6] := tmp[12] - tmp[7];	{ phase 2 }
      mov  ax,word ptr tmp[24]
      sub  ax,word ptr tmp[14]
      mov  word ptr tmp[12],ax
{    tmp[5] := tmp[11] - tmp[6];}
      mov  ax,word ptr tmp[22]
      sub  ax,word ptr tmp[12]
      mov  word ptr tmp[10],ax
{    tmp[4] := tmp[10] + tmp[5];}
      mov  ax,word ptr tmp[20]
      add  ax,word ptr tmp[10]
      mov  word ptr tmp[8],ax
    { Final output stage: scale down by a factor of 8 and range-limit }
      les  di,range_limit
      mov  ax,es
      db   8Eh,0E8h {mov gs,ax}
      les  si,outptr

{    outptr^[0] := range_limit^[IDESCALE(tmp[0] + tmp[7], PASS1_BITS+3)
			    and RANGE_MASK];}
      mov  dx,word ptr tmp[0]
      mov  bx,word ptr tmp[14]
      mov  cx,dx
      add  dx,bx
      sar  dx,5
      add  di,dx
      db   65h,8Bh,05h {mov ax,gs:[di]}
      sub  di,dx
      mov  es:[si],al
{    outptr^[7] := range_limit^[IDESCALE(tmp[0] - tmp[7], PASS1_BITS+3)
			    and RANGE_MASK];}
      sub  cx,bx
      sar  cx,5
      add  di,cx
      db   65h,8Bh,05h {mov ax,gs:[di]}
      sub  di,cx
      mov  es:[si+7],al

{    outptr^[1] := range_limit^[IDESCALE(tmp[1] + tmp[6], PASS1_BITS+3)
			    and RANGE_MASK];}
      mov  dx,word ptr tmp[2]
      mov  cx,dx
      mov  bx,word ptr tmp[12]
      add  dx,bx
      sar  dx,5
      add  di,dx
      db   65h,8Bh,05h {mov ax,gs:[di]}
      sub  di,dx
      mov  es:[si+1],al
{    outptr^[6] := range_limit^[IDESCALE(tmp[1] - tmp[6], PASS1_BITS+3)
 			    and RANGE_MASK];}
      sub  cx,bx
      sar  cx,5
      add  di,cx
      db   65h,8Bh,05h {mov ax,gs:[di]}
      sub  di,cx
      mov  es:[si+6],al

{    outptr^[2] := range_limit^[IDESCALE(tmp[2] + tmp[5], PASS1_BITS+3)
			    and RANGE_MASK];}
      mov  dx,word ptr tmp[4]
      mov  bx,word ptr tmp[10]
      mov  cx,dx
      add  dx,bx
      sar  dx,5
      add  di,dx
      db   65h,8Bh,05h {mov ax,gs:[di]}
      sub  di,dx
      mov  es:[si+2],al
{    outptr^[5] := range_limit^[IDESCALE(tmp[2] - tmp[5], PASS1_BITS+3)
			    and RANGE_MASK];}
      sub  cx,bx
      sar  cx,5
      add  di,cx
      db   65h,8Bh,05h {mov ax,gs:[di]}
      sub  di,cx
      mov  es:[si+5],al

{    outptr^[4] := range_limit^[IDESCALE(tmp[3] + tmp[4], PASS1_BITS+3)
			    and RANGE_MASK];}
      mov  dx,word ptr tmp[6]
      mov  bx,word ptr tmp[8]
      mov  cx,dx
      add  dx,bx
      sar  dx,5
      add  di,dx
      db   65h,8Bh,05h {mov ax,gs:[di]}
      sub  di,dx
      mov  es:[si+4],al
{    outptr^[3] := range_limit^[IDESCALE(tmp[3] - tmp[4], PASS1_BITS+3)
			    and RANGE_MASK];}
      sub  cx,bx
      sar  cx,5
      add  di,cx
      db   65h,8Bh,05h {mov ax,gs:[di]}
      sub  di,cx
      mov  es:[si+3],al
{      Inc(int_ptr(wsptr), DCTSIZE);	{ advance pointer to next row }
      add  word ptr wsptr,16
    end;
  end;
  loopend:
end;

end.

----------------------------------------------------------------------
Nomssi: Feig Method

type
  matasm  = array[0..DCTSIZE2-1] of integer;
  bmatrix  = array[0..DCTSIZE2-1] of byte;
  bmatrixptr = ^bmatrix;

const
  FIX_1_082392200 = INT32(Round(CONST_SCALE*1.082392200));  {277}
  FIX_1_414213562 = INT32(Round(CONST_SCALE*1.414213562));  {362}
  FIX_1_847759065 = INT32(Round(CONST_SCALE*1.847759065));  {473}
  FIX_2_613125930 = INT32(Round(CONST_SCALE*2.613125930));  {669}

procedure ANN_IDCT(count : integer;
                   var coeffs :matasm;
                   var outptr :bmatrix);

Const
  CONST_IC4 = 1.414213562; { 1/0.707106781; }
  FP_IC4    = FIX_1_414213562;
  FP_I_C4_2 = FP_IC4;

  Function Descale(x : integer):byte;
  var y : integer;
  begin
    y := (x + (1 shl (16-1))+ (4 shl PASS_BITS)) div (8 shl PASS_BITS);
    { DeScale := x sar (3 + PASS_BITS);
      Borland Pascal SHR is unsigned }
    if y < 0 then
      descale := 0
    else
      if y > $ff then
        descale := $ff
      else
        descale := y;
  end;

  function Multiply(X, Y: Integer): integer; assembler;
  asm
    mov ax, X
    imul Y
    mov al, ah
    mov ah, dl
  end;


var
  z10, z11, z12, z13,
  tmp0,tmp1,tmp2,tmp3,
  tmp4,tmp5,tmp6,tmp7,
  tmp10,tmp11,
  tmp12,tmp13 : integer;
  column, row : byte;

  Procedure N1(var x, y : integer);   { rotator 1 }
  Const
    FP_a5 = FIX_1_847759065;
    FP_a4 = FIX_2_613125930;
    FP_a2 = FIX_1_082392200;
  var
    z5, tmp : integer;
  begin
    tmp := x;

    z5 := Multiply(tmp + y, FP_a5);  { c6 }
    x := Multiply(y, FP_a2) - z5;  { c2-c6 }
    y := Multiply(tmp, -FP_a4) + z5;  { c2+c6 }
  end;

  Procedure N2(var x, y : integer); { N1 scaled by c4 }
  Const
    FP_b5 = Integer(Round(CONST_SCALE*1.847759065*CONST_IC4));
    FP_b4 = Integer(Round(CONST_SCALE*2.613125930*CONST_IC4));
    FP_b2 = Integer(Round(CONST_SCALE*1.082392200*CONST_IC4));
  var
    z5, tmp : integer;
  begin
    tmp := x;

    z5 := Multiply(tmp + y, FP_b5);
    x := Multiply(y, FP_b2) - z5;
    y := Multiply(tmp,-FP_b4) + z5;
  end;
Const
  RowSize = 8;
var
  a, b : integer;

  sample : ^matasm;
  bbo : bmatrixptr;

  num : integer;
begin
  sample := @coeffs;
  bbo := @outptr;
  for num := 0 to Pred(count) do
  begin
    { R1 x R1 }
    for column := 7 downto 0 do
    BEGIN
      tmp5 := sample^[1*RowSize + column];

      sample^[1*RowSize + column] := sample^[4*RowSize + column];

      tmp7 := sample^[3*RowSize + column];

      a := sample^[2*RowSize + column];
      b := sample^[6*RowSize + column];
      sample^[2*RowSize + column] := a - b;
      sample^[3*RowSize + column] := a + b;

      a := sample^[5*RowSize + column];
      sample^[4*RowSize + column] := a - tmp7;
      z13 := a + tmp7;

      b := sample^[7*RowSize + column];
      sample^[6*RowSize + column] := tmp5 - b;
      z11 := tmp5 + b;

      sample^[5*RowSize + column] := z11 - z13;
      sample^[7*RowSize + column] := z11 + z13;
    END;

    for row := 7 downto 0 do
    BEGIN
      tmp5 := sample^[row*RowSize + 1];

      sample^[row*RowSize + 1] := sample^[row*RowSize + 4];

      tmp7 := sample^[row*RowSize + 3];

      a := sample^[row*RowSize + 2];
      b := sample^[row*RowSize + 6];
      sample^[row*RowSize + 2] := a - b;
      sample^[row*RowSize + 3] := a + b;

      a := sample^[row*RowSize + 5];
      sample^[row*RowSize + 4] := a - tmp7;
      z13 := a + tmp7;

      b := sample^[row*RowSize + 7];
      sample^[row*RowSize + 6] := tmp5 - b;
      z11 := tmp5 + b;

      sample^[row*RowSize + 5] := z11 - z13;
      sample^[row*RowSize + 7] := z11 + z13;
    END;

    { M x M tensor }
    for row := 0 to 7 do
    Case row of
    0,1,3,7: { M1 }
      begin
        sample^[row*RowSize + 2] := Multiply(sample^[row*RowSize + 2], FP_IC4);     { 2/c4 }
        sample^[row*RowSize + 5] := Multiply(sample^[row*RowSize + 5], FP_IC4);     { 2/c4 }

        N1(sample^[row*RowSize +  4], sample^[row*RowSize +  6]);
      end;
    2,5: { M2 }
      begin
        sample^[row*RowSize + 0] := Multiply(sample^[row*RowSize + 0], FP_IC4);
        sample^[row*RowSize + 1] := Multiply(sample^[row*RowSize + 1], FP_IC4);
        sample^[row*RowSize + 3] := Multiply(sample^[row*RowSize + 3], FP_IC4);
        sample^[row*RowSize + 7] := Multiply(sample^[row*RowSize + 7], FP_IC4);

        sample^[row*RowSize + 2] := sample^[row*RowSize + 2] * 2;  { shift }
        sample^[row*RowSize + 5] := sample^[row*RowSize + 5] * 2;

        N2(sample^[row*RowSize + 4], sample^[row*RowSize + 6]);
      end;
    end; { Case }

    { M x N tensor }
    { rows 4,6 }
    begin
      N1(sample^[4*RowSize + 0], sample^[6*RowSize + 0]);
      N1(sample^[4*RowSize + 1], sample^[6*RowSize + 1]);
      N1(sample^[4*RowSize + 3], sample^[6*RowSize + 3]);
      N1(sample^[4*RowSize + 7], sample^[6*RowSize + 7]);

      N2(sample^[4*RowSize + 2], sample^[6*RowSize + 2]);
      N2(sample^[4*RowSize + 5], sample^[6*RowSize + 5]);

      { N3 }
      { two inverse matrices => same as FDCT }
      tmp0 := sample^[4*RowSize + 4];
      tmp3 := sample^[6*RowSize + 6];
      tmp12 := (tmp0 + tmp3) * 2;
      z10 := tmp0 - tmp3;

      tmp1 := sample^[6*RowSize + 4];
      tmp2 := sample^[4*RowSize + 6];
      tmp13 :=-(tmp1 - tmp2)*2;
      z11 := tmp1 + tmp2;

      tmp0 := Multiply(z10 + z11, FP_I_C4_2);
      tmp1 := Multiply(z10 - z11, FP_I_C4_2);


      sample^[4*RowSize + 4] := tmp12 + tmp0;
      sample^[6*RowSize + 4] := tmp1 + tmp13;

      sample^[4*RowSize + 6] := tmp1 - tmp13;
      sample^[6*RowSize + 6] := tmp12 - tmp0;
    end;

    { R2 x R2 }

    for row := 0 to 7 do
    BEGIN
      { Odd part }
      tmp7 := sample^[row*RowSize + 7];
      tmp6 := sample^[row*RowSize + 6] - tmp7;
      tmp5 := sample^[row*RowSize + 5] - tmp6;
      tmp4 :=-sample^[row*RowSize + 4] - tmp5;

      { even part }
      tmp0 := sample^[row*RowSize + 0];
      tmp1 := sample^[row*RowSize + 1];
      tmp10 := tmp0 + tmp1;
      tmp11 := tmp0 - tmp1;

      tmp2 := sample^[row*RowSize + 2];
      tmp13 := sample^[row*RowSize + 3];
      tmp12 := tmp2 - tmp13;

      tmp0 := tmp10 + tmp13;
      tmp3 := tmp10 - tmp13;
      sample^[row*RowSize + 0] := (tmp0 + tmp7);
      sample^[row*RowSize + 7] := (tmp0 - tmp7);

      sample^[row*RowSize + 3] := (tmp3 + tmp4);
      sample^[row*RowSize + 4] := (tmp3 - tmp4);

      tmp1 := tmp11 + tmp12;
      tmp2 := tmp11 - tmp12;

      sample^[row*RowSize + 1] := (tmp1 + tmp6);
      sample^[row*RowSize + 6] := (tmp1 - tmp6);

      sample^[row*RowSize + 2] := (tmp2 + tmp5);
      sample^[row*RowSize + 5] := (tmp2 - tmp5);
    END;

    for column := 0 to 7 do
    BEGIN
      { even part }
      tmp0 := sample^[0*RowSize + column];
      tmp1 := sample^[1*RowSize + column];
      tmp2 := sample^[2*RowSize + column];
      tmp3 := sample^[3*RowSize + column];

      tmp10 := tmp0 + tmp1;
      tmp11 := tmp0 - tmp1;

      tmp13 := tmp3;
      tmp12 := tmp2 - tmp3;

      tmp0 := tmp10 + tmp13;
      tmp3 := tmp10 - tmp13;

      tmp1 := tmp11 + tmp12;
      tmp2 := tmp11 - tmp12;

      { Odd part }
      tmp4 := sample^[4*RowSize + column];
      tmp5 := sample^[5*RowSize + column];
      tmp6 := sample^[6*RowSize + column];
      tmp7 := sample^[7*RowSize + column];

      tmp6 := tmp6 - tmp7;
      tmp5 := tmp5 - tmp6;
      tmp4 :=-tmp4 - tmp5;

      bbo^[0*RowSize + column] := DeScale(tmp0 + tmp7);
      bbo^[1*RowSize + column] := DeScale(tmp1 + tmp6);

      bbo^[2*RowSize + column] := DeScale(tmp2 + tmp5);
      bbo^[3*RowSize + column] := DeScale(tmp3 + tmp4);

      bbo^[4*RowSize + column] := DeScale(tmp3 - tmp4);
      bbo^[5*RowSize + column] := DeScale(tmp2 - tmp5);

      bbo^[6*RowSize + column] := DeScale(tmp1 - tmp6);
      bbo^[7*RowSize + column] := DeScale(tmp0 - tmp7);
    END;

    Inc(bbo);
    Inc(sample);
  End;
End; {----------------------------------------}


