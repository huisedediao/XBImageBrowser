//
//  XBImageBrowserItem.h
//  XBImageBrowser
//
//  Created by xxb on 2017/1/11.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBImageBrowserHeader.h"

@interface XBImageBrowserItem : UIView

@property (nonatomic,strong)UIImage *image;

/** 记录cell的序号，在cell不显示时将item的scrollView的缩放倍数还原 */
@property (nonatomic,assign) NSInteger int_index;

@property (nonatomic,copy) NSString *str_imagePathOrUrlstr;

/** 正在载入的view要什么样子，如果不设置默认为菊花 */
@property (nonatomic,copy) CreateLoadingViewBlockType createLoadingViewBlock;

-(instancetype)initWithIndex:(NSInteger)index;

-(instancetype)initWithIndex:(NSInteger)index createLoadingViewBlock:(CreateLoadingViewBlockType)createLoadingViewBlock;

@end
