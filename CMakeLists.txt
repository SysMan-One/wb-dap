cmake_minimum_required(VERSION 3.4.1)

project(wb)

IF (NOT DEFINED DAP_SDK_ROOT)
    SET(DAP_SDK_ROOT ".")
ENDIF()
ADD_DEFINITIONS(-DDAP_SDK_ROOT=${DAP_SDK_ROOT})

message(STATUS "Current DAP SDK path is '${DAP_SDK_ROOT}'. Add '-DDAP_SDK_ROOT=<path_to_sdk>' to cmake if want to change path")

include_directories( 
	${DAP_SDK_ROOT}/net/server/http_server/include/
    ${DAP_SDK_ROOT}/net/stream/stream/include/
    ${DAP_SDK_ROOT}/net/core/include/
    ${DAP_SDK_ROOT}/core/include/
    ${DAP_SDK_ROOT}/core/src/unix/
    ${DAP_SDK_ROOT}/net/server/http_server/http_client/include/
    ${DAP_SDK_ROOT}/crypto/include/
    ${DAP_SDK_ROOT}/crypto/src/sha3/
    ${DAP_SDK_ROOT}/crypto/src/XKCP/lib/common/
    )

set(DAP_SDK_SOURCES 
		${DAP_SDK_ROOT}/core/src/dap_common.c
		${DAP_SDK_ROOT}/core/src/dap_config.c
		${DAP_SDK_ROOT}/core/src/dap_file_utils.c
		${DAP_SDK_ROOT}/core/src/dap_list.c
		${DAP_SDK_ROOT}/core/src/dap_module.c
		${DAP_SDK_ROOT}/core/src/dap_strfuncs.c
		${DAP_SDK_ROOT}/core/src/dap_string.c
		${DAP_SDK_ROOT}/core/src/rpmalloc/rpmalloc.c
		${DAP_SDK_ROOT}/core/src/unix/dap_cpu_monitor.c
		${DAP_SDK_ROOT}/core/src/unix/dap_process_manager.c
		${DAP_SDK_ROOT}/core/src/unix/dap_process_memory.c
		${DAP_SDK_ROOT}/core/src/unix/linux/dap_network_monitor.c
		${DAP_SDK_ROOT}/crypto/src/dap_hash.c
		${DAP_SDK_ROOT}/net/core/dap_events.c
		${DAP_SDK_ROOT}/net/core/dap_events_socket.c
		${DAP_SDK_ROOT}/net/core/dap_net.c
		${DAP_SDK_ROOT}/net/core/dap_proc_queue.c
		${DAP_SDK_ROOT}/net/core/dap_proc_thread.c
		${DAP_SDK_ROOT}/net/core/dap_server.c
		${DAP_SDK_ROOT}/net/core/dap_timerfd.c
		${DAP_SDK_ROOT}/net/core/dap_worker.c
		${DAP_SDK_ROOT}/net/server/http_server/dap_http.c
		${DAP_SDK_ROOT}/net/server/http_server/dap_http_folder.c
		${DAP_SDK_ROOT}/net/server/http_server/dap_http_simple.c
		${DAP_SDK_ROOT}/net/server/http_server/http_client/dap_http_client.c
		${DAP_SDK_ROOT}/net/server/http_server/http_client/dap_http_header.c
		${DAP_SDK_ROOT}/net/server/http_server/http_client/dap_http_user_agent.c
        )

add_executable(wb ${DAP_SDK_SOURCES} wb.c)

target_compile_definitions(wb PRIVATE
        -DCELLFRAME_SDK_VERSION="3.0-15"
        -DDAP_MODULES_DYNAMIC=1
        -DDAP_OS_LINUX=1
        -DDAP_OS_UNIX=1
        -DDAP_SRV_STAKE_USED=1
        -DDAP_VERSION="5-0.26"
        -D_GNU_SOURCE=1
        )

target_link_libraries(wb -pthread -lrt  -ljson-c -lmagic)


FILE(WRITE ${CMAKE_BINARY_DIR}/index.html
"<html>\r\n"
"  <head>\r\n"
"    <title>BadAss's nano HTTP server index.html</title>\r\n"
"  </head>\r\n"
"  <body>\r\n"
"   <p>This is an example index page to demonstrate a Power of the DAP SKD API</p>\r\n"
"  </body>\r\n"
"</html>\r\n"
)
