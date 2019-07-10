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

+(instancetype)sharedManager;

/**
 传本地图片path或者网络urlStr
 如果本地有图片，直接返回图片
 本地无图片，返回nil，并且请求网络图片，完成后发送下载完成通知
 */
-(void)getImageWith:(NSString *)urlStr;

/**
 传本地图片path或者网络urlStr
 */
-(void)getImageWith:(NSString *)urlStr completeBlock:(XBImageManagerCompleteBlock)completeBlock;

/*
    从本地取图片
    传本地图片path或者网络urlStr
 */
-(UIImage *)getImageFromLocalWithUrlStr:(NSString *)urlStr;

/**imageBrowser释放掉的时候，清除缓存字典中的图片（节约内存）*/
-(void)removeImagesFromTempDictWith:(NSArray *)arr_urlStrOrPath;

/** 把已有的图片写到本地 */
-(void)addImageToLocal:(UIImage *)image forUrlStr:(NSString *)urlStr;

/* 本地是否存在图片 */
- (BOOL)existImageAtLocalForUrlStr:(NSString *)urlStr;

@end
