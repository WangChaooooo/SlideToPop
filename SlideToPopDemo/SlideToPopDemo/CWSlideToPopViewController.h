//
//  CWSlideToPopViewController.h
//  SlideToPopDemo
//
//  Created by wangchao on 14-1-25.
//  Copyright (c) 2014年 wangchao. All rights reserved.
//
/*
English:
 this view controller is used when it is embeded in the navigation controller
 
 */

#import <UIKit/UIKit.h>

@interface CWSlideToPopViewController : UIViewController

@property (nonatomic, assign) BOOL isViewControllerMoving;

//call this method before the view shows
- (void)getCurrentViewscreenshot:(UIView *)view;

//call this method when the view loads
- (void)addPanGestureRecognizerToView:(UIView *)view;

//call this method when the view loads and the view contains a tableview
- (void)addPanGestureRecognizer:(UIPanGestureRecognizer *)panGesture ToView:(UIView *)view;

@end
