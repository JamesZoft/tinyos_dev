#include <Timer.h>
#include "BlinkToRadio.h"

module BlinkToRadioC {
	uses interface Boot;
	uses interface Leds;
	uses interface Timer<TMilli> as Timer0;	
	uses interface packet;
	uses interface AMPacket;
	uses interface AMSend;
	uses interface SplitControl as AMControl;
}

implementation {
	uint16_t counter = 0;
	bool busy = FALSE;
	message_t pkt;
	
	event void Boot.booted() {
		call AMControl.start();
	}
	
	event void AMControl.startDone(error_t err)
	{
		if (err == SUCCESS) {
			call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
		}
		else {
			call AMControl.start();
		}
	}
	
	event void sendDone(message_t* msg, error_t err)
	{
		if(&pkt == msg) {
			busy = FALSE;
		}
	}
	
	event void AMControl.stopDone(error_t err) {
		
	}
	
	event void Timer0.fired() {
		//counter++;
		//call Leds.set(counter);
		
		
		if(!busy) {
			BlinkToRadioMsg* btrpkt = (BlinkToRadioMsg*) (call Packet.getPayload(&pkt, NULL));
		btrpkt->nodeid = TOS_NODE_ID;
		btrpkt->counter = counter++;
		if(call AMSend.send(AM_BROADCASTER_ADDR, &pkt, sizeof(BlinkToRadioMsg)) == SUCCESS) {
			busy = TRUE;
		}
	}
}
