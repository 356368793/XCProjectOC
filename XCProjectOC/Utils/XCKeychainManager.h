//
//  XCKeychainManager.h
//  LiveWallpapers
//
//  Created by xiaochen on 2018/3/24.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCKeychainManager : NSObject

+ (void)saveImageUrl:(NSString *)imageUrl andBeyondMaxBlock:(void(^)(BOOL, NSInteger))beyondMax;

+ (NSInteger)getLeftImageCount;

@end
