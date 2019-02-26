# vidor_template
This repository contains the bare minimum to create a project for the MKR Vidor 4000 from scratch. Unlike the code provided from Arduino it is intended for creating a standalone application rather than a library to be distributed. Another key difference is that the top module for the FPGA is written in VHDL.

## Workflow
1. Use Quartus to open the project in the quartus folder.
2. Compile the Quartus project.
3. Find the .ttf in quartus/output_files. This is the bitstream created from compilation.
4. Run the python script ReverseByte.py found in the arduino folder on the bitstream, e.g.

   ```
   ./ReverseByte.py ../quartus/output_files/top.ttf vidor_template/app.h
   ```
   
   This flips the bytes in the bitstream Quartus generates which allows us to program the FPGA through the Arduino IDE. The output file must match the `#include` found in the bitstream section of the .ino file. It is treated as a C header file by the IDE.
5. Open the project in the arduino folder with the Arduino IDE. Note that the name of the .ino file and the folder it's in must be the same.
6. Ensure the board is connected via USB. It should show up on linux as something like `/dev/ttyACM0`.
7. Compile and upload the Arduino project with the IDE.

This process creates a composite file containing both the program for the microcontroller and the bitstream for the FPGA. It is written to flash by the IDE and should persist across power cycles. Alternatively, one could use the following procedure to quickly program the FPGA on its own.

1. Install the USBBlaster library in the Arduino IDE.
2. Open the inlcuded project with File -> Examples -> USBBlaster -> USB_Blaster
3. Compile and upload to the Vidor board. This makes the microcontroller emulate a USB Blaster connected to the FPGA.
4. Open the included project in Quartus.
5. Use the Quartus programmer to write to the FPGA directly.

## Troubleshooting
If you encounter problems with the USB Blaster method you may need to change the permissions of the USB device. Find out which bus and device your board is listed as with `lsusb`, then use the following command to enable user read and write on it.
```
sudo chmod 666 /dev/bus/usb/xxx/yyy
```
Similarly you may need to change the permissions on the serial device (`/dev/ttyACM0` for example) when using the Arduino IDE.
