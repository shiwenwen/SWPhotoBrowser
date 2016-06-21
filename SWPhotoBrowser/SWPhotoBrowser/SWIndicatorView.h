//
//  SWIndicatorView.h
//  SWPhotoBrowser
//
//  Created by mac on 2016/6/18.
//  Copyright © 2016年 sww. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SWIndicatorViewMode ) {
    SWIndicatorViewModeLoopDiagram = 0, // 环型
    SWIndicatorViewModePieDiagram  = 1  // 饼型
};

@interface SWIndicatorView : UIView

/** 1.图片下载的进度 */
@property (nonatomic, assign)CGFloat progress;

/** 2.指示器的显示模式 */
@property (nonatomic, assign)SWIndicatorViewMode viewMode;

@end


