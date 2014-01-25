//
//  CWSlideToPopWithTabelViewViewController.m
//  SlideToPopDemo
//
//  Created by wangchao on 14-1-25.
//  Copyright (c) 2014年 wangchao. All rights reserved.
//

#import "CWSlideToPopWithTabelViewViewController.h"

@interface CWSlideToPopWithTabelViewViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CWSlideToPopWithTabelViewViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        
        for (int i=1; i<101; i++) {
            NSString *string = [NSString stringWithFormat:@"%d",i];
            [_dataArray addObject:string];
        }
    }
    return _dataArray;
}

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
    
    [self addPanGestureRecognizer:self.tableView.panGestureRecognizer ToView:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

@end
