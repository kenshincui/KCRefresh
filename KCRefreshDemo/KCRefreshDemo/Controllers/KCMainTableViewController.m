//
//  KCMainTableViewController.m
//  KCRefreshDemo
//
//  Created by KenshinCui on 15/9/22.
//  Copyright © 2015年 CMJStudio. All rights reserved.
//

#import "KCMainTableViewController.h"
#import "KCPagingViewController.h"
#import "KCVerticalPagingViewController.h"
#import "KCNormalRefreshViewController.h"

static NSString *const cellIdentifier = @"myTableViewCell";
@interface KCMainTableViewController ()

@property(strong, nonatomic) NSArray *data;

@end

@implementation KCMainTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"刷新演示";
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
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

#pragma mark - UITableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        KCNormalRefreshViewController *normalController = [[KCNormalRefreshViewController alloc]init];
        [self.navigationController pushViewController:normalController animated:YES];
    } else if (indexPath.row == 1) {
		KCPagingViewController *pagingController = [[KCPagingViewController alloc] init];
		[self.navigationController pushViewController:pagingController animated:YES];
	} else {
		KCVerticalPagingViewController *verticalPagingController = [[KCVerticalPagingViewController alloc] init];
		[self.navigationController pushViewController:verticalPagingController animated:YES];
	}
}

#pragma mark - 属性
/**
 *  数据
 */
- (NSArray *)data {
	if (!_data) {
		_data = [NSArray arrayWithObjects:@"上拉刷新和下拉加载",@"类似于淘宝头条的分页刷新", @"类似于网易云阅读的分页刷新", nil];
	}
	return _data;
}

@end
