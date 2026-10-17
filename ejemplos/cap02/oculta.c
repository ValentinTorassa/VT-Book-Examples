/*
 * oculta.c: esconde notas.md de readdir() para mostrar que strace ve lo que
 * devolvió el kernel, no lo que devuelve glibc. Solo para el directorio de prueba.
 * Compilar: gcc -shared -fPIC -o oculta.so oculta.c -ldl
 * Probar:   LD_PRELOAD=./oculta.so ls
 *           strace -E LD_PRELOAD=./oculta.so -e trace=getdents64 ls
 */
#define _GNU_SOURCE
#include <dirent.h>
#include <dlfcn.h>
#include <string.h>
struct dirent *readdir(DIR *d) {
    static struct dirent *(*real)(DIR *);
    if (!real) real = dlsym(RTLD_NEXT, "readdir");
    struct dirent *e;
    while ((e = real(d)) && strcmp(e->d_name, "notas.md") == 0) ;
    return e;
}
