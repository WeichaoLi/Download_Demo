//
//  BasicViewController.m
//  MapDemo
//
//  Created by 李伟超 on 15/1/13.
//  Copyright (c) 2015年 LWC. All rights reserved.
//

#import "BasicViewController.h"

@implementation BasicViewController

- (instancetype)init {
    self = [super init];
    if (self) {
#ifdef __IPHONE_7_0
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            self.navigationController.navigationBar.translucent = NO;
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.automaticallyAdjustsScrollViewInsets = YES;
        }
#endif
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef __IPHONE_7_0
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.navigationController.navigationBar.translucent = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
#endif
    
}

@end
