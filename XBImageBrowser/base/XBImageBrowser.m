//
//  XBImageBrowser.m
//  XBImageBrowser_CollectionView
//
//  Created by xxb on 2017/1/11.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import "XBImageBrowser.h"
#import "XBImageBrowserHeader.h"
#import "XBImageBrowserCell.h"
#import "XBImageManager.h"
#import "XBImageBrowserFrameAnimateManager.h"

@interface XBImageBrowser () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

/** 记录屏幕方向 */
@property (nonatomic,assign) UIInterfaceOrientation lastInterfaceOrientation;
@property (nonatomic,strong) XBImageBrowserFrameAnimateManager *tempAnimateView;
@end

@implementation XBImageBrowser


#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotice];
    
    self.view.backgroundColor=[UIColor blackColor];
    
    [self.view addSubview:self.xbCollectionView];
}


-(void)viewWillAppear:(BOOL)animated
{
    //重新设置一遍frame，避免进来时候就横屏造成的错位
    self.xbCollectionView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.xbCollectionView reloadData];
    
    CGPoint tempOffset = self.xbCollectionView.contentOffset;
    tempOffset.x=self.indexOfItem * ScreenWidth;
    self.xbCollectionView.contentOffset=tempOffset;
    
    //记录下屏幕的方向，避免进来时就横屏，翻转180度造成的错位
    if (ScreenWidth > ScreenHeight)
    {
        //这里方向UIInterfaceOrientationLandscapeLeft 或者 right都可以，因为后面只用来判断屏幕宽高，else同理
        self.lastInterfaceOrientation=UIInterfaceOrientationLandscapeLeft;
    }
    else
    {
        self.lastInterfaceOrientation=UIInterfaceOrientationPortrait;
    }
}

-(void)dealloc
{
    NSLog(@"%@释放了",NSStringFromClass([self class]));
    [[XBImageManager sharedManager] removeImagesForUrlOrPathArr:self.arrM_imagePathOrUrlstr];
    [self removeNotice];
}



#pragma mark - 通知相关
-(void)addNotice
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTapImage:) name:kNotice_itemImageClicked object:nil];
}
-(void)removeNotice
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotice_itemImageClicked object:nil];
}
-(void)handleTapImage:(NSNotification *)noti
{
    NSLog(@"tap");
    if (self.tempAnimateView)
    {
        [self.tempAnimateView hiddenAnimate];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 旋转相关

- (void)deviceOrientationDidChange:(UIInterfaceOrientation)toInterfaceOrientation
{
    //如果没有完成滚动，重复执行，等待滚动完成
    if (self.xbCollectionView.isDecelerating == YES)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self deviceOrientationDidChange:toInterfaceOrientation];
        });
        return;
    }
    
    __block CGFloat fixWidth;
    
    [UIView animateWithDuration:0.5 animations:^{
        //判断旋转前后的屏幕宽高是否改变了
        if (((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) && (self.lastInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.lastInterfaceOrientation == UIInterfaceOrientationLandscapeRight)) || ((toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) && (self.lastInterfaceOrientation == UIInterfaceOrientationPortrait || self.lastInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)))//没改变
        {
            self.xbCollectionView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            fixWidth=ScreenWidth;
        }
        else//改变了
        {
            self.xbCollectionView.frame=CGRectMake(0, 0, ScreenHeight, ScreenWidth);
            fixWidth=ScreenHeight;
        }
    }];


    [self.xbCollectionView reloadData];
    CGPoint tempOffset=self.xbCollectionView.contentOffset;
    tempOffset.x=self.indexOfItem*fixWidth;
    self.xbCollectionView.contentOffset=tempOffset;
    
    self.lastInterfaceOrientation=toInterfaceOrientation;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotice_deviceOrientationWillChange object:nil];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"%@",[NSThread currentThread]);
    [self deviceOrientationDidChange:toInterfaceOrientation];
}


#pragma mark - 懒加载

