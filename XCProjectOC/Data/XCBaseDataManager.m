//
//  XCBaseDataManager.m
//  LiveWallpapers
//
//  Created by xiaochen on 2018/3/22.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "XCBaseDataManager.h"

@implementation XCBaseDataManager

static XCBaseDataManager *_sharedManager = nil;
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[XCBaseDataManager alloc] init];
    });
    return _sharedManager;
}

- (void)addFavorite:(XCPhotoModel *)model {
    NSMutableArray<XCPhotoModel *> *array = [NSMutableArray arrayWithArray:[XCBaseData sharedData].favListArray];
    [array addObject:model];
    [XCBaseData sharedData].favListArray = array;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[XCFMDBManager sharedManager] addPhoto:model];
    });
}

- (void)removeFavorite:(XCPhotoModel *)model {
    NSMutableArray<XCPhotoModel *> *array = [NSMutableArray arrayWithArray:[XCBaseData sharedData].favListArray];
    for (XCPhotoModel *tmpModel in [array copy]) {
        if ([tmpModel.imageurl isEqualToString:model.imageurl] &&
            [tmpModel.smallimageurl isEqualToString:model.smallimageurl]) {
            [array removeObject:model];
        }
    }
    [XCBaseData sharedData].favListArray = array;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[XCFMDBManager sharedManager] removePhoto:model];
    });
}

- (BOOL)isExist:(XCPhotoModel *)model {
    NSMutableArray<XCPhotoModel *> *array = [NSMutableArray arrayWithArray:[XCBaseData sharedData].favListArray];
    for (XCPhotoModel *tmpModel in [array copy]) {
        if ([tmpModel.imageurl isEqualToString:model.imageurl] &&
            [tmpModel.smallimageurl isEqualToString:model.smallimageurl]) {
            return YES;
        }
    }
    return NO;
}

- (void)managerAddListDataWithArray:(NSArray *)array block:(void (^)(BOOL))block {
    NSMutableArray *models = [NSMutableArray array];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger i = 0; i < [array count]; i++) {
            XCPhotoModel *model = [XCPhotoModel mj_objectWithKeyValues:array[i]];
            [models addObject:model];
        }
        [XCBaseData sharedData].addListArray = models;
        dispatch_async(dispatch_get_main_queue(), ^{
            block(YES);
        });
    });
}

- (void)managerPopListDataWithArray:(NSArray *)array block:(void (^)(BOOL))block {
    NSMutableArray *models = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger i = 0; i < [array count]; i++) {
            XCPhotoModel *model = [XCPhotoModel mj_objectWithKeyValues:array[i]];
            [models addObject:model];
        }
        [XCBaseData sharedData].popListArray = models;
        dispatch_async(dispatch_get_main_queue(), ^{
            block(YES);
        });
    });
}

- (void)managerCategoryImageListDataWithArray:(NSArray *)array block:(void (^)(BOOL))block {
    NSMutableArray *models = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger i = 0; i < [array count]; i++) {
            XCPhotoModel *model = [XCPhotoModel mj_objectWithKeyValues:array[i]];
            [models addObject:model];
        }
        [XCBaseData sharedData].categoryImageListArray = models;
        dispatch_async(dispatch_get_main_queue(), ^{
            block(YES);
        });
    });
}

- (void)managerCategoryListDataWithArray:(NSArray *)array block:(void (^)(BOOL))block {
    
}

@end
