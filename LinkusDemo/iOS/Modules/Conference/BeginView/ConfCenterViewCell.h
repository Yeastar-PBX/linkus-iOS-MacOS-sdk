//
//  ConfCenterViewCell.h
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/5.
//

#import <UIKit/UIKit.h>

typedef void(^ClickPicture)(YLSConfMember *member);

@interface ConfCenterViewCell : UICollectionViewCell

+ (instancetype)dequeueCellWithCollectionView:(UICollectionView *)collectionView
                                    indexPath:(NSIndexPath *)indexPath;

@property (nonatomic,strong) UIButton *iconButton;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) YLSConfMember *member;

@property (nonatomic,strong) ClickPicture clickPicture;

@property (nonatomic,strong) UIImageView *stateView;

@end
