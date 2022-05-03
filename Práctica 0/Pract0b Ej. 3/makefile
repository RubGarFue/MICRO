all: alumno.exe

alumno.exe: alumno.obj
	tlink /v alumno

alumno.obj: alumno.asm
	tasm /zi alumno.asm,,alumno.lst

clean:
	del *.exe
	del *.obj
	del *.map
