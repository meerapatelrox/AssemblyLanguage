# AssemblyLanguage
Projects in assembly language focusing on the MIPS instruction set and memory operations.

## Use
Programs are assembled in MARS 4.5 IDE. Assemble _NumberGuess.asm_ and _DD_emulator.asm_ using **Run > Assemble (F3)** and run using **Run > Go (F5)**. See description of _MMIO_emulator.asm_ for instruction of use.

### NumberGuess.asm
_NumberGuess.asm_ is a guessing game where the user picks a number from 0 to 100 while the computer tries to guess the number. After each guess, the user specifies whether their number is higher or lower than the computer’s guess. The computer continues to guess a random
number between the known minimum and maximum values, and when successful, it prints the number of tries it took to guess the number.

### DD_emulator.asm
The Unix command _dd_ is a utility primarily used for converting or copying files. Users specify an input file path, output file path, block size, and other parameters. The block size is given in bytes and specifies how many bytes one wishes to copy/convert/etc. _DD_emulator.asm_ emulates the functionality of the _dd_ command. Because there is no file system in MIPS, we must instead specify a region in memory to start copying from, a destination to copy to, and the number of bytes to copy. If a word transfer is possible (i.e. the user has specified a number of bytes that is divisible by the word size), the program performs word transfers and will otherwise default to byte transfers. Returns 0 in the $v0 register upon success.

Before any copying takes place, the program verifies that the user hasn’t specified an illegal region of memory to read from or copy to. If this occurs, -1 is returned to indicate an INVALID_READ, and -2 is returned to indicate an INVALID_WRITE.

A “dry run” feature is also provided, where the console displays what would happen if the command were executed without actually changing anything. The parameter passed into register $a3 will optionally print the source address and the data instead of actually copying.

### MMIO_emulator.asm
Memory Mapped Input/Output (MMIO) is a technique for allowing the CPU to communicate with peripheral devices like a graphics card, HIDs (human interface devices, like a mouse or keyboard), etc. These devices are all connected to the processor on a system bus. In a MMIO scheme, peripheral devices are assigned a range of memory. When the CPU loads or stores a word from one of these reserved addresses, additional hardware detects the load/store is occurring in this reserved space. Instead of reading/writing to the data memory, it issues these commands on the system bus – communicating with the peripheral devices instead. Hence, configuration of data registers in the peripheral devices are mapped to certain addresses in the data memory to enable input/output.

Devices can communicate with the CPU using either polling or interrupts. When polling, the CPU idles in a loop, reading the device status register every so often. _MMIO_emulator.asm_ implements a device driver in MIPS that constantly polls the keyboard status register, reads the keyboard data register, then polls the display status and writes the keyboard data into the display data register.

To use, assemble with **Run > Assemble (F3)** and run with **Run > Go (F5)**. Then open **Tools > Keyboard and Display MMIO Simulator** and click **Connect to MIPS**. Whatever is typed in the keyboard data register should then be displayed in the display data register above. The polling loop can be exited with **ctrl+C**. 
