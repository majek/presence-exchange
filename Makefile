PACKAGE=rabbit_presence_exchange
APPNAME=rabbit_presence_exchange
DEPS=rabbitmq-server rabbitmq-erlang-client

START_RABBIT_IN_TESTS=true
TEST_APPS=rabbit_presence_exchange

include ../include.mk
