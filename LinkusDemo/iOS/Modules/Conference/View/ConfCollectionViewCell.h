//
//  ConfCollectionViewCell.h
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/3.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

typedef void(^ClickPicture)(Contact *contact);

@interface ConfCollectionViewCell : UICollectionViewCell

+ (instancetype)dequeueCellWithCollectionView:(UICollectionView *)collectionView
                                    indexPath:(NSIndexPath *)indexPath;

@property (nonatomic,strong) UIButton *iconButton;

@property (nonatomic,strong) UILabel *numberLabel;

@property (nonatomic,strong) Contact *contact;

@property (nonatomic,copy) ClickPicture clickPicture;

@end
