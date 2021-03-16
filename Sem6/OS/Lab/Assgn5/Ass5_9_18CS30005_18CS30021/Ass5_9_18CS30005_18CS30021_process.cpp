#include<bits/stdc++.h>

#include<sys/shm.h>
#include<sys/wait.h>
#include<time.h>
#include<pthread.h>
#include<unistd.h>
#include<signal.h>
#include<sys/ipc.h>


using namespace std;

#define MAX_N 8

// Create a job structure
struct job {

	// Producer process ID
	pid_t pid; 

	// Producer number
	int pno;

	// Job priority
	int priority;

	// Time taken in computing
	int time;  

	// Job ID
	int jid;

	// Dummy constructor
	job() { }

	//Our constructor for the job
	job(pid_t v, int w, int x, int y, int z) {
		pid = v;
		pno = w;
		priority = x;
		time = y;
		jid = z;
	}
};

//Create a shared memory structure of different variables to be used in the shared memory
struct SHM {
	job jqueue[MAX_N + 1];
	int job_created, job_completed, num_jobs;
	pthread_mutex_t mutex;
};

// Comparision function to pick the job that comes first in queue
bool compare_job(SHM *S, int x, int y) {
    job j1 = S->jqueue[x];
    job j2 = S->jqueue[y];
    return j1.priority > j2.priority;
}

// Makes the heap proper from bottom to top
void adjust_heap_up(SHM *S, int p) {
	// Till it reaches the root
    while( (p/2) > 0 ) {
        job j1 = S->jqueue[p/2];
        job j2 = S->jqueue[p];
        if(compare_job(S, p/2, p)) {
			return;
        }
        else {
			S->jqueue[p] = j1;
			S->jqueue[p/2] = j2;
		}
        p /= 2;
    }
}

// Makes the heap proper from top to bottom;
void adjust_heap_down(SHM *S, int p) {
    int L = 2*p;
    int R = 2*p+1;
    int n = S->num_jobs;
    int mn;
    if(L <= n) {
        if(compare_job(S, L ,p)) mn = L;
        else mn = p;
    }
    else {
		mn = p;
    }

    if(R <= n && compare_job(S, R, mn)) {
		mn = R;
    }
    
    if(mn != p) {
        job temp = S->jqueue[mn];
        job temp1 = S->jqueue[p];
	    S->jqueue[mn] = temp1, S->jqueue[p] = temp;
        adjust_heap_down(S, mn);
    }
}

//Extract the job with highest priority and adjust the heap afterwards
int erase_job(SHM *H, job *jb) {
	// When queue is empty, ie, num_jobs==0
    if(H->num_jobs == 0) return -1;

    *jb = H->jqueue[1];	//Remove the most prior job

	// Order the priority queue
    H->jqueue[1] = H->jqueue[H->num_jobs], H->num_jobs--;
    adjust_heap_down(H,1);

    return 0;
}

// Insert a new job according to the priority in the priority queue
int insert_job(SHM *H, job j) {
	if(H->num_jobs == MAX_N) return -1;
    H->num_jobs++;	
    H->jqueue[H->num_jobs] = j; 
    adjust_heap_up(H, H->num_jobs);  
	return 0;
}

// Function to access the shared memory
int helper_function(SHM *H, int option, job *jp = NULL) {
	pthread_mutex_lock(&(H->mutex));  
	
	// For insertion, return value -1 when queue is full
	if(option == 0) {
		pthread_mutex_unlock(&(H->mutex));
		return insert_job(H, *jp);
	}

	// For erasing the job, return value -1 when queue is empty
	if(option == 1) {
		pthread_mutex_unlock(&(H->mutex));
		return erase_job(H, jp);
	}

	// Update jobs created
	if(option == 2) {
		pthread_mutex_unlock(&(H->mutex));
		return H->job_created ++;
	}

	//Update jobs completed
	if(option == 3) {
		pthread_mutex_unlock(&(H->mutex));
		return H->job_completed ++; 
	}

	//Return number of jobs completed	
	if(option == 4) {
		pthread_mutex_unlock(&(H->mutex));
		return H->job_completed;  
	}

	pthread_mutex_unlock(&(H->mutex));
	return -1;
}

