//
//  XCSubscriptionView.h
//  LiveWallpapers
//
//  Created by xiaochen on 2018/3/24.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RestoreBlock)(void);
typedef void(^PurchaseBlock)(void);
typedef void(^DismissBlock)(void);
typedef void(^HTMLBlock)(NSString *);

@interface XCSubscriptionView : UIView

+ (instancetype)viewWithRestoreBlock:(void(^)(void))restoreBlock purchaseBlock:(void(^)(void))purchaseBlock dismissBlock:(void(^)(void))dismissBlock htmlBlock:(HTMLBlock)htmlBlock;

@end
