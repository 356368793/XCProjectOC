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

- (void)addPhoto:(XCPhotoModel *)photo;
- (BOOL)isPhotoExist:(XCPhotoModel *)photo;
- (void)removePhoto:(XCPhotoModel *)photo;
- (NSArray<XCPhotoModel *> *)getFavoritePhotos;

@end
