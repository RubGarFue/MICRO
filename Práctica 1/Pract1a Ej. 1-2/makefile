all: pract1a.exe

pract1a.exe: pract1a.obj
	tlink /v pract1a

pract1a.obj: pract1a.asm
	tasm /zi pract1a.asm,,pract1a.lst

clean:
	del *.exe
	del *.obj
	del *.map
