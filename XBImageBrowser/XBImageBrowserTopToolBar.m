//
//  XBImageBrowserTopToolBar.m
//  XBImageBrowser_CollectionView
//
//  Created by xxb on 2017/1/12.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import "XBImageBrowserTopToolBar.h"
#import "Masonry.h"
#import "XBImageBrowserHeader.h"

@interface XBImageBrowserTopToolBar ()
@property (nonatomic,assign) BOOL isNotFirstRun;
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UILabel *titleLabel;
@end

@implementation XBImageBrowserTopToolBar

-(instancetype)init
{
    if (self=[super init]) {
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.2];
        [self createSubviews];
        [self addNotice];
    }
    return self;
}

-(void)createSubviews
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:@"XBIB_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.equalTo(backBtn.superview);
        make.top.equalTo(backBtn.superview).offset(20);
        make.width.mas_equalTo(50);
    }];
    self.backBtn=backBtn;
    
    self.titleLabel=[UILabel new];
    [self addSubview:self.titleLabel];
    self.titleLabel.text=@"title";
    self.titleLabel.textColor=[UIColor whiteColor];
    self.titleLabel.font=[UIFont systemFontOfSize:15];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.titleLabel.superview);
        make.centerY.equalTo(backBtn);
    }];
}

- (void)layoutSubviews
{
    if (self.isNotFirstRun == NO)
    {
        [self deviceOrientationDidChange:nil];
        self.isNotFirstRun = YES;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 通知相关
- (void)addNotice
{
    //添加通知获取设备发生旋转时的相关信息
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}
- (void)deviceOrientationDidChange:(NSNotification *)notification
{
    UIInterfaceOrientation stateNoworientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (stateNoworientation == UIInterfaceOrientationLandscapeLeft || stateNoworientation ==  UIInterfaceOrientationLandscapeRight)
    {
        [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.equalTo(self);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(50);
        }];
    }
    else
    {
        [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.equalTo(self);
            make.top.equalTo(self).offset(20 + TopSafeAreaHeight * 0.5);
            make.width.mas_equalTo(50);
        }];
    }
}


-(void)setTitle:(NSString *)title
{
    _title=title;
    self.titleLabel.text=title;
}

- (void)backBtnClick:(UIButton *)btn
{
    WEAK_SELF
    if (weakSelf.block)
    {
        weakSelf.block(weakSelf);
    }
}


@end
