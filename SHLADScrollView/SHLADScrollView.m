//
//  SHLADScrollView.m
//  SHLApp
//
//  Created by DOLFVE on 16/3/29.
//  Copyright © 2016年 DOLFVE. All rights reserved.
//

#import "SHLADScrollView.h"

@interface SHLADScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) NSInteger pageCount;

@end

@implementation SHLADScrollView

- (instancetype)init{
    if (self == [super init]) {
        //TO DO SOMETH
        [self initView];
    }
    return self;
}

#pragma mark -自定义函数
- (void)initView{
    //
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    
    weakSelf(weakSelf);
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.edges.equalTo(weakSelf);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.width.equalTo(weakSelf);
        make.height.mas_equalTo(15);
        make.centerX.equalTo(weakSelf);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).with.offset(-15);
    }];
}

- (void)initScrollView{
    //
    weakSelf(weakSelf);
    
    //开始将其定位在第二个imageView（实际为第一张图片）
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
    
    if ([self.delegate respondsToSelector:@selector(arrayOfImageInADScrollView)] && [self.delegate respondsToSelector:@selector(placeholderImageInADScrollView)]) {
        NSArray *imageArr = [self.delegate arrayOfImageInADScrollView];
        UIImage *placeholderImage = [UIImage imageNamed:[self.delegate placeholderImageInADScrollView]];;
        
        self.pageCount = imageArr.count;
        
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * (imageArr.count + 2), 0)];
                
        [_pageControl setNumberOfPages:[[self.delegate arrayOfImageInADScrollView] count]];
        
        //最后一张图片(用作第一张图片，用于数组第一张图片向左移的情况)
        UIImageView *lastImageView = [[UIImageView alloc] init];
        [lastImageView sd_setImageWithURL:[NSURL URLWithString:[imageArr lastObject]] placeholderImage:placeholderImage];
        [self.scrollView addSubview:lastImageView];
        //设置约束
        [lastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            //
            make.top.bottom.left.equalTo(weakSelf.scrollView);
            make.width.mas_equalTo(self.scrollView.frame.size.width);
        }];
        
        __weak UIView *tmpView = lastImageView;
        
        __block __weak UIView *lastView;
        [imageArr enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:placeholderImage];
            
            [weakSelf.scrollView addSubview:imageView];
            //设置imageView的约束
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                //
                make.top.bottom.equalTo(weakSelf.scrollView);
                make.width.mas_equalTo(self.scrollView.frame.size.width);
                make.height.mas_equalTo(self.scrollView.frame.size.height);
                //是否是最开始的view
                if (lastView) {
                    make.left.equalTo(lastView.mas_right);
                } else {
                    make.left.equalTo(tmpView.mas_right);
                }
            }];
            lastView = imageView;
        }];
        
        //第一张图片(用作最后一张图片，用于数组最后一张图片向右移的情况)
        UIImageView *firstImageView = [[UIImageView alloc] init];
        [firstImageView sd_setImageWithURL:[NSURL URLWithString:[imageArr firstObject]] placeholderImage:placeholderImage];
        [self.scrollView addSubview:firstImageView];
        
        [firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            //
            make.top.bottom.equalTo(weakSelf.scrollView);
            make.left.equalTo(lastView.mas_right);
            make.width.mas_equalTo(self.scrollView.frame.size.width);
        }];
        
        __weak UIView *firstTmpView  = firstImageView;
        
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            //
            make.right.equalTo(firstTmpView.mas_right);
        }];
        
        [self scrollViewDidEndDecelerating:self.scrollView];
    }
}

- (void)reloadImage{
    [self initScrollView];
}

//自动播放
- (void)autoPlayWithCurrenPage:(NSInteger)currenPage{
    //
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, timeInterval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
//    dispatch_source_set_event_handler(timer, ^{
//        //获取当前页数
//        NSInteger currentPage = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
//        if (self.direction == SHLADScrollViewLeftDirection) {
//            //向左
//        } else if (self.direction == SHLADScrollViewRightDirection) {
//            //向右
//        }
//    });
//    dispatch_resume(timer);
    if ([self.delegate respondsToSelector:@selector(timeIntervalForADScrollView)]) {
        NSTimeInterval timeInterval = [self.delegate timeIntervalForADScrollView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //
            if (self.direction == SHLADScrollViewLeftDirection) {
                //向左
                [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width * (currenPage - 1), 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
                
                [self scrollViewDidEndDecelerating:self.scrollView];
//                if (currenPage == 0) {
//                    [self.pageControl setCurrentPage:self.pageCount];
//                } else {
//                    [self.pageControl setCurrentPage:currenPage];
//                }
            } else if (self.direction == SHLADScrollViewRightDirection) {
                //向右
                [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width * (currenPage + 1), 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
                
                [self scrollViewDidEndDecelerating:self.scrollView];
                if (currenPage == self.pageCount) {
                    [self.pageControl setCurrentPage:0];
                } else {
                    [self.pageControl setCurrentPage:currenPage];
                }
            }
        });
    }
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (currentPage == 0) {
        [scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width * self.pageCount, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:NO];
        //当前页为最后一页
        currentPage = self.pageCount - 1;
    }
    
    if (currentPage == self.pageCount + 1) {
        [scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:NO];
        //当前页为第一页
        currentPage = 0;
    }
    currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self.pageControl setCurrentPage:currentPage - 1];
    
    //当到达当页，并且停止滑动时，开始倒计时
    [self autoPlayWithCurrenPage:currentPage];
}

#pragma mark -getter && setter
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollEnabled = YES;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPage = 1;
        _pageControl.pageIndicatorTintColor = RGB(226, 226, 226);
        _pageControl.currentPageIndicatorTintColor = APP_COLOR;
    }
    return _pageControl;
}

@end