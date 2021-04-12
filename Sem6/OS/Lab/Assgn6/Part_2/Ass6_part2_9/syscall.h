#ifndef USERPROG_SYSCALL_H
#define USERPROG_SYSCALL_H

#include <stdbool.h>
#include "threads/thread.h"
#include <list.h>
#include "threads/synch.h"
#define ui unsigned

struct fd_elem
{
    int fd;                        // File Descriptor ID
    struct file *myfile;           // Actual File
    struct list_elem element;      // List element to add the fd_elem in fd_list
};

struct lock file_lock;       // Lock and Unlock access file
struct child_element* get_child(tid_t tid,struct list *mylist);

void syscall_init (void);
tid_t exec (const char *cmdline);
void exit (int status);
int wait (tid_t pid);
bool create (const char *file, unsigned initial_size);
bool remove (const char *file);
int open (const char *file);
int filesize (int fd);
int read (int fd, void *buffer, unsigned size);
int write (int fd, const void *buffer_, unsigned size);
void close (int fd);

void args_extract_1(struct intr_frame *f, int choose, void *args);
void args_extract_2(struct intr_frame *f, int choose, void *args);
void args_extract_3(struct intr_frame *f, int choose, void *args);

#endif /* userprog/syscall.h */
