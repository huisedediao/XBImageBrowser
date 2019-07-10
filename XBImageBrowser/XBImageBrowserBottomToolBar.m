//
//  XBImageBrowserBottomToolBar.m
//  XBImageBrowser_CollectionView
//
//  Created by xxb on 2017/1/12.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import "XBImageBrowserBottomToolBar.h"
#import "Masonry.h"
#import "XBImageBrowserHeader.h"

@interface XBImageBrowserBottomToolBar ()

@property (nonatomic,strong) UIButton *leftBtn;

@property (nonatomic,strong) UIButton *rightBtn;

@end

@implementation XBImageBrowserBottomToolBar

-(instancetype)initWithImageNameArr:(NSArray *)imageArr
{
    if (self=[super init])
    {
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.2];
        [self createSubviewsWithImageNameArr:(NSArray *)imageArr];
    }
    return self;
}

- (void)leftBtnClick:(UIButton *)btn
{
    WEAK_SELF
    if (weakSelf.leftBlock)
    {
        weakSelf.leftBlock(weakSelf);
    }
}
- (void)rightBtnClick:(UIButton *)btn
{
    WEAK_SELF
    if (weakSelf.rightBlock)
    {
        weakSelf.rightBlock(weakSelf);
    }
}

-(void)createSubviewsWithImageNameArr:(NSArray *)imageArr
{
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(60);
    }];
    
    [self.leftBtn setImage:[UIImage imageNamed:imageArr[0]] forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.equalTo(self);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(60);
    }];
    [self.rightBtn setImage:[UIImage imageNamed:imageArr[1]] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

@end
