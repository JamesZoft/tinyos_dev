#include <Timer.h>
#include "BlinkToRadio.h"

configuration BlinkToRadioAppC {
}

implementation {
	components new SerialAMReceiverC (AM_BLINKTORADIOMSG);
	components SerialActiveMessageC;
	
	components new AMSenderC (AM_BLINKTORADIOMSG);
	components ActiveMessageC;
	
	components BlinkToRadioC as App;
	components MainC;
	components LedsC;
	
	App -> MainC.Boot;
	App.Leds -> LedsC;
	
	App.SerialPacket -> SerialAMReceiverC;

	App.RadioAMSend -> AMSenderC;
	App.RadioAMControl -> ActiveMessageC;
	App.SerialAMControl -> SerialActiveMessageC;
	App.SerialReceive -> SerialAMReceiverC;
}
