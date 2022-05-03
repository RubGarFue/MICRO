all: pract2e.exe

pract2e.exe: pract2e.obj
	tlink /v pract2e

pract2e.obj: pract2e.asm
	tasm /zi pract2e.asm,,pract2e.lst

clean:
	del *.exe
	del *.obj
	del *.map
