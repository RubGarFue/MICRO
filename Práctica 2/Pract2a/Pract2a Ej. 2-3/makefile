all: pract2b.exe pract2c.exe

pract2b.exe: pract2b.obj
	tlink /v pract2b

pract2b.obj: pract2b.asm
	tasm /zi pract2b.asm,,pract2b.lst

pract2c.exe: pract2c.obj
	tlink /v pract2c

pract2c.obj: pract2c.asm
	tasm /zi pract2c.asm,,pract2c.lst

clean:
	del *.exe
	del *.obj
	del *.map
