//
//  XBImageBrowserCell.m
//  XBImageBrowser_CollectionView
//
//  Created by xxb on 2017/1/11.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import "XBImageBrowserCell.h"
#import "XBImageBrowserItem.h"

@interface XBImageBrowserCell ()
@property (nonatomic,strong) XBImageBrowserItem *item;
@end

@implementation XBImageBrowserCell


-(instancetype)initWithFrame:(CGRect)frame createLoadingViewBlock:(CreateLoadingViewBlockType)createLoadingViewBlock
{
    if (self=[super initWithFrame:frame])
    {
        self.item=[[XBImageBrowserItem alloc] initWithIndex:0 createLoadingViewBlock:createLoadingViewBlock];
        [self.contentView addSubview:self.item];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        self.item=[[XBImageBrowserItem alloc] initWithIndex:0];
        [self.contentView addSubview:self.item];
    }
    return self;
}

-(void)setCreateLoadingViewBlock:(CreateLoadingViewBlockType)createLoadingViewBlock
{
    _createLoadingViewBlock = createLoadingViewBlock;
    self.item.createLoadingViewBlock = createLoadingViewBlock;
}

-(void)setIndex:(NSInteger)index
{
    _index=index;
    self.item.int_index=index;
}

- (void)setImage:(UIImage *)image
{
    self.item.image = image;
}

-(void)setStr_imagePathOrUrlstr:(NSString *)str_imagePathOrUrlstr
{
    self.item.str_imagePathOrUrlstr=str_imagePathOrUrlstr;
}

@end
