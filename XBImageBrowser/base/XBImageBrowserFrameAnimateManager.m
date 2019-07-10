//
//  XBImageBrowserFrameAnimateManager.m
//  AnXin
//
//  Created by xxb on 2018/6/25.
//  Copyright © 2018年 xxb. All rights reserved.
//

#import "XBImageBrowserFrameAnimateManager.h"
#import "XBImageBrowserHeader.h"
#import "XBImageManager.h"


#define kAnimateTime (0.3)

@interface XBImageBrowserFrameAnimateManager ()
@property (nonatomic,weak) UIView *tempBGView;
@property (nonatomic,weak) UIImageView *tempImageView;
@property (nonatomic,assign) CGRect oldFrame;
@property (nonatomic,copy) XBImageBrowserFrameAnimateManagerCommonBlock hiddenBlock;
//imageBrowser当前用于展示图片的imageView
@property (nonatomic,weak) UIImageView *currentImageView;
@end

@implementation XBImageBrowserFrameAnimateManager

- (instancetype)init
{
    if (self = [super init])
    {
        [self addNotice];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"XBImageBrowserFrameAnimateManager销毁");
    [self removeNotice];
}

- (void)addNotice
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageHasBeenSetted:) name:kNotice_imageHasBeenSetted object:nil];
}
- (void)removeNotice
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)imageHasBeenSetted:(NSNotification *)noti
{
    self.currentImageView = noti.object;
    
    CGRect rect = [self.currentImageView.superview convertRect:self.currentImageView.frame toView:self.tempBGView];
    [UIView animateWithDuration:kAnimateTime animations:^{
        self.tempImageView.frame = rect;
    } completion:^(BOOL finished) {
        self.tempBGView.alpha = 0;
        if (self.tempImageView)
        {
            [self.tempImageView removeFromSuperview];
            self.tempImageView = nil;
        }
    }];
}


+ (void)showAnimateWithImageView:(UIImageView *)imageView urlStr:(NSString *)urlStr completeBlock:(void (^)(XBImageBrowserFrameAnimateManager *animateView))completeBlock hiddenBlock:(XBImageBrowserFrameAnimateManagerCommonBlock)hiddenBlock
{
    UIImage *currentImage = [[XBImageManager sharedManager] getImageFromLocalWithUrlStr:urlStr];
    if (currentImage == nil)
    {
        currentImage = imageView.image;
    }
    
    XBImageBrowserFrameAnimateManager *animateView = [XBImageBrowserFrameAnimateManager new];
    animateView.hiddenBlock = hiddenBlock;

    UIWindow *deleWindow = [UIApplication sharedApplication].delegate.window;
    deleWindow.userInteractionEnabled = NO;
    
    UIView *bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0;
    [deleWindow addSubview:bgView];
    animateView.tempBGView = bgView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:animateView action:@selector(bgViewTap:)];
    [bgView addGestureRecognizer:tap];
    
    CGRect imgFrame = [imageView.superview convertRect:imageView.frame toView:deleWindow];
    animateView.oldFrame = imgFrame;
    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:imgFrame];
    [bgView addSubview:tempImageView];
    animateView.tempImageView = tempImageView;
    tempImageView.image = currentImage;
    
    CGFloat hwRate = imageView.frame.size.height / imageView.frame.size.width;
    CGFloat width = currentImage.size.width;
    if (width > ScreenWidth)
    {
        width = ScreenWidth;
    }
    CGFloat height = width * hwRate;
    CGRect newRect = CGRectMake((ScreenWidth - width) * 0.5, (ScreenHeight - height) * 0.5, width, height);
    
    [UIView animateWithDuration:kAnimateTime animations:^{
        bgView.alpha = 1;
        tempImageView.frame = newRect;
    } completion:^(BOOL finished) {
        if (completeBlock)
        {
            completeBlock(animateView);
            deleWindow.userInteractionEnabled = YES;
        }
    }];
}
- (void)bgViewTap:(UIGestureRecognizer *)tap
{
    [self hiddenAnimate];
}
- (void)hiddenAnimate
{
    UIWindow *deleWindow = [UIApplication sharedApplication].delegate.window;
    [self hiddenAnimateWithSuperView:deleWindow frame:self.oldFrame];
}
- (void)hiddenAnimateWithView:(UIView *)view
{
    [self hiddenAnimateWithSuperView:view.superview frame:view.frame];
}
- (void)hiddenAnimateWithSuperView:(UIView *)superView frame:(CGRect)frame
{
    self.tempBGView.alpha = 1;
    
    UIWindow *deleWindow = [UIApplication sharedApplication].delegate.window;
    UIView *copyView = [self copyAView:self.currentImageView.superview];
    [deleWindow addSubview:copyView];
    
    UIImageView *imageView = copyView.subviews[0];
    
    if (self.hiddenBlock)
    {
        self.hiddenBlock();
    }
    
    [UIView animateWithDuration:kAnimateTime animations:^{
        CGRect rect = [superView convertRect:frame toView:copyView];
        imageView.frame = rect;
        self.tempBGView.alpha = 0;
    } completion:^(BOOL finished) {
        [copyView removeFromSuperview];
    }];
}
- (UIView *)copyAView:(UIView *)view
{
    NSData *tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

@end
