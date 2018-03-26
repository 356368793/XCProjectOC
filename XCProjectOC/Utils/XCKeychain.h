//
//  XCKeychain.h
//  LiveWallpapers
//
//  Created by xiaochen on 2018/3/23.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface XCKeychain : NSObject

/**
 *  用KeyChaina去保存用户名和密码
 */
+ (void)save:(NSString *)service data:(id)data;
/**
 *  从KeyChina取出用户名和密码
 */
+ (id)load:(NSString *)service;
/**
 *  从KeyChina中删除用户名和密码
 */
+ (void)delete:(NSString *)service;

@end
