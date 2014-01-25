//
//  CWSlideToPopViewController.m
//  SlideToPopDemo
//
//  Created by wangchao on 14-1-25.
//  Copyright (c) 2014年 wangchao. All rights reserved.
//

#import "CWSlideToPopViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ImageViewWithLayer : UIImageView

@property (nonatomic, strong) UIImageView *subLayerImageView;

@end

@implementation ImageViewWithLayer

- (UIImageView *)subLayerImageView {
    if (!_subLayerImageView) {
        _subLayerImageView = [[UIImageView alloc] initWithFrame:self.frame];
        _subLayerImageView.backgroundColor = [UIColor blackColor];
        _subLayerImageView.alpha = 0.5;
        return _subLayerImageView;
    }
    return _subLayerImageView;
}

@end


@interface CWSlideToPopViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGPoint originalPosition;
@property (nonatomic, strong) UIView *viewContainsPanGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *concurentPanGestureRecognizer;
@property (nonatomic, strong) UIImage *previewImage;
@property (nonatomic, strong) ImageViewWithLayer *bgImageView;
@property (nonatomic, strong) UIView *moveView;

@end

@implementation CWSlideToPopViewController

#pragma mark - Life Cycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.moveView = self.navigationController.view;
    
    [self.viewContainsPanGesture addGestureRecognizer:self.panGestureRecognizer];
    
    if (self.tabBarController) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.bgImageView];
        [[UIApplication sharedApplication].keyWindow sendSubviewToBack:self.bgImageView];;
        return;
    }
    [[UIApplication sharedApplication].keyWindow insertSubview:self.bgImageView belowSubview:self.moveView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.viewContainsPanGesture removeGestureRecognizer:self.panGestureRecognizer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.bgImageView removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

#pragma mark - GetMethods

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[ImageViewWithLayer alloc] initWithImage:self.previewImage];
        _bgImageView.frame = self.moveView.frame;
        [_bgImageView addSubview:_bgImageView.subLayerImageView];
    }
    return _bgImageView;
}

#pragma mark - Public Methods

- (void)addPanGestureRecognizer:(UIPanGestureRecognizer *)panGesture ToView:(UIView *)view {
    if (!self.previewImage) {
        return;
    }
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAwaked:)];
    [view addGestureRecognizer:self.panGestureRecognizer];
    self.panGestureRecognizer.delegate = self;
    self.concurentPanGestureRecognizer = panGesture;
    self.viewContainsPanGesture = view;
}

- (void)addPanGestureRecognizerToView:(UIView *)view {
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAwaked:)];
    self.panGestureRecognizer.delegate = self;
    [view addGestureRecognizer:self.panGestureRecognizer];
    
    self.viewContainsPanGesture = view;
}

- (void)removePanGestureRecognizer {
    [self.viewContainsPanGesture removeGestureRecognizer:self.panGestureRecognizer];
}

- (void) getCurrentViewscreenshot:(UIView *)view {
    if (UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(view.frame.size);
    }
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.previewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

#pragma mark - Private Methods

- (void)panGestureRecognizerAwaked:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.concurentPanGestureRecognizer.enabled = NO;
        self.viewContainsPanGesture.userInteractionEnabled = NO;
        if ([self.viewContainsPanGesture isKindOfClass:[UITableView class]]) {
            self.isViewControllerMoving = YES;
        }
        self.originalPosition = [recognizer locationInView:self.moveView];
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translationPoint = [recognizer translationInView:self.moveView];
        CGFloat centerX = 160+ translationPoint.x < 160 ? 160 : 160 + translationPoint.x;
        
        self.bgImageView.transform = CGAffineTransformMakeScale(centerX / 6400.0 + 0.925, centerX / 6400.0 + 0.925);
        self.bgImageView.subLayerImageView.alpha = centerX / (-640.0) + 0.75;
        
        self.moveView.center = CGPointMake(centerX, self.moveView.center.y);
        
    } else {
        self.concurentPanGestureRecognizer.enabled = YES;
        self.viewContainsPanGesture.userInteractionEnabled = YES;
        if ([self.viewContainsPanGesture isKindOfClass:[UITableView class]]) {
            self.isViewControllerMoving = NO;
        }
        
        CGPoint velocity = [recognizer velocityInView:self.moveView];
        CGPoint translation = [recognizer translationInView:self.moveView];
        if ((translation.x > 40) && (velocity.x > 0 || (velocity.x == 0 && self.moveView.center.x >= 320))) {
            [UIView animateWithDuration:0.2 animations:^{
                [self.moveView setCenter:CGPointMake(320 + 160, self.moveView.center.y)];
                self.bgImageView.transform = CGAffineTransformMakeScale(1, 1);
                self.bgImageView.subLayerImageView.alpha = 0;
            } completion:^(BOOL finished) {
                self.moveView.center = CGPointMake(160, self.moveView.center.y);
                [self.navigationController popViewControllerAnimated:NO];
            }];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                [self.moveView setCenter:CGPointMake(160, self.moveView.center.y)];
                self.bgImageView.transform = CGAffineTransformMakeScale(0.95, 0.95);
                self.bgImageView.subLayerImageView.alpha = 0.5;
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

#pragma mark - UIGestureDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    CGPoint point;
    if (self.concurentPanGestureRecognizer) {
        point = [self.concurentPanGestureRecognizer translationInView:self.concurentPanGestureRecognizer.view];
    } else {
        return YES;
    }
    
    if (fabs(point.y) > 1.0) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")]) {
        UIScrollView *scrollView = (UIScrollView *)otherGestureRecognizer.view;
        if (scrollView.contentOffset.x <= 0 && scrollView.contentSize.width > scrollView.frame.size.width) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    return YES;
}

@end
