/**
 * TinyOS wrapper around avr-softuart.
 *
 * @author Raido Pahtma
 * @license MIT
 **/
#include "softuart.h"
module SoftwareSerialC {
	provides interface StdControl;
	provides interface UartStream;
	provides interface UartByte;
}
implementation {

	#define __MODUUL__ "swser"
	#define __LOG_LEVEL__ ( LOG_LEVEL_SoftwareSerialC & BASE_LOG_LEVEL )
	#include "log.h"

	#include "softuart.c"

	command error_t StdControl.start() {
		debug1("SOFTUART_TIMERTOP %"PRIu32, (uint32_t)SOFTUART_TIMERTOP);
		// softuart_init(&PORTD, 3, &PORTD, 2);
		softuart_init(&PORTE, 4, &PORTE, 5);
		return SUCCESS;
	}

	command error_t StdControl.stop() {
		return SUCCESS;
	}

	async command error_t UartStream.enableReceiveInterrupt() {
    	softuart_turn_rx_on();
    	return SUCCESS;
	}

	async command error_t UartStream.disableReceiveInterrupt() {
		softuart_turn_rx_off();
		return SUCCESS;
	}

	async command error_t UartStream.receive(uint8_t* buf, uint16_t len) {
    	return FAIL;
	}

	async command error_t UartStream.send(uint8_t *buf, uint16_t len) {
		return FAIL;
	}

	async command error_t UartByte.send(uint8_t byte) {
		softuart_putchar(byte);
		return SUCCESS;
  	}

	async command bool UartByte.sendAvail() {
		return softuart_transmit_busy() == 0;
	}

	async command error_t UartByte.receive(uint8_t * byte, uint8_t timeout) {
		// TODO loop for the timeout?
		if(call UartByte.receiveAvail()) {
			*byte = softuart_getchar();
			return SUCCESS;
		}
		return FAIL;
	}

	async command bool UartByte.receiveAvail() {
		return softuart_kbhit();
	}

	default async event void UartStream.sendDone(uint8_t* buf, uint16_t len, error_t error) { }
	default async event void UartStream.receivedByte(uint8_t byte) { }
	default async event void UartStream.receiveDone(uint8_t* buf, uint16_t len, error_t error) { }

}
