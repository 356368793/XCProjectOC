//
//  XCKeychainManager.m
//  LiveWallpapers
//
//  Created by xiaochen on 2018/3/24.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "XCKeychainManager.h"
#import "XCKeychain.h"

#define kKeyImages @"images"
#define kKeyCount @"count"
#define kMaxCount 5

@implementation XCKeychainManager

+ (void)saveImageUrl:(NSString *)imageUrl andBeyondMaxBlock:(void (^)(BOOL))beyondMax {
    NSString *bundleID = [XCTools getBundleID];
    NSDictionary *dic = [XCKeychain load:bundleID];
    BOOL bMax = NO;
    NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
    
    if (dic != nil) {
        // 1. delete
        [XCKeychain delete:bundleID];
        
        // 2. set new dic
        NSMutableArray *urls = [NSMutableArray arrayWithArray:dic[kKeyImages]];
        NSInteger count = [dic[kKeyCount] integerValue];
        if ([urls containsObject:imageUrl]) {
            newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        } else {
            [urls addObject:imageUrl];
            count = count + 1;
            if (count > kMaxCount) {
                newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                bMax = YES;
            } else {
                [newDic setObject:urls forKey:kKeyImages];
                [newDic setObject:@(count) forKey:kKeyCount];
            }
        }
        
    } else {
        NSDictionary *tmpNewDic = @{
                                 kKeyCount: @(1),
                                 kKeyImages: @[imageUrl]
                                 };
        newDic = [NSMutableDictionary dictionaryWithDictionary:tmpNewDic];
    }
    // 3. save new dic
    [XCKeychain save:bundleID data:newDic];
    NSLog(@"newDic = %@", newDic);
    
    beyondMax(bMax);
}

@end
