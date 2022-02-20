#define	__MODULE__	"WB$HTTP"
#define	__IDENT__	"X.00-02"


/*
 *   FACILITY: WorkBench for testk task to study DAP SDK
 *
 *   DESCRIPTION: Main module of the  WorkBench for test task.
 *
 *   ABSTRACT: A demonstraion of using DAP SDK to implement a simple HTTP server to
 *	serve request on the single path.
 *
 *	Always return a content of the index.html file!
 *
 *   AUTOHR: Ruslan (BadAss SysMan) Laishev
 *
 *   CREATION DATE: 25-JAN-2022
 *
 *   BUILD:
 *
 *	$ cmake build . -DDAP_SDK_ROOT="./"
 *	$ cd build
 *	$ make
 *
 *   USAGE:
 *	on server side:
 *		$ ./wb <ENTER>
 *
 *	on client side:
 *		$ wget -d http://127.0.0.1:8080/  <ENTER>
 *
 *   MODIFICATION HISTORY:
 *
 *	25-JAN-2022	RRL	Stole some parts from the DAP SDK modules
 *
 *	26-JAN-2022	RRL	Recoded by using source files from the DAP SDK is included as a part of the project
 *
 *	27-JAN-2022	RRL	Some reformating,
 *
 *	29-JAN-2022	RRL	X.00-02 : Adopted to use build with the CELLFRAME/DAP-SDK Libraries instead of
 *				sources.
 *
 *
 */

#include	<stdio.h>
#include	<stdlib.h>
#include	<string.h>
#include	<unistd.h>
#include	<errno.h>

#include	"dap_common.h"
#include	"dap_config.h"						/* *g_config - a global context with the run-time parameters */
#include	"dap_server.h"
#include	"dap_http.h"
#include	"dap_http_simple.h"
#include	"dap_http_folder.h"
#include	"dap_events.h"
#include	"dap_file_utils.h"
#include	"http_status_code.h"
#include	"dap_enc_http.h"



#define		WB$SZ_MAXREPLY		64*1024				/* Maximum length of the HTT"s body can be returned to caller */
#define		WB$T_LOCADDR		"0.0.0.0"			/* Local address to bind, 0.0.0.0 - any */
#define		WB$K_LOCPORT		8080				/* Local port bind TCP listener server */
#define		LOG_TAG			"WB$HTTP"			/* A marker for the LOG's records */
#define		WB$T_HOMEPAGE		"index.html"			/* A name of file to be returned content from */
#define		WB$T_CONFSPEC		"./wb.conf"			/* A file spec of the WB/DAP-SDK configuration file */


/*
 *   DESCRIPTION: Retrieve and return to HTTP's engine a whole or part of the index.html file.
 *	It is supposed to be used as the callback.
 *
 *   INPUTS:
 *	ctx:	A context for the HTTP's Simple
 *
 *   OUTPUTS:
 *	rc:	A result of the processing request, HTTP Status
 *
 *   RETURNS:
 *	NONE
 */
static void s_wb_http_rqproc_cb (void *a_ctx, int *a_rc )
{
struct dap_http_simple *l_hts = (	struct dap_http_simple *) a_ctx;
char	*l_contents;
size_t	l_length;

	if ( !dap_file_get_contents(WB$T_HOMEPAGE, &l_contents, &l_length) )
		{
		*a_rc = Http_Status_NotFound;
		log_it( L_ERROR, "dap_file_get_contents(%s),reply HTTP's status code : %d", WB$T_HOMEPAGE, *a_rc);
		}
	else	{
		dap_http_simple_reply(l_hts, l_contents, l_length );
		free(l_contents);

		strcpy( l_hts->reply_mime, "text/html" );

		*a_rc = Http_Status_OK;
		log_it( L_DEBUG, "A content to be returned follows (%lu octets)\n\n%.*s\n\n", l_hts->reply_size, (int) l_hts->reply_size, l_hts->reply_str);
		}

	log_it( L_DEBUG, "Reply HTTP's status code : %d", *a_rc);
}


