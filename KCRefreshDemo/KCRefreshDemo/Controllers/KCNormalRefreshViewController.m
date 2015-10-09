//
//  KCRefreshViewController.m
//  KCRefreshDemo
//
//  Created by KenshinCui on 15/10/8.
//  Copyright © 2015年 CMJStudio. All rights reserved.
//  普通下拉刷新，上拉加载

#import "KCNormalRefreshViewController.h"
#import "UIScrollView+KCNormalRefresh.h"

static NSString *const cellIdentifier = @"myTableViewCell";
@interface KCNormalRefreshViewController ()
/**
 *  数据
 */
@property(strong, nonatomic) NSMutableArray *data;

@property (assign,nonatomic) NSInteger index;
@end

@implementation KCNormalRefreshViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"刷新演示";
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
	//添加下拉刷新、上拉加载
    __weak typeof(self) weakSelf=self;
	[self.tableView addRefreshHeaderWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{[weakSelf resetData];
            [weakSelf.tableView endRefreshHeader];
        });
    }];
    
    [self.tableView addRefreshFooterWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf addData];
            [weakSelf.tableView endRefreshFooter];
        });
    }];
    
}

#pragma mark - UITableView数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
	cell.textLabel.text = self.data[indexPath.row];

	return cell;
}

#pragma mark - 私有方法
-(void)resetData{
    [self.data removeAllObjects];
    NSInteger rdm = arc4random_uniform(1000);
    self.index = 20;
    for (NSInteger i = 0; i < self.index; ++i) {
        [self.data addObject:[NSString stringWithFormat:@"data-%4ld-%ld",rdm, i]];
    }
    [self.tableView reloadData];
}

-(void)addData{
    NSInteger rdm = arc4random_uniform(1000);
    for (NSInteger i = self.index; i < self.index + 20; ++i) {
        [self.data addObject:[NSString stringWithFormat:@"data-%4ld-%ld", rdm,i]];
    }
    self.index += 20;
    [self.tableView reloadData];
}

#pragma mark - 属性
/**
 *  数据
 */
- (NSMutableArray *)data {
	if (!_data) {
		_data = [NSMutableArray array];
        self.index = 20;
        NSInteger rdm = arc4random_uniform(1000);
        for (NSInteger i = 0; i < self.index; ++i) {
			[_data addObject:[NSString stringWithFormat:@"data-%4ld-%ld",rdm, i]];
		}
	}
	return _data;
}

@end
