#include "file_operations.h"

int main() {
    try {
        File file("testfile");

        int i;
        std::cout << "Enter an integer: ";
        std::cin >> i;
        std::cout << "i: " << i << '\n';

        // Convert integer to byte array
        unsigned char buff[4];
        std::memcpy(buff, &i, 4);

        file.seek(0);
        file.write(buff, 4);

        // Wipe out value from i
        i = 0;

        // Recover value from file
        file.seek(0);
        file.read(buff, 4);
        std::memcpy(&i, buff, 4);

        std::cout << "Recovered i: " << i << '\n';
    } catch (FileError &e) {
        std::cerr << e << std::endl;
    }

    return 0;
}
