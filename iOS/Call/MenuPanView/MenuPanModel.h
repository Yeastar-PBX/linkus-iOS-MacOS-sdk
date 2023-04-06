//
//  MenuPanModel.h
//  Linkus
//
//  Created by 杨桂福 on 2022/11/25.
//  Copyright © 2022 Yeastar Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MenuPanViewType) {
    MenuPanViewTypeHold        = 0,
    MenuPanViewTypeMute        = 1,
    MenuPanViewTypeSpeaker     = 2,
    MenuPanViewTypeHangup      = 3,
    MenuPanViewTypeCancelFlip  = 4,
    MenuPanViewTypeAddCall     = 5,
    MenuPanViewTypeCamera      = 6,
    MenuPanViewTypeKeypad      = 7,
    MenuPanViewTypeRecord      = 8,
    MenuPanViewTypeAttended    = 9,
    MenuPanViewTypeBlind       = 10,
    MenuPanViewTypeCallFlip    = 11,
};

@interface MenuPanModel : NSObject

@property (nonatomic,assign) MenuPanViewType type;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) UIColor *fontColor;

@property (nonatomic,copy) NSString *normalImageName;

@property (nonatomic,copy) NSString *selectedImageName;

@property (nonatomic,copy) NSString *disableImageName;

@property (nonatomic,strong) UIColor *normalColor;

@property (nonatomic,strong) UIColor *selectedColor;

@property (nonatomic,assign) BOOL selected;

@property (nonatomic,assign) BOOL enabled;

@property (nonatomic,assign) BOOL showLockView;

@end
