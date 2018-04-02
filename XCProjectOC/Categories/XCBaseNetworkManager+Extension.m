//
//  XCBaseNetworkManager+Extension.m
//  LiveWallpapers
//
//  Created by xiaochen on 2018/3/26.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "XCBaseNetworkManager+Extension.h"

@implementation XCBaseNetworkManager (Extension)

- (void)managerAllListDataWithArray:(NSArray *)array block:(void (^)(NSArray<XCPhotoModel *> *))block {
    NSMutableArray *models = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger i = 0; i < [array count]; i++) {
            XCPhotoModel *model = [XCPhotoModel mj_objectWithKeyValues:array[i]];
            [models addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            block(models);
        });
    });
}

- (void)managerAddListDataWithArray:(NSArray *)array block:(void (^)(NSArray<XCPhotoModel *> *))block {
    NSMutableArray *models = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger i = 0; i < [array count]; i++) {
            XCPhotoModel *model = [XCPhotoModel mj_objectWithKeyValues:array[i]];
            [models addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            block(models);
        });
    });
}

- (void)managerPopListDataWithArray:(NSArray *)array block:(void (^)(NSArray<XCPhotoModel *> *))block {
    NSMutableArray *models = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger i = 0; i < [array count]; i++) {
            XCPhotoModel *model = [XCPhotoModel mj_objectWithKeyValues:array[i]];
            [models addObject:model];
        }
//        [XCBaseData sharedData].popListArray = models;
        dispatch_async(dispatch_get_main_queue(), ^{
            block(models);
        });
    });
}

- (void)managerCategoryImageListDataWithArray:(NSArray *)array block:(void (^)(NSArray<XCPhotoModel *> *))block {
    NSMutableArray *models = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger i = 0; i < [array count]; i++) {
            XCPhotoModel *model = [XCPhotoModel mj_objectWithKeyValues:array[i]];
            [models addObject:model];
        }
//        [XCBaseData sharedData].categoryImageListArray = models;
        dispatch_async(dispatch_get_main_queue(), ^{
            block(models);
        });
    });
}

- (void)managerDayListDataWithArray:(NSArray *)array block:(void (^)(NSArray<XCDailyPhotoModel *> *))block {
    NSMutableArray<XCDailyPhotoModel *> *models = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger i = 0; i < [array count]; i++) {
            [XCDailyPhotoModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"info": [XCPhotoModel class]
                         };
            }];
            XCDailyPhotoModel *model = [XCDailyPhotoModel mj_objectWithKeyValues:array[i]];
            
            [models addObject:model];
        }
        block(models);
    });
}

- (void)managerCategoryListDataWithArray:(NSArray *)array block:(void (^)(BOOL))block {
    
}

@end
