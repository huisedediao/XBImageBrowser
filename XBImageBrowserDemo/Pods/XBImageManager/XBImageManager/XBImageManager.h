//
//  XBImageManager.h
//  XBImageBrowser_CollectionView
//
//  Created by xxb on 2017/1/14.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^XBImageManagerCompleteBlock)(UIImage *image);

@interface XBImageManager : NSObject

/** 是否要把图片缓存到内存,默认yes */
@property (nonatomic,assign) BOOL isNeedTempCache;

/** 多少KB以内，把图片缓存到内存，默认50KB */
@property (nonatomic,assign) NSInteger maxSizeForTempCache;

+(instancetype)sharedManager;

/**
 传本地图片path或者网络urlStr
 */
- (void)getImageWith:(NSString *)urlStr completeBlock:(XBImageManagerCompleteBlock)completeBlock;

/** 清除内存中的缓存 */
- (void)clearTempCache;

/** 清除本地硬盘缓存 */
- (void)clearLocalData;

/**
    从本地取图片
    传本地图片path或者网络urlStr
 */
- (UIImage *)getImageFromLocalWithUrlStr:(NSString *)urlStr;

/** 清除图片*/
- (void)removeImagesForUrlOrPathArr:(NSArray *)urlStrOrPathArr;

/** 把已有的图片写到本地 */
- (void)addImageToLocal:(UIImage *)image forUrlStr:(NSString *)urlStr;

/** 本地是否存在图片 */
- (BOOL)existImageAtLocalForUrlStr:(NSString *)urlStr;

@end
