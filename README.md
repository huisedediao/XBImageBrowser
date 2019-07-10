# XBImageBrowser
图片浏览器，支持本地图片和网络图片（支持混搭，虽然没什么卵用）

</br>
### 效果图：

![image](https://github.com/huisedediao/XBImageBrowser/raw/master/showNew.gif)
<br/>
<br/>
### 特别说明：

如果需要转屏，必须满足以下两个条件</br>

1.imageBrowser是present出来的</br>

2.如果app不支持屏幕旋转，appDelegate必须实现下面这个方法：</br>

<pre>
-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    return UIInterfaceOrientationMaskAll;
}
</pre>
</br>

### 使用：

</br>
<pre>
    
    XBImageBrowser_smanos *browser=[XBImageBrowser_smanos new];
    
    //设置数据源数组，可以是网络的也可以是本地的
    browser.arr_imagePathOrUrlstr=[@[@"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png",[[NSBundle mainBundle] pathForResource:@"AW1C_product01.png" ofType:nil],[[NSBundle mainBundle] pathForResource:@"AW1C_product02.png" ofType:nil],[[NSBundle mainBundle] pathForResource:@"AW1C_product03.png" ofType:nil],[[NSBundle mainBundle] pathForResource:@"AW1C_product04.png" ofType:nil],[[NSBundle mainBundle] pathForResource:@"AW1C_settingwifi.png" ofType:nil]] mutableCopy];
    
    //进入时展示第几张（从0开始）
    browser.indexOfItem=1;
    
    [self presentViewController:browser animated:YES completion:nil];

</pre>
