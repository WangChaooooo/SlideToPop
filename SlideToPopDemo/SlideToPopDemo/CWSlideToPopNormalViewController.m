//
//  CWSlideToPopNormalViewController.m
//  SlideToPopDemo
//
//  Created by wangchao on 14-1-25.
//  Copyright (c) 2014年 wangchao. All rights reserved.
//

#import "CWSlideToPopNormalViewController.h"
#import "CWSlideToPopWithTabelViewViewController.h"

@interface CWSlideToPopNormalViewController ()

@end

@implementation CWSlideToPopNormalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self addPanGestureRecognizerToView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *viewController = segue.destinationViewController;
    
    if ([viewController isKindOfClass:[CWSlideToPopWithTabelViewViewController class]]) {
        CWSlideToPopWithTabelViewViewController *viewControllerWithTableView = (CWSlideToPopWithTabelViewViewController *)viewController;
        [viewControllerWithTableView getCurrentViewscreenshot:self.navigationController.view];
    }
}

@end
