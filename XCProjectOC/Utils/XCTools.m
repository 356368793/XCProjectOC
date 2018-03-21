//
//  XCTools.m
//  XCProjectOC
//
//  Created by xiaochen on 2018/3/21.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "XCTools.h"

@implementation XCTools

+ (NSString *)getBundleID {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

+ (NSString *)getVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)getAppName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

@end
