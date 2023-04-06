//
//  MenuPanView.h
//  Linkus
//
//  Created by 杨桂福 on 2022/11/21.
//  Copyright © 2022 Yeastar Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuPanModel.h"
#import "AudioRouteHandler.h"
#import "PanHandler.h"

@class MenuPanView;

@protocol MenuPanViewDelegate <NSObject>

@optional

- (void)menuPanView:(MenuPanView *)menuPanView touch:(MenuPanViewType)type selected:(BOOL)selected;

@end


@interface MenuPanView : UIView

@property (nonatomic,weak) id<MenuPanViewDelegate> delegate;

- (void)callReload:(YLSSipCall *)currentCall;

- (void)callNormal:(YLSSipCall *)currentCall waitingCall:(YLSSipCall *)waitingCall transferCall:(YLSSipCall *)transferCall;

- (void)reloadData;

@end
