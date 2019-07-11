//
//  UIImageView+webImage.m
//  XBImageManager
//
//  Created by xxb on 2019/7/11.
//  Copyright © 2019 xxb. All rights reserved.
//

#import "UIImageView+webImage.h"
#import "XBImageManager.h"

@implementation UIImageView (webImage)

- (void)setImageWithUrlStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholderImage
{
    if (placeholderImage)
    {
        self.image = placeholderImage;
    }
    typeof(self) __weak weakSelf = self;
    [[XBImageManager sharedManager] getImageWith:urlStr completeBlock:^(UIImage *image) {
        weakSelf.image = image;
    }];
}

@end
