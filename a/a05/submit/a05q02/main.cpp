// main.cpp
// Nathan Cochran

#include <iostream>
#include <thread>
#include <mutex>
#include <queue>

std::queue<int> q;
int n = 0;

std::mutex n_mutex;

// inserts data into queue, printing inserted value
void f1()
{
		n_mutex.lock();
		q.push(n);
		std::cout << "q: pushed " << n << "\n";
		++n;
		n_mutex.unlock();
}

// pops data from queue, printing square of value
void f2()
{
		while (q.size() < 1) {
				continue;
		}
		n_mutex.lock();
		int n0 = q.front();
		q.pop();
		int n_squared = n0 * n0;
		std::cout << n0 << " * " << n0 << " = " << std::to_string(n_squared) << "\n";
		
		n_mutex.unlock();
}

int main()
{
		std::thread t0(f1);
		std::thread t1(f1); 
		std::thread t2(f1); 
		std::thread t3(f1);
		std::thread t4(f2);
		std::thread t5(f2); 
		std::thread t6(f2); 
		std::thread t7(f2);
		
		t0.join(); 
		t1.join(); 
		t2.join();
		t3.join();
		t4.join(); 
		t5.join(); 
		t6.join();
		t7.join();
		
		return 0;
}
