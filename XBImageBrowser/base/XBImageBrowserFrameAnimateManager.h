//
//  XBImageBrowserFrameAnimateManager.h
//  AnXin
//
//  Created by xxb on 2018/6/25.
//  Copyright © 2018年 xxb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XBImageBrowserFrameAnimateManagerCommonBlock)(void);

@interface XBImageBrowserFrameAnimateManager : NSObject
/**
 以imageView的位置为起点，把imageView的image动画展示在屏幕中央
 imageView : 起始位置的imageView
 urlStr : 图片的url地址
 completeBlock : 做完动画后的回调
 */
+ (void)showAnimateWithImageView:(UIImageView *)imageView urlStr:(NSString *)urlStr completeBlock:(void (^)(XBImageBrowserFrameAnimateManager *animateView))completeBlock hiddenBlock:(XBImageBrowserFrameAnimateManagerCommonBlock)hiddenBlock;
/**
 以当前展示图片的imageView的位置为起点，以之前设置的imageView的位置为终点做动画
 block : 做完动画后的回调
 */
- (void)hiddenAnimate;
/**
 以当前展示图片的imageView的位置为起点，以view的位置为终点做动画
 block : 做完动画后的回调
 */
- (void)hiddenAnimateWithView:(UIView *)view;
@end
