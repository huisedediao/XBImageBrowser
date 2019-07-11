//
//  UIImageView+webImage.h
//  XBImageManager
//
//  Created by xxb on 2019/7/11.
//  Copyright © 2019 xxb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (webImage)

- (void)setImageWithUrlStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholderImage;

@end

NS_ASSUME_NONNULL_END
