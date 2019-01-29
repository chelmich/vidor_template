#include <wiring_private.h>
#include "jtag.h"

// pins used for sending bitstream
#define MB_INT 28
#define MB_INT_PIN 31

#define no_data	0xFF, 0xFF, 0xFF, 0xFF, \
                0xFF, 0xFF, 0xFF, 0xFF, \
                0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, \
                0xFF, 0xFF, 0xFF, 0xFF, \
                0x00, 0x00, 0x00, 0x00  \

#define NO_BOOTLOADER   no_data
#define NO_APP          no_data
#define NO_USER_DATA    no_data


__attribute__ ((used, section(".fpga_bitstream_signature")))
const unsigned char signatures[4096] = {
    #include "signature.h"
};

__attribute__ ((used, section(".fpga_bitstream")))
const unsigned char bitstream[] = {
    #include "app.h"
};

void setup (){
    // enable fpga clock
    pinPeripheral(30, PIO_AC_CLK);
    clockout(0, 1);
    delay(1000);

    // send bitstream over jtag
    uint32_t ptr[1] = {3};
    jtagInit();
    mbPinSet();
    mbEveSend(ptr, 1);
    delay(1000);

    // turn on built in LED
    pinMode(LED_BUILTIN, OUTPUT);
}

void loop (){

}
