//
//  UINavigationBar+XCSwizzling.m
//  XCProjectOC
//
//  Created by xiaochen on 2018/3/20.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "UINavigationBar+XCSwizzling.h"
#import "SwizzlingDefine.h"

@implementation UINavigationBar (XCSwizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzling_exchangeMethod([UINavigationBar class], @selector(layoutSubviews), @selector(swizzling_layoutSubviews));
    });
}

#pragma mark - layoutSubviews -
#define NavigationBtnMargin 28
#define TitleMargin 43
- (void)swizzling_layoutSubviews {
    [self swizzling_layoutSubviews];
    
    UINavigationItem *navigationItem = [self topItem];
    UIView *subview = [[navigationItem leftBarButtonItem] customView];
    subview.x = NavigationBtnMargin;
    
    // 解决标题过长时，设置navigationItem.title导致标题偏移的问题
    UILabel *label = (UILabel *)navigationItem.titleView;
    UIFont *font = self.titleTextAttributes[NSFontAttributeName];
    if (font) {
        label.font = font;
    }
    UIColor *color = self.titleTextAttributes[NSForegroundColorAttributeName];
    if (color) {
        label.textColor = color;
    }
    [label sizeToFit];
    [self layoutLabel];
}

#pragma mark -- Private --
- (void)layoutLabel {
    UINavigationItem *navigationItem = [self topItem];
    UIView *leftView = [[navigationItem leftBarButtonItems].lastObject customView];
    UIView *rightView = [[navigationItem rightBarButtonItems].firstObject customView];
    CGFloat titleLeft = leftView.x + leftView.width;
    CGFloat titleRight = rightView ? rightView.x : self.width;
    CGFloat maxWidth = titleRight - titleLeft - 2 * TitleMargin;
    
    UIView *titleView = navigationItem.titleView;
    titleView.width = (titleView.width > maxWidth) ? maxWidth : titleView.width;
    titleView.centerX = self.width * .5;
    titleView.centerY = self.height * .5;
}

@end
