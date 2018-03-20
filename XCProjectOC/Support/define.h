//
//  define.h
//  XCProjectOC
//
//  Created by xiaochen on 2018/3/19.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#ifndef define_h
#define define_h

/**
 size
 */
#define APP_WIDTH [UIScreen mainScreen].bounds.size.width
#define APP_HEIGHT [UIScreen mainScreen].bounds.size.height
#define APP_NAVI_HEIGHT self.navigationController.navigationBar.frame.size.height
#define APP_STATUS_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define APP_SCALE_W(w) ((APP_WIDTH / 375.0) * w)
#define APP_SCALE_H(h) ((APP_HEIGHT / 667.0) * h)

/**
 color
 */
#define UIColorFromRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]
#define UIColorFromRGB(rgbValue)  UIColorFromRGBA(rgbValue,1.0f)
#define APP_MAIN_COLOR [UIColor clearColor]

/**
 Log
 */
#ifdef DEBUG
#define NSLog(format, ...) do {                                                                          \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0)
#else
#define NSLog(...) do { } while (0)
#endif

/**
 Dismiss leak warning
 */
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

/**
 sandbox
 */
// temp
#define kPathTemp NSTemporaryDirectory()
// Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
// Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

/**
 Device
 */
#define iPhone [[XCDevice getDeviceName] containsString:@"iPhone"]
#define iPad [[XCDevice getDeviceName] containsString:@"iPad"]
#define Simulator [[XCDevice getDeviceName] containsString:@"Simulator"]

/**
 Shared
 */
#define SharedAppDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])



#endif /* define_h */
