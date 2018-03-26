//
//  XCBaseData.m
//  LiveWallpapers
//
//  Created by xiaochen on 2018/3/22.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "XCBaseData.h"

@implementation XCBaseData

static XCBaseData *_sharedData = nil;
+ (instancetype)sharedData {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedData = [[XCBaseData alloc] init];
    });
    return _sharedData;
}

@end
