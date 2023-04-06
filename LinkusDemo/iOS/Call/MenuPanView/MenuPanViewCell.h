//
//  MenuPanViewCell.h
//  Linkus
//
//  Created by 杨桂福 on 2022/11/22.
//  Copyright © 2022 Yeastar Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuPanView.h"
#import "MenuPanModel.h"

@class MenuPanViewCell;

@protocol MenuPanViewCellDelegate <NSObject>

@optional

- (void)menuPanViewCell:(MenuPanViewCell *)menuPanViewCell touch:(MenuPanViewType)type selected:(BOOL)selected;

@end

@interface MenuPanViewCell : UICollectionViewCell

@property (nonatomic,weak) id<MenuPanViewCellDelegate> delegate;

@property (nonatomic,strong) MenuPanModel *model;


@end
