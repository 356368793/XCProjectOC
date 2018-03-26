//
//  XCSubscriptionView.m
//  LiveWallpapers
//
//  Created by xiaochen on 2018/3/24.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "XCSubscriptionView.h"
#import "AppDelegate.h"

@interface XCSubscriptionView ()

@property (copy, nonatomic) RestoreBlock restoreBlock;
@property (copy, nonatomic) PurchaseBlock purchaseBlock;
@property (copy, nonatomic) DismissBlock dismissBlock;
@property (copy, nonatomic) HTMLBlock htmlBlock;


@end

@implementation XCSubscriptionView

+ (instancetype)viewWithRestoreBlock:(void (^)(void))restoreBlock purchaseBlock:(void (^)(void))purchaseBlock dismissBlock:(void (^)(void))dismissBlock htmlBlock:(HTMLBlock)htmlBlock {
    XCSubscriptionView *v = [[XCSubscriptionView alloc] init];
    v.restoreBlock = restoreBlock;
    v.purchaseBlock = purchaseBlock;
    v.dismissBlock = dismissBlock;
    v.htmlBlock = htmlBlock;
    [v setupSubviews];
    return v;
}

- (void)setupSubviews {
    UIView *cover = [[UIView alloc] init];
    cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    [self addSubview:cover];
    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    CGFloat mWMargin = APP_SCALE_W(20);
    CGFloat mHMargin = APP_SCALE_H(40);
    
    UIView *mainView = [[UIView alloc] init];
    mainView.backgroundColor = [UIColor whiteColor];
    [mainView.layer setCornerRadius:5];
    [self addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(mWMargin);
        make.right.equalTo(self.mas_right).offset(-mWMargin);
        make.top.equalTo(self.mas_top).offset(mHMargin);
        make.bottom.equalTo(self.mas_bottom).offset(-mHMargin);
    }];
    
    CGFloat mSubMargin = APP_SCALE_W(10);
    
    UILabel *premiumLabel = [[UILabel alloc] init];
    premiumLabel.text = @"Premium";
    premiumLabel.textColor = [UIColor blackColor];
    premiumLabel.textAlignment = NSTextAlignmentCenter;
    premiumLabel.font = [UIFont boldSystemFontOfSize:18];
    [mainView addSubview:premiumLabel];
    CGFloat preH = [premiumLabel.text getHeightWithFont:[UIFont boldSystemFontOfSize:18] width:MAXFLOAT];
    [premiumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainView.mas_top).offset(mSubMargin);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.equalTo(@(preH));
    }];
    
    UILabel *info1 = [[UILabel alloc] init];
    info1.text = @"Save with NO limits!";
    info1.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.8];
    info1.font = [UIFont systemFontOfSize:14];
    CGFloat info1H = [info1.text getHeightWithFont:[UIFont systemFontOfSize:16] width:MAXFLOAT];
    [mainView addSubview:info1];
    [info1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainView.mas_left).offset(mSubMargin);
        make.right.equalTo(mainView.mas_right).offset(-mSubMargin);
        make.top.equalTo(premiumLabel.mas_bottom).offset(APP_SCALE_H(5));
        make.height.equalTo(@(info1H));
    }];
    
    UILabel *info2 = [[UILabel alloc] init];
    info2.text = @"Daily NEW HD Wallpapers!";
    info2.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.8];
    info2.font = [UIFont systemFontOfSize:14];
    CGFloat info2H = [info2.text getHeightWithFont:[UIFont systemFontOfSize:16] width:MAXFLOAT];
    [mainView addSubview:info2];
    [info2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainView.mas_left).offset(mSubMargin);
        make.right.equalTo(mainView.mas_right).offset(-mSubMargin);
        make.top.equalTo(info1.mas_bottom).offset(5);
        make.height.equalTo(@(info2H));
    }];
    
    UIButton *restoreButton = [[UIButton alloc] init];
    [restoreButton setTitle:@"Restore" forState:UIControlStateNormal];
    [restoreButton setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.7] forState:UIControlStateNormal];
    [restoreButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [restoreButton addTarget:self action:@selector(restoreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:restoreButton];
    [restoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainView.mas_left).offset(mSubMargin);
        make.bottom.equalTo(mainView.mas_bottom).offset(-mSubMargin);
        make.width.equalTo(@(APP_SCALE_W(80)));
        make.height.equalTo(@(APP_SCALE_H(30)));
    }];
    
