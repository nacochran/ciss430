#include "file_operations.h"

std::ostream &operator<<(std::ostream &out, FileError &e) {
    out << "Error " << e.errno_ << ": " << strerror(e.errno_);
    out.flush();
    return out;
}

File::File(const char *filename) {
    fd_ = open(filename, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR);
    if (fd_ < 0) throw OpenError();
}


void File::close() {
    if (fd_ >= 0) {
        ::close(fd_);
        fd_ = -1;
    }
}

File::~File() {
    if (fd_ >= 0) close();  
}

ssize_t File::read(unsigned char *buff, ssize_t size) {
    ssize_t total_size = 0; // Total bytes read

    while (size > 0) {
        ssize_t result_size = ::read(fd_, buff, size);

        if (result_size == 0) break;  // EOF
        if (result_size == -1) throw ReadError();

        buff += result_size;
        size -= result_size;
        total_size += result_size;
    }

    return total_size;
}

ssize_t File::write(unsigned char *buff, ssize_t size) {
    ssize_t total_size = 0; // Total bytes written

    while (size > 0) {
        ssize_t result_size = ::write(fd_, buff, size);

        if (result_size == 0) break;  // EOF
        if (result_size == -1) throw WriteError();

        buff += result_size;
        size -= result_size;
        total_size += result_size;
    }

    return total_size;
}

off_t File::seek(off_t offset, int whence) {
    return lseek(fd_, offset, whence);
}