-(UICollectionView *)xbCollectionView
{
    if (_xbCollectionView==nil)
    {
        UICollectionViewFlowLayout *flow=[[UICollectionViewFlowLayout alloc] init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flow.minimumInteritemSpacing = 0;
        flow.minimumLineSpacing = 0;
        _xbCollectionView=[[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flow];
        // 设置collectionView的代理：
        _xbCollectionView.delegate = self;
        _xbCollectionView.dataSource = self;
        _xbCollectionView.pagingEnabled=YES;
        _xbCollectionView.showsHorizontalScrollIndicator=NO;
        if (@available(iOS 11.0, *)) {
            _xbCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        // 注册item:
        [_xbCollectionView registerClass:[XBImageBrowserCell class] forCellWithReuseIdentifier:@"cell"];
        _xbCollectionView.backgroundColor=[UIColor clearColor];
    }
    return _xbCollectionView;
}

#pragma mark - collection代理和数据源
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self getImageCount];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XBImageBrowserCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    //    cell.contentView.backgroundColor=RandColor;
    
    cell.createLoadingViewBlock = self.createLoadingViewBlock;
    [self setContentForCell:cell index:indexPath.row];
    cell.index=indexPath.item;
    NSLog(@"%p",cell);
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.bounds.size;
}

//某个item从显示到不显示后调用
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    /** 发送通知，还原item的scrollView的缩放倍数 */
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotice_currentImageIndexChange object:@(indexPath.item)];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 将collectionView在控制器view的中心点转化成collectionView上的坐标
    CGPoint pInView = [self.view convertPoint:self.xbCollectionView.center toView:self.xbCollectionView];
    // 获取这一点的indexPath
    NSIndexPath *indexPathNow = [self.xbCollectionView indexPathForItemAtPoint:pInView];
    // 赋值给记录当前坐标的变量
    self.indexOfItem = indexPathNow.item;
}


#pragma mark - show
/*
 以Presen效果显示
 currentVC : 弹出图片浏览器的vc
 */
- (void)showUsePresentWithCurrentVC:(UIViewController *)currentVC
{
    [currentVC presentViewController:self animated:YES completion:nil];
}

/*
 以点击的图片放大到屏幕中间的效果显示
 imageView : 要放大的图片控件
 index : 展示第几张图片
 currentVC : 弹出图片浏览器的vc
 */
+ (void)showUseFrameAnimateWithView:(UIImageView *)imageView imagePathOrUrlstrArr:(NSArray *)imagePathOrUrlstrArr index:(NSInteger)index currentVC:(UIViewController *)currentV
{
    NSString *urlStr = imagePathOrUrlstrArr[index];
    XBImageBrowser *imageBrowser = [XBImageBrowser new];
    imageBrowser.arrM_imagePathOrUrlstr = [imagePathOrUrlstrArr mutableCopy];
    imageBrowser.indexOfItem = index;
    typeof(imageBrowser) __weak weakImageBrowser = imageBrowser;
    [XBImageBrowserFrameAnimateManager showAnimateWithImageView:imageView urlStr:urlStr completeBlock:^(XBImageBrowserFrameAnimateManager *animateView) {
        imageBrowser.tempAnimateView = animateView;
        [currentV presentViewController:imageBrowser animated:NO completion:nil];
    } hiddenBlock:^{
        [weakImageBrowser dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - 其他
- (NSInteger)getImageCount
{
    if (self.arrM_image.count)
    {
        return self.arrM_image.count;
    }
    return self.arrM_imagePathOrUrlstr.count;
}
- (void)setContentForCell:(XBImageBrowserCell *)cell index:(NSInteger)index
{
    if (self.arrM_image.count)
    {
        [cell setImage:self.arrM_image[index]];
    }
    else
    {
        NSString *path = self.arrM_imagePathOrUrlstr[index];
        cell.str_imagePathOrUrlstr = path;
    }
}
@end
