//
//  XBImageBrowserWithToolBar.h
//  XBImageBrowser_CollectionView
//
//  Created by xxb on 2017/1/12.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import "XBImageBrowser.h"

@interface XBImageBrowserWithToolBar : XBImageBrowser
@property (nonatomic,copy) void (^bl_share)(NSInteger index);
@property (nonatomic,copy) void (^bl_delete)(NSInteger index);
@end
