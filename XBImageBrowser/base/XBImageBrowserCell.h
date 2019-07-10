//
//  XBImageBrowserCell.h
//  XBImageBrowser_CollectionView
//
//  Created by xxb on 2017/1/11.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBImageBrowserHeader.h"

@interface XBImageBrowserCell : UICollectionViewCell

- (void)setImage:(UIImage *)image;

- (void)setStr_imagePathOrUrlstr:(NSString *)str_imagePathOrUrlstr;

@property (nonatomic,assign) NSInteger index;

/** 正在载入的view要什么样子，如果不设置默认为菊花 */
@property (nonatomic,copy) CreateLoadingViewBlockType createLoadingViewBlock;

-(instancetype)initWithFrame:(CGRect)frame createLoadingViewBlock:(CreateLoadingViewBlockType)createLoadingViewBlock;

@end
