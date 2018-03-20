//
//  UIView+XCExtension.h
//  XCProjectOC
//
//  Created by xiaochen on 2018/3/20.
//  Copyright © 2018年 xiaochen. All rights reserved.
//  property的属性默认是：readwrite，assign, atomic

#import <UIKit/UIKit.h>

@interface UIView (XCExtension)

@property (nonatomic) CGFloat x;

@property (nonatomic) CGFloat y;

@property (nonatomic) CGFloat width;

@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat centerX;

@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGPoint origin;

@property (nonatomic) CGSize size;

- (UIViewController *)viewController;

@end
