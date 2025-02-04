// File : main.cpp
// Author: Nathan Cochran
// Location: cosc-430/a/a01/a01q01

#include <iostream>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <cerrno>
#include <cstring>
#include <list>
#include <unordered_map>
#include <vector>
#include <iomanip>
#include <limits>
#include <algorithm>


// ///////////////////////////////////// //
// Utility Functions                     //
// ///////////////////////////////////// //

// @function removeSpaces
// Precondition: Accepts a string such as 'p p p p'
// Postcondition: Returns a string with no spaces, i.e.: 'pppp'
std::string removeSpaces(const std::string& str) {
    std::string new_str = "";
		
    for (int i = 0; i < str.size(); ++i) {
        if (str[i] != ' ') {
            new_str += str[i];
        }
    }

    return new_str;
}


// @function movePointer
// Moves the file r/w pointer to a specified offset
// Used by @readFile and @writeFile functions
off_t movePointer(int fd, off_t offset, int whence) {
    off_t newPos = lseek(fd, offset, whence);
    if (newPos < 0) {
        std::cerr << "Error moving pointer: " << strerror(errno) << std::endl;
    }
    return newPos;
}

// @function openFile
// Opens a file for read and write operations
// If file does not already exist, create it
int openFile(const char *filename) {
    int fd = open(filename, O_RDWR | O_CREAT, 0644);
    if (fd < 0) {
        std::cerr << "Error opening file: " << strerror(errno) << std::endl;
    }
    return fd;
}

// @function closeFile
// Closes a file
void closeFile(int fd) {
    if (close(fd) < 0) {
        std::cerr << "Error closing file: " << strerror(errno) << std::endl;
    }
}

// @function readFile
// Reads data from a file between start and end positions
ssize_t readFile(int fd, off_t start, off_t end, char *buffer) {
    if (start > end) {
        std::cerr << "Invalid range: start position is greater than end position." << std::endl;
        return -1;
    }

    size_t numBytes = end - start;
    size_t totalBytesRead = 0;

    if (movePointer(fd, start, SEEK_SET) < 0) {
        return -1;
    }

    while (totalBytesRead < numBytes) {
        ssize_t bytesRead = read(fd, buffer + totalBytesRead, numBytes - totalBytesRead);
        if (bytesRead < 0) {
            std::cerr << "Error reading file: " << strerror(errno) << std::endl;
            return -1;
        } else if (bytesRead == 0) {
            // Reached EOF
            break;
        }
        totalBytesRead += bytesRead;
    }

    return totalBytesRead;
}

// @function writeFile
// Writes data to a file starting at the specified position
ssize_t writeFile(int fd, const char *data, off_t position, size_t numBytes) {
    size_t totalBytesWritten = 0;

    if (movePointer(fd, position, SEEK_SET) < 0) {
        return -1;
    }

    while (totalBytesWritten < numBytes) {
        ssize_t bytesWritten = write(fd, data + totalBytesWritten, numBytes - totalBytesWritten);
        if (bytesWritten < 0) {
            std::cerr << "Error writing file: " << strerror(errno) << std::endl;
            return -1;
        }
        totalBytesWritten += bytesWritten;
    }

    return totalBytesWritten;
}

// ////////////////////////////////////// //
// BufferPoolManager Class                //
// Used to simulate a buffer pool with    //
// two different memories, which we'll    //
// call M1 and M2. M1 is fast memory,     //
// which could represent main memory,     //
// and M2 is slower, which could          //
// represent secondary storage (hdd, etc) //
// M1 has a smaller capacity; in our      //
// program we call M1 memory units frames //
// M2 memory units are blocks, or pages   //
// ////////////////////////////////////// //

// TODO: Use unordered_map (hash table) and doubly linked list (list)

class BufferPoolManager {
private:
    int NUM_FRAMES;
    int PAGE_SIZE;
    int NUM_BLOCKS;
    
    std::vector<std::vector<unsigned char>> frame;
    std::vector<bool> available;
    std::vector<int> block_index;
    std::vector<bool> dirty;
		std::list<int> LRU;
		std::unordered_map<int, std::list<int>::iterator> frameMap;
    int fd;

