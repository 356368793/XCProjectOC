//
//  XCBaseNetwork.h
//  XCProjectOC
//
//  Created by xiaochen on 2018/3/21.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface XCBaseNetwork : NSObject

+ (instancetype _Nullable)sharedNetwork;

/** category */
- (void)getWallpaperCategoryWithParams:(id)params andBlock:(void(^_Nullable)(id _Nullable response, NSError *_Nullable error))block;

/** new list */
- (void)getAddListWithParams:(id)params andBlock:(void(^_Nullable)(id _Nullable response, NSError * _Nullable error))block;

/** pop list */
- (void)getPopListWithParams:(id)params andBlock:(void(^_Nullable)(id _Nullable response, NSError *_Nullable error))block;

/** category image list */
- (void)getCategoryImageListWithParams:(id)params andBlock:(void(^_Nullable)(id _Nullable response, NSError *_Nullable error))block;

/** audit */
- (void)getAuditResultWithParams:(id)params andBlock:(void(^_Nullable)(id _Nullable response, NSError *_Nullable error))block;

@end
