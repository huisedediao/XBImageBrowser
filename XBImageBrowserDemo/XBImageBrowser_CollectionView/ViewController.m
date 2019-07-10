//
//  ViewController.m
//  XBImageBrowser_CollectionView
//
//  Created by xxb on 2017/1/11.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import "ViewController.h"
#import "XBImageBrowserWithToolBar.h"

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)show:(id)sender {
    
    XBImageBrowserWithToolBar *browser=[XBImageBrowserWithToolBar new];
//    browser.arrM_image = [@[[UIImage imageNamed:@"AW1C_product01"],[UIImage imageNamed:@"AW1C_product02"],[UIImage imageNamed:@"AW1C_product03"],[UIImage imageNamed:@"AW1C_product04"]] mutableCopy];
    browser.arrM_imagePathOrUrlstr=[@[@"http://img5q.duitang.com/uploads/item/201502/23/20150223111936_XH3m8.jpeg",@"http://cdn.duitang.com/uploads/item/201507/26/20150726235001_3iH4x.thumb.700_0.jpeg",@"http://img4.duitang.com/uploads/item/201308/22/20130822233017_zPwVZ.thumb.700_0.jpeg",@"http://img4q.duitang.com/uploads/item/201505/28/20150528074128_SREUh.thumb.700_0.jpeg",@"http://img5q.duitang.com/uploads/item/201504/08/20150408H5738_MxjmX.jpeg",@"http://img4.duitang.com/uploads/item/201410/05/20141005204955_imwRj.png",@"http://imgsrc.baidu.com/forum/w%3D580/sign=acd2738992529822053339cbe7cb7b3b/5343fbf2b21193135a8fb0fe67380cd790238db4.jpg"] mutableCopy];
    browser.indexOfItem=1;

    /*
    browser.createLoadingViewBlock = ^UIView *{
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 0, 100, 100);
        view.backgroundColor = [UIColor redColor];
        return view;
    };
     */
    [self presentViewController:browser animated:YES completion:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",NSHomeDirectory());

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation

{
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
