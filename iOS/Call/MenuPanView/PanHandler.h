//
//  PanHandler.h
//  Linkus
//
//  Created by 杨桂福 on 2022/11/21.
//  Copyright © 2022 Yeastar Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MenuPanViewHeightMin  86.f * ScreenScale + 48
#define MenuPanViewHeightMax  306 * ScreenScale + 48
#define MenuPanViewRadiusMax  (MenuPanViewHeightMin - 16)/2
#define MenuPanViewRadiusMin  40.f * ScreenScale

#define MenuPanViewCellWidth  56.f * ScreenScale
#define MenuPanViewCellHeight 86.f * ScreenScale

#define MenuPanViewCellSpacing 24.0f * ScreenScale

@interface PanHandler : NSObject

- (instancetype)initWithPresenView:(UIView *)presenView
                        cornerView:(UIView *)cornerView
                 dragIndicatorView:(UIButton *)dragButton;

@end
