TEMPLATE	= app
CONFIG		+= console
CONFIG		-= app_bundle
CONFIG		-= qt
CONFIG		+= -static

__DAP_SDK_ROOT	= /root/Works/cellframe-node/dap-sdk
__DAP_LIB_ROOT	= /root/Works/cellframe-node/build/cellframe-sdk/dap-sdk


INCLUDEPATH	+= ./
INCLUDEPATH	+= $$__DAP_SDK_ROOT/net/server/http_server/include/
INCLUDEPATH	+= $$__DAP_SDK_ROOT/net/stream/stream/include/
INCLUDEPATH	+= $$__DAP_SDK_ROOT/net/core/include/
INCLUDEPATH	+= $$__DAP_SDK_ROOT/core/include/
INCLUDEPATH	+= $$__DAP_SDK_ROOT/core/src/unix/
INCLUDEPATH	+= $$__DAP_SDK_ROOT/net/server/http_server/http_client/include/
INCLUDEPATH	+= $$__DAP_SDK_ROOT/crypto/include/
INCLUDEPATH	+= $$__DAP_SDK_ROOT/crypto/src/sha3/
INCLUDEPATH	+= $$__DAP_SDK_ROOT/crypto/src/XKCP/lib/common/


DAP_SDK_SOURCES = \
		$$__DAP_SDK_ROOT/core/src/dap_common.c \
		$$__DAP_SDK_ROOT/core/src/dap_config.c \
		$$__DAP_SDK_ROOT/core/src/dap_file_utils.c \
		$$__DAP_SDK_ROOT/core/src/dap_list.c \
		$$__DAP_SDK_ROOT/core/src/dap_module.c \
		$$__DAP_SDK_ROOT/core/src/dap_strfuncs.c \
		$$__DAP_SDK_ROOT/core/src/dap_string.c \
		$$__DAP_SDK_ROOT/core/src/rpmalloc/rpmalloc.c \
		$$__DAP_SDK_ROOT/core/src/unix/dap_cpu_monitor.c \
		$$__DAP_SDK_ROOT/core/src/unix/dap_process_manager.c \
		$$__DAP_SDK_ROOT/core/src/unix/dap_process_memory.c \
		$$__DAP_SDK_ROOT/core/src/unix/linux/dap_network_monitor.c \
		$$__DAP_SDK_ROOT/crypto/src/dap_hash.c \
		$$__DAP_SDK_ROOT/net/core/dap_events.c \
		$$__DAP_SDK_ROOT/net/core/dap_events_socket.c \
		$$__DAP_SDK_ROOT/net/core/dap_net.c \
		$$__DAP_SDK_ROOT/net/core/dap_proc_queue.c \
		$$__DAP_SDK_ROOT/net/core/dap_proc_thread.c \
		$$__DAP_SDK_ROOT/net/core/dap_server.c \
		$$__DAP_SDK_ROOT/net/core/dap_timerfd.c \
		$$__DAP_SDK_ROOT/net/core/dap_worker.c \
		$$__DAP_SDK_ROOT/net/server/http_server/dap_http.c \
		$$__DAP_SDK_ROOT/net/server/http_server/dap_http_folder.c \
		$$__DAP_SDK_ROOT/net/server/http_server/dap_http_simple.c \
		$$__DAP_SDK_ROOT/net/server/http_server/http_client/dap_http_client.c \
		$$__DAP_SDK_ROOT/net/server/http_server/http_client/dap_http_header.c \
		$$__DAP_SDK_ROOT/net/server/http_server/http_client/dap_http_user_agent.c \

DEFINES		+= CELLFRAME_SDK_VERSION=\\\"3.0-15\\\"
DEFINES		+= DAP_MODULES_DYNAMIC=1
DEFINES		+= DAP_OS_LINUX=1
DEFINES		+= DAP_OS_UNIX=1
DEFINES		+= DAP_SRV_STAKE_USED=1
DEFINES		+= DAP_VERSION=\\\"5-0.26\\\"
DEFINES		+= _GNU_SOURCE=1

QMAKE_CFLAGS	+= -std=gnu11 -std=c11


SOURCES		+= $$DAP_SDK_SOURCES \
		wb.c \

HEADERS		+= \

DEFINES		+= DAP_OS_LINUX=1
DEFINES		+= "__ARCH__NAME__=\"\\\"$$QMAKE_HOST.arch\\\"\""

##DEFINES += "VERSION=\"\\\"0.1.0\\\"\""

#QMAKE_LIBS	+= $$__DAP_LIB_ROOT/net/core/libdap_server_core.a
#QMAKE_LIBS	+= $$__DAP_LIB_ROOT/core/libdap_core.a
#QMAKE_LIBS	+= $$__DAP_LIB_ROOT/net/server/http_server/libdap_http_server.a
#QMAKE_LIBS	+= $$__DAP_LIB_ROOT/crypto/libdap_crypto.a

QMAKE_LIBS	+= -pthread -lrt  -ljson-c -lmagic


CONFIG (debug, debug|release) {
	DEFINES	+= _DEBUG=1 __TRACE__=1 DEBUG=1
}
else {
	CONFIG	+= warn_off
	DEFINES	+= _DEBUG=1 __TRACE__=1 DEBUG=1
}
