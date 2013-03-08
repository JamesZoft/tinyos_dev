#include "EasyDisseminationWithSerial.h"

module EasyDisseminationWithSerialC {

	uses interface Boot;
	uses interface SplitControl as RadioControl;
	uses interface StdControl as DisseminationControl;
	uses interface DisseminationValue<uint16_t> as Value;
	uses interface DisseminationUpdate<uint16_t> as Update;
	uses interface Leds;
	uses interface Receive;
	uses interface SplitControl as Control;

}

implementation {

	uint16_t counter;
	message_t packet;
	bool locked;
	
	event void Boot.booted() {
	  call Control.start();
	}
	
	event void Control.startDone(error_t err) {
	
		if(err != SUCCESS) {
			call Control.start();
		}
		else {
			call RadioControl.start();
		}
	}
	
	event void Control.stopDone(error_t err) {}
	
	event void RadioControl.startDone(error_t err) {
		if(err != SUCCESS) {
			call RadioControl.start();
		}
		else {
			counter = 0;
			call DisseminationControl.start();
		}
	}
	
	event message_t* Receive.receive(message_t* bufPtr, 
				   void* payload, uint8_t len) {
    if (len != sizeof(test_serial_msg_t)) {return bufPtr;}
    else {
      test_serial_msg_t* rcm = (test_serial_msg_t*)payload;
      uint16_t rcmCounter = rcm->counter;
     	call Update.change(&rcmCounter);
      return bufPtr;
    }
  }

	event void RadioControl.stopDone(error_t err) {}
	
	event void Value.changed() {
		const uint16_t* newVal = call Value.get();
		counter = *newVal;
		call Leds.set(counter);
	}
  
 
}
		
