//
//  NSString+XCExtension.h
//  XCProjectOC
//
//  Created by xiaochen on 2018/3/19.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XCExtension)

- (BOOL)isBlankString;

- (CGFloat)getHeightWithFont:(UIFont *)font width:(CGFloat)width;

@end
