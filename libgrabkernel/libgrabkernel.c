//
//  libgrabkernel.c
//  libgrabkernel
//
//  Created by tihmstar on 31.01.19.
//  Copyright © 2019 tihmstar. All rights reserved.
//

#include "all_libgrabkernel.h"
#include "libgrabkernel.h"
#include <sys/utsname.h>
#include <string.h>

#define assure(a) do{ if ((a) == 0){err=__LINE__; goto error;} }while(0)
#define retassure(retcode, a) do{ if ((a) == 0){err=retcode; goto error;} }while(0)
#define safeFree(a) do{ if (a){free(a); a=NULL;} }while(0)

#define IPSW_URL_TEMPLATE "https://api.ipsw.me/v2.1/%s/%s/url/dl"

int getBuildNum(char *outStr, size_t *inOutSize){
    int err = 0;
    size_t realSize = 0;
    assure(outStr);
    assure(inOutSize);
    
    realSize = sizeof("15F79");//debug
    assure(*inOutSize>=realSize);
    
    *inOutSize = realSize;
    strncpy(outStr,"15F79",realSize);
    
error:
    return err;
}

int getMachineName(char *outStr, size_t *inOutSize){
    int err = 0;
    size_t realSize = 0;
    struct utsname name;
    
    assure(outStr);
    assure(inOutSize);
    
    assure(!uname(&name));
    
    realSize = strlen(name.machine)+1;
    assure(*inOutSize>=realSize);

    *inOutSize = realSize;
    strncpy(outStr,name.machine,realSize);

error:
    return err;
}

int grabkernel(void){
    int err = 0;
    char build[0x100] = {};
    char machine[0x100] = {};
    char firmwareUrl[0x200] = {};
    size_t sBuild = 0;
    size_t sMachine = 0;

    sBuild = sizeof(build);
    assure(!getBuildNum(build, &sBuild));
    sMachine = sizeof(machine);
    assure(!getMachineName(machine, &sMachine));
    
    assure(sizeof(firmwareUrl)>sBuild+sMachine+strlen(IPSW_URL_TEMPLATE)+1);
    snprintf(firmwareUrl, sizeof(firmwareUrl), IPSW_URL_TEMPLATE, machine,build);
    
    
    
error:
    return err;
}


const char* libgrabkernel_version(){
    return "Libgrabkernel Version: " LIBGRABKERNEL_VERSION_COMMIT_SHA " - " LIBGRABKERNEL_VERSION_COMMIT_COUNT;
}
