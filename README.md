# wb-dap
## A workbench project to be used to study DAP SDK API to implement a simple HTTP server.

First at all get the DAP-SDK from the Git@DemoLabs to some directory.

  $ git clone https://gitlab.demlabs.net/cellframe/cellframe-node.git --recursive
  
  
To build WorkBench program use:
	
	$ cmake build ./  -DDAP_SDK_ROOT="<path_to_dap_sdk_root_directory>"
	$ cd build
  $ make
  
To run :  
 on server side:
 $ ./wb <ENTER>
 
 on client side :
 $ wget -d http://127.0.0.1:8080/  <ENTER>
	
 or
$ lynx  http://127.0.0.1:8080/  <ENTER>	
