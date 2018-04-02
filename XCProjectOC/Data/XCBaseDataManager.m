//
//  XCBaseDataManager.m
//  LiveWallpapers
//
//  Created by xiaochen on 2018/3/22.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "XCBaseDataManager.h"
#import "XCFMDBManager.h"

@interface XCBaseDataManager ()

@property (copy, nonatomic) NSArray<XCPhotoModel *> *addListArray;
@property (copy, nonatomic) NSArray<XCDailyPhotoModel *> *dayList;
@property (copy, nonatomic) NSArray<XCPhotoModel *> *popList;
@property (copy, nonatomic) NSArray<XCPhotoModel *> *categoryImageList;

@end

@implementation XCBaseDataManager

static XCBaseDataManager *_sharedManager = nil;
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[XCBaseDataManager alloc] init];
    });
    return _sharedManager;
}

#pragma mark -- favorite --
- (void)addFavorite:(XCPhotoModel *)model {
    [[XCFMDBManager sharedManager] addFavorite:model];
}

- (void)removeFavorite:(XCPhotoModel *)model {
    [[XCFMDBManager sharedManager] removeFavorite:model];
}

- (BOOL)isExist:(XCPhotoModel *)model {
    return [[XCFMDBManager sharedManager] isExist:model];
}

- (NSArray<XCPhotoModel *> *)getFavoritePhotos {
    return [[XCFMDBManager sharedManager] getFavoritePhotos];
}


#pragma mark -- new --
- (void)getXxxxxWithType:(XCBasePhotoType)type block:(void(^)(NSArray<XCPhotoModel *> *))block {
    if (type == XCBasePhotoTypeGet) {
        if ([self.addListArray count]) {
            block(self.addListArray);
        } else {
            NSInteger page = [[XCBaseData sharedData] getPageWithPageName:@"New"];
            [[XCBaseNetworkManager sharedManager] requestAddListWithPage:page block:^(NSArray<XCPhotoModel *> *models) {
                self.addListArray = models;
                block(self.addListArray);
            }];
        }
    } else {
        NSInteger newPage = [[XCBaseData sharedData] getAddPageWithPageName:@"New"];
        [[XCBaseNetworkManager sharedManager] requestAddListWithPage:newPage block:^(NSArray<XCPhotoModel *> *models) {
            NSMutableArray *muteModels = [NSMutableArray arrayWithArray:self.addListArray];
            [muteModels addObjectsFromArray:models];
            self.addListArray = muteModels;
            block(muteModels);
        }];
    }
}




@end
