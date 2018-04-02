//
//  XCFMDBManager.m
//  LiveWallpapers
//
//  Created by xiaochen on 2018/3/23.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "XCFMDBManager.h"
#import "XCFMDB.h"

@interface XCFMDBManager () 

@end

@implementation XCFMDBManager

#pragma mark - public -
- (void)addFavorite:(XCPhotoModel *)model {
    NSMutableArray<XCPhotoModel *> *array = [NSMutableArray arrayWithArray:[XCBaseData sharedData].favListArray];
    [array addObject:model];
    [XCBaseData sharedData].favListArray = array;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[XCFMDB sharedFMDB] addPhoto:model];
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
        [[XCFMDB sharedFMDB] removePhoto:model];
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

- (NSArray<XCPhotoModel *> *)getFavoritePhotos {
    return [[XCFMDB sharedFMDB] getFavoritePhotos];
}


static XCFMDBManager *_sharedManager = nil;
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[XCFMDBManager alloc] init];
    });
    return _sharedManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (_sharedManager == nil) {
        _sharedManager = [super allocWithZone:zone];
    }
    return _sharedManager;
}

- (id)copy {
    return self;
}

- (id)mutableCopy {
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return self;
}

@end
