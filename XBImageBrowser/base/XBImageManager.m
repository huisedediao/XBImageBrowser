//
//  XBImageManager.m
//  XBImageBrowser_CollectionView
//
//  Created by xxb on 2017/1/14.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import "XBImageManager.h"
#import "XBImageBrowserHeader.h"


@interface XBImageManager ()

/**缓存数组，缓存本次启动app用到的图片到内存提高效率*/
@property (nonatomic,strong) NSMutableDictionary *dicM_tempImage;

/**存储url（key）和图片本地路径Path的对应关系*/
@property (nonatomic,strong) NSMutableDictionary *dicM_pathForUrl;

/**记录缓存图片的key*/
@property (nonatomic,strong) NSString *tempImgKey;

@property (nonatomic,copy) XBImageManagerCompleteBlock completeBlock;

@end

@implementation XBImageManager


#pragma mark - 生命周期

+(instancetype)sharedManager
{
    return [self new];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _dicM_pathForUrl=[NSKeyedUnarchiver unarchiveObjectWithFile:KdicM_pathForUrlStorePath];
        });
    }
    return self;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static XBImageManager *manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[super allocWithZone:zone];
    });
    return manager;
}



#pragma mark - 实例方法
-(void)getImageWith:(NSString *)urlStr
{
    dispatch_async(dispatch_queue_create("", NULL), ^{
        @synchronized (self)
        {
            UIImage *result = [self getImageFromLocalWithUrlStr:urlStr];
            if (result)
            {
                [self postNofiWith:urlStr image:result];
                return;
            }
            
            //从url请求图片
            [self getImageWithUrlstr:urlStr];
        }
    });
}

/**
 传本地图片path或者网络urlStr
 */
-(void)getImageWith:(NSString *)urlStr completeBlock:(XBImageManagerCompleteBlock)completeBlock
{
    self.completeBlock = completeBlock;
    dispatch_async(dispatch_queue_create("", NULL), ^{
        @synchronized (self)
        {
            UIImage *result = [self getImageFromLocalWithUrlStr:urlStr];
            if (result)
            {
                [self callCompleteBlockWithImage:result];
                return;
            }
            
            //从url请求图片
            [self getImageWithUrlstr:urlStr];
        }
    });
}

- (UIImage *)getImageFromLocalWithUrlStr:(NSString *)urlStr
{
    self.tempImgKey = urlStr;
    UIImage *result = nil;
    //从本地缓存字典中查找是否有改urlStr对应的图片
    result=self.dicM_tempImage[urlStr];
    if (result)
    {
        return result;
    }
    
    //假设为本地文件的path，判断urlStr本地是否有该文件
    result=[self getImageWithlocalPath:urlStr];
    if (result)
    {
        return result;
    }
    
    //判断dicM_pathForUrl对应的path的文件是否存在
    NSString *imageName=self.dicM_pathForUrl[urlStr];
    if (imageName) {
        NSString *path=[NSString stringWithFormat:@"%@/%@",KdownloadImgStoreFullPath,imageName];
        result=[self getImageWithlocalPath:path];
        if (result)
        {
            return result;
        }
    }
    return result;
}
-(UIImage *)getImageWithlocalPath:(NSString *)path
{
    UIImage *image=nil;
    NSData *imageData=UIImageJPEGRepresentation([UIImage imageWithData:[NSData dataWithContentsOfFile:path]], kImageQuality);
    if (imageData) {
        NSLog(@"图片大小%ldKB",imageData.length / 1024);
        image=[UIImage imageWithData:imageData];
        [self addImageToCache:image forUrlStr:self.tempImgKey];
    }
    
    return image;
}
-(void)getImageWithUrlstr:(NSString *)urlStr
{
    NSData *imgDate=UIImageJPEGRepresentation([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]], kImageQuality);
    UIImage *image=[UIImage imageWithData:imgDate];
    [self addImageToCache:image forUrlStr:urlStr];
    
    [self writeImageData:imgDate forUrlStr:urlStr];
    
    [self callCompleteBlockWithImage:image];
    [self postNofiWith:urlStr image:image];
}
-(void)removeImagesFromTempDictWith:(NSArray *)arr_urlStrOrPath
{
    for (NSString *str in arr_urlStrOrPath)
    {
        [self.dicM_tempImage removeObjectForKey:str];
    }
}
/** 把已有的图片添加到缓存 */
- (void)addImageToCache:(UIImage *)image forUrlStr:(NSString *)urlStr
{
    if (image)
    {
        [self.dicM_tempImage setObject:image forKey:urlStr];
    }
}
/** 把已有的图片写到本地 */
-(void)addImageToLocal:(UIImage *)image forUrlStr:(NSString *)urlStr
{
    if (image)
    {
        NSData *imgDate=UIImageJPEGRepresentation(image, kImageQuality);
        [self writeImageData:imgDate forUrlStr:urlStr];
    }
}
/* 本地是否存在图片 */
- (BOOL)existImageAtLocalForUrlStr:(NSString *)urlStr
{
    UIImage *image = [self getImageFromLocalWithUrlStr:urlStr];
    if (image)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)postNofiWith:(NSString *)urlStr image:(UIImage *)image
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotice_imageFinishDownload object:@{kUrlStrKey:urlStr,kImageKey:image}];
    });
}
- (void)callCompleteBlockWithImage:(UIImage *)image
{
    if (self.completeBlock)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.completeBlock(image);
        });
    }
}

- (void)writeImageData:(NSData *)imgDate forUrlStr:(NSString *)urlStr
{
    //如果存储图片的文件夹不存在则创建
    if([[NSFileManager defaultManager] fileExistsAtPath:KdownloadImgStoreFullPath] == NO)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:KdownloadImgStoreFullPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //保存图片到某个path、保存url和path的映射到dicM_pathForUrl
    //以时间戳命名
    NSString *imageName=[NSString stringWithFormat:@"%f",[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]];
    //避免同名
    if ([imageName isEqualToString:self.dicM_pathForUrl[urlStr]])
    {
        imageName=[NSString stringWithFormat:@"%f",[imageName doubleValue]+1];
    }
    
    NSString *savePath=[NSString stringWithFormat:@"%@/%@",KdownloadImgStoreFullPath,imageName];
    [imgDate writeToFile:savePath atomically:YES];
    [self.dicM_pathForUrl setObject:imageName forKey:urlStr];
    [self saveData];
}

-(BOOL)saveData
{
    return [NSKeyedArchiver archiveRootObject:self.dicM_pathForUrl toFile:KdicM_pathForUrlStorePath];
}



#pragma mark - 懒加载
-(NSMutableDictionary *)dicM_tempImage
{
    if (_dicM_tempImage==nil)
    {
        _dicM_tempImage=[NSMutableDictionary new];
    }
    return _dicM_tempImage;
}
-(NSMutableDictionary *)dicM_pathForUrl
{
    if (_dicM_pathForUrl==nil)
    {
        _dicM_pathForUrl=[NSMutableDictionary new];
    }
    return _dicM_pathForUrl;
}
@end
