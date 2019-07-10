特别说明：


如果需要转屏，必须满足以下两个条件

1.imageBrowser是present出来的

2.appDelegate实现了下面这个方法：

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    return UIInterfaceOrientationMaskAll;
}
