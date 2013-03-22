
#ifndef DATA_AGGREGATION_WITH_SERIAL_H
#define DATA_AGGREGATION_WITH_SERIAL_H

enum {
  AM_TEST_SERIAL_MSG = 0x89,
};

enum {
  /* Number of readings per message. If you increase this, you may have to
     increase the message_t size. */
  NREADINGS = 10,

  /* Default sampling period. */
  DEFAULT_INTERVAL = 256,

  AM_OSCILLOSCOPE = 0x93
};

#endif
