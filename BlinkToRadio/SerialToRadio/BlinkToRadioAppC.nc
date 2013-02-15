#include <Timer.h>
#include "BlinkToRadio.h"

configuration BlinkToRadioAppC {
}

implementation {
	components MainC;
	components LedsC;
	components BlinkToRadioC as App;
	//components new TimerMilliC() as Timer0;
	components ActiveMessageC;
	components new AMSenderC (AM_BLINKTORADIOMSG);
	components new SerialAMReceiverC (AM_BLINKTORADIOMSG);
	components SerialActiveMessageC;
	//components new SerialAMSenderC (AM_BLINKTORADIOMSG);

	
	
	App.Boot -> MainC;
	App.Leds -> LedsC;
	//App.Timer0 -> Timer0;
	App.SerialPacket -> SerialAMReceiverC;
	App.SerialAMPacket -> SerialAMReceiverC;
	App.RadioPacket -> AMSenderC;
	App.RadioAMPacket -> AMSenderC;
//	App.SerialAMSend -> SerialAMSenderC;
	App.RadioAMSend -> AMSenderC;
	App.RadioAMControl -> ActiveMessageC;
	App.SerialAMControl -> SerialActiveMessageC;
	App.SerialReceive -> SerialAMReceiverC;
}