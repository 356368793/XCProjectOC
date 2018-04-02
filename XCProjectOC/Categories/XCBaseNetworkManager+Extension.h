//
//  XCBaseNetworkManager+Extension.h
//  LiveWallpapers
//
//  Created by xiaochen on 2018/3/26.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "XCBaseNetworkManager.h"

@interface XCBaseNetworkManager (Extension)

- (void)managerAllListDataWithArray:(NSArray *)array block:(void(^)(NSArray<XCPhotoModel *> *))block;
- (void)managerAddListDataWithArray:(NSArray *)array block:(void(^)(NSArray<XCPhotoModel *> *))block;
- (void)managerPopListDataWithArray:(NSArray *)array block:(void(^)(NSArray<XCPhotoModel *> *))block;
- (void)managerCategoryImageListDataWithArray:(NSArray *)array block:(void(^)(NSArray<XCPhotoModel *> *))block;
- (void)managerDayListDataWithArray:(NSArray *)array block:(void(^)(NSArray<XCDailyPhotoModel *> *))block;
- (void)managerCategoryListDataWithArray:(NSArray *)array block:(void(^)(BOOL success))block;

@end