//    UIButton *howButton = [[UIButton alloc] init];
//    [howButton setTitle:@"Cancel" forState:UIControlStateNormal];
//    [howButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [howButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
//    [howButton addTarget:self action:@selector(howButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [mainView addSubview:howButton];
//    [howButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(mainView.mas_right).offset(-mSubMargin);
//        make.bottom.equalTo(mainView.mas_bottom).offset(-mSubMargin);
//        make.width.equalTo(@(APP_SCALE_W(100)));
//        make.height.equalTo(@(APP_SCALE_H(35)));
//    }];
    
    UIView *clickView = [[UIView alloc] init];
    [clickView.layer setCornerRadius:5];
    UIColor *clickColor = [UIColor colorWithRed:47 / 255. green:162 / 255. blue:255 / 255. alpha:.8];
    [clickView setBackgroundColor:clickColor];
    [mainView addSubview:clickView];
    [clickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainView.mas_left).offset(mSubMargin);
        make.right.equalTo(mainView.mas_right).offset(-mSubMargin);
        make.bottom.equalTo(restoreButton.mas_top).offset(-APP_SCALE_H(5));
        make.height.equalTo(@(APP_SCALE_H(60)));
    }];
    UITapGestureRecognizer *clickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickViewAction)];
    [clickView addGestureRecognizer:clickTap];
    
    UILabel *clickLabel1 = [[UILabel alloc] init];
    clickLabel1.text = @"3-Day Free Trial";
    clickLabel1.textColor = [UIColor whiteColor];
    clickLabel1.font = [UIFont boldSystemFontOfSize:16];
    clickLabel1.textAlignment = NSTextAlignmentCenter;
    [clickView addSubview:clickLabel1];
    [clickLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(clickView.mas_left);
        make.right.equalTo(clickView.mas_right);
        make.height.equalTo(clickView.mas_height).multipliedBy(.35);
        make.top.equalTo(clickView.mas_top).offset(APP_SCALE_H(5));
    }];
        
    UILabel *clickLabel2 = [[UILabel alloc] init];
    clickLabel2.text = @"then $39.99 for 1 week";
    clickLabel2.textColor = [UIColor whiteColor];
    clickLabel2.font = [UIFont systemFontOfSize:14];
    clickLabel2.textAlignment = NSTextAlignmentCenter;
    [clickView addSubview:clickLabel2];
    [clickLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(clickView.mas_left);
        make.right.equalTo(clickView.mas_right);
        make.top.equalTo(clickLabel1.mas_bottom);
        make.bottom.equalTo(clickView.mas_bottom).offset(-APP_SCALE_H(5));
    }];
    
    NSString *s = @"In-app purchases are automatically renewed purchases\n\
    - $39.99/weekly, the first three days of subscription are free.\n\
    * Confirm your purchase and pay for your iTunes account\n\
    * Subscription package after use the system automatically renews the default, to cancel, to be at least 24 hours before the end of the package is closed automatically renew\n\
    * Within 24 hours before the package expires, the account will recognize and automatically renew the payment\n\
    * Subscriptions are managed by the user, after the user has purchased the subscription, he can go to the user account settings to turn off automatic renewal\n\
    * The current subscription can not be canceled while the subscription is activated\n\
    * If a user buys a subscription package within the period of the free trial package (if available), the unused portion of the subscription period will expire\n\
    - Privacy Policy:\n\
    http://s.fastcleanerme.com/themegather/PrivacyPolicy.html\n\
    - Terms of Service:\n\
    http://s.fastcleanerme.com/themegather/TermsofUse.html";
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:s];
//    attrString.yy_underlineStyle = NSUnderlineStyleSingle;
    [attrString yy_setTextHighlightRange:NSMakeRange([s rangeOfString:kHTMLPrivacyPolicy].location, [kHTMLPrivacyPolicy length]) color:[UIColor blueColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        if (self.htmlBlock) {
            self.htmlBlock(kHTMLPrivacyPolicy);
        }
    }];
    [attrString yy_setTextHighlightRange:NSMakeRange([s rangeOfString:kHTMLTermsofUse].location, [kHTMLTermsofUse length]) color:[UIColor blueColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        if (self.htmlBlock) {
            self.htmlBlock(kHTMLTermsofUse);
        }
    }];
    
    YYTextView *textView = [[YYTextView alloc] init];
    textView.editable = NO;
    textView.font = [UIFont systemFontOfSize:10];
    textView.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    textView.attributedText = attrString;
    [mainView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainView.mas_left).offset(mSubMargin);
        make.right.equalTo(mainView.mas_right).offset(-mSubMargin);
        make.top.equalTo(info2.mas_bottom).offset(APP_SCALE_H(5));
        make.bottom.equalTo(clickView.mas_top).offset(-APP_SCALE_H(5));
    }];
    
    CGFloat dismissWH = APP_SCALE_W(26);
    UIButton *dismissButton = [[UIButton alloc] init];
    [dismissButton setImage:[UIImage imageNamed:@"dismiss"] forState:UIControlStateNormal];
    [dismissButton setBackgroundColor:[UIColor whiteColor]];
    [dismissButton.layer setCornerRadius:dismissWH * .5];
    [dismissButton addTarget:self action:@selector(dismissButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dismissButton];
    [self bringSubviewToFront:dismissButton];
    [dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(mainView.mas_right);
        make.centerY.equalTo(mainView.mas_top);
        make.width.equalTo(@(dismissWH));
        make.height.equalTo(@(dismissWH));
    }];
}

- (void)dismissButtonClick {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (void)clickViewAction {
    if (self.purchaseBlock) {
        self.purchaseBlock();
    }
}

//- (void)howButtonClick {
//
//}

- (void)restoreButtonClick {
    if (self.restoreBlock) {
        self.restoreBlock();
    }
}

@end
