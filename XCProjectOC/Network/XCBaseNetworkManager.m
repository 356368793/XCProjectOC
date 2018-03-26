//
//  XCBaseNetworkManager.m
//  LiveWallpapers
//
//  Created by xiaochen on 2018/3/22.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "XCBaseNetworkManager.h"

@implementation XCBaseNetworkManager

static XCBaseNetworkManager *_sharedManager = nil;
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[XCBaseNetworkManager alloc] init];
    });
    return _sharedManager;
}

- (void)hasNetwork:(void (^)(BOOL))block {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable:
                block(NO);
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN:
                block(YES);
                break;
        }
    }];
    [manager stopMonitoring];
}

- (void)requestAllListWithPage:(NSInteger)page block:(void(^)(BOOL))block {
    
}

- (void)requestAddListWithPage:(NSInteger)page block:(void(^)(BOOL))addListBlock {
    NSDictionary *addListParams = @{@"page": @(page), @"pkg": [XCTools getBundleID]};
    [[XCBaseNetwork sharedNetwork] getAddListWithParams:addListParams andBlock:^(id  _Nullable response, NSError * _Nullable error) {
        if (error) {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:error.description];
            return;
        }
        NSDictionary *dic = [response mj_JSONObject];
        if ([dic[@"msg"] isEqualToString:@"success"]) {
            NSArray *dataArray = dic[@"data"];
            
            [[XCBaseDataManager sharedManager] managerAddListDataWithArray:dataArray block:^(BOOL success) {
                if (success) {
                    // update views
                    addListBlock(YES);
                }
            }];
        } else {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"Update Wallpapers Failed."];
        }
    }];
}

- (void)requestPopListWithPage:(NSInteger)page block:(void(^)(BOOL))block {
    NSDictionary *popListParams = @{@"page": @(page), @"pkg": [XCTools getBundleID]};
    [[XCBaseNetwork sharedNetwork] getPopListWithParams:popListParams andBlock:^(id  _Nullable response, NSError * _Nullable error) {
        if (error) {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:error.description];
            return;
        }
        NSDictionary *dic = [response mj_JSONObject];
        if ([dic[@"msg"] isEqualToString:@"success"]) {
            NSArray *dataArray = dic[@"data"];
            
            [[XCBaseDataManager sharedManager] managerPopListDataWithArray:dataArray block:^(BOOL success) {
                if (success) {
                    block(YES);
                }
            }];
        } else {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"Update Wallpapers Failed."];
        }
    }];
}

- (void)requestWallpaperCategoryWithBlock:(void(^)(BOOL))block {
    NSDictionary *wpCategoryParams = @{@"pkg": [XCTools getBundleID]};
    [[XCBaseNetwork sharedNetwork] getWallpaperCategoryWithParams:wpCategoryParams andBlock:^(id  _Nullable response, NSError * _Nullable error) {
        if (error) {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:error.description];
            return;
        }
        NSDictionary *dic = [response mj_JSONObject];
        if ([dic[@"msg"] isEqualToString:@"success"]) {
            NSMutableArray *models = [NSMutableArray array];
            NSArray *dataArray = dic[@"data"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (NSInteger i = 0; i < [dataArray count]; i++) {
                    XCWallpaperCategoryModel *model = [XCWallpaperCategoryModel mj_objectWithKeyValues:dataArray[i]];
                    [models addObject:model];
                }
                // add 'new' 'pop' 'favorite' model to this array
                XCWallpaperCategoryModel *favModel = [[XCWallpaperCategoryModel alloc] init];
                favModel.cgimgurl = @"favorite";
                favModel.cgname = @"Favorite";
                [models insertObject:favModel atIndex:0];
                
                XCWallpaperCategoryModel *popModel = [[XCWallpaperCategoryModel alloc] init];
                popModel.cgimgurl = @"pop";
                popModel.cgname = @"Pop";
                [models insertObject:popModel atIndex:0];
                
                XCWallpaperCategoryModel *newModel = [[XCWallpaperCategoryModel alloc] init];
                newModel.cgimgurl = @"new";
                newModel.cgname = @"New";
                [models insertObject:newModel atIndex:0];
                
//                self.categoryArray = models;
                [XCBaseData sharedData].categoryArray = models;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(YES);
                });
            });
        } else {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"Update WallpaperCategory Failed."];
        }
    }];
}

- (void)requestCategoryImageListWithPage:(NSInteger)page cid:(NSString *)cid block:(void (^)(BOOL))block {
    NSDictionary *params = @{@"page": @(page), @"cid": cid, @"pkg": [XCTools getBundleID]};
    [[XCBaseNetwork sharedNetwork] getCategoryImageListWithParams:params andBlock:^(id  _Nullable response, NSError * _Nullable error) {
        if (error) {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:error.description];
            return;
        }
        NSDictionary *dic = [response mj_JSONObject];
        if ([dic[@"msg"] isEqualToString:@"success"]) {
            NSArray *dataArray = dic[@"data"];
            
            [[XCBaseDataManager sharedManager] managerCategoryImageListDataWithArray:dataArray block:^(BOOL success) {
                if (success) {
                    // update views
                    block(YES);
                }
            }];
        } else {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"Update Wallpapers Failed."];
        }
    }];
}


@end
