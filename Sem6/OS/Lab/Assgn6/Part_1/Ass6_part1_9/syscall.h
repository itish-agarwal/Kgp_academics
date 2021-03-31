#ifndef USERPROG_SYSCALL_H
#define USERPROG_SYSCALL_H

#include <stdbool.h>
#include "threads/thread.h"
#include <list.h>
#include "threads/synch.h"
#define ui unsigned

struct lock file_lock;       /*lock an unlock access file with multi thread*/

void syscall_init (void);
void exit (int status);
tid_t exec (const char *cmd_line);
int write (int fd, const void *buffer, ui size);
int wait (tid_t pid);
void args_extract_1(struct intr_frame *f, int choose, void *args);
void args_extract_2(struct intr_frame *f, int choose, void *args);

struct child_element* get_child(tid_t tid, struct list *mylist);

#endif /* userprog/syscall.h */
