//
//  XCAnimationProgress.m
//  LiveWallpapers
//
//  Created by xiaochen on 2018/3/21.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "XCAnimationProgress.h"

#define kLayerLineW 7

@interface XCAnimationProgress () {
    CAShapeLayer *_shapeLayer;
}

@end

@implementation XCAnimationProgress

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    CGFloat circleWH = APP_WIDTH * .5;
    CGFloat circleY = APP_HEIGHT * .4 - circleWH * .5;
    CGFloat circleX = (APP_WIDTH - circleWH) * .5;
    CGRect circleFrame = CGRectMake(circleX, circleY, circleWH, circleWH);
    // path
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:circleFrame];
    // backgroundLayer
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    bgLayer.frame = CGRectMake(0, 0, circleWH, circleWH);
    bgLayer.fillColor = [UIColor clearColor].CGColor;
    bgLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    bgLayer.lineWidth = kLayerLineW;
    bgLayer.strokeStart = 0;
    bgLayer.strokeEnd = 1;
    bgLayer.path = path.CGPath;
    [self.layer addSublayer:bgLayer];
    // redLayer
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.frame = CGRectMake(0, 0, circleWH, circleWH);
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    _shapeLayer.lineWidth = kLayerLineW + 2;
    _shapeLayer.strokeStart = 0;
    _shapeLayer.strokeEnd = 0;
    _shapeLayer.path = path.CGPath;
    [self.layer addSublayer:_shapeLayer];
    
//    UILabel *progressLabel = [[UILabel alloc] initWithFrame:circleFrame];
//    progressLabel.text = @"00%";
//    progressLabel.textAlignment = NSTextAlignmentCenter;
//    progressLabel.textColor = [UIColor whiteColor];
//    progressLabel.font = [UIFont systemFontOfSize:14];
//    [self addSubview:progressLabel];
}

- (void)setProgress:(CGFloat)progress {
    _shapeLayer.strokeEnd = progress;
}

- (void)startAnimation {
    
}

@end
