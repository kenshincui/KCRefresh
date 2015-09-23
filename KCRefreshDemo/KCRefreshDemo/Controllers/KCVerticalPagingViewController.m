//
//  ViewController.m
//  KCRefreshDemo
//
//  Created by KenshinCui on 15/9/20.
//  Copyright © 2015年 CMJStudio. All rights reserved.
//  类似网易云阅读的下拉、上拉翻页效果

#import "KCVerticalPagingViewController.h"
#import "KCPerson.h"
#import "KCPersonService.h"
#import "KCRefresh.h"
#import "KCCardView.h"
#import "UIView+KC.h"

static CGFloat kAnimationDuration = 0.5;
@interface KCVerticalPagingViewController ()

@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) KCCardView *cardView;
@property(strong, nonatomic) NSMutableArray *data;
@property(assign, nonatomic) NSUInteger index;

@end

@implementation KCVerticalPagingViewController

#pragma mark - 生命周期及其基类方法
- (void)viewDidLoad {
	[super viewDidLoad];

	[self setupUI];
}

#pragma mark - 私有方法
- (void)setupUI {
	self.title = @"分页刷新2";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
	[self.view addSubview:self.scrollView];
	[self.scrollView addSubview:self.cardView];
	self.scrollView.contentSize = CGSizeMake(0, self.cardView.frame.size.height + 1);

	//添加分页刷新
	__weak typeof(self) weakSelf = self;
	[self.scrollView addVerticalPagingRefreshHeaderWithIdleText:@"下拉查看上一张"
						     refreshingText:@"松开查看上一张"
						    refreshingBlock:^{
						      [weakSelf updatePageWithDirection:NO];
						    }];
	[self.scrollView addVerticalPagingRefreshFooterWithIdleText:@"上拉查看下一张"
						     refreshingText:@"松开查看下一张"
						    refreshingBlock:^{
						      [weakSelf updatePageWithDirection:YES];
						    }];

	KCPerson *person = [self.data firstObject];
	self.cardView.person = person;
}

- (void)updatePageWithDirection:(BOOL)up {
	CGFloat position = [UIScreen mainScreen].bounds.size.height;
	if (up) {
		self.index++;
		position = -position;
	} else {
		self.index--;
	}

	NSUInteger dataCount = self.data.count;
	self.index = (dataCount + self.index) % dataCount;
	KCPerson *person = [self.data objectAtIndex:self.index];

	[UIView animateWithDuration:kAnimationDuration
	    animations:^{
	      self.scrollView.y = position;
	    }
	    completion:^(BOOL finished) {
	      self.cardView.person = person;
	      [self.scrollView endVerticalPagingRefreshHeader];
	      [self.scrollView endVerticalPagingRefreshFooter];
	      self.scrollView.y = 64.0;
	      self.cardView.alpha = 0;
	      [UIView animateWithDuration:kAnimationDuration
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
