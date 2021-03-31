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

//List of function names
struct child_element* get_child(tid_t tid,struct list *mylist);

static void syscall_handler (struct intr_frame *);

int write (int fd, const void *buffer_, unsigned size);

tid_t exec (const char *cmdline);

void exit (int status);

int wait (tid_t pid);


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

void args_extract_1(struct intr_frame *f, int choose, void *args) {

    int argv = *((int*) args);
    args += 4;

    if (choose == SYS_EXIT) {
        exit(argv);
    }
    else if (choose == SYS_EXEC) {
        check_valid_ptr((const void*) argv);
        f -> eax = exec((const char *) argv);
    } else if(choose == SYS_WAIT) {
        f -> eax = wait(argv);
    }
}


void args_extract_2(struct intr_frame *f, int choose, void *args) {

    int argv = *((int*) args);
    args += 4;
    int argv_1 = *((int*) args);
    args += 4;
    int argv_2 = *((int*) args);
    args += 4;

    check_valid_ptr((const void*) argv_1);

    void * temp = ((void*) argv_1)+ argv_2 ;

    check_valid_ptr((const void*) temp);

    if (choose == SYS_WRITE) {
        f -> eax = write (argv,(void *) argv_1,(unsigned) argv_2);
    }
}

static void syscall_handler (struct intr_frame *frame ) {

    int sys_number = 0;

    check_valid_ptr((const void*) frame -> esp);

    void *args = frame -> esp;

    sys_number = *( (int *) frame -> esp );

    args += 4;

    check_valid_ptr((const void*) args);

    if(sys_number == SYS_EXIT) {
        args_extract_1(frame, SYS_EXIT, args);
    } else if(sys_number == SYS_EXEC) {
        args_extract_1(frame, SYS_EXEC, args);
    } else if(sys_number == SYS_WRITE) {
        args_extract_2(frame, SYS_WRITE, args);
    } else if(sys_number == SYS_WAIT) {
        args_extract_1(frame, SYS_WAIT, args);

        
    }else {
        printf("Probably the syscall does not belong to part 1 of assignment\n");
        exit(-1);
    }
}

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

int write (int fd, const void *buffer, unsigned size) {

    int * buff = (int *) buffer;
    int res = -1;
    if (fd == 1) {
        // write in the console
        putbuf( (char *)buff, size );
        return (int) size;
    }
    return res;
}

int wait (tid_t pid)
{
    return process_wait(pid);
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
