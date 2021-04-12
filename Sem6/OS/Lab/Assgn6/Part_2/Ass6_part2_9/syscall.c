#include <stdio.h>
#include <syscall-nr.h>
#include "threads/interrupt.h"
#include "threads/vaddr.h"
#include "threads/malloc.h"
#include "devices/shutdown.h"
#include "devices/input.h"
#include "userprog/syscall.h"
#include "process.h"
#include "filesys/file.h"
#include "filesys/filesys.h"
#include "threads/synch.h"

// List of function names

struct child_element* get_child(tid_t tid,struct list *mylist);

struct fd_elem* get_fd(int fd);

void close_all(struct list *fd_list);

// Syscall Handler

static void syscall_handler (struct intr_frame *);

// Syscalls

tid_t exec (const char *cmdline);

void exit (int status);

int wait (tid_t pid);

bool create (const char *file, unsigned initial_size);

bool remove (const char *file);

int open (const char *file);

int filesize (int fd);

int read (int fd, void *buffer, unsigned size);

int write (int fd, const void *get_buffer, unsigned size);

void close (int fd);

void lock_cs() {
    lock_acquire(&file_lock);
}

void open_cs() {
    lock_release(&file_lock);
}

struct child_element* get_child(tid_t tid, struct list *mylist) {
    struct list_elem* it;
    for (it = list_begin (mylist); it != list_end (mylist); it = list_next (it)) {
        struct child_element *child = list_entry (it, struct child_element, child_elem);
        if(child -> child_pid == tid) {
            return child;
        }
    }
}

/**
 * iterate on the fd_list of the cuttrnt thread and get the file which
 * have the same fd
 * if nou found retuen NULL
 * */
struct fd_elem* get_fd(int fd) {
    struct list_elem *e;
    for (e = list_begin (&thread_current()->fd_list); e != list_end (&thread_current()->fd_list); e = list_next (e)) {
        struct fd_elem *fd_el = list_entry (e, struct fd_elem, element);
        if(fd_el->fd == fd) {
            return fd_el;
        }
    }
    return NULL;
}

void close_all(struct list *fd_list) {
    struct list_elem *e;
    while(!list_empty(fd_list)) {
        e = list_pop_front(fd_list);
        struct fd_elem *fd_el = list_entry (e, struct fd_elem, element);
        file_close(fd_el->myfile);
        list_remove(e);
        free(fd_el);
    }
}

// Initialize software interrupt code for syscall handling
void syscall_init (void) {

    intr_register_int (0x30, 3, INTR_ON, syscall_handler, "syscall");

    lock_init(&file_lock);
}

void check_valid_ptr (const void *pointer) {
    if (!is_user_vaddr(pointer)) {
        exit(-1);
    }

    void *check_pointer = pagedir_get_page(thread_current()->pagedir, pointer);

    if (!check_pointer) {
        exit(-1);
    }
}

void args_extract_1(struct intr_frame *frame, int choose, void *args) {

    int argv = *((int*) args);
    args = args + 4;

    if (choose == SYS_EXIT) {
        exit(argv);
    } else if (choose == SYS_EXEC) {
        check_valid_ptr((const void*) argv);
        frame -> eax = exec((const char *) argv);
    } else if(choose == SYS_WAIT) {
        frame -> eax = wait(argv);
    } else if(choose == SYS_OPEN) {
        check_valid_ptr((const void*) argv);
        frame -> eax = open((const char *) argv);
    } else if(choose == SYS_FILESIZE) {
        frame -> eax = filesize(argv);
    }
}

void args_extract_2(struct intr_frame *frame, int choose, void *args) {
    int argv = *((int*) args);
    args = args + 4;
    int argv_1 = *((int*) args);
    args = args + 4;

    if (choose == SYS_CREATE) {
        check_valid_ptr((const void*) argv);
        frame -> eax = create((const char *) argv, (unsigned) argv_1);
    }
}

void args_extract_3(struct intr_frame *frame, int choose, void *args) {

    int argv = *((int*) args);
    args = args + 4;
    int argv_1 = *((int*) args);
    args = args + 4;
    int argv_2 = *((int*) args);
    args = args + 4;

    check_valid_ptr((const void*) argv_1);

    void * temp = ((void*) argv_1)+ argv_2 ;

    check_valid_ptr((const void*) temp);

    if (choose == SYS_WRITE) {
        frame -> eax = write (argv,(void *) argv_1,(unsigned) argv_2);
    } else {
        frame -> eax = read (argv,(void *) argv_1, (unsigned) argv_2);
    }
}

static void syscall_handler (struct intr_frame *frame ) {

    int sys_number = 0;

    check_valid_ptr((const void*) frame -> esp);

    void *args = frame -> esp;

    sys_number = *( (int *) frame -> esp );

    args = args + 4;

    check_valid_ptr((const void*) args);

    if(sys_number == SYS_EXIT) {
        args_extract_1(frame, SYS_EXIT, args);
    } else if(sys_number == SYS_EXEC) {
        args_extract_1(frame, SYS_EXEC, args);
    } else if(sys_number == SYS_WRITE) {
        args_extract_3(frame, SYS_WRITE, args);
    } else if(sys_number == SYS_WAIT) {
        args_extract_1(frame, SYS_WAIT, args);
    } else if(sys_number == SYS_CREATE) {
    	args_extract_2(frame, SYS_CREATE,args);
    } else if(sys_number == SYS_REMOVE) {
    	args_extract_1(frame, SYS_REMOVE,args);
    } else if(sys_number == SYS_OPEN) {
        args_extract_1(frame, SYS_OPEN,args);
    } else if(sys_number == SYS_FILESIZE) {
        args_extract_1(frame, SYS_FILESIZE,args);
    } else if(sys_number == SYS_READ) {
        args_extract_3(frame, SYS_READ,args);
    } else if(sys_number == SYS_CLOSE) {
        args_extract_1(frame, SYS_CLOSE,args);
    } else {
        printf("Probably the syscall does not belong to part 2 of assignment\n");
        exit(-1);
    }
}

