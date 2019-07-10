//
//  XBImageBrowserItem.m
//  XBImageBrowser
//
//  Created by xxb on 2017/1/11.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import "XBImageBrowserItem.h"
#import "XBImageBrowserHeader.h"
#import "XBImageManager.h"

@interface XBImageBrowserItem () <UIScrollViewDelegate>

@property (nonatomic,strong)UIView *loadingView;
@property (nonatomic,strong)UIActivityIndicatorView *activityView;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIImageView *imageView;

@end

@implementation XBImageBrowserItem


#pragma mark - 生命周期

-(instancetype)initWithIndex:(NSInteger)index createLoadingViewBlock:(CreateLoadingViewBlockType)createLoadingViewBlock
{
    if (self=[super init])
    {
        self.loadingView = createLoadingViewBlock();
        self.int_index=index;
        [self addNotice];
        [self configSubViews];
        [self updateSubviewsFrame];
    }
    return self;
}

-(instancetype)initWithIndex:(NSInteger)index
{
    if (self=[super init])
    {
        self.int_index=index;
        [self addNotice];
        [self configSubViews];
        [self updateSubviewsFrame];
    }
    return self;
}

- (void)configSubViews
{
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
//    [self addSubview:self.loadingView];
}

-(void)dealloc
{
    [self removeNotice];
}



#pragma mark - 通知相关

-(void)addNotice
{
    //添加通知获取设备发生旋转时的相关信息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:kNotice_deviceOrientationWillChange
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentImageIndexChanged:) name:kNotice_currentImageIndexChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageFinishDownload:) name:kNotice_imageFinishDownload object:nil];
}

-(void)removeNotice
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotice_deviceOrientationWillChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotice_currentImageIndexChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotice_imageFinishDownload object:nil];
}

-(void)currentImageIndexChanged:(NSNotification *)noti
{
    if ([noti.object integerValue] == self.int_index)
    {
        self.scrollView.zoomScale=1.0;
    }
}

- (void)deviceOrientationDidChange:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self updateSubviewsFrame];
        
        self.image=self.image;
        
//        self.scrollView.zoomScale=1.0;
    });
    
}

-(void)updateSubviewsFrame
{
//    NSLog(@"width:%f,height:%f\r",ScreenWidth,ScreenHeight);
//    NSLog(@"rect:%@",NSStringFromCGRect(self.superview.bounds));
    /*
    这里不直接使用self.superview.bounds是因为
    
    2017-01-16 09:40:34.627892 XBImageBrowser_CollectionView[669:148531] width:568.000000,height:320.000000
    2017-01-16 09:40:34.628139 XBImageBrowser_CollectionView[669:148531] rect:{{0, 0}, {320, 568}}
     */
    
    self.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.scrollView.frame=self.bounds;
    self.scrollView.zoomScale=1.0;
    _loadingView.center=self.center;
}

-(void)imageFinishDownload:(NSNotification *)noti
{
    NSDictionary *dic=noti.object;
    if ([dic[kUrlStrKey] isEqualToString:self.str_imagePathOrUrlstr])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image=dic[kImageKey];
        });
    }
}


#pragma mark - 懒加载

