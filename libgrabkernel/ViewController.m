//
//  ViewController.m
//  libgrabkernel
//
//  Created by tihmstar on 31.01.19.
//  Copyright © 2019 tihmstar. All rights reserved.
//

#import "ViewController.h"
#include "libgrabkernel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    char path[1024] = {0};
    snprintf(path, sizeof(path), "%skernel", getenv("TMPDIR"));

    int asd = grabkernel(path, 0);


    printf("");
}


@end
