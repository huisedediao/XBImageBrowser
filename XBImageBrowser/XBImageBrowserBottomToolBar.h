//
//  XBImageBrowserBottomToolBar.h
//  XBImageBrowser_CollectionView
//
//  Created by xxb on 2017/1/12.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBImageBrowserBottomToolBar : UIView
-(instancetype)initWithImageNameArr:(NSArray *)imageNameArr;
@property (nonatomic,copy) void (^leftBlock)(XBImageBrowserBottomToolBar *bottomToolBar);
@property (nonatomic,copy) void (^rightBlock)(XBImageBrowserBottomToolBar *bottomToolBar);
@end
