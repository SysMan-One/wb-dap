TEMPLATE	= app
CONFIG		+= console
CONFIG		-= app_bundle
CONFIG		-= qt
CONFIG		+= -static


__DAP_SDK_SRCROOT	= /root/Works/cellframe-node/cellframe-sdk/dap-sdk
__3DPARTY_ROOT		= /root/Works/cellframe-node/cellframe-sdk/3rdparty
__DAP_SDK_LIBROOT	= /root/Works/cellframe-node/build//cellframe-sdk/


INCLUDEPATH	+= ./
INCLUDEPATH	+= $$__DAP_SDK_SRCROOT/net/server/http_server/include/
INCLUDEPATH	+= $$__DAP_SDK_SRCROOT/net/server/enc_server/include/
INCLUDEPATH	+= $$__DAP_SDK_SRCROOT/net/stream/stream/include/
INCLUDEPATH	+= $$__DAP_SDK_SRCROOT/net/core/include/
INCLUDEPATH	+= $$__DAP_SDK_SRCROOT/core/include/
INCLUDEPATH	+= $$__DAP_SDK_SRCROOT/core/src/unix/
INCLUDEPATH	+= $$__DAP_SDK_SRCROOT/net/server/http_server/http_client/include/
INCLUDEPATH	+= $$__DAP_SDK_SRCROOT/crypto/include/
INCLUDEPATH	+= $$__DAP_SDK_SRCROOT/crypto/src/sha3/
INCLUDEPATH	+= $$__DAP_SDK_SRCROOT/crypto/src/rand/
INCLUDEPATH	+= $$__DAP_SDK_SRCROOT/crypto/src/XKCP/lib/common/

INCLUDEPATH	+= $$__3DPARTY_ROOT/uthash/src


DEFINES		+= CELLFRAME_SDK_VERSION=\\\"3.0-15\\\"
DEFINES		+= DAP_MODULES_DYNAMIC=1
DEFINES		+= DAP_OS_LINUX=1
DEFINES		+= DAP_OS_UNIX=1
DEFINES		+= DAP_SRV_STAKE_USED=1
DEFINES		+= DAP_VERSION=\\\"5-0.26\\\"
DEFINES		+= _GNU_SOURCE=1
DEFINES		+= DAP_NET_CLIENT_SSL=1


QMAKE_CFLAGS	+= -std=gnu11 -std=c11


SOURCES		+=  \    #### $$DAP_SDK_SOURCES \
		wb.c \

HEADERS		+= \

DEFINES		+= DAP_OS_LINUX=1
DEFINES		+= "__ARCH__NAME__=\"\\\"$$QMAKE_HOST.arch\\\"\""

##DEFINES += "VERSION=\"\\\"0.1.0\\\"\""

QMAKE_LIBS	+= $$__DAP_SDK_LIBROOT/dap-sdk/net/server/enc_server/libdap_enc_server.a
QMAKE_LIBS	+= $$__DAP_SDK_LIBROOT/dap-sdk/net/server/http_server/libdap_http_server.a
QMAKE_LIBS	+= $$__DAP_SDK_LIBROOT/dap-sdk/net/client/libdap_client.a
QMAKE_LIBS	+= $$__DAP_SDK_LIBROOT/dap-sdk/net/core/libdap_server_core.a
QMAKE_LIBS	+= $$__DAP_SDK_LIBROOT/dap-sdk/crypto/libdap_crypto.a
QMAKE_LIBS	+= $$__DAP_SDK_LIBROOT/dap-sdk/core/libdap_core.a



QMAKE_LIBS	+= -pthread -lrt  -ljson-c -lmagic -lssl -lcrypto


CONFIG (debug, debug|release) {
	DEFINES	+= _DEBUG=1 __TRACE__=1 DEBUG=1
}
else {
	CONFIG	+= warn_off
	DEFINES	+= _DEBUG=1 __TRACE__=1 DEBUG=1
}
