//
//  XCHomeViewController.m
//  XCProjectOC
//
//  Created by xiaochen on 2018/3/19.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "XCHomeViewController.h"

@interface XCHomeViewController ()

@end

@implementation XCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor randomColor];
    
    XCCache *cache = [[XCCache alloc] init];
    NSString *cacheString = [cache getCacheString];
    NSLog(@"cacheString = %@", cacheString);
    
    NSString *bundle = [XCTools getBundleID];
    NSString *version = [XCTools getVersion];
    NSString *appName = [XCTools getAppName];
    NSLog(@"bundle = %@, version = %@, appName = %@", bundle, version, appName);
}

@end
