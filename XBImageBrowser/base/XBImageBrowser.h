//
//  XBImageBrowser.h
//  XBImageBrowser_CollectionView
//
//  Created by xxb on 2017/1/11.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBImageBrowserHeader.h"

@interface XBImageBrowser : UIViewController


@property (nonatomic,strong) UICollectionView *xbCollectionView;

@property (nonatomic,strong) NSMutableArray *arrM_image;

@property (nonatomic,strong) NSMutableArray *arrM_imagePathOrUrlstr;

/** 当前展示的是第几张 */
@property (nonatomic,assign) NSInteger indexOfItem;

/** 正在载入的view要什么样子，如果不设置默认为菊花 */
@property (nonatomic,copy) CreateLoadingViewBlockType createLoadingViewBlock;

- (NSInteger)getImageCount;

- (void)deviceOrientationDidChange:(UIInterfaceOrientation)toInterfaceOrientation;

/*
 以Presen效果显示
 currentVC : 弹出图片浏览器的vc
 */
- (void)showUsePresentWithCurrentVC:(UIViewController *)currentVC;
/*
 以点击的图片放大到屏幕中间的效果显示
 imageView : 要放大的图片控件
 index : 展示第几张图片
 currentVC : 弹出图片浏览器的vc
 */
+ (void)showUseFrameAnimateWithView:(UIImageView *)imageView imagePathOrUrlstrArr:(NSArray *)imagePathOrUrlstrArr index:(NSInteger)index currentVC:(UIViewController *)currentV;

@end
