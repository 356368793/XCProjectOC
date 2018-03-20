//
//  UIImage+XCExtension.m
//  XCProjectOC
//
//  Created by xiaochen on 2018/3/19.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "UIImage+XCExtension.h"

@implementation UIImage (XCExtension)

+ (UIImage*)imageWithColor:(UIColor *)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
