all: pract2a.exe

pract2a.exe: pract2a.obj
	tlink /v pract2a

pract2a.obj: pract2a.asm
	tasm /zi pract2a.asm,,pract2a.lst

clean:
	del *.exe
	del *.obj
	del *.map
