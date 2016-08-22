//
//  SHLADScrollView.h
//  SHLApp
//
//  Created by DOLFVE on 16/3/29.
//  Copyright © 2016年 DOLFVE. All rights reserved.
//

#import "UIKit/UIKit.h"

//需要添加一个滑动到最右边，还可以继续滑动（也就是滑动到最左边）

 /// 说明
/*
 *如果网络数据未加载完的时候，开始默认显示三个轮播图
 */
#define SHL_AD_SCROLLVIEW_DEFAUT_IMAGE_COUNT                    3

@class SHLADScrollView;
typedef NS_ENUM(NSInteger, SHLADScrollViewDirection) {
    SHLADScrollViewLeftDirection = 0,
    SHLADScrollViewRightDirection = 1
};

@protocol SHLADScrollViewDelegate <NSObject>

@optional
/**
 *  自动播放的时间间隔（不设置，默认为3s）
 *
 *  @return NSTimeInterval(时间间隔)
 */
- (NSTimeInterval)timeIntervalForADScrollView;

/**
 *  点击轮播图
 *
 *  @param scrollView SHLADScrollView
 *  @param index      第几张图片
 */
- (void)adScrollView:(SHLADScrollView *)scrollView didSelectImageAtIndex:(NSInteger)index;              //未实现

@required
/**
 *  获取图片数组
 *
 *  @return 数组
 */
- (NSArray <NSString *>*)arrayOfImageInADScrollView;

/**
 *  获取默认图片
 *
 *  @return 本地图片路径
 */
- (NSString *)placeholderImageInADScrollView;

@end

@interface SHLADScrollView : UIView

@property (nonatomic, assign) BOOL isAutoPaly;           //是否自动播放（默认为自动播放）

@property (nonatomic, assign) SHLADScrollViewDirection direction;

@property (nonatomic, weak) id<SHLADScrollViewDelegate> delegate;

- (void)reloadImage;

@end