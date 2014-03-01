project3ex: mymalloc.o drv.o 
	gcc -o project3ex mymalloc.o drv.o -m32
mymalloc.o: mymalloc.c mymalloc.h
	gcc -c mymalloc.c -m32
drv.o: drv.c mymalloc.h
	gcc -c drv.c -m32
