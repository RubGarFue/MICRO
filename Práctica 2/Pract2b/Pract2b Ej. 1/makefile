all: pract2d.exe

pract2d.exe: pract2d.obj
	tlink /v pract2d

pract2d.obj: pract2d.asm
	tasm /zi pract2d.asm,,pract2d.lst

clean:
	del *.exe
	del *.obj
	del *.map
