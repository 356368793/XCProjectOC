//
//  XCDailyPhotoModel.h
//  XCHDWallpaperGather
//
//  Created by xiaochen on 2018/3/27.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCDailyPhotoModel : NSObject

@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSArray<XCPhotoModel *> *info;

@end
