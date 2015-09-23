# KCRefresh
![](https://github.com/kenshincui/KCRefresh/blob/master/KCRefreshDemo/KCRefreshDemo/Resources/cmjLogo120.png?raw=true)  

KCRefresh 是一个高可扩展性的刷新控件，通过它可以快速实现各类刷新翻页效果。目前普通的下拉刷新、上拉加载控件已经很多，因此在此控件中默认并没有实现这些子控件，而是重点放到了一些其他刷新效果上面，例如淘宝头条和网易云阅读的两类分页刷新效果上面。但是注意，使用KCRefresh并不是不能实现普通的刷新效果，应该说有了KCRefresh实现起来并不难（后面有时间也会加上普通的刷新效果）。   
KCRefresh并不是简单提供集中刷新效果，这不是此控件的目的，控件关键还是放在可扩展性上，因为实际开发中往往不能使用“拿来主义”，个性化的需求随处可见。利用KCRefresh基类KCRefreshComponent极其直接子类KCRefreshHeader、KCRefreshFooter几乎可以实现任何刷新效果（包括普通刷新和个性化刷新，例如目前已经实现的子类KCPagingRefreshHeader、KCPagingRefreshFooter、KCVerticalPagingRefreshHeader、KCVerticalPagingRefreshFooter），这才是KCRefresh存在的最主要的目的。   
## 主要的类
__KCRefreshComponent__：这是刷新控件的基类，此类对于刷新操作进行抽象，监听偏移量变化、手势变化等提供给子类使用。KCRefreshComponent自身并不区分是头部刷新还是尾部刷新，其具体细节由子类决定。  
__KCRefreshHeader__：刷新头部控件抽象，继承于KCRefreshComponent，重写offsetChange:和stateChange:percent:方法，KCRefreshHeader实现了状态刷新状态变化的细节并负责在合适的时机执行刷新完成操作。   
__KCRefreshFooter__：刷新尾部控件抽象，继承于KCRefreshComponent，重写offsetChange:和stateChange:percent:方法，KCRefreshFooter实现了状态刷新状态变化的细节并负责在合适的时机执行刷新完成操作。   
****
以上三个类是实现刷新的基类，非特殊情况下如果有个性需求只需要继承并实现KCRefreshHeader或者KCRefreshFooter，除非二者不能满足需求才需要直接继承KCRefreshComponent。另外在代码中已经默认实现了两种分页刷新效果，这也是目前市面上除了普通刷新效果之外的两种常见效果（后面会把普通刷新效果补充上）。   
## 示例
### 1. 类似于淘宝头条的分页刷新
不同于普通刷新效果的是上拉刷新后不是加载更多而是弹回到原来的位置并执行其他操作，并且提供了类似于淘宝的动画旋转效果。   
```objc
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
```   
__效果__   

![](https://github.com/kenshincui/KCRefresh/blob/master/KCRefreshDemo/KCRefreshDemo/Resources/PagingRefresh.gif?raw=true)   
### 2. 类似于网易云阅读的分页刷新
和上面的分页刷新效果不同的是无论是下拉刷新还是上拉刷新均不会弹回到原来的位置而是直接执行翻页效果，并此类刷新不像普通的刷新，它只有两种状态切换。   
```objc
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
```   
__效果__   

![](https://github.com/kenshincui/KCRefresh/blob/master/KCRefreshDemo/KCRefreshDemo/Resources/VerticalPagingRefresh.gif?raw=true)


