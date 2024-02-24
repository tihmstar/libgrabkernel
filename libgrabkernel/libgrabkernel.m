//
//  libgrabkernel.c
//  libgrabkernel
//
//  Created by tihmstar on 31.01.19.
//  Copyright © 2019 tihmstar. All rights reserved.
//

#include "../include/libgrabkernel/libgrabkernel.h"
#include <libgeneral/macros.h>
#include <libfragmentzip/libfragmentzip.h>

#include <CoreFoundation/CoreFoundation.h>
#include <Foundation/Foundation.h>

#include <sys/utsname.h>
#include <string.h>


#define IPSW_URL_TEMPLATE "https://api.ipsw.me/v2.1/%s/%s/url/dl"

CFPropertyListRef MGCopyAnswer(CFStringRef property);
char * MYCFStringCopyUTF8String(CFStringRef aString) {
    if (aString == NULL) {
        return NULL;
    }
    
    CFIndex length = CFStringGetLength(aString);
    CFIndex maxSize =
    CFStringGetMaximumSizeForEncoding(length, kCFStringEncodingUTF8) + 1;
    char *buffer = (char *)malloc(maxSize);
    if (CFStringGetCString(aString, buffer, maxSize,
                           kCFStringEncodingUTF8)) {
        return buffer;
    }
    free(buffer); // If we failed
    return NULL;
}

int getBuildNum(char *outStr, size_t *inOutSize){
    int err = 0;
    cassure(outStr);
    cassure(inOutSize);

    CFStringRef buildVersion = MGCopyAnswer(CFSTR("BuildVersion"));
    CFIndex length = CFStringGetLength(buildVersion);
    CFIndex maxSize = CFStringGetMaximumSizeForEncoding(length, kCFStringEncodingUTF8) + 1;
    cassure(*inOutSize>=maxSize);

    cassure(CFStringGetCString(buildVersion, outStr, maxSize, kCFStringEncodingUTF8));
    *inOutSize = strlen(outStr)+1;
    
error:
    return err;
}

int getHWModel(char *outStr, size_t *inOutSize){
    int err = 0;
    cassure(outStr);
    cassure(inOutSize);
    
    CFStringRef s = MGCopyAnswer(CFSTR("HWModelStr"));
    CFIndex length = CFStringGetLength(s);
    CFIndex maxSize = CFStringGetMaximumSizeForEncoding(length, kCFStringEncodingASCII) + 1;
    cassure(*inOutSize>=maxSize);
    
    cassure(CFStringGetCString(s, outStr, maxSize, kCFStringEncodingUTF8));
    *inOutSize = strlen(outStr)+1;
    
error:
    return err;
}

int getMachineName(char *outStr, size_t *inOutSize){
    int err = 0;
    size_t realSize = 0;
    struct utsname name;
    
    cassure(outStr);
    cassure(inOutSize);
    
    cassure(!uname(&name));
    
    realSize = strlen(name.machine)+1;
    cassure(*inOutSize>=realSize);

    *inOutSize = realSize;
    strncpy(outStr,name.machine,realSize);

error:
    return err;
}

static void fragmentzip_callback(unsigned int progress){
    static int prevProgress = 0;
    if (prevProgress != progress) {
        prevProgress = progress;
        if (progress % 5 == 0) {
            printf(".");
        }
    }
}

char *getKernelpath(const char *buildmanifestPath, const char *model, int isResearchKernel){
    int err = 0;
    char *rt = NULL;
    cassure(buildmanifestPath);
    cassure(model);
   
    @autoreleasepool {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithCString:buildmanifestPath encoding:NSUTF8StringEncoding]];
        NSArray *identities = [dict valueForKey:@"BuildIdentities"];
        for (NSDictionary *item in identities) {
            NSDictionary *info = [item valueForKey:@"Info"];
            NSString *hwmodel = [info valueForKey:@"DeviceClass"];
            
            if (strcasecmp(hwmodel.UTF8String, model) == 0) {
                NSDictionary *manifest = [item valueForKey:@"Manifest"];
                NSDictionary *kcache = [manifest valueForKey:@"KernelCache"];
                NSDictionary *kinfo = [kcache valueForKey:@"Info"];
                NSString *kpath = [kinfo valueForKey:@"Path"];
                rt = strdup(kpath.UTF8String);
                break;
            }
        }
    }
    cassure(rt);
error:
    if (err) {
        printf("[GK] Error: %d\n",err);
        return NULL;
    }
    return rt;
}

int grabkernel(const char *downloadPath, int isResearchKernel){
    int err = 0;
    char build[0x100] = {};
    char machine[0x100] = {};
    char hwmodel[0x100] = {};
    char firmwareUrl[0x200] = {};
    size_t sBuild = 0;
    size_t sMachine = 0;
    size_t sModel = 0;
    fragmentzip_t * fz= NULL;
    char *kernelpath = NULL;
    printf("[GK] %s\n",libgrabkernel_version());
    cassure(downloadPath);

    sBuild = sizeof(build);
    cassure(!getBuildNum(build, &sBuild));
    printf("[GK] Got build number: %s\n",build);
    sMachine = sizeof(machine);
    cassure(!getMachineName(machine, &sMachine));
    printf("[GK] Got machine number: %s\n",machine);
    sModel = sizeof(hwmodel);
    cassure(!getHWModel(hwmodel, &sModel));
    printf("[GK] Got model: %s\n",hwmodel);

    cassure(sizeof(firmwareUrl)>sBuild+sMachine+strlen(IPSW_URL_TEMPLATE)+1);
    snprintf(firmwareUrl, sizeof(firmwareUrl), IPSW_URL_TEMPLATE, machine,build);
    
    char path[1024] = {0};
    snprintf(path, sizeof(path), "%sBuildmanifest.plist", getenv("TMPDIR"));
    
    printf("[GK] Opening remote url %s\n",firmwareUrl);
    cassure(fz = fragmentzip_open(firmwareUrl));
    
    printf("[GK] Downloading Buildmanifest");
    cassure(!fragmentzip_download_file(fz, "BuildManifest.plist", path, fragmentzip_callback));
    printf(" ok!\n");
    
    cassure(kernelpath = getKernelpath(path, hwmodel, isResearchKernel));
    printf("[GK] Downloading kernel: %s",kernelpath);
    cassure(!fragmentzip_download_file(fz, kernelpath, downloadPath, fragmentzip_callback));
    printf(" ok!\n");

    printf("[GK] Done!\n");
    
    
error:
    safeFree(kernelpath);
    return err;
}


const char* libgrabkernel_version(){
    return VERSION_STRING;
}
