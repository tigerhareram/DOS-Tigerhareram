(*
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
                     Inertia Realtime 3D Rendering Engine
     Copyright (c) 1996, Alex Chalfin, Jeroen Bouwens. All Rights Reserved.
                       Inertia/16 Source Code Release.
อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*)


{$UNDEF SHAREWARE}
{ If SHAREWARE is defined, the engine is limited to a maximum of 500   }
{ visible polygons                                                     }

{$DEFINE VERSION_7} 
{ If you are using Turbo Pacal v7 or Borland Pascal v7, the VERSION_7  }
{ statement should be defined. When using Turbo Pascal v6, this should }
{ not be defined. VERSION_7 automatically gets define when compiling   }
{ under BP7's protected mode.                                          }

{$DEFINE MEM_CHECKS}
{ If MEM_CHECKS is defined, all memory allocations are check for enough }
{ available memory before allocation. This increases code size only and }
{ has no effect on performance.                                         }

{$DEFINE IO_CHECKS}
{ If IO_CHECKS is defined, all file operations are checked by the engine  }
{ otherwise standard Pascal error handlers are in place. Defining         }
{ IO_CHECKS makes the code larger, but also makes file reads recoverable. }

{$UNDEF DEBUGGING}
{ If DEBUGGING is defined, the engine gets compiled in the $L+,D+ state.  }
{ With debugging turned off, the code size is much smaller. This does not }
{ effect execution speed.                                                 }

{$DEFINE DELTAROTATIONS}
{ If DELTAROTATIONS is defined, correct interdependant axis systems will }
{ be kept in place. This method is just a bit slower than non delta      }
{ rotations. If you are just coding for demos, you might as well leave   }
{ this off but for any sort of game trying to model any sort of flight,  }
{ this is essential.                                                     }

{$DEFINE USE8087}
{ An 8087 math comprocessor is reccommended for best results in this 3d    }
{ engine. However, it isn't necessary, and you can expect good performance }
{ without one. The main matrix system is corrected using floating point    }
{ every 256 frames (or culling errors could result) using floating point   }
{ numbers as well as a few other routines (SetFocusPoint and RotateLight). }
{ The matrix system only needs correction if and only if DELTAROTATIONS is }
{ defined.                                                                 }


{$IFDEF DMPI}
{$DEFINE VERSION_7}
{$ENDIF}

{$DEFINE TRANSPARENCY}

{$DEFINE SMOOTHUNSHADED}
{$DEFINE SMOOTHAMBIENT}
{$DEFINE SMOOTHLAMBERT}
{$DEFINE SMOOTHGOURAUD}
{$DEFINE SMOOTHPHONG}

{$DEFINE TEXTUREUNSHADED}
{$DEFINE TEXTUREAMBIENT}
{$DEFINE TEXTURELAMBERT}
{$DEFINE TEXTUREGOURAUD}
{$DEFINE TEXTUREPHONG}

{$DEFINE REFLECTIONUNSHADED}
{$DEFINE REFLECTIONAMBIENT}
{$DEFINE REFLECTIONLAMBERT}
{$DEFINE REFLECTIONGOURAUD}
{$DEFINE REFLECTIONPHONG}

{ Don't touch the stuff below this line. It is for internal use and is }
{ based off the user definable conditionals                            }

{$DEFINE SMOOTHCASE}
{$DEFINE TEXTURECASE}
{$DEFINE REFLECTIONCASE}

{$IFNDEF SMOOTHAMBIENT}
{$IFNDEF SMOOTHLAMBERT}
{$IFNDEF SMOOTHGOURAUD}
{$IFNDEF SMOOTHPHONG}
{$UNDEF SMOOTHCASE}
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}

{$IFNDEF TEXTUREAMBIENT}
{$IFNDEF TEXTURELAMBERT}
{$IFNDEF TEXTUREGOURAUD}
{$IFNDEF TEXTUREPHONG}
{$UNDEF TEXTURECASE}
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}

{$IFNDEF REFLECTIONAMBIENT}
{$IFNDEF REFLECTIONLAMBERT}
{$IFNDEF REFLECTIONGOURAUD}
{$IFNDEF REFLECTIONPHONG}
{$UNDEF REFLECTIONCASE}
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}


{$IFDEF IO_CHECKS}
{$I-}
{$ELSE}
{$I+}
{$ENDIF}

{$IFDEF DEBUGGING}
{$L+}
{$D+}
{$R-} { Can't define these. Code segment too large :( stupid real mode }
{$S-}
{$ELSE}
{$L-}
{$D-}
{$R-}
{$S-}
{$ENDIF}

{$IFDEF USE8087}
{$N+,E+}
{$ENDIF}

{$G+}  { Use 286 Code            }
{$A+}  { Use word alignment      }
{$X+}  { Use extended syntax     }
