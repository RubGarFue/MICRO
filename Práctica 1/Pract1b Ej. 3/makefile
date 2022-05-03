all: pract1b.exe

pract1b.exe: pract1b.obj
	tlink /v pract1b

pract1b.obj: pract1b.asm
	tasm /zi pract1b.asm,,pract1b.lst

clean:
	del *.exe
	del *.obj
	del *.map
