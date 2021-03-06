//
//  XCIAPManager.h
//  LiveWallpapers
//
//  Created by xiaochen on 2018/3/24.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#define kPurchaseID @""

typedef enum {
    kIAPPurchSuccess = 0,       // 购买成功
    kIAPPurchFailed = 1,        // 购买失败
    kIAPPurchCancle = 2,        // 取消购买
    KIAPPurchVerFailed = 3,     // 订单校验失败
    KIAPPurchVerSuccess = 4,    // 订单校验成功
    kIAPPurchNotArrow = 5,      // 不允许内购
}IAPPurchType;

typedef void (^IAPCompletionHandle)(IAPPurchType type,NSData *data);

@interface XCIAPManager : NSObject

+ (instancetype)sharedManager;

- (void)startPurchWithID:(NSString *)purchID completeHandle:(IAPCompletionHandle)handle;

/// 恢复购买
- (void) restoreTransaction;

/// 验证订购
- (void)verifyPurchaseWithPaymentTransaction:(SKPaymentTransaction *)transaction isTestServer:(BOOL)flag Compl:(void(^)(NSDate *currentDate))compl;
- (BOOL)verifyPurchaseWithPaymentTransaction:(SKPaymentTransaction *)transaction isTestServer:(BOOL)flag;

@end
