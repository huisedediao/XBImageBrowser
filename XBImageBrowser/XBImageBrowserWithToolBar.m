//
//  XBImageBrowserWithToolBar.m
//  XBImageBrowser_CollectionView
//
//  Created by xxb on 2017/1/12.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import "XBImageBrowserWithToolBar.h"
#import "XBImageBrowserHeader.h"
#import "XBImageBrowserBottomToolBar.h"
#import "XBImageBrowserTopToolBar.h"
#import "Masonry.h"

@interface XBImageBrowserWithToolBar () <UIAlertViewDelegate>
@property (nonatomic,assign) BOOL handleTapImage;
@property (nonatomic,strong) XBImageBrowserTopToolBar *topToolBar;
@property (nonatomic,strong) XBImageBrowserBottomToolBar *bottomToolBar;
@end

@implementation XBImageBrowserWithToolBar

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildUI];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.handleTapImage == NO)
    {
        UIInterfaceOrientation stateNoworientation = [[UIApplication sharedApplication] statusBarOrientation];
        [self showTopBarLayoutWith:stateNoworientation];
    }
}

- (void)deviceOrientationDidChange:(UIInterfaceOrientation)toInterfaceOrientation
{
    [super deviceOrientationDidChange:toInterfaceOrientation];
    
    [self showTopBarLayoutWith:toInterfaceOrientation];
}

- (void)showTopBarLayoutWith:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation ==  UIInterfaceOrientationLandscapeRight)
    {
        [_topToolBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self->_topToolBar.superview);
            make.height.mas_equalTo(NavBarHeight - TopSafeAreaHeight);
        }];
    }
    else
    {
        [_topToolBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self->_topToolBar.superview);
            make.height.mas_equalTo(NavBarHeight);
        }];
    }
}

-(void)buildUI
{
    self.topToolBar.backgroundColor=self.topToolBar.backgroundColor;
    self.bottomToolBar.backgroundColor=self.bottomToolBar.backgroundColor;
}

-(UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)handleTapImage:(NSNotification *)noti
{
    self.handleTapImage = YES;
    static NSTimeInterval lastTime = 0.0;
    NSTimeInterval newTime = getCurrentTimeInterval;
    BOOL isRepeat = newTime - lastTime < 0.3;
    lastTime=newTime;
    if (isRepeat)
    {
        return;
    }
    
    
    static int i=0;
    if (i % 2 ==0)
    {
        [UIView animateWithDuration:0.5 animations:^{
            [self.topToolBar mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.equalTo(self->_topToolBar.superview);
                make.top.equalTo(self->_topToolBar.superview).offset(-64);
                make.height.mas_equalTo(64);
            }];
            
            [self.bottomToolBar mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.equalTo(self->_bottomToolBar.superview);
                make.top.equalTo(self->_bottomToolBar.superview.mas_bottom);
                make.height.mas_equalTo(50);
            }];
            
            [self.view layoutIfNeeded];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            UIInterfaceOrientation stateNoworientation = [[UIApplication sharedApplication] statusBarOrientation];
            [self showTopBarLayoutWith:stateNoworientation];
            
            [self.bottomToolBar mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.leading.trailing.equalTo(self->_bottomToolBar.superview);
                make.height.mas_equalTo(50);
            }];
            
            [self.view layoutIfNeeded];
        }];
    }
    i++;
}



-(void)setIndexOfItem:(NSInteger)indexOfItem
{
    [super setIndexOfItem:indexOfItem];

    self.topToolBar.title=[NSString stringWithFormat:@"%zd/%zd",indexOfItem+1,[self getImageCount]];
}


-(XBImageBrowserTopToolBar *)topToolBar
{
    if (_topToolBar==nil)
    {
        _topToolBar=[XBImageBrowserTopToolBar new];
        [self.view addSubview:_topToolBar];
        UIInterfaceOrientation stateNoworientation = [[UIApplication sharedApplication] statusBarOrientation];
        [self showTopBarLayoutWith:stateNoworientation];
        WEAK_SELF
        _topToolBar.block=^(XBImageBrowserTopToolBar *toolBar){
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
        
        _topToolBar.title=[NSString stringWithFormat:@"%zd/%zd",self.indexOfItem+1,[self getImageCount]];
    }
    return _topToolBar;
}

-(XBImageBrowserBottomToolBar *)bottomToolBar
{
    if (_bottomToolBar==nil)
    {
        _bottomToolBar=[[XBImageBrowserBottomToolBar alloc] initWithImageNameArr:@[@"XBIB_share",@"XBIB_delete"]];
        [self.view addSubview:_bottomToolBar];
        [_bottomToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.equalTo(self->_bottomToolBar.superview);
            make.height.mas_equalTo(49);
        }];
        WEAK_SELF
        _bottomToolBar.leftBlock = ^(XBImageBrowserBottomToolBar *toolBar){
            NSLog(@"leftBlock");
            if (weakSelf.bl_share)
            {
                weakSelf.bl_share(weakSelf.indexOfItem);
            }
        };
        _bottomToolBar.rightBlock = ^(XBImageBrowserBottomToolBar *toolBar){
            NSLog(@"rightBlock");
            if (weakSelf.arrM_image)
            {
                [weakSelf removeObjectAtIndex:weakSelf.indexOfItem forArrM:weakSelf.arrM_image];
            }
            else
            {
                [weakSelf removeObjectAtIndex:weakSelf.indexOfItem forArrM:weakSelf.arrM_imagePathOrUrlstr];
            }
        };
    }
    return _bottomToolBar;
}

- (void)removeObjectAtIndex:(NSInteger)index forArrM:(NSMutableArray *)arrM
{
    [arrM removeObjectAtIndex:index];
    if (self.bl_delete)
    {
        self.bl_delete(index);
    }
    if (arrM.count == 0)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.xbCollectionView reloadData];
        if (arrM.count > index)
        {
            self.indexOfItem = index;
        }
        else
        {
            self.indexOfItem =arrM.count - 1;
        }
    }
}

@end
