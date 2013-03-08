
#ifndef EASY_DISSEMINATION_WITH_SERIAL_H
#define EASY_DISSEMINATION_WITH_SERIAL_H

typedef nx_struct test_serial_msg {
  nx_uint16_t counter;
} test_serial_msg_t;

enum {
  AM_TEST_SERIAL_MSG = 0x89,
};

#endif
