//
//  ViewController.m
//  DylibTest
//
//  Created by apple on 2017/11/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#include <dlfcn.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *url = @"http://7xie3d.com1.z0.glb.clouddn.com/plugDylib.dylib";
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *fileName = response.suggestedFilename;
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:fileName];
        NSError *err = nil;
        NSLog(@"location=%@",location);
        if (location) {
            [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:path] error:&err];
            if (!err) {
                NSLog(@"下载成功，动态库路径为%@",path);
                openLib(path);
            }
        }
        
    }];
    [task resume];
    
    // Do any additional setup after loading the view, typically from a nib.
}
void openLib(NSString *libPath)
{
    if (dlopen(libPath.UTF8String, RTLD_NOW) == NULL) {
        NSLog(@"error=%s",dlerror());
    }
    else
    {
        Class playerClass = NSClassFromString(@"AdTest");
        SEL selector = NSSelectorFromString(@"playing");
        id runtimePlayer = [[playerClass alloc] init];
        [runtimePlayer performSelector:selector withObject:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
