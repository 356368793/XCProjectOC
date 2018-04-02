//
//  XCBaseNetworkManager.m
//  LiveWallpapers
//
//  Created by xiaochen on 2018/3/22.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "XCBaseNetworkManager.h"
#import "XCBaseNetworkManager+Extension.h"

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

- (void)requestAllListWithPage:(NSInteger)page block:(void(^)(NSArray<XCPhotoModel *> *))block {
    NSDictionary *allListParams = @{@"page": @(page), @"pkg": [XCTools getBundleID]};
    [[XCBaseNetwork sharedNetwork] getXxxxxWithParams:allListParams andBlock:^(id  _Nullable response, NSError * _Nullable error) {
        if (error) {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:error.description];
            return;
        }
        NSDictionary *dic = [response mj_JSONObject];
        if ([dic[@"msg"] isEqualToString:@"success"]) {
            NSArray *dataArray = dic[@"data"];
            
            [self managerAllListDataWithArray:dataArray block:^(NSArray<XCPhotoModel *> *models) {
                block(models);
            }];
        } else {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"Update all list Failed."];
        }
    }];
}




@end

