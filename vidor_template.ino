#include <wiring_private.h>
#include "jtag.h"
#include "defines.h"

__attribute__ ((used, section(".fpga_bitstream_signature")))
const unsigned char signatures[4096] = {
    #include "signature.h"
};

__attribute__ ((used, section(".fpga_bitstream")))
const unsigned char bitstream[] = {
    #include "app.h"
};

void FPGA_init (){
    // enable fpga clock
    pinPeripheral(30, PIO_AC_CLK);
    clockout(0, 1);

    // wait for clock to come up (unnecessary?)
    delay(1000);

    // send bitstream over jtag
    uint32_t ptr[1] = {3};
    jtagInit();
    mbPinSet();
    mbEveSend(ptr, 1);
}

void setup (){
    FPGA_init();

    delay(1000);

    // turn on built in LED
    pinMode(LED_BUILTIN, OUTPUT);
}

void loop (){

}