    // @method readBlock
    // Reads a block from our file into a frame
    void readBlock(int block, unsigned char* frame) {
        off_t start = block * PAGE_SIZE;
        off_t end = start + PAGE_SIZE;
        if (readFile(fd, start, end, reinterpret_cast<char*>(frame)) < 0) {
            std::cerr << "Error reading block " << block << " from file.\n";
            exit(EXIT_FAILURE);
        }
    }

    // @method writeBlock
    // Writes a frame back into the file, based on the
    // designated block
    void writeBlock(int block, unsigned char* frame) {
        off_t position = block * PAGE_SIZE;

        const char* b = reinterpret_cast<const char*>(frame);

        if (writeFile(fd, b, position, PAGE_SIZE) < 0) {
            std::cerr << "Error writing block " << block << " to file.\n";
            exit(EXIT_FAILURE);
        }
    }

    // @method evictFrame
    // Expels a frame from M1 memory
    // If frame was flagged as dirty, then
    // write it into the corresponding block
    // in storage space
    void evictFrame(int frame_id) {
        if (dirty[frame_id]) {
            std::cout << "Frame " << frame_id << " is dirty ... writing to block " << block_index[frame_id] << "\n";
            writeBlock(block_index[frame_id], frame[frame_id].data());
        } else {
            std::cout << "Frame " << frame_id << " is not dirty ... no write\n";
        }
        block_index[frame_id] = -1;
        available[frame_id] = true;
        dirty[frame_id] = false;
    }

		int getLRUFrame() {
        return LRU.back();
    }

    // @method displayFrames
    // Displays frames of M1 memory
    // Used for main menu
    void displayFrames() const {
        std::cout << "Frames:";
        for (int i = 0; i < NUM_FRAMES; ++i) {
            if (available[i]) {
                std::cout << "[]";
            } else {
                std::cout << "[";
                if (dirty[i]) std::cout << "*";
                std::cout << block_index[i] << ":"
                          << std::string(reinterpret_cast<const char*>(frame[i].data()), PAGE_SIZE)
                          << "]";
            }
        }
        std::cout << std::endl;
    }

public:
    // @constructor BufferPoolManager
    // Precondition: filename exists with NUM_BLOCKS of blocks
    // each with PAGE_SIZE, where PAGE_SIZE determines the #
    // of characters
    // Postcondition: powers on buffer management system
    BufferPoolManager(const std::string& filename, int num_frames, int page_size, int num_blocks)
        : NUM_FRAMES(num_frames), PAGE_SIZE(page_size), NUM_BLOCKS(num_blocks) {
        frame.resize(NUM_FRAMES, std::vector<unsigned char>(PAGE_SIZE));
        available.resize(NUM_FRAMES, true);
        block_index.resize(NUM_FRAMES, -1);
        dirty.resize(NUM_FRAMES, false);
				// for (int i = 0; i < NUM_FRAMES; ++i) {
				// 		LRU[i] = i;
				// }

        fd = openFile(filename.c_str());
        if (fd < 0) {
            std::cerr << "Failed to open file: " << filename << std::endl;
            exit(EXIT_FAILURE);
        }
        powerOn();
    }

    // @deconstructor BufferPoolManager
    // Postcondition: powers off buffer pool manager and
    // closes connection to storage (file) before deleting data
    ~BufferPoolManager() {
        powerOff();
        closeFile(fd);
    }

    // @method powerOn
    // Initializes frames to be ready to be used
    // by buffer pool management methods
    void powerOn() {
        for (int i = 0; i < NUM_FRAMES; i++) {
            available[i] = true;
            block_index[i] = -1;
            dirty[i] = false;
        }
    }

    // @method powerOff
    // Evicts frames from memory, writing any
    // dirty frames to block storage
    void powerOff() {
        for (int i = 0; i < NUM_FRAMES; i++) {
            if (!available[i] && dirty[i]) {
                evictFrame(i);
            }
        }
        std::cout << "Halt" << std::endl;
    }

