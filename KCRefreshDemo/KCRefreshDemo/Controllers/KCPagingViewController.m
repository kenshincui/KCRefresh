//
//  ViewController.m
//  KCRefreshDemo
//
//  Created by KenshinCui on 15/9/20.
//  Copyright © 2015年 CMJStudio. All rights reserved.
//  类似淘宝的下拉、上拉翻页效果

#import "KCPagingViewController.h"
#import "KCPerson.h"
#import "KCPersonService.h"
#import "KCCardView.h"
#import "KCRefresh.h"
#import "UIView+KC.h"

static CGFloat kAnimationDuration = 0.5;
@interface KCPagingViewController ()

@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) KCCardView *cardView;
@property(strong, nonatomic) NSMutableArray *data;
@property(assign, nonatomic) NSUInteger index;

@end

@implementation KCPagingViewController

#pragma mark - 生命周期及其基类方法
- (void)viewDidLoad {
	[super viewDidLoad];

	[self setupUI];
}

#pragma mark - 私有方法
- (void)setupUI {
	self.title = @"分页刷新1";
	self.view.backgroundColor = [UIColor whiteColor];
	self.automaticallyAdjustsScrollViewInsets = NO;
	[self.view addSubview:self.scrollView];
	[self.scrollView addSubview:self.cardView];
	self.scrollView.contentSize = CGSizeMake(0, self.scrollView.height + 1);

	//添加分页刷新
	__weak typeof(self) weakSelf = self;
	[self.scrollView addPagingRefreshHeaderWithIdleText:@"下拉查看上一张"
						pullingText:@"松开刷新"
					     refreshingText:@"正在刷新..."
					    refreshingBlock:^{
					      [weakSelf.scrollView endPagingRefreshHeader];
					      [weakSelf updatePageWithDirection:NO];
					    }];
	[self.scrollView addPagingRefreshFooterWithIdleText:@"上拉查看下一张"
						pullingText:@"松开刷新"
					     refreshingText:@"正在刷新..."
					    refreshingBlock:^{
					      [weakSelf.scrollView endPagingRefreshFooter];
					      [weakSelf updatePageWithDirection:YES];
					    }];

	KCPerson *person = [self.data firstObject];
	self.cardView.person = person;
}

- (void)updatePageWithDirection:(BOOL)up {
	if (up) {
		self.index++;

	} else {
		self.index--;
	}
	NSUInteger dataCount = self.data.count;
	self.index = (dataCount + self.index) % dataCount;
	KCPerson *person = [self.data objectAtIndex:self.index];
	[UIView animateWithDuration:kAnimationDuration
	    animations:^{
	      self.cardView.alpha = 0.0;
	    }
	    completion:^(BOOL finished) {
	      self.cardView.person = person;
	      [UIImageView animateWithDuration:kAnimationDuration
				    animations:^{
				      self.cardView.alpha = 1.0;
				    }];

	    }];
}

#pragma mark - 属性
- (UIScrollView *)scrollView {
	if (!_scrollView) {
		CGRect screenBounds = [UIScreen mainScreen].bounds;
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 64.0, screenBounds.size.width, screenBounds.size.height - 64.0)];
	}
	return _scrollView;
}

- (KCCardView *)cardView {
	if (!_cardView) {
		_cardView = [[KCCardView alloc] initWithFrame:self.scrollView.bounds];
	}
	return _cardView;
}

- (NSMutableArray *)data {
	if (!_data) {
		_data = [[KCPersonService requestPersons] copy];
	}
	return _data;
}

@end