-(UIScrollView *)scrollView
{
    if (_scrollView==nil)
    {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 5.0;//最大缩放倍数
        _scrollView.minimumZoomScale = 1.0;//最小缩放倍数
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

-(UIImageView *)imageView
{
    if (_imageView==nil)
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        
        //添加双击手势
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        [_imageView addGestureRecognizer:doubleTap];
        
        //添加单击手势
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [_imageView addGestureRecognizer:tap];
        
        //单击手势在双击没起作用时才起作用
        [tap requireGestureRecognizerToFail:doubleTap];
    }
    return _imageView;
}


-(UIView *)loadingView
{
    if (_loadingView == nil && self.createLoadingViewBlock != nil) {
        _loadingView = self.createLoadingViewBlock();
    }
    if (_loadingView == nil) {
        NSLog(@"loadingView init");
        _loadingView = self.activityView;
    }
    if (_loadingView == self.activityView) {
        [self.activityView startAnimating];
    }
    return _loadingView;
}


-(UIActivityIndicatorView *)activityView
{
    if (_activityView==nil)
    {
        _activityView=[[UIActivityIndicatorView alloc] init];
        _activityView.center=self.center;
        [_activityView startAnimating];
    }
    return _activityView;
}



#pragma mark - 方法重写

-(void)setCreateLoadingViewBlock:(CreateLoadingViewBlockType)createLoadingViewBlock
{
    _createLoadingViewBlock = createLoadingViewBlock;
    
    [self addSubview:self.loadingView];
    
    [self updateSubviewsFrame];
}

-(void)setInt_index:(NSInteger)int_index
{
    _int_index=int_index;
    
    [self updateSubviewsFrame];
}

-(void)setStr_imagePathOrUrlstr:(NSString *)str_imagePathOrUrlstr
{
    _str_imagePathOrUrlstr=str_imagePathOrUrlstr;
    
    //避免本地图片太大(不管本地或者网络)，滑动到下一次cell复用，仍然显示上一张图片
    self.imageView.frame=CGRectZero;
    
    [self setLoadingViewHidden:NO];
    
    [[XBImageManager sharedManager] getImageWith:str_imagePathOrUrlstr];
}

- (void)setImage:(UIImage *)image
{
    [self setLoadingViewHidden:YES];
    _image = image;
    self.imageView.image = image;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat maxHeight = self.scrollView.bounds.size.height;
    CGFloat maxWidth = self.scrollView.bounds.size.width;
    //如果图片尺寸大于view尺寸，按比例缩放
    if(width > maxWidth || height > width)
    {
        CGFloat ratio = height / width;
        CGFloat maxRatio = maxHeight / maxWidth;
        if(ratio < maxRatio)
        {
            width = maxWidth;
            height = width*ratio;
        }
        else
        {
            height = maxHeight;
            width = height / ratio;
        }
    }
    self.imageView.frame = CGRectMake((maxWidth - width) / 2, (maxHeight - height) / 2, width, height);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotice_imageHasBeenSetted object:self.imageView];
}



#pragma mark - UIScrollView代理方法

//指定缩放UIScrolleView时，缩放UIImageView来适配
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

//缩放后让图片显示到屏幕中间
-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize originalSize = _scrollView.bounds.size;
    CGSize contentSize = _scrollView.contentSize;
    CGFloat offsetX = originalSize.width > contentSize.width ? (originalSize.width - contentSize.width) / 2 : 0;
    CGFloat offsetY = originalSize.height > contentSize.height ? (originalSize.height - contentSize.height) / 2 : 0;
    self.imageView.center = CGPointMake(contentSize.width / 2 + offsetX, contentSize.height / 2 + offsetY);
    NSLog(@"imageViewGect  %@",NSStringFromCGRect(self.imageView.frame));
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotice_imageViewDidZoom object:self.imageView];
}



#pragma mark - 手势处理

-(void)handleTap:(UITapGestureRecognizer *)tap
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotice_itemImageClicked object:self.image];
    NSLog(@"tap");
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recongnizer
{
    UIGestureRecognizerState state = recongnizer.state;
    switch (state)
    {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            //以点击点为中心，放大图片
            CGPoint touchPoint = [recongnizer locationInView:recongnizer.view];
            BOOL zoomOut = self.scrollView.zoomScale == self.scrollView.minimumZoomScale;
            CGFloat scale = zoomOut?self.scrollView.maximumZoomScale:self.scrollView.minimumZoomScale;
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.zoomScale = scale;
                if(zoomOut)
                {
                    CGFloat x = touchPoint.x*scale - self.scrollView.bounds.size.width / 2;
                    CGFloat maxX = self.scrollView.contentSize.width-self.scrollView.bounds.size.width;
                    CGFloat minX = 0;
                    x = x > maxX ? maxX : x;
                    x = x < minX ? minX : x;
                    
                    CGFloat y = touchPoint.y * scale-self.scrollView.bounds.size.height / 2;
                    CGFloat maxY = self.scrollView.contentSize.height-self.scrollView.bounds.size.height;
                    CGFloat minY = 0;
                    y = y > maxY ? maxY : y;
                    y = y < minY ? minY : y;
                    self.scrollView.contentOffset = CGPointMake(x, y);
                }
            }];
            
        }
            break;
        default:break;
    }
}

#pragma mark - 其他
- (void)setLoadingViewHidden:(BOOL)hidden
{
    if (self.loadingView == self.activityView)
    {
        if (hidden)
        {
            [self.activityView stopAnimating];
        }
        else
        {
            [self.activityView startAnimating];
        }
    }
    else
    {
        self.loadingView.hidden = hidden;
    }
}
@end