    // @method fetchPage
    // Performs a [0] fetch page into memory operation, as
    // provided by the main menu
    void fetchPage(int page) {
        for (int i = 0; i < NUM_FRAMES; i++) {
            if (!available[i] && block_index[i] == page) {
                std::cout << "Page " << page << " is already fetched ... frame ID is " << i << "\n";
                return;
            }
        }

        int frame_id = -1;
        for (int i = 0; i < NUM_FRAMES; i++) {
            if (available[i]) {
                frame_id = i;
								updateLRU(frame_id);
                break;
            }
        }

        if (frame_id == -1) {
						frame_id = getLRUFrame();
            // utilize LRU as our page-replacement algorithm
            evictFrame(frame_id);

						std::cout << "Frame " << frame_id << " was LRU, so it will be replaced." << std::endl;
        }

        readBlock(page, frame[frame_id].data());
        available[frame_id] = false;
        block_index[frame_id] = page;
        dirty[frame_id] = false;
				
        std::cout << "Page " << page << " loaded into frame " << frame_id << ".\n";
    }

		void printLRU() {
        std::cout << "LRU List: ";
        for (int frame_id : LRU) {
            std::cout << frame_id << " ";
        }
        std::cout << std::endl;
    }

		// @method updateLRU
		// TODO: update
	  void updateLRU(int frame_id) {
				// remove frame_id from LRU (if it exists)
        if (frameMap.find(frame_id) != frameMap.end()) {
            LRU.erase(frameMap[frame_id]);
        }

				// push frame_id to beginning of LRU
        LRU.push_front(frame_id);

				// update map
        frameMap[frame_id] = LRU.begin();
    }

    // @method writeFrame
    // Performs a [1] write frame operation, as provided
    // by the main menu
    void writeFrame(int frame_id, const std::string& data) {
        if (frame_id < 0 || frame_id >= NUM_FRAMES || available[frame_id]) {
            std::cerr << "Invalid frame ID or frame is not in use.\n";
            return;
        }
        if (data.size() != PAGE_SIZE) {
            std::cerr << "Data size must be " << PAGE_SIZE << " bytes.\n";
            return;
        }

        std::memcpy(frame[frame_id].data(), data.c_str(), PAGE_SIZE);
        dirty[frame_id] = true;
				updateLRU(frame_id);
				
        std::cout << "Data written to frame " << frame_id << " and marked as dirty.\n";
    }

    // @method run
		// Runs buffer pool manager, providing a menu to perform
		// actions
    void run() {
        int option;
        do {
            std::cout << "[0] Fetch a page into memory\n"
                      << "[1] Write frame\n"
                      << "[2] Shutdown\n";
            displayFrames();
						printLRU();
            std::cout << "Option: ";
            std::cin >> option;

            if (option == 0) {
                int page;
                std::cout << "Which page? ";
                std::cin >> page;
                if (page < 0 || page >= NUM_BLOCKS) {
                    std::cerr << "Invalid page number.\n";
                } else {
                    fetchPage(page);
                }
            } else if (option == 1) {
								int page_id;
                int frame_id = -1;
                std::string data;
								
                std::cout << "Which page? ";
                std::cin >> page_id;

								// collects data ("x x x x" = "xxxx")
								std::cout << "Enter " << PAGE_SIZE << " characters: ";
								std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');

								std::getline(std::cin, data);
								
								data = removeSpaces(data);

								// determine which frame is storing the contents of that page
								for (int i = 0; i < NUM_FRAMES; ++i)
								{
										if (block_index[i] == page_id) {
												frame_id = i;
										}
								}

								// assume frame_id is found
								writeFrame(frame_id, data);
            } else if (option != 2) {
                std::cerr << "Invalid option.\n";
            }

						std::cout << std::endl;
        } while (option != 2);
    }
};

// ////////////////////////////////////// //
// Main Execution of Program              //
// ////////////////////////////////////// //

std::string file_name;
std::string size_of_file;
std::string page_size;
std::string max_frames;

int main() {
		std::cout << "File Name: ";
		std::cin >> file_name;
		std::cout << "Size of File: ";
		std::cin >> size_of_file;
		std::cout << "Page Size: ";
		std::cin >> page_size;
		std::cout << "Max Frames: ";
		std::cin >> max_frames;

		int num_blocks = std::stoi(size_of_file) / std::stoi(page_size);
		
    BufferPoolManager bpm(file_name + ".txt", std::stoi(max_frames), std::stoi(page_size), num_blocks); 
    bpm.run();

    return 0;
}
