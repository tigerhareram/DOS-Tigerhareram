NASM-IDE Version 1.8
~~~~~~~~~~~~~~~~~~~~

Readme file, Rob Anderton, 10th October 2002
--------------------------------------------


Contents
--------

1. Disclaimer and license
2. What is NASM-IDE?
3. System requirements
4. Installation
5. Contacting the author
6. Bugs, limitations and the future
7. Revision history



1. Disclaimer and license
-------------------------

Please see LICENSE.TXT.


2. What is NASM-IDE?
--------------------

NASM-IDE is a DOS based system providing a front-end to the Netwide Assembler 
(NASM). NASM-IDE has been designed to provide an interface which should be
as easy to use as possible for beginners and experts alike, especially those
who are familiar with Borland development products.


3. System requirements
----------------------

NASM-IDE requires the following minimum system specification:

- 8086 or higher CPU
- Colour monitor
- 1.2 megabytes (approximately) minimum hard disk space
- 450K minimum conventional memory with 512K or more XMS or EMS
- DOS 3.3 or higher (NASM-IDE will run under Windows95/98, NT, 2000 and XP)
- Mouse
- NASM version 0.98.08 or higher executable for DOS (or Win32 if running in a DOS box)


4. Installation
---------------

The NASM-IDE archive is zipped using PKZIP. To use NASM-IDE, create a
directory and unzip the entire archive to that directory (making sure you
unzip with the '-d' option to create the required directory structure). At
the command prompt, change to your NASM-IDE directory and type NASMIDE,
followed by return.