//SYSCALLS for part 1 of Assignment 6

tid_t exec (const char *command_line) {

    struct thread* parent = thread_current();
    tid_t pid = -1;
    // create child process to execute cmd
    pid = process_execute(command_line);

    // get the created child
    struct child_element *child = get_child(pid, &parent -> child_list);
    // wait this child until load
    sema_down(&child-> child_thread -> sema_exec);
    // after wake up check if child load successfully
    if(!child -> loaded) {
        //failed to load
        return -1;
    }
    return pid;
}

void exit (int status) {
    struct thread *current = thread_current();
    printf ("%s: exit(%d)\n", current -> name, status);

    //get me as a child
    struct child_element *child = get_child(current->tid, &current -> parent -> child_list);
    //setting my exit status
    child -> exit_status = status;
    // mark my current status
    if (status == -1) {
        child -> cur_status = WAS_KILLED;
    }
    else {
        child -> cur_status = HAD_EXITED;
    }

    thread_exit();
}

int wait (tid_t pid) {
    return process_wait(pid);
}


//SYSCALLS for part 2 of assignment 6

//file handler syscalls
bool create (const char *file_name, unsigned initial_size) {
    //lock the critical section
    lock_cs();
    //filesys_create is defined in src/filesys/filesys.c
    //creates a file named file_name with the given initial size
    bool return_status = filesys_create(file_name, initial_size);
    open_cs();
    return return_status;
}

bool remove (const char *file_name) {

    lock_cs();

    //deletes the file named file_name
    //return true is successful, false otherwise(or if no file named file_name exists)

    bool return_status = filesys_remove(file_name);

    //unlock the critical section
    open_cs();
    return return_status;
}

int open (const char *file_name) {    

    //lock the critical section
    lock_cs();
    struct thread *current = thread_current ();

    struct file * opened_file = filesys_open(file_name);

    open_cs();
    int return_status = -1;

    //if file named file_name exists and is opened successfully
    if(opened_file) {

        //increase file descriptor count of current thread
        current -> fd_size++;

        //we need to return file descriptor of newly opened file
        return_status = current -> fd_size;

        /*create and init new fd_elem*/
        struct fd_elem *file_element = (struct fd_elem*) malloc(sizeof(struct fd_elem));
        
        file_element -> myfile = opened_file;
        file_element -> fd = return_status;

        // add this fd_elem to this thread fd_list
        list_push_back(&current->fd_list, &file_element->element);
    }
    return return_status;
}

int filesize (int fd) {
    struct file *File = get_fd(fd) -> myfile;

    //lock the critical section
    lock_cs();
    //file->length
    //Return size of file in bytes
    int return_length = file_length(File);

    open_cs();
    return return_length;
}


int read (int fd, void *buffer, unsigned int read_size) {

    int return_status = -1;

    if(fd == 0) {
        //Standard input stream STDIN 
        // read from the keyboard

        //defined in devices/input.c
        return_status = input_getc();
    }
    else if(fd > 0) {
        //read from file
        //get the fd_elem
        struct fd_elem *fd_el = get_fd(fd);
        if(!fd_el || !buffer) {
            return -1;
        }
        //get the file
        struct file *myfile = fd_el->myfile;

        lock_cs();

        return_status = file_read(myfile, buffer, read_size);

        open_cs();

        //it couldn't read the specified number of bytes
        if(return_status < (int)read_size && return_status != 0) {
            //some error happened
            return_status = -1;
        }
    }
    return return_status;
}

int write (int fd, const void *get_buffer, unsigned size) {
    //Writes size bytes from buffer to the open file fd. Returns the number of bytes
    //actually written, which may be less than size if some bytes could not be written
    uint8_t * buffer = (uint8_t *) get_buffer;
    int return_status = -1;
    if (fd == 1) {
        // write in the console using putbuf function
        putbuf( (char *) buffer, size);
        return (int) size;
    }

    //write in file
    //get the fd_elem
    struct fd_elem *fd_el = get_fd(fd);
    if(!fd_el || !get_buffer) {
        return -1;
    }
    //get the file
    struct file *myfile = fd_el->myfile;
    
    lock_cs();
    //file_write->
    /* Writes SIZE bytes from BUFFER into FILE,
   starting at the file's current position.*/
    return_status = file_write(myfile, get_buffer, size);

    open_cs();
    
    return return_status;
}


void close (int fd) {

    struct fd_elem *fd_el = get_fd(fd);

    if(!fd_el) return;

    struct file *my_file = fd_el->myfile;

    lock_cs();
    //file_close -> closes file
    file_close(my_file);

    open_cs();
}

