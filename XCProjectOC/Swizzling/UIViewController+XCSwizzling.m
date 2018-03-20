//
//  UIViewController+XCSwizzling.m
//  XCProjectOC
//
//  Created by xiaochen on 2018/3/19.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "UIViewController+XCSwizzling.h"
#import "SwizzlingDefine.h"
#import <Foundation/Foundation.h>

@implementation UIViewController (XCSwizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzling_exchangeMethod([UIViewController class], @selector(initWithNibName:bundle:), @selector(swizzling_initWithNibName:bundle:));
        swizzling_exchangeMethod([UIViewController class], @selector(init), @selector(swizzling_init));
        swizzling_exchangeMethod([UIViewController class], @selector(viewWillAppear:), @selector(swizzling_viewWillAppear:));
        swizzling_exchangeMethod([UIViewController class], @selector(viewDidAppear:), @selector(swizzling_viewDidAppear:));
        swizzling_exchangeMethod([UIViewController class], @selector(viewDidLoad), @selector(swizzling_viewDidLoad));
        swizzling_exchangeMethod([UIViewController class], @selector(viewWillDisappear:), @selector(swizzling_viewWillDisappear:));
        swizzling_exchangeMethod([UIViewController class], @selector(viewDidDisappear:), @selector(swizzling_viewDidDisappear:));
        swizzling_exchangeMethod([UIViewController class], NSSelectorFromString(@"dealloc"), @selector(swizzling_dealloc));
    });
}

//如果希望vchidesBottomBarWhenPushed为NO的话，请在vc init方法之后调用vc.hidesBottomBarWhenPushed = NO;
- (instancetype)swizzling_initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    id instance = [self swizzling_initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return instance;
}

- (instancetype)swizzling_init{
    id instance = [self swizzling_init];
    
#if DEBUG
    NSString *string = [NSString stringWithFormat:@"%@ init", [self class]];
    NSLog(@"%@", string);
#endif
    
    return instance;
}

- (void)swizzling_viewWillAppear:(BOOL)animated {
    if (self.parentViewController == self.navigationController) {
        if ([self swizzling_isUseClearBar] && self.navigationController) {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        } else {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_MAIN_COLOR] forBarMetrics:UIBarMetricsDefault];
            //去掉透明后导航栏下边的黑边
            [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        }
    }
    [self swizzling_viewWillAppear:animated];
}

- (void)swizzling_viewDidAppear:(BOOL)animated {
    [self swizzling_viewDidAppear:animated];
}

- (void)swizzling_viewDidLoad {
    [self swizzling_viewDidLoad];
}

- (void)swizzling_viewWillDisappear:(BOOL)animated {
    [self swizzling_viewWillDisappear:animated];
}

- (void)swizzling_viewDidDisappear:(BOOL)animated {
    [self swizzling_viewDidDisappear:animated];
}

- (void)swizzling_dealloc {
#if DEBUG
    NSString *status = [NSString stringWithFormat:@"%@ dealloc!", [self class]];
    NSLog(@"%@", status);
#endif
    [self swizzling_dealloc];
}


#pragma mark - Private
- (BOOL)swizzling_isUseClearBar {
    SEL  sel = NSSelectorFromString(@"useClearBar");
    BOOL use = NO;
    if ([self respondsToSelector:sel]) {
        SuppressPerformSelectorLeakWarning(use = (BOOL)[self performSelector:sel]);
    }
    return use;
}

@end
