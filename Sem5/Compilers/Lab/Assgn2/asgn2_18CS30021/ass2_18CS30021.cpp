#include "toylib.h"

int printStringUpper(char* s) {
  int i = 0, n = 0;
  while(s[i] != '\0') {
    i++;
  }
  n = i + 1;
  char buff[n];
  for(int i = 0; i < n; i++) {
    buff[i] = s[i];
    if(buff[i]>='a' && buff[i]<='z') {
      buff[i] += 'A'-'a';
    }
  }
  
  __asm__ __volatile__ (
    "movl $1, %%eax \n\t"
    "movq $1, %%rdi \n\t"
    "syscall \n\t"
    :
    :"S"(buff), "d"(n) 
  );
  return n-1;
}

int readHexInteger(int* N) {
  char buff[nax];
  for(int i = 0; i < nax; i++) buff[i]='?';
  __asm__ __volatile__ (
    "movl $0, %%eax \n\t"
    "movq $1, %%rdi \n\t"
    "syscall \n\t"
    :
    :"S"(buff), "d"(sizeof(buff))
  );
  int n = 0, ans = 0;
  while(buff[n] != '\n') {
    if(!(buff[n]>='0' && buff[n]<='9') && !(buff[n]>='a' && buff[n]<='f')) {
      return BAD;
    }
    n++;
  }
  long long p = 1;
  for(int i = n-1; i >= 0; i--) {
    if((buff[i]>='a' && buff[i]<='z') || (buff[i]>='A' && buff[i]<='Z')) {
      ans += ((buff[i]-87) * p);
    } else {
      ans += ((buff[i]-'0') * p);
    }
    p *= 16;
  }
  *N = ans;
  return GOOD;
}

int printHexInteger(int n) {
  char buff[nax];
  int i = 0, j = 0, k;
  if(n < 0) {
    buff[i++] = '-';
    n = -n;
    j++;
  }
  while(n > 0) {
    int dig = n%16;    
    if(dig < 10) {
      buff[i++] = dig + '0';
    } else {
      buff[i++] = (char)(55 + dig);
    }
    n /= 16;
  }
  
  k = i - 1;
  while(j < k) {
    char tmp = buff[j];
    buff[j] = buff[k];
    buff[k] = tmp;
    k--; j++;
  }
  buff[i] = '\n';
  
  __asm__ __volatile__ (
    "movl $1, %%eax \n\t"
    "movq $1, %%rdi \n\t"
    "syscall \n\t"
    :
    :"S"(buff), "d"(i+1)
  );
  return GOOD;
}   

int readFloat(float* f) {
  char buff[nax];
  for(int i = 0; i < nax; i++) buff[i]='?';
  __asm__ __volatile__ (
    "movl $0, %%eax \n\t"
    "movq $1, %%rdi \n\t"
    "syscall \n\t"
    :
    :"S"(buff), "d"(sizeof(buff))
  );
  int n = 0, in = -1;
  while(buff[n] != '\n') {
    if(buff[n]=='.') {
      if(in > -1) return BAD;
      in = n;
    } else if(!(buff[n]>='0' && buff[n]<='9')) {
      return BAD;
    }
    n++;
  }
  if(in == -1) in = n;
  
  float ans = 0.0;
  long long p = 1;
  int k = in - 1;
  while(k >= 0) {
    ans += (float) ((buff[k]-'0') * p);
    p *= 10;
    k--;
  }
  float pp = 0.1;
  k = in + 1;
  while(k < n) {
    ans += (float) ((buff[k]-'0') * pp);
    pp /= 10;
    k++;
  }
  *f = ans;
  return GOOD;
}

int printFloat(float f) {
  char buff[nax];
  int begin, i = 0, j = 0;
  
  bool is_zero = (f == 0.0);
  if(is_zero) {
    buff[i++] = '0';
    buff[i++] = '.';
  } else {
    if(f < 0) {
      buff[i++] = '-';
      f *= -1.0;
      j++;
    }
    
    begin = f;
    float end = f - (float)begin;
    while(begin > 0) {
      int dig = begin%10;
      buff[i++] = dig + '0';
      begin /= 10;
    }
    int k = i - 1;
    while(j < k) {
      char tmp = buff[j];
      buff[j] = buff[k];
      buff[k] = tmp;
      k--; j++;
    }
    
    buff[i++] = '.';
    int precision = 0;
    while(end > 0 && precision < 6) {
      end *= 10.0;
      int dig = end;
      buff[i++] = dig + '0';
      end -= dig;
      precision++;
    }
    
  }
  buff[i] = '\n';
  
  __asm__ __volatile__ (
    "movl $1, %%eax \n\t"
    "movq $1, %%rdi \n\t"
    "syscall \n\t"
    :
    :"S"(buff), "d"(i+1)
  );
  
  return 0;
}
    
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
