#include "EasyDisseminationWithSerial.h"

configuration EasyDisseminationWithSerialAppC {}

implementation {

	components EasyDisseminationWithSerialC as App, LedsC, MainC;
  components SerialActiveMessageC as AM;
  App.Receive -> AM.Receive[AM_TEST_SERIAL_MSG];
  App.Control -> AM;
  //App.AMSend -> AM.AMSend[AM_TEST_SERIAL_MSG];
  
	components EasyDisseminationWithSerialC;
	//components MainC;
	
	EasyDisseminationWithSerialC.Boot -> MainC;
	
	components ActiveMessageC;
	EasyDisseminationWithSerialC.RadioControl -> ActiveMessageC;
	
	components DisseminationC;
	
	EasyDisseminationWithSerialC.DisseminationControl -> DisseminationC;
	components new DisseminatorC(uint16_t, 0x1234) as Diss16C;
	
	EasyDisseminationWithSerialC.Value -> Diss16C;
	EasyDisseminationWithSerialC.Update -> Diss16C;
	
	//components LedsC;
	EasyDisseminationWithSerialC.Leds -> LedsC;
	
	components new TimerMilliC();
	
	
}
	
