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

- (void)requestAllListWithPage:(NSInteger)page block:(void(^)(BOOL))block;
- (void)requestAddListWithPage:(NSInteger)page block:(void(^)(BOOL))block;
- (void)requestPopListWithPage:(NSInteger)page block:(void(^)(BOOL))block;
- (void)requestCategoryImageListWithPage:(NSInteger)page cid:(NSString *)cid block:(void(^)(BOOL))block;
- (void)requestWallpaperCategoryWithBlock:(void(^)(BOOL))block;

@end
