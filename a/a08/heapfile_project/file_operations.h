#ifndef FILE_OPERATIONS_H
#define FILE_OPERATIONS_H

#include <iostream>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <cerrno>
#include <cstring>

class FileError {
public:
    FileError() : errno_(errno) {}
    int errno_;
};

std::ostream &operator<<(std::ostream &out, FileError &e);

class OpenError : public FileError {};
class ReadError : public FileError {};
class WriteError : public FileError {};

class File {
public:
    File(const char *filename);
    ~File();
    
    ssize_t read(unsigned char *buff, ssize_t size);
    ssize_t write(unsigned char *buff, ssize_t size);
    off_t seek(off_t offset, int whence = SEEK_SET);
    void close();

private:
    int fd_;
};

#endif
