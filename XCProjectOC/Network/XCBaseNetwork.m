//
//  XCBaseNetwork.m
//  XCProjectOC
//
//  Created by xiaochen on 2018/3/21.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "XCBaseNetwork.h"
#import <AFNetworking.h>

@interface XCBaseNetwork ()

@property (strong, nonatomic) AFHTTPSessionManager *manager;

@end

@implementation XCBaseNetwork

static XCBaseNetwork *_sharedNetwork = nil;
+ (instancetype)sharedNetwork {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedNetwork = [[XCBaseNetwork alloc] init];
        _sharedNetwork.manager = [AFHTTPSessionManager manager];
        _sharedNetwork.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sharedNetwork.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json", @"text/javascript", @"text/html", @"application/json", nil];
        
        // set request serializer
        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
//        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        requestSerializer.timeoutInterval = 10.;
        // request content type
        [requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        _sharedNetwork.manager.requestSerializer = requestSerializer;
        
        // request content length
//        [_sharedNetwork.manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld", (unsigned long)[jsonStr length]] forHTTPHeaderField:@"Content-Length"];
//
//        // request content encoding type
//        [_sharedNetwork.manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    });
    return _sharedNetwork;
}


- (void)getWallpaperCategoryWithParams:(id)params andBlock:(void (^)(id, NSError *))block {
    NSString *url = URLWallpaperCategory;
    [_manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (block) {
            block(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)getAddListWithParams:(id)params andBlock:(void (^)(id, NSError *))block {
    [_manager POST:URLAddList parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (block) {
            block(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)getPopListWithParams:(id)params andBlock:(void (^)(id, NSError *))block {
    [_manager POST:URLPopList parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (block) {
            block(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)getCategoryImageListWithParams:(id)params andBlock:(void (^)(id _Nullable, NSError * _Nullable))block {
    [_manager POST:URLCategoryImgList parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (block) {
            block(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)getAuditResultWithParams:(id)params andBlock:(void (^)(id _Nullable, NSError * _Nullable))block {
    NSString *url = URLAudit;
    [_manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (block) {
            block(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil, error);
        }
    }];
}


@end
