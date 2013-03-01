#include <Timer.h>

module EasyDisseminationC {

	uses interface Boot;
	uses interface SplitControl as RadioControl;
	uses interface StdControl as DisseminationControl;
	uses interface DisseminationValue<uint16_t> as Value;
	uses interface DisseminationUpdate<uint16_t> as Update;
	uses interface Leds;
	uses interface Timer<TMilli>;
}

implementation {

	uint16_t counter;
	
	task void ShowCounter() {
	
		if(counter & 0x1) 
			call Leds.led0On();
		else
			call Leds.led0Off();
			
			
		if(counter & 0x2) 
			call Leds.led1On();
		else
			call Leds.led1Off();
		
		
		if(counter & 0x4) 
			call Leds.led2On();
		else
			call Leds.led2Off();

	}
	
	event void Boot.booted() {
	
		call RadioControl.start();
	}
	
	event void RadioControl.startDone(error_t err) {
		if(err != SUCCESS) {
			call RadioControl.start();
		}
		else {
			call DisseminationControl.start();
			counter = 0;
			if(TOS_NODE_ID == 1)
				call Timer.startPeriodic(2000);
		}
	}
	
	event void RadioControl.stopDone(error_t err) {}
	
	event void Timer.fired() {
		counter = counter + 1;
		post ShowCounter();
		call Update.change(&counter);
	}
	
	event void Value.changed() {
		const uint16_t* newVal = call Value.get();
		counter = *newVal;
		post ShowCounter();
	}
	
  event message_t* Receive.receive(message_t* bufPtr, void* payload, uint8_t len)
	{
	  if (len != sizeof(test_serial_msg_t)) {return bufPtr;}
	  else {
	    test_serial_msg_t* rcm = (test_serial_msg_t*)payload;
	    if (rcm->counter & 0x1) {
				call Leds.led0On();
	    }
	    else {
				call Leds.led0Off();
	    }
	    if (rcm->counter & 0x2) {
				call Leds.led1On();
	    }
	    else {
				call Leds.led1Off();
	    }
	    if (rcm->counter & 0x4) {
				call Leds.led2On();
	    }
	    else {
				call Leds.led2Off();
	    }
	    return bufPtr;
	  }
  }
	
}
		
