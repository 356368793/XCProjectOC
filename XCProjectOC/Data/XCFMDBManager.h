//
//  XCFMDBManager.h
//  LiveWallpapers
//
//  Created by xiaochen on 2018/3/23.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCFMDBManager : NSObject

+ (instancetype)sharedManager;

- (void)addFavorite:(XCPhotoModel *)model;
- (void)removeFavorite:(XCPhotoModel *)model;
- (BOOL)isExist:(XCPhotoModel *)model;
- (NSArray<XCPhotoModel *> *)getFavoritePhotos;

@end
