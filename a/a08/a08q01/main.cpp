#include <iostream>
#include <iomanip>
#include <cctype>
#include <cstdint>


void print_page_memory(unsigned char* address, size_t page_size, size_t pointer_pos, int view_mode) {
    std::cout << "+-----------+-----------------------------------------------------------------+" << std::endl;
    for (size_t i = 0; i < page_size; i += 16) {
        std::cout << "| " << std::setw(3) << i << " 0x"
                  << std::setfill('0') << std::setw(4) << std::hex << i << std::dec << "| ";

        for (size_t j = 0; j < 16 && (i + j) < page_size; ++j) {
            size_t index = i + j;

            // Print pointer symbol '>' for the selected byte
            if (index == pointer_pos)
                std::cout << ">";
            else
                std::cout << " ";

            // Print according to view mode
            if (view_mode == 0) {  // Char view
								unsigned char c = address[index];
								if (c >= 32 && c <= 126) {  // Printable ASCII
										std::cout << std::setw(2) << std::setfill(' ') << c << " ";
								} else {
										// Handle special escape sequences
										switch (c) {
												case '\0': std::cout << "\\0 "; break;
												case '\a': std::cout << "\\a "; break;
												case '\b': std::cout << "\\b "; break;
												case '\t': std::cout << "\\t "; break;
												case '\n': std::cout << "\\n "; break;
												case '\v': std::cout << "\\v "; break;
												case '\f': std::cout << "\\f "; break;
												case '\r': std::cout << "\\r "; break;
												default: std::cout << "   "; break; // Non-printable characters get blank spaces
										}
								}
						}
            else if (view_mode == 1) {  // Integer view
                std::cout << std::setw(3) << std::setfill(' ') << (int)address[index];
            } 
            else {  // Hex view (default)
                std::cout << std::setw(2) << std::setfill('0') << std::hex 
                          << (int)address[index] << " " << std::dec;
            }
        }
        std::cout << "|" << std::endl;
    }
    std::cout << "+-----------+-----------------------------------------------------------------+" << std::endl;
}

int main() {
    unsigned char page[256];
    for (int i = 0; i < 256; ++i) page[i] = i;  // Initialize with dummy data

    size_t pointer_pos = 0;  // Default pointer position
    int view_mode = 2;  // Default to hex view

    while (true) {
        print_page_memory(page, 256, pointer_pos, view_mode);

        std::cout << "offset: " << pointer_pos 
          << "   char: ";

				unsigned char c = page[pointer_pos];
				switch (c) {
						case '\0': std::cout << "\\0"; break;
						case '\a': std::cout << "\\a"; break;
						case '\b': std::cout << "\\b"; break;
						case '\t': std::cout << "\\t"; break;
						case '\n': std::cout << "\\n"; break;
						case '\v': std::cout << "\\v"; break;
						case '\f': std::cout << "\\f"; break;
						case '\r': std::cout << "\\r"; break;
						default:
								if (c >= 32 && c <= 126)  // Printable ASCII
										std::cout << c;
								else
										std::cout << " ";  // Non-printable characters are replaced with a space
				}
				
				std::cout << "   uint8: " << (int)page[pointer_pos] 
								  << "   int32: 0x" << std::hex << reinterpret_cast<uintptr_t>(&page[pointer_pos]) 
          << "   " << std::dec << reinterpret_cast<uintptr_t>(&page[pointer_pos]) << std::endl;

				
        std::cout << "change to offset (9-quit, 3-view, 6-enter data, 8-change offset): ";
        int choice;
        std::cin >> choice;

        if (choice == 9) break;
        else if (choice == 3) {
            std::cout << "0-char, 1-int, 2-hex: ";
            std::cin >> view_mode;
            if (view_mode < 0 || view_mode > 2) view_mode = 2;  // Default to hex if invalid
        } 
        else if (choice == 6) {
            std::cout << "0..255 value at offset: ";
            int new_value;
            std::cin >> new_value;
            if (new_value >= 0 && new_value <= 255) 
                page[pointer_pos] = (unsigned char)new_value;
        } 
        else if (choice == 8) {
            std::cout << "Enter new offset (0-255): ";
            int new_offset;
            std::cin >> new_offset;
            if (new_offset >= 0 && new_offset < 256)
                pointer_pos = new_offset;
        }
    }

    return 0;
}
