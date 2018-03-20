//
//  UIViewController+XCBackButtonHandler.h
//  XCProjectOC
//
//  Created by xiaochen on 2018/3/19.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShouldPopOnBackButtonProtocol <NSObject>

@optional
- (BOOL)navigationShouldPopOnBackButton;

@end

@interface UIViewController (XCBackButtonHandler) <ShouldPopOnBackButtonProtocol>

@end
