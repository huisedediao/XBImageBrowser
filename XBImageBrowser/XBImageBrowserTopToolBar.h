//
//  XBImageBrowserTopToolBar.h
//  XBImageBrowser_CollectionView
//
//  Created by xxb on 2017/1/12.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBImageBrowserTopToolBar : UIView


@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) void(^block)(XBImageBrowserTopToolBar *topToolBar);


@end
