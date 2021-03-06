#ifndef _MYL_H
#define _MYL_H
#define ERR 1
#define OK 0

int readInt(int *eP); 	// *eP is for error for non integer input
int readf(float *);		// return value is error or OK
int printStr(char *);
int printInt(int);
int printd(float);
#endif


