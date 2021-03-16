#include <bits/stdc++.h>
#include <semaphore.h>
#include <pthread.h>
#include <unistd.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/wait.h>

#define N 1000000
#define MAX_N 8

using namespace std;

typedef struct job {
	// Producer process jid
	pthread_t pid; 

	// Producer number
	int pno;

	// Job priority
	int priority;

	// Time taken in computing
	int time;  

	// Job ID
	int jid;

} job;

// Useful Global variables

int NP, NC, num_jobs, jqueue_size, size, job_created, job_completed;
job jqueue[100];

sem_t queue_full;
sem_t queue_empty;
sem_t m_lock;


//Adjust the heap by heapifying downwards
void adjust_heap_down(job jobs[], int size, int index) {
	int mx = index;
	int l = 2*index + 1;
	int r = 2*index + 2;

	if (jobs[l].priority > jobs[mx].priority && l < size) {
		mx = l;
	}

	if (jobs[r].priority > jobs[mx].priority && r < size) {
		mx = r;
	}

	if (mx != index) {
		job temp = jobs[index];
		jobs[index] = jobs[mx];
		jobs[mx] = temp;

		adjust_heap_down(jobs, size, mx);
	}
}

//Adjust the heap by heapifying upwards
void adjust_heap_up(job jobs[], int size, int index) {
	int p = (index-1)/2;

	if (jobs[p].priority > 0) {
		if (jobs[index].priority > jobs[p].priority) {
			job j = jobs[index];
			jobs[index] = jobs[p];
			jobs[p] = j;

			adjust_heap_up(jobs, size, p);
		}
	}
}

void insert_job(job jobs[], int &size, job j) {
	jobs[size] = j;

	++size;

	adjust_heap_up(jobs, size, size-1);
}

void erase_job(job jobs[], int size) {
	jobs[0] = jobs[size-1];

	--size;

	adjust_heap_down(jobs, size, 0);
}

void exit_thread() {
	pthread_exit(0);
}

void *consumer_func(void *p) {
		int *t = (int *) p;
		job j;

		sem_wait(&m_lock);
		sem_post(&m_lock);

		do {
			if (job_completed >= num_jobs) {
				exit_thread();
			}
			sleep(rand()%4);

			sem_wait(&queue_full);
			sem_wait(&m_lock);

			if (num_jobs > job_completed) {
				j = jqueue[0];
				erase_job(jqueue, size);

				job_completed++;
				cout << "Consumer: "<< *t <<", Consumer PID: "<< pthread_self() <<", ";
				cout << "Producer: " << j.pno << ", Producer PID: " << j.pid << ", ";
				cout << "Priority: " << j.priority << ", Compute Time: " << j.time << ", ";
				cout << "Job ID: " << j.jid << endl;
				cout << "Jobs created : " << job_created << endl;
				cout << "Jobs completed : " << job_completed << endl;
			}

			sem_post(&m_lock);
			sem_post(&queue_empty);

			sleep(j.time);
			
		} while (true);
}

void *producer_func(void *p) {
		int *t = (int *) p;

		sem_wait(&m_lock); 
		sem_post(&m_lock);

		do {
			if (job_created >= num_jobs) {
				exit_thread();
			}

			// Next produced job
			job j;

			j.pid = pthread_self();
			j.pno = *t;
			j.time = rand()%4 + 1;
			j.jid = rand()%N + 1;
			j.priority = rand()%10 + 1;
			

			sleep(rand()%4);

			sem_wait(&queue_empty);
			sem_wait(&m_lock);

			if (job_created < num_jobs) {
				insert_job(jqueue, size, j);
				++job_created;
				cout << "Producer: " << j.pno << ", Producer PID: " << j.pid << ", ";
				cout << "Priority: " << j.priority << ", Compute Time: " << j.time << ", ";
				cout << "Job ID: " << j.jid << endl;
				cout << "Jobs created : " << job_created << endl;
				cout << "Jobs completed : " << job_completed << endl;
			}

			sem_post(&m_lock);
			sem_post(&queue_full);

		} while (true);

		exit_thread();
}

int main() {
	cout << "Number of producers : ";
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
	cin >> num_jobs;

	if (num_jobs <= 0) {
		cout << "Invalid input! Number of jobs must be greater than 0" << endl;
		exit(EXIT_FAILURE);
	}

	job_created = 0;
	job_completed = 0;
	size = 0;

	// Initializing 
	sem_init(&queue_empty, 0, MAX_N);
	sem_init(&m_lock, 0, 1);
	sem_init(&queue_full, 0, 0);
	

	// Producer and consumer array
	pthread_attr_t A;
	pthread_attr_init (&A);
	pthread_t P_arr[NP], C_arr[NC];
	
	for (int i = 0; i < NP; i++) {
		int *p = (int*)malloc(sizeof(*p));
		*p = i;
		pthread_create(&P_arr[i], &A, producer_func, p);
	}

	for (int i = 0; i < NC; i++) {
		int *p = (int*)malloc(sizeof(*p));
		*p = i;
		pthread_create(&C_arr[i], &A, consumer_func, p);
	}

	while (job_created < num_jobs && job_completed < num_jobs);

	for (int i = 0; i < NP; i++) {
		pthread_join(P_arr[i], NULL);
	}

	for (int i = 0; i < NC; i++) {
		pthread_join(C_arr[i], NULL);
	}

	cout << "\nJobs completed!" << endl;
}