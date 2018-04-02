//
//  XCLocalPush.m
//  XCProjectOC
//
//  Created by xiaochen on 2018/4/2.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "XCLocalPush.h"

@interface XCLocalPush ()

@end

@implementation XCLocalPush

static XCLocalPush *_sharedPush = nil;
+ (instancetype)sharedPush {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPush = [[XCLocalPush alloc] init];
    });
    return _sharedPush;
}

+ (void)registerLocalNotification{
    [[XCLocalPush sharedPush] registerLocalNotification];
}

- (void)registerLocalNotification {
    UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
}


+ (void)sendLocalNotification {
    [[XCLocalPush sharedPush] sendLocalNotification];
}

- (void)sendLocalNotification {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    //处理时间字符串
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *fireDate = [formatter dateFromString:@"2018-04-01 20:48:00"];
    NSAssert(fireDate, @"Date string wrong type!");
    
    localNotification.fireDate = fireDate;
    //重复间隔
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval = NSCalendarUnitDay;
    //通知内容
    localNotification.alertBody = @"New Wallpapers have been Updated! Please come and get them!";
    localNotification.applicationIconBadgeNumber = 1;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

+ (void)removeLocalNotification {
    UIApplication *application = [UIApplication sharedApplication];
    [application cancelAllLocalNotifications];
    application.applicationIconBadgeNumber = 0;
}


@end
