#include "DataAggregation.h"

configuration DataAggregationAppC{}

implementation {

	components DataAggregationC, MainC, LedsC, ActiveMessageC, new PhotoC() as Sensor;
	
  components SerialActiveMessageC as AM;
  DataAggregationC.SerialControl -> AM;
	
  DataAggregationC.AMSend -> AM.AMSend[AM_TEST_SERIAL_MSG];
  DataAggregationC.Packet -> AM;

	DataAggregationC.Read -> Sensor;

	components CollectionC as Collector;
	components new CollectionSenderC(0xee);
	
	DataAggregationC.Boot -> MainC;
	DataAggregationC.RadioControl -> ActiveMessageC;
	
	DataAggregationC.RoutingControl -> Collector;
	DataAggregationC.Leds -> LedsC;
	
	DataAggregationC.Send -> CollectionSenderC;
	
	DataAggregationC.RootControl -> Collector;
	DataAggregationC.Receive -> Collector.Receive[0xee];
	
	components new TimerMilliC();	
	DataAggregationC.Timer -> TimerMilliC;

	
}
