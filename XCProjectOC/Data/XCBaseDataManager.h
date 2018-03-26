//
//  XCBaseDataManager.h
//  LiveWallpapers
//
//  Created by xiaochen on 2018/3/22.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCBaseDataManager : NSObject

+ (instancetype)sharedManager;

- (void)addFavorite:(XCPhotoModel *)model;
- (void)removeFavorite:(XCPhotoModel *)model;
- (BOOL)isExist:(XCPhotoModel *)model;

- (void)managerAddListDataWithArray:(NSArray *)array block:(void(^)(BOOL success))block;
- (void)managerPopListDataWithArray:(NSArray *)array block:(void(^)(BOOL success))block;
- (void)managerCategoryImageListDataWithArray:(NSArray *)array block:(void(^)(BOOL success))block;
- (void)managerCategoryListDataWithArray:(NSArray *)array block:(void(^)(BOOL success))block;


@end
