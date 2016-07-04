# SWPhotoBrowser
仿微博，朋友圈的图片浏览，功能丰富
==========================
适用于UIcollectionView,UIScrollView以及普通视图中的图片浏览，支持网络以及本地图片的加载，暂不支持视频。
>>>点击的图片需要为UIbutton或者UIImageView
>>>>在图片的点击方法中 使用即可（UIcollectionView可以在didSelected代理中使用）
    SWBrowserPhotoController *bro = [[SWBrowserPhotoController alloc]initWithPhotos:self.arrayImageUrl sourceImagesContainerView:self.scrollView];
    //sourceImagesContainerView是当前图片视图所在的源控制器 例如UIcollectionView，view
    
    bro.showIndexTitle = YES;//是否显示几分之几张得标题
    bro.showPageControl = YES;//底部是否显示PageControl
    bro.currentIndex = (int)button.tag; //当前点击的的图片的index ，即点击的是第几张图片 
    bro.allowSaveImage = YES; //是否允许保存图片 长按保存
    
    bro.showDelete = YES; //是否显示删除按钮 设置代理bro.delegate（SWPhotoBrowserDelegate） 可在删除回调-(void)photoBrowser:(SWBrowserPhotoController *)photoBrowser deleteAtIndex:(NSInteger)index中进行相应处理
    bro.FillTheSamllPic = YES;//图片尺寸小于屏幕尺寸时，YES进行屏幕大小填充 NO则是原始尺寸显示
    bro.maxZoomScale = 2;//最大放大倍数 不设置则默认最大为2倍
    [bro show];//显示
    
