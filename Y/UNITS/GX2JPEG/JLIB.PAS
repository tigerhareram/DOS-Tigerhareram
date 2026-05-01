{****************************************************************************
 * GrafX2 JPEG Loader - copyright (c) 1998-1999 by Stefan Goehler           *
 * Requires the PasJPEG-Sources written by Jacques Nomssi Nzali. You can    *
 * They're not included because of their large size                         *
 * Download them at this URL:                                               *
 * http://www.tu-chemnitz.de/~nomssi                                        *
 ****************************************************************************}

unit jlib;

interface

uses
  jmorecfg, jerror, jpeglib,
  jdatadst, jcparam, jcapimin, jcapistd, jdapimin, jdatasrc, jdapistd,
  gx_glob,gx_image,gx_col,newfrontier,stream32,objects;


function loadjpeg(var stream : tstream32;var image : timage;usebpp,flags : longint) : word;
function savejpeg(var stream : tstream32;image : timage;quality : int) : word;

var
  image_buffer : JSAMPROW;	{ Points to large array of R,G,B-order data }
  image_height : int;	        { Number of rows in image }
  image_width : int;		{ Number of columns in image }
var
  current_line : int;
type
  jmp_buf = pointer;

implementation

var
  convertdata   : tcnvproc;
  cnvtmp        : pcnvproc;

function setjmp(setjmp_buffer : jmp_buf) : int;
begin
  setjmp := 0;
  current_line := 0;
end;

procedure longjmp(setjmp_buffer : jmp_buf; flag : int);
begin
  Halt(2);
end;



{ Here's the extended error handler struct: }
type
  my_error_ptr = ^my_error_mgr;
  my_error_mgr = record
    pub : jpeg_error_mgr;	{ "public" fields }

    setjmp_buffer : jmp_buf;	{ for return to caller }
  end;


{ Here's the routine that will replace the standard error_exit method: }

{METHODDEF}
procedure my_error_exit (cinfo : j_common_ptr); far;
var
  myerr : my_error_ptr;
begin
  myerr := my_error_ptr (cinfo^.err);

  cinfo^.err^.output_message (cinfo);

  longjmp(myerr^.setjmp_buffer, 1);
end;


{GLOBAL}
function loadjpeg(var stream : tstream32;var image : timage;usebpp,flags : longint) : word;
var
  cinfo : jpeg_decompress_struct;
  jerr  : my_error_mgr;
  { More stuff }
  buffer : JSAMPARRAY;		{ Output row buffer }
  row_stride  : int;		{ physical row width in output buffer }
  imgpos      : longint;
  err,i       : word;
begin
  loadjpeg := errfileerror;
  if (stream.status <> stok) then exit;
  cinfo.err := jpeg_std_error(jerr.pub);
  jerr.pub.error_exit := my_error_exit;
  jerr.pub.trace_level := 3;	{ I'm debbuging a lot (Nomssi) }
  imgpos := image.imagestart;
  if (setjmp(jerr.setjmp_buffer) <> 0) then
  begin
    jpeg_destroy_decompress(@cinfo);
    stream.done;
    loadjpeg := errgenerror; {load error}
    exit;
  end;

  jpeg_create_decompress(@cinfo);
  jpeg_stdio_src(@cinfo, @stream);
  jpeg_read_header(@cinfo, TRUE);

  cinfo.scale_num    := 1;
  cinfo.dct_method   := JDCT_IFAST;
  cinfo.scale_denom  := 1;

  jpeg_start_decompress(@cinfo);

  cnvtmp := prepareimage_cnv(image,cinfo.output_width,cinfo.output_height,
                             cinfo.output_components shl 3,usebpp,1,flags,cnvimgmd+cnvswap);
  loadjpeg := errfalsebpp;
  if cnvtmp = nil then begin
    jpeg_destroy_decompress(@cinfo);
    stream.done;
    exit;
  end;
  convertdata := tcnvproc(cnvtmp);

  row_stride := cinfo.output_width * cinfo.output_components;
  buffer := cinfo.mem^.alloc_sarray
            (j_common_ptr(@cinfo), JPOOL_IMAGE, row_stride, 1);

  while (cinfo.output_scanline < cinfo.output_height) do
  begin
    jpeg_read_scanlines(@cinfo, buffer, 1);
    convertdata(farptr(buffer^[0]),ptr48(image.data,imgpos),cinfo.output_width*3);
    inc(imgpos,image.bpl);
  end;
  jpeg_finish_decompress(@cinfo);
  jpeg_destroy_decompress(@cinfo);
  stream.done;
  loadjpeg := errnoerror;
end;

function savejpeg(var stream : tstream32;image : timage;quality : int) : word;
var
  cinfo : jpeg_compress_struct;

  jerr : jpeg_error_mgr;
  { More stuff }
  row_pointer : array[0..0] of JSAMPROW ;	{ pointer to JSAMPLE row[s] }
  row_stride : int;		{ physical row width in image buffer }
  linebuffer : pointer;
  imgpos     : longint;
begin
  savejpeg := errfileerror;
  cinfo.err := jpeg_std_error(jerr);

  jerr.trace_level := 3;
  jpeg_create_compress(@cinfo);

  if (stream.status <> stok) then exit;

  cnvtmp := getcnvproc(image.bpp,24,cnvimgmd or cnvswap);
  savejpeg := errfalsebpp;
  if cnvtmp = nil then begin
    jpeg_destroy_decompress(@cinfo);
    stream.done;
    exit;
  end;
  convertdata := tcnvproc(cnvtmp);

  jpeg_stdio_dest(@cinfo, @stream);
{  image_buffer := JSAMPROW(@image_line);}
  image_width  := image.sizex;
  image_height := image.sizey;

  cinfo.image_width := image_width; 	{ image width and height, in pixels }
  cinfo.image_height := image_height;
  cinfo.input_components := 3;		{ # of color components per pixel }
  cinfo.in_color_space := JCS_RGB; 	{ colorspace of input image }

  jpeg_set_defaults(@cinfo);

  jpeg_set_quality(@cinfo, quality, TRUE { limit to baseline-JPEG values });

  jpeg_start_compress(@cinfo, TRUE);

  row_stride := image_width * 3;	{ JSAMPLEs per row in image_buffer }
  getmem(linebuffer,row_stride+3);
  imgpos := image.imagestart;
  while (cinfo.next_scanline < cinfo.image_height) do
  begin
    convertdata(ptr48(image.data,imgpos),farptr(linebuffer),image.sizex*image.pixel);
    inc(imgpos,image.bpl);
    row_pointer[0] := linebuffer;
    {void} jpeg_write_scanlines(@cinfo, JSAMPARRAY(@row_pointer), 1);
  end;
  freemem(linebuffer,row_stride+3);

  jpeg_finish_compress(@cinfo);
  stream.done;

  jpeg_destroy_compress(@cinfo);

  savejpeg := errnoerror;
end;


end.