Note: in order to use NASM-IDE you will need to download the NASM 0.98.08
      package for DOS from the NASM website (http://sourceforge.net/projects/nasm)
      and copy the NASM 16-bit executable into the NASM-IDE directory.

********* I M P O R T A N T ***********

Before you can assemble code you need to type the full path and file name of
the NASM executable in the 'NASM location' text box of the 'Assembler Options'
dialog. If the path and file name does not exist, any attempt to assemble
code will give an error message.


When you assemble code, if you see "nasm: invalid option to '-w'" in the 
Error Information window, you need to customise your NASMIDE.INI file.

In order to work correctly you version of NASM must support four warning parameters, 
to check open a DOS prompt, change to your NASM directory and type 'NASM -h'. Look for
the following:


	-w+foo      enables warnings about foo; -w-foo disables them 

 	 where foo can be:

	 macro-params            macro calls with wrong no. of params (default off)
	 macro-selfref           cyclic macro self-references (default off)
	 orphan-labels           labels alone on lines without trailing `:' (default off)
	 number-overflow         numeric constants greater than 0xFFFFFFFF (default on)


If any of the above four warning parameters are missing, open your NASMIDE.INI file
in a text editor and search for the line:

	NASM_SUPPORTED_WARNINGS=15

This bitmapped setting tells NASM-IDE which of the four warning flags are supported by your 
version of NASM. Each flag is assigned the following values:

	macro-params	= 1
	orphan-labels	= 2
	number-overflow	= 4
	macro-selfref	= 8

So if you version of NASM only supports the 'macro-params' and 'macro-selfref' warning flags
you would change your NASMIDE.INI file to:

	NASM_SUPPORTED_WARNINGS=9

Similarly if your version of NASM supports all except the 'number-overflow' warning flag then:

	NASM_SUPPORTED_WARNINGS=11

Please note that newer versions of NASM may support even more warning flags, however these would
have to be entered via the 'Custom Parameters' in the 'Assembler Options' dialogue box.

***************************************


5. Contacting the author
------------------------

email : rob@inglenook.co.uk
www   : http://uk.geocities.com/rob_anderton/

Shameless plugs: 

http://www.customermagnetism.co.uk/ 	my day job!
http://www.tacticaltrader.com/		my other day job :)


6. Bugs, limitations and the future
-----------------------------------

This is version 1.8 of NASM-IDE.

Bug 1: On certain Windows NT 4.0 systems the NASMIDE.INI file is not renamed when
NASM-IDE is exited. Your settings are not lost, they're stored in a NASMIDE.TMP file.

Workaround: run NASM-IDE from within a batch file similar to the following:

@ECHO OFF
NASMIDE
REN NASMIDE.TMP NASMIDE.INI


Bug 2: You may experience an 'Error Log Not Found' message when using NASM-IDE with
the Win32 version of NASM.

Workaround: Use the DOS 16 bit version!


Bug 3: On certain Windows XP systems NASM-IDE will not run in a full-screen
DOS session. This seems to be a problem with XP rather than NASM-IDE as
Turbo Pascal also refuses to run in full-screen mode.

Workaround: Use a windowed DOS session.


Limitations

NASM-IDE requires version 0.98.08 or higher of NASM. To confirm that you have the
correct verson of NASM, run 'nasm -r' from the command prompt.


6. Revision history
-------------------

Key:

Symbol 	Description

+	New feature
- 	Removed feature
*	Bug fix
@	Optimisation/updated feature


Version 1.0

Programmed using Turbo Pascal 7.0 and Turbo Vision 2.0, NASM-IDE was released to the
world back in May 1997.


Version 1.1

After large amounts of user feedback, including bug reports and suggestions for new
features, NASM-IDE 1.1 is released in December 1997, with the following additions and
changes.

@ now uses the standard NASM 0.96 (no modified version is required)

@ modified method used to call NASM

+ a recently used file list is now available via the File|Reopen command

+ a Save all command has been added

+ the clipboard uses the syntax highlighting editor

+ the use of a Primary file as the target Build and Run commands has been added

+ the OS/2 and COFF output formats are now supported

+ the NASM warnings can now be enabled/disabled

+ Include and output directories can now be specified

+ 80x43 / 80x50 screen modes are now supported

+ the startup logo can be disabled for systems which have trouble displaying it

+ a Close All command has been added

* the Error information viewer now displayed the correct error log

+ the Error information viewer allows an error to be selected so that the
  appropriate source code file is opened and the cursor is position on the line
  containing the error

+ commands that are not available in the current context are now disabled

@ the NASM-IDE help has been completely rewritten and now incorporates the
  NASM 0.95 documentation

+ a full 80x86 opcode reference with MMX and Pentium Pro instruction is included

+ a full 80x87 floating point reference is included

- the Previous help topic command is not available in this version

@ the clock now correctly handles midnight (for all you coders who don't sleep!)

@ dialog boxes now update the status line and contain online help

+ double clicking on the cursor position indicator in an edit window displays the
  jump to line dialog

@ the syntax highlighting editor code has been cleaned up, removing 5000 lines of
  unnecessary code and speeding it up enough to allow 80x50 mode to become
  bearable

+ new example code has been included to show off NASM's features

@ configuration settings are now stored in a Windows style INI file

@ my brother drew me a nice new logo!


There are bound to be more changes that I've forgotten, but I think that's enough for
now!


Version 1.2

@ Syntax highlighting can now be turned off (which should be good news for those with
  older computers)

@ Supports new features of NASM 0.97

* Help button in the 'Go to line' dialog now works (thanks to David Moerman for reporting
  this bug)

+ Added desktop autosave feature to allow window positions to be saved/restored between
  sessions (as suggested by Mark Junker)

@ Changed old style 'Output Format' radio buttons in the 'Assembler Options' dialog to a
  new user configurable 'Target' list. This allows you to add support for new
  NASM formats as required (as suggested by Mark Junker)

+ Added NASM listing file support (-l parameter)

* Fixed 'Unable to initialise file' message when starting the IDE from a
  directory other than the NASM-IDE directory (thanks to Shaun for pointing
  out this error)

+ Added support for command line parameters to allow file names to be
  specified on the command line


Version 1.3

+ Added support for NASM 0.98 response files. This helps when you are using
  long path names.

@ Updated the language definition to add new NASM opcodes, registers and
  macros.

+ Removed the graphics logo, allowing NASM-IDE to be compiled to run on
  8086 processors.


Version 1.4

* Fixed missing response file error caused when assembling from a directory
  other than the NASM-IDE directory.

@ Added checks for INI file corruption to remove Runtime error 213 problems
  when accessing the Assembler Options.

+ Added ability to specify the path and file name of the NASM executable.
  NASM-IDE no longer expects it to be called NASM.EXE.


Version 1.5

* Fixed syntax highlighting bug where the hex numbers where partially formatted as 
  registers (e.g. 010AH - the AH was being shown as a register)

* Removed the flashing attribute from the ASM assistant dialogs (they didn't flash in Windows!)

* Finally removed the useless 'Unknown SPAWNO error code' messages and replaced with
  useful error messages!

* Fixed bug that prevented read-only source files from being opened

@ Updated save routines to check for read-only files and prompt for a new file name

@ Updated syntax highlighting to recognise user directives

@ Added new opcodes to the syntax highlighter

@ The desktop is no longer tiled when the Error Log Viewer is displayed, the viewer
  retains its location and is simply brought into focus

@ Updated the NASM-IDE help file to reflect addition functionality (the opcode references
  WERE NOT CHANGED)

@ Updated the example files to reflect newer NASM syntax

+ Added the ability to specify addition NASM command line parameters when assembling

+ Added the cylic macro self-reference warning option

+ The INI file is checked for the read-only attribute and a warning is displayed as
  necessary (this is for those users who copy NASM-IDE from a CD-ROM)

- Removed the unneccessary startup delay 


Version 1.5a

* Fixed bug in the creation of source code backup files that crept in during the last release 
  (and prevented any files from being saved)


Version 1.6

* Menu items are now being correctly enabled/disabled depending on the window
  that has the input focus

* The log file is now being cleared before NASM is invoked, removing any errors from the
  previous assemble command

+ Added tags (%SRCNAME%, %SRCEXT%, %SRCDIR%, %OUTNAME%, %OUTEXT% and %OUTDIR%) in the NASM custom 
  parameters setting

+ Added a browse button to simplify the selection of the NASM Location in the Assembler Options
  dialog box


Version 1.7

* Fixed a bug which caused the IDE to crash if the log file did not exist

* Fixed the incorrect version number being displayed when a critical error
  occurs

* Added a 'Press any key to continue...' pause when a critical error occurs

@ Added new instructions and macros to update syntax highlighting in the editor


Version 1.8

* Fixed a bug in the DOS Spawn error handling routine that was preventing some errors 
  from being reported

+ Added critical error definitions to assist in tracking down the cause of the error

+ Added a 'Previous Topic' command to the online help system

+ Added a 'NASM_SUPPORTED_WARNINGS' flag in the NASMIDE.INI file to allow warning flags
  to be omitted from the assembly process when using certain versions of NASM

@ Updated the NASMIDE.HLP file