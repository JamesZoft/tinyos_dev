#include <Timer.h>
#include "BlinkToRadio.h"

module BlinkToRadioC {
	uses interface Boot;
	uses interface Leds;
	//uses interface Timer<TMilli> as Timer0;	
	uses interface Packet as SerialPacket;
	uses interface AMPacket as SerialAMPacket;
	uses interface Packet as RadioPacket;
	uses interface AMPacket as RadioAMPacket;
	//uses interface AMSend as SerialAMSend;
	uses interface AMSend as RadioAMSend;
	uses interface SplitControl as SerialAMControl;
	uses interface SplitControl as RadioAMControl;
	uses interface Receive as SerialReceive;
}

implementation {
	uint16_t counter = 1;
	uint16_t prevCounter = 0;
	uint16_t droppedPackets = 0;
	bool busy = FALSE;
	message_t pkt;
	
	event void Boot.booted() {
		call SerialAMControl.start();
	}
	
	event void SerialAMControl.startDone(error_t err)
	{
		if (err == SUCCESS) {
			call RadioAMControl.start();
		}
		else {
			call SerialAMControl.start();
		}
	}
	
	event void RadioAMControl.startDone(error_t err)
	{
		if (err == SUCCESS) {
		}
		else {
			call RadioAMControl.start();
		}
	}
	
	//event void SerialAMSend.sendDone(message_t* msg, error_t err)
//	{
	//	if(&pkt == msg) {
	//		busy = FALSE;
	//	}
//	}
	
	event void RadioAMSend.sendDone(message_t* msg, error_t err)
	{
		if(&pkt == msg) {
			busy = FALSE;
		}
	}
	
	event void RadioAMControl.stopDone(error_t err) {
		
	}
	
	event void SerialAMControl.stopDone(error_t err) {
		
	}
	
	event message_t* SerialReceive.receive(message_t* msg, void* payload, uint8_t len) {
		if(len == sizeof(BlinkToRadioMsg) ) {
			BlinkToRadioMsg* btrpkt = (BlinkToRadioMsg*)payload;
			if(btrpkt->txnodeid == TOS_NODE_ID) {
				call Leds.set(btrpkt->counter);
				if(call RadioAMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(BlinkToRadioMsg)) == SUCCESS) {
					busy = TRUE;
				}
			}
		}
		return msg;		
	}
		
/*	event void Timer0.fired() {
		//call Leds.set(counter);
		if(!busy) {
			BlinkToRadioMsg* btrpkt = (BlinkToRadioMsg*) (call Packet.getPayload(&pkt, NULL));
			btrpkt->nodeid = TOS_NODE_ID;
			btrpkt->txnodeid = ((TOS_NODE_ID % 3) + 1);
			btrpkt->counter = counter++;
			if(call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(BlinkToRadioMsg)) == SUCCESS) {
				busy = TRUE;
			}
		}
	}*/
}