/* DESCRIPTION: Main routine: performs network (TCP and HTTP) initialization stuff to start listening for HTTP request on the
 *	predefibed WB$K_LOCADRR/WB$K_LOCPORT pair. Start hibernation untile Control-C.
 *	Setup the collback routine to process HTTP request by sending HTTP's body as-is to the requestor.
 *
 *  INPUTS:
 *	NONE
 *
 *  OUTPUTS:
 *	NONE
 *
 *  RETURNS:
 *	0 >	- execution has been aborted
 *	0	- ordinar shutdown
 */
int	main ( void )
{
dap_server_t *l_server = NULL;
bool	l_debug_mode = false;
int	l_rc = 0, l_locport = WB$K_LOCPORT;
const char	*l_locaddr = WB$T_LOCADDR;
dap_events_t *l_events;

	dap_set_appname("wb");								/* Facility prefix for loggin purpose */

	if ( dap_common_init("WB$HTTP", 0, 0 ) )					/* Log to console only ! */
		{
		fprintf(stderr, "dap_common_init() failed, errno=%d", errno);
		return -2;
		}

	/* Retreive a run-time parameters from the ./wb.cfg file */
	l_rc = dap_config_init(".");

	if ( !(g_config = dap_config_open("wb")) )
		{
		log_it( L_CRITICAL,"Can't init general configurations" );
		return -1;
		}

	l_debug_mode = dap_config_get_item_bool_default( g_config ,"general", "debug_mode", false );
	l_locport = dap_config_get_item_uint16_default( g_config ,"general", "locport", WB$K_LOCPORT  );
	l_locaddr = dap_config_get_item_str_default( g_config ,"general", "locaddr", WB$T_LOCADDR  );


	log_it( L_ATT, l_debug_mode ? "*** DEBUG MODE ***" : "*** NORMAL MODE ***" );
	dap_log_level_set( l_debug_mode ? L_DEBUG : L_NOTICE );


	/* New event loop init */
	dap_events_init( 0, 0 );

	if ( !(l_events = dap_events_new()) )
		return	log_it( L_CRITICAL, "dap_events_new() failed" ),  -4;

	dap_events_start( l_events );


#if 0
	if ( dap_client_http_init() )
		return	log_it( L_CRITICAL, "dap_client_init()) failed" ), -4;
#endif


	/* TCP and HTTP related initialization to handling request to the root (/) path  */
	if ( dap_server_init() )
		return	log_it( L_CRITICAL, "dap_server_init()) failed" ), -4;

	if ( dap_http_init() != 0 )
		return	log_it( L_CRITICAL, "dap_http_init() failed" ), -5;

	if ( dap_http_simple_module_init() )
		return	log_it(L_CRITICAL, "dap_http_simple_module_init() failed"), -9;

	if ( !(l_server = dap_server_new(l_events, l_locaddr,  l_locport, SERVER_TCP, NULL)) )
		return	log_it( L_CRITICAL, "dap_server_new() failed"), -EINVAL;

	if ( dap_http_new ( l_server, "BadAss's nano HTTP server") )
		return	log_it( L_CRITICAL, "dap_http_new() failed"), -EINVAL;

	dap_http_simple_proc_add( DAP_HTTP( l_server), "/", DAP_HTTP_SIMPLE_REQUEST_MAX, (dap_http_simple_callback_t) s_wb_http_rqproc_cb);
#if 0
	enc_http_add_proc( DAP_HTTP( l_server), "/enc_init");
#endif


	/* Hibernate main thread untile something critical will take place ... */
	l_rc = dap_events_wait(l_events);
	log_it( l_rc ? L_CRITICAL : L_NOTICE, "Server loop stopped with return code %d", l_rc );

	/* Cleanuping ... */
	dap_server_deinit();
	dap_http_simple_module_deinit();
	dap_http_deinit();
	dap_events_deinit();
	dap_common_deinit();

	return	0;	/* Stop programm */
}
