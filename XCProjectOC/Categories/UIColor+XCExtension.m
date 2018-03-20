//
//  UIColor+XCExtension.m
//  XCProjectOC
//
//  Created by xiaochen on 2018/3/19.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "UIColor+XCExtension.h"

@implementation UIColor (XCExtension)

+ (UIColor *)randomColor {
    CGFloat r = (arc4random() % 256) / 255.;
    CGFloat g = (arc4random() % 256) / 255.;
    CGFloat b = (arc4random() % 256) / 255.;
    
    UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:1.];
    return color;
}

@end
