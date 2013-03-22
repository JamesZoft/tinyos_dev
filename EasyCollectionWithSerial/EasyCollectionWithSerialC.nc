#include <Timer.h>
#include "EasyCollectionWithSerial.h"

module EasyCollectionWithSerialC{
uses interface Boot;
uses interface SplitControl as RadioControl;
uses interface SplitControl as SerialControl;
uses interface StdControl as RoutingControl;
uses interface Send;
uses interface Leds;
uses interface Timer<TMilli>;
uses interface RootControl;
uses interface Receive;
uses interface AMSend;
uses interface Packet;
uses interface Read<uint16_t>;
}
 
implementation {
	message_t packet;
	bool sendBusy = FALSE;
  bool locked = FALSE;
  uint16_t counter = 0;
	
	typedef nx_struct EasyCollectionWithSerialMsg{
	nx_uint16_t data;
	nx_uint16_t nodeid;
	} EasyCollectionWithSerialMsg;



	event void Boot.booted(){
		call SerialControl.start();
	}
	
	event void SerialControl.startDone(error_t err) {
		if(err != SUCCESS)
			call SerialControl.start();
		else {
			call RadioControl.start();
		}
	}
	
	event void SerialControl.stopDone(error_t err) {}
		
	event void RadioControl.startDone(error_t err){
		if(err != SUCCESS)
			call RadioControl.start();
		else{
				call RoutingControl.start();
			if(TOS_NODE_ID == 1) {
				call RootControl.setRoot();
				//call Leds.led1On();
			}
			else {
				call Timer.startPeriodic(2000);
				//call Leds.led0On();
			}
		}
	}

	
	event void RadioControl.stopDone(error_t err){}
	
	void sendMessage(uint16_t val){
	 	
			EasyCollectionWithSerialMsg* msg = (EasyCollectionWithSerialMsg*)call Send.getPayload(&packet,sizeof(EasyCollectionWithSerialMsg));
			msg->nodeid = TOS_NODE_ID;
			msg->data = val;
			if(call Send.send(&packet,sizeof(EasyCollectionWithSerialMsg)) != SUCCESS)
				{}
			else
				sendBusy=TRUE;
	}
	
	event void Read.readDone(error_t err, uint16_t val)
	{
		if(err == SUCCESS)
		{
			if(!sendBusy)
				sendMessage(val);
		}
	}
		
	event void Timer.fired(){
		call Leds.led2Toggle();
		
		call Read.read();
	//		sendMessage();
	}
	
	event void AMSend.sendDone(message_t* bufPtr, error_t error) {
	  call Leds.led2Off();
    if (&packet == bufPtr) {
    	call Leds.led1Toggle();
      locked = FALSE;
    }
  }
		
	event void Send.sendDone(message_t* m, error_t err){
		if(err != SUCCESS)
			call Leds.led0Toggle();
		sendBusy=FALSE;
	}
	
	
	
	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len)
	{
		//call Leds.led2Toggle();
		if (locked) {
			return msg;
		}
		else {
			EasyCollectionWithSerialMsg* rcm = (EasyCollectionWithSerialMsg*)payload;
			EasyCollectionWithSerialMsg* sendMsg = (EasyCollectionWithSerialMsg*)(call Packet.getPayload(&packet, sizeof(EasyCollectionWithSerialMsg)));		
			//call Leds.led0Toggle();
			if(len == sizeof(EasyCollectionWithSerialMsg) && rcm != NULL) {
				call Leds.led0Toggle();
				(*sendMsg) = (*rcm);

				if (call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(EasyCollectionWithSerialMsg)) == SUCCESS) {
				
					call Leds.led2On();
					locked = TRUE;
				}
			}
			
			//if (call Packet.maxPayloadLength() < sizeof(EasyCollectionWithSerialMsg)) {
				//return msg;
			//}
			
		}
		return msg;
	}
}
