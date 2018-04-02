//
//  XCBaseDataManager.h
//  LiveWallpapers
//
//  Created by xiaochen on 2018/3/22.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XCBasePhotoType) {
    XCBasePhotoTypeGet = 0, // return old data if exist
    XCBasePhotoTypeAdd // query new page data
};

@interface XCBaseDataManager : NSObject

+ (instancetype)sharedManager;

// favorite
- (void)addFavorite:(XCPhotoModel *)model;
- (void)removeFavorite:(XCPhotoModel *)model;
- (BOOL)isExist:(XCPhotoModel *)model;
- (NSArray<XCPhotoModel *> *)getFavoritePhotos;


- (void)getXxxxxWithType:(XCBasePhotoType)type block:(void(^)(NSArray<XCPhotoModel *> *))block;

@end