int main() {
	// Take NP and NC inputs
	int NP, NC, jobs;
	cout << "Number of producers: ";
	cin >> NP;
	if (NP <= 0) {
		cout << "Invalid input! Number of producers must be greater than 0" << endl;
		exit(EXIT_FAILURE);
	}
	cout << "Number of consumers: ";
	cin >> NC;
	if (NC <= 0) {
		cout << "Invalid input! Number of consumers must be greater than 0" << endl;
		exit(EXIT_FAILURE);
	}
	cout << "Number of jobs : ";
	cin >> jobs;
	if (jobs <= 0) {
		cout << "Invalid input! Number of jobs must be greater than 0" << endl;
		exit(EXIT_FAILURE);
	}

	// Create a shared memory to store the structure with our variables
	int shmid = shmget(IPC_PRIVATE, sizeof(SHM), 0700|IPC_CREAT);
	if(shmid < 0) {
		cout<<"Shared memory creation failed\n";
		exit(EXIT_FAILURE);
	}

	// Attaching it to a physical address, get the structure pointer as a way to identify the data
	SHM *sharedMem = (SHM *)shmat(shmid, NULL, 0);

	// Initialise the shared memory and data
	sharedMem->num_jobs = sharedMem->job_created = sharedMem->job_completed = 0; 
	pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_setpshared(&attr, PTHREAD_PROCESS_SHARED);
    pthread_mutex_init(&(sharedMem[0].mutex), &attr);

	// Create the consumer processes
	for(int nr = 1; nr <= NC; nr++) {
		pid_t Consumer_id = fork();
		if( Consumer_id == 0 ) {

			srand(time(NULL) ^ (getpid()<<16));  // Seed the random new_joberator
			pid_t id = getpid();  //Get process identity

			for(int i = -100; ; i++) {
				sleep(rand() % 4);  // Sleeps for random time between 0 and 4
				
				// Perform the erase_job every untill a job is erase_job, every 10ms
				job get_job;

				while(helper_function(sharedMem, 1, &get_job) == -1)
					usleep(10000);

				// Print the details of the job
				cout << "Consumer: " << nr << ", Consumer PID: " << id <<", ";
				cout << "Producer: " << get_job.pno << ", Producer PID: " << get_job.pid << ", ";
				cout << "Priority: " << get_job.priority << ", Compute Time: " << get_job.time << ", ";
				cout << "Job ID: " << get_job.jid << '\n';

				helper_function(sharedMem, 3); // Increase the count of completed jobs
				sleep(get_job.time); // Compute the job, sleep for that amount
			}
			exit(EXIT_SUCCESS);
		}
	}

	// Create the producer processes
	for(int nr = 1; nr <= NP; nr++) {
		pid_t Producer_id = fork(); // Create a child process for the producer i
		if( Producer_id == 0 ) {
			srand(time(NULL) ^ (getpid()<<16));  // Seed the random new_joberator
			pid_t id = getpid();  // Gets the process id
			for(int i = -160; ; i++) {
				job new_job(id, nr, (rand() % 10) + 1, (rand() % 4) + 1, (rand() % 100000) + 1);  // Create a job
				sleep(rand() % 4);  // Sleep for random time between 0 and 4

				// Try inserting the job into queue every 10ms untill the queue is not full
				while(helper_function(sharedMem, 0, &new_job) == -1)
					usleep(10000);

				helper_function(sharedMem, 2); // Increase the job created count
				cout << "Producer: " << new_job.pno << ", Producer PID: " << new_job.pid << ", ";
				cout << "Priority: " << new_job.priority << ", Compute Time: " << new_job.time << ", ";
				cout << "Job ID: " << new_job.jid << '\n';
			}
			exit(EXIT_SUCCESS);
		}
	}

	clock_t st = clock(), en;
	double time = 0;

	// Run till required jobs has reached
	while(2) {
		usleep(10000); // sleep for 1 second
		time += 0.01;

		// If required jobs are reached ( checks every second )
		if(helper_function(sharedMem,4) >= jobs) {
			en = clock(); 
			time += ((double)(en - st)) / CLOCKS_PER_SEC ; // calculate time taken
			cout << setprecision(3) << fixed << "TIME TAKEN:- " << time << " s\n"; // output time taken 
			kill(-getpid(), SIGQUIT); // quit all processes (parent and children)
		}
	}
}