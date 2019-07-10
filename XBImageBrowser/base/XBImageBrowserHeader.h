//
//  XBImageBrowserHeader.h
//  XBImageBrowser
//
//  Created by xxb on 2017/1/11.
//  Copyright © 2017年 xxb. All rights reserved.
//

#ifndef XBImageBrowserHeader_h
#define XBImageBrowserHeader_h


typedef UIView * (^CreateLoadingViewBlockType)(void);

//屏幕宽高
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define isIphoneXSeries (ScreenHeight == 812 || ScreenHeight == 896 || ScreenWidth == 812 || ScreenWidth == 896)
//顶部安全区域高
#define TopSafeAreaHeight (isIphoneXSeries ? 24 : 0)
//底部安全区域高
#define BottomSafeAreaHeight (isIphoneXSeries ? 34 : 0)

//状态栏高度
#define KStatusBarHeight    (TopSafeAreaHeight + 20)

#define NavBarHeight (KStatusBarHeight + 44)

#define WEAK_SELF __typeof(self) __weak weakSelf = self;


#define RandColor [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0]


//通知
#define kNotice_currentImageIndexChange @"kNotice_currentImageIndexChange"
#define kNotice_itemImageClicked @"kNotice_itemImageClicked"
#define kNotice_itemImageDeleted @"kNotice_itemImageDeleted"
#define kNotice_imageFinishDownload @"kNotice_imageFinishDownload"
#define kNotice_deviceOrientationWillChange @"kNotice_deviceOrientationWillChange"
#define kNotice_imageHasBeenSetted @"kNotice_imageHasBeenSetted"
#define kNotice_imageViewDidZoom @"kNotice_imageViewDidZoom"

#define kUrlStrKey @"urlStr"
#define kImageKey @"image"

#define kImageQuality (1.0)


//路径
#define KdicM_pathForUrlStorePath [NSString stringWithFormat:@"%@/Documents/KdicM_pathForUrlStorePath",NSHomeDirectory()]
#define KdownloadImgStoreFullPath [NSString stringWithFormat:@"%@%@",NSHomeDirectory(),@"/Documents/KdownloadImgStorePath"]

//获取当前时间戳 (NSTimeInterval)
#define getCurrentTimeInterval ({ \
NSDate* data = [NSDate dateWithTimeIntervalSinceNow:0];\
NSTimeInterval a=[data timeIntervalSince1970]; \
a;})

#endif /* XBImageBrowserHeader_h */
