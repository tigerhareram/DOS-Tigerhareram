{****************************************************************************
 * Author            : Stefan Goehler, Germany                              *
 * Version           : 1.0                                                  *
 *******                                                                    *
 * my mail-address   : stefan.goehler@gmx.de                                *
 * my homepage       : http://crossfire.home.pages.de                       *
 ****** COPYRIGHT ***********************************************************
 * This little piece of work is freeware. Use it where you want to.         *
 * But please don't expect this unit will be work the same way as it does   *
 * at the moment. I'll change some things in the future..                   *
 ******* HISTORY ************************************************************
 * Version 1.0       : first release with GrafX 1.4b2                       *
 ******* KNOWN PROBLEMS *****************************************************
 * .reading blocks larger than the buffer will cause problems-use directread*
 ****************************************************************************}
unit fcache;

interface

type
  tfilerec = record
    f       : file;
    fmode   : byte;
    bufpos  : word;
    bufsize : word;
    loadbuf : pointer;
    loaded  : integer;
    fpos    : longint;
    fsize   : longint;
  end;

const
  fm_ro        = $00; { * Filemodes, linkable with OR * }
  fm_DenyNone  = $40;
  fm_DenyRead  = $30;
  fm_DenyWrite = $20;
  fm_DenyAll   = $10;

  function  openfile(name : string;fmode : byte;bufsize : word;var rec : tfilerec): byte;
  function  endoffile(var rec : tfilerec) : boolean;
  procedure bufferread(var rec : tfilerec;var dest;size : word);
  procedure directread(var rec : tfilerec;var dest;size : word);
  procedure bufferseek(var rec : tfilerec;pos : longint);
  function  getbyte(var rec : tfilerec) : byte;
  function  bufferfilepos(var rec : tfilerec) : longint;
  procedure refillbuffer(var rec : tfilerec);
  procedure closefile(var rec : tfilerec);

implementation

uses gr_vars;

procedure closefile(var rec : tfilerec);
begin
  close(rec.f);
  freemem(rec.loadbuf,rec.bufsize);
  fillbyte(rec,sizeof(rec),0);
end;

function openfile(name : string;fmode : byte;bufsize : word;var rec : tfilerec) : byte;
var
  result : word;
  lastfm : byte;
begin
  openfile := 0;
  lastfm   := filemode;
  filemode := fmode;
  assign(rec.f,name);
  {$I-}reset(rec.f,1);{$I+}
  result   := ioresult;
  filemode := lastfm;
  if result <> 0 then
  begin
    openfile := result;
    exit;
  end;
  rec.fmode   := fmode;
  rec.bufsize := bufsize;
  getmem(rec.loadbuf,rec.bufsize);
  rec.bufpos  := rec.bufsize;
  rec.loaded  := 0;
  rec.fpos    := 0;
  rec.fsize   := filesize(rec.f);
end;

function endoffile(var rec : tfilerec) : boolean;
begin
  endoffile := rec.fpos = rec.fsize;
end;

procedure fillbuffer(var rec : tfilerec);
begin
  blockread(rec.f,rec.loadbuf^,rec.bufsize,rec.loaded);
  rec.bufpos := 0;
end;

procedure bufferread(var rec : tfilerec;var dest;size : word);
var
  overlap : word;
begin
  if (rec.bufpos+longint(size)) > longint(rec.bufsize) then
  begin
    overlap := rec.bufsize-rec.bufpos;
    if rec.bufpos < rec.bufsize then
    move2(ptr(seg(rec.loadbuf^),ofs(rec.loadbuf^)+rec.bufpos)^,rec.loadbuf^,overlap);
    blockread(rec.f,ptr(seg(rec.loadbuf^),ofs(rec.loadbuf^)+overlap)^,rec.bufpos,rec.loaded);
    rec.bufpos := 0;
  end;
  move2(ptr(seg(rec.loadbuf^),ofs(rec.loadbuf^)+rec.bufpos)^,dest,size);
  inc(rec.bufpos,size);
  inc(rec.fpos,size);
end;

procedure directread(var rec : tfilerec;var dest;size : word);
begin
  seek(rec.f,rec.fpos);
  blockread(rec.f,dest,size,rec.loaded);
  inc(rec.fpos,size);
  rec.bufpos := rec.bufsize;
end;

procedure bufferseek(var rec : tfilerec;pos : longint);
var
  bufstart,bufend : longint;
begin
  if rec.bufpos = rec.bufsize then begin
    seek(rec.f,pos);
    rec.fpos := pos;
{    fillbuffer(rec);}
  end else
  begin
    bufstart := rec.fpos-rec.bufpos;
    bufend   := bufstart+rec.bufsize;
    rec.fpos := pos;
    if (pos >= bufstart)and(pos <= bufend) then { Seeking position is in buffer }
      rec.bufpos := pos-bufstart
    else
    begin
      seek(rec.f,pos);
{      fillbuffer(rec);}
    end;
  end;
end;

function getbyte(var rec : tfilerec) : byte;assembler;
asm
  les   di,rec
  mov   bx,tfilerec[es:di].bufpos
  cmp   bx,tfilerec[es:di].bufsize
  jnae  @noreload
    push  es
    push  di
    call  fillbuffer
    xor   bx,bx
@noreload:
  inc   bx
  mov   tfilerec[es:di].bufpos,bx
  db    66h;inc word ptr tfilerec[es:di].fpos
  les   di,tfilerec[es:di].loadbuf
  mov   al,es:[di+bx-1]
end;

procedure refillbuffer(var rec : tfilerec);
begin
  if rec.fpos = rec.fsize then exit;
  if rec.bufpos < rec.bufsize then
  move2(ptr(seg(rec.loadbuf^),ofs(rec.loadbuf^)+rec.bufpos)^,rec.loadbuf^,rec.bufsize-rec.bufpos);
  blockread(rec.f,ptr(seg(rec.loadbuf^),ofs(rec.loadbuf^)+rec.bufsize-rec.bufpos)^,rec.bufpos,rec.loaded);
  rec.bufpos := 0;
end;

function bufferfilepos(var rec : tfilerec) : longint;
begin
  bufferfilepos := rec.fpos;
end;

begin
end.
