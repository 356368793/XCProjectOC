//
//  XCBaseData.h
//  LiveWallpapers
//
//  Created by xiaochen on 2018/3/22.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBaseDataFavoriteListArray @"kBaseDataFavoriteListArray"

@interface XCBaseData : NSObject

+ (instancetype)sharedData;

@property (copy, nonatomic) NSArray<XCPhotoModel *> *addListArray;
@property (copy, nonatomic) NSArray<XCPhotoModel *> *popListArray;
@property (copy, nonatomic) NSArray<XCPhotoModel *> *favListArray;
@property (copy, nonatomic) NSArray<XCPhotoModel *> *categoryImageListArray;
@property (copy, nonatomic) NSArray<XCWallpaperCategoryModel *> *categoryArray;

@end
