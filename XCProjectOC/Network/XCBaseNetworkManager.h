//
//  XCBaseNetworkManager.h
//  LiveWallpapers
//
//  Created by xiaochen on 2018/3/22.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCBaseNetworkManager : NSObject

+ (instancetype)sharedManager;

- (void)hasNetwork:(void(^)(BOOL))block;

- (void)requestAllListWithPage:(NSInteger)page block:(void(^)(NSArray<XCPhotoModel *> *))block;

- (void)requestAddListWithPage:(NSInteger)page block:(void(^)(NSArray<XCPhotoModel *> *))block;

- (void)requestPopListWithPage:(NSInteger)page block:(void(^)(NSArray<XCPhotoModel *> *))block;

- (void)requestCategoryImageListWithPage:(NSInteger)page name:(NSString *)name cid:(NSString *)cid block:(void(^)(NSArray<XCPhotoModel *> *))block;

- (void)requestDayListWithPage:(NSInteger)page num:(NSInteger)num block:(void(^)(NSArray<XCDailyPhotoModel *> *))block;

- (void)requestWallpaperCategoryWithBlock:(void(^)(NSArray<XCWallpaperCategoryModel *> *))block;

- (void)sendFeedbackWithText:(NSString *)text block:(void(^)(BOOL))block;

@end

