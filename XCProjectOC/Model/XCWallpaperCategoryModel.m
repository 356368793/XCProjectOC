//
//  XCWallpaperCategoryModel.m
//  LiveWallpapers
//
//  Created by xiaochen on 2018/3/22.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "XCWallpaperCategoryModel.h"

@implementation XCWallpaperCategoryModel

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID": @"id"};
}

@end
