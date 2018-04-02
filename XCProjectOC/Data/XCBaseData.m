//
//  XCBaseData.m
//  LiveWallpapers
//
//  Created by xiaochen on 2018/3/22.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "XCBaseData.h"

@interface XCBaseData ()

@property (strong, nonatomic) NSMutableDictionary *pageDictionary;

@end

@implementation XCBaseData

static XCBaseData *_sharedData = nil;
+ (instancetype)sharedData {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedData = [[XCBaseData alloc] init];
        _sharedData.pageDictionary = [NSMutableDictionary dictionary];
    });
    return _sharedData;
}

- (NSInteger)getPageWithPageName:(NSString *)pageName {
    if ([[_pageDictionary allKeys] containsObject:pageName]) {
        return [_pageDictionary[pageName] integerValue];
    } else {
        [_pageDictionary setObject:@(1) forKey:pageName];
        return 1;
    }
}

- (NSInteger)getAddPageWithPageName:(NSString *)pageName {
    if ([[_pageDictionary allKeys] containsObject:pageName]) {
        NSInteger page = [_pageDictionary[pageName] integerValue] + 1;
        [_pageDictionary setObject:@(page) forKey:pageName];
        
        NSLog(@"PageName = %@, page = %ld", pageName, page);
        return page;
    } else {
        [_pageDictionary setObject:@(1) forKey:pageName];
        
        NSLog(@"PageName = %@, page = 1", pageName);
        return 1;
    }
}

@end
