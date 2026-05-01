unit flc;
interface


type
  tfliheader = record
    FileSize     : longint;
    FormatID     : word;    { AF11h FLI;AF12h FLC;AF44h FLC > 8 bpp; AF30 huffmann/BWT compressed }
    NumFrames    : word;
    Width        : word;
    Height       : word;
    Depth        : word;
    Flags        : word;    { 0 or 3                       }
    Speed        : longint;
    Reserved     : word;
    Created      : longint; { Date of flic creation /FLC   }
    CreatorNum   : longint; { Compiler ID /FLC             }
    LastModified : longint; { Date of FLIC update /FLC     }
    LastModifier : longint; { last modifier ID /FLC        }
    AspectX      : word;    { FLC                          }
    AspectY      : word;    { FLC                          }
    extflags     : word;    { flags for EGI extensions     }
    keyframes    : word;    { Key frame frequency /EGI     }
    totalframes  : word;    { total frames/segments /EGI   }
    reqmem       : longint; { max chunk size uncompr. /EGI }
    Reserved2    : array[0..27] of byte;
    offsetFrame1 : longint; { FLC                          }
    offsetFrame2 : longint; { FLC                          }
    Reserved3    : array[0..39] of byte;
  end;

  tflcblock = record
    Size      : longint;
    BlockID   : word;
    SubBlocks : word;
    Reserved  : array[0..7] of byte;
  end;

  tflcsubblock = record
    size      : longint;
    blockid   : word;
    data      : record end;
  end;

  PFLCColorPacket = ^TFLCColorPacket;
  TFLCColorPacket = Record
    SkipCount : Byte; (* Number of colors to skip *)
    ColorTriplets : Byte; (* Number of RGB colors to set *)
    Data : Record End;
  End;

  PFLCColorTriplet = ^TFLCColorTriplet;
  TFLCColorTriplet = Record
    R,G,B : Byte;
  End;

const
  creatorid_unknown  = 0;
  creatorid_egi      = $45474900;
  creatorid_fliclib  = $464C4942;
  creatorid_fliclib2 = $42494C46;
  creatorid_simply3d = $41544542;
  creatorid_3dstudio = $30314C46;

function getflcblockname(id : word) : string;
function getcreatorname(id : longint) : string;

implementation

function makestr(w : word) : string;
var
  c : string;
begin
  str(w,c);
  makestr := c;
end;

function getflcblockname(id : word) : string;
begin
  case id of
    3 : getflcblockname := 'CEL data';
    4 : getflcblockname := 'Palette-256';
    7 : getflcblockname := 'Word delta frame';
   11 : getflcblockname := 'Palette-64';
   12 : getflcblockname := 'Byte delta frame';
   13 : getflcblockname := 'Black frame';
   15 : getflcblockname := 'Byte RLE';
   16,26 : getflcblockname := 'Uncompressed frame';
   18 : getflcblockname := 'Stamp';
   25 : getflcblockname := 'Pixel RLE';
   27 : getflcblockname := 'Pixel delta frame';
   31 : getflcblockname := 'Frame label';
   32 : getflcblockname := 'Bitmap mask';
   33 : getflcblockname := 'Multilevel Mask';
   34 : getflcblockname := 'Segment info';
   35 : getflcblockname := 'Key image';
   36 : getflcblockname := 'Key palette';
   37 : getflcblockname := 'Region';
   38 : getflcblockname := 'Wave chunk';
   39 : getflcblockname := 'User data';
   else getflcblockname := 'Unknown ('+makestr(id)+')';
  end;
end;

function getcreatorname(id : longint) : string;
begin
  if id = creatorid_egi then getcreatorname := 'EGI' else
  if id = creatorid_fliclib  then getcreatorname := 'FlicLib' else
  if id = creatorid_fliclib2 then getcreatorname := 'FlicLib 2' else
  if id = creatorid_simply3d then getcreatorname := 'Micrografx Simply3D' else
  if id = creatorid_3dstudio then getcreatorname := 'Kinetix 3DStudio MAX' else
  getcreatorname := 'Unknown';
end;

begin
end.

