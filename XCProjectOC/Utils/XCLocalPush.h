//
//  XCLocalPush.h
//  XCProjectOC
//
//  Created by xiaochen on 2018/4/2.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCLocalPush : NSObject

+ (void)registerLocalNotification;

+ (void)sendLocalNotification;

+ (void)removeLocalNotification;

@end
