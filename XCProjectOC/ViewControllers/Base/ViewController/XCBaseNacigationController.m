//
//  XCBaseNacigationController.m
//  XCProjectOC
//
//  Created by xiaochen on 2018/3/19.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "XCBaseNacigationController.h"

@interface XCBaseNacigationController ()

@end

@implementation XCBaseNacigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// for statue bar style
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.visibleViewController;//当前可见的控制器
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
