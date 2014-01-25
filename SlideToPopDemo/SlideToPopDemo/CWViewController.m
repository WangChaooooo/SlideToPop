//
//  CWViewController.m
//  SlideToPopDemo
//
//  Created by wangchao on 14-1-25.
//  Copyright (c) 2014年 wangchao. All rights reserved.
//

#import "CWViewController.h"
#import "CWSlideToPopNormalViewController.h"

@interface CWViewController ()

@end

@implementation CWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *viewController = [segue destinationViewController];
    if ([viewController isKindOfClass:[CWSlideToPopNormalViewController class]]) {
        [((CWSlideToPopNormalViewController *)viewController) getCurrentViewscreenshot:self.navigationController.view];
    }
}

@end
