//
//  UIViewController+XCBackButtonHandler.m
//  XCProjectOC
//
//  Created by xiaochen on 2018/3/19.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "UIViewController+XCBackButtonHandler.h"

@implementation UIViewController (XCBackButtonHandler)

@end

@implementation UINavigationController (ShouldPopOnBackButton)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    
    if ([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    
    BOOL shouldPop = YES;
    UIViewController *vc = [self topViewController];
    if ([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
        shouldPop = [vc navigationShouldPopOnBackButton];
    }
    
    if (shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    } else {
        for (UIView *v in [navigationBar subviews]) {
            if (0. < v.alpha && v.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    v.alpha = 1.;
                }];
            }
        }
    }
    
    return NO;
}

@end
