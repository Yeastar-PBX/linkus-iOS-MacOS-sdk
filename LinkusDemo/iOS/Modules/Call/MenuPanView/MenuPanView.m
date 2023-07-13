//
//  MenuPanView.m
//  Linkus
//
//  Created by 杨桂福 on 2022/11/21.
//  Copyright © 2022 Yeastar Technology Co., Ltd. All rights reserved.
//

#import "MenuPanView.h"
#import "MenuPanViewCell.h"
#import <AVKit/AVKit.h>

@interface MenuPanView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,MenuPanViewCellDelegate,AudioRouteHandlerDelegate>

@property (nonatomic,assign) BOOL multiCall;

@property (nonatomic,assign) BOOL transfer;

@property (nonatomic,assign) BOOL waiting;

@property (nonatomic,strong) YLSSipCall *currentCall;

@property (nonatomic,strong) NSArray *dataArr;

@property (nonatomic,strong) PanHandler *panHandler;

@property (nonatomic,strong) AudioRouteHandler *audioHandler;

@property (nonatomic,strong) UIVisualEffectView *effectView;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIButton *dragButton;

@property (nonatomic,strong) UIView *dragView;

@property (nonatomic,strong) AVRoutePickerView *castView;

@end

@implementation MenuPanView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupControls];
    }
    return self;
}

- (void)setupControls {
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    self.effectView = effectView;
    [self addSubview:effectView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = MenuPanViewCellSpacing;
    flowLayout.minimumLineSpacing = MenuPanViewCellSpacing;
    flowLayout.sectionInset = UIEdgeInsetsMake(16.0f, 20.0f, 16.0f, 20.0f);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                collectionViewLayout:flowLayout];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.delaysContentTouches = NO;
    collectionView.scrollEnabled = NO;
    [self addSubview:collectionView];

    UIButton *dragButton = [[UIButton alloc] init];
    self.dragButton = dragButton;
    [self addSubview:dragButton];
    
    _panHandler = [[PanHandler alloc] initWithPresenView:self cornerView:collectionView dragIndicatorView:dragButton];
    _audioHandler = [[AudioRouteHandler alloc] init];
    _audioHandler.delegate = self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(16.0f, 0.0f, 0.0f, 0.0f));
    }];
    
    [self.effectView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f));
    }];
    
    [self.dragView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.width.mas_equalTo(32);
    }];
    
    [self.dragButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.width.mas_equalTo(32);
    }];
    
    [self addDragBorder];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MenuPanModel *model = self.dataArr[indexPath.row];
    [collectionView registerClass:MenuPanViewCell.class forCellWithReuseIdentifier:model.title];
    MenuPanViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:model.title forIndexPath:indexPath];
    cell.delegate = self;
    cell.model = model;
    if (cell.model.type == MenuPanViewTypeSpeaker) {
        if (self.audioHandler.bluetoothHeadsetConnected) {
            if (![cell.contentView.subviews containsObject:self.castView]) {
                [cell.contentView addSubview:self.castView];
            }
        }else{
            if ([cell.contentView.subviews containsObject:self.castView]) {
                [self.castView removeFromSuperview];
            }
        }
    }
    return cell;
}

#pragma mark- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(MenuPanViewCellWidth, MenuPanViewCellHeight);
    return size;
}

#pragma mark- MenuPanViewCellDelegate
- (void)menuPanViewCell:(MenuPanViewCell *)menuPanViewCell touch:(MenuPanViewType)type selected:(BOOL)selected {
    if (type == MenuPanViewTypeSpeaker) {
        if (!selected) {
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
            self.audioHandler.selected = YES;
        }else{
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
            self.audioHandler.selected = NO;
        }
        self.audioHandler.videoSpeaker = NO;
        [self reloadData];
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(menuPanView:touch:selected:)]) {
            [self.delegate menuPanView:self touch:type selected:selected];
        }
    }
}

#pragma mark- AudioRouteHandlerDelegate
- (void)audioRouteHandlerRefresh:(AudioRouteHandler *)handler {
    [self reloadData];
}

#pragma mark - 刷新
- (void)callReload:(YLSSipCall *)currentCall {
    self.currentCall = currentCall;
    [self reloadData];
}

#pragma mark - 页面设置
- (void)callNormal:(YLSSipCall *)currentCall waitingCall:(YLSSipCall *)waitingCall transferCall:(YLSSipCall *)transferCall {
    if (transferCall) {
        self.transfer = YES;
    }else{
        self.transfer = NO;
    }
    if (waitingCall) {
        self.waiting = YES;
    }else{
        self.waiting = NO;
    }
    self.currentCall = currentCall;
    [self reloadData];
}

#pragma mark - 多方通话页面设置
- (void)callMulti:(YLSSipCall *)currentCall {
    self.currentCall = currentCall;
    self.multiCall = YES;
    self.transfer = NO;
    [self reloadData];
}

- (void)reloadData {
    self.dataArr = nil;
    [self.collectionView reloadData];
}

#pragma mark- 页面配置
- (MenuPanModel *)holdModel {
    MenuPanModel *model = [[MenuPanModel alloc] init];
    model.type = MenuPanViewTypeHold;
    model.title = @"Hold";
    model.normalImageName = @"MenuPanView_Hold_Normal";
    model.selectedImageName = @"MenuPanView_Hold_Selected";
    model.disableImageName = @"MenuPanView_Hold_Disable";
    model.normalColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.13];
    model.selectedColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.93];
    model.selected = self.currentCall.onHold;
    model.enabled = self.currentCall.status == CallStatusBridge && !self.transfer;
    model.fontColor = model.enabled ? [UIColor colorWithRGB:0xFFFFFF alpha:0.87] : [UIColor colorWithRGB:0xFFFFFF alpha:0.6];
    return model;
}

- (MenuPanModel *)muteModel {
    MenuPanModel *model = [[MenuPanModel alloc] init];
    model.type = MenuPanViewTypeMute;
    model.title = @"Mute";
    model.normalImageName = @"MenuPanView_Mute_Normal";
    model.selectedImageName = @"MenuPanView_Mute_Selected";
    model.disableImageName = @"MenuPanView_Mute_Disable";
    model.normalColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.13];
    model.selectedColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.93];
    model.selected = self.currentCall.mute;
    model.enabled = self.currentCall.status == CallStatusBridge;
    model.fontColor = model.enabled ? [UIColor colorWithRGB:0xFFFFFF alpha:0.87] : [UIColor colorWithRGB:0xFFFFFF alpha:0.6];
    return model;
}

- (MenuPanModel *)speakerModel {
    MenuPanModel *model = [[MenuPanModel alloc] init];
    model.type = MenuPanViewTypeSpeaker;
    model.title = @"Speaker";
    model.fontColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.87];
    model.normalImageName = @"MenuPanView_Speaker_Normal";
    model.selectedImageName = @"MenuPanView_Speaker_Selected";
    model.disableImageName = @"MenuPanView_Speaker_Disable";
    model.normalColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.13];
    model.selectedColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.93];
    if (self.audioHandler.bluetoothHeadsetConnected) {
        model.selected = YES;
        if (self.audioHandler.type == AudioRouteTypeSpeaker) {
            model.selectedImageName = @"MenuPanView_Speaker_Selected";
            model.title = @"Speaker";
        }else if (self.audioHandler.type == AudioRouteTypeBluetooth) {
            model.selectedImageName = @"MenuPanView_Bluetooth_Selected";
            model.title = @"Bluetooth headset";
        }else if (self.audioHandler.type == AudioRouteTypeHeadset) {
            model.selectedImageName = @"MenuPanView_HeadSet_Selected";
            model.title = @"Wired headset";
        }else if (self.audioHandler.type == AudioRouteTypeMic) {
            model.selectedImageName = @"MenuPanView_Mic_Selected";
            model.title = @"Handset earpiece";
        }
    }else{
        model.selected = self.audioHandler.selected;
    }
    model.enabled = YES;
    return model;
}

- (MenuPanModel *)hangupModel {
    MenuPanModel *model = [[MenuPanModel alloc] init];
    model.type = MenuPanViewTypeHangup;
    model.fontColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.87];
    if (self.transfer) {
        model.normalImageName = @"MenuPanView_Hangup_Cancel";
        model.selectedImageName = @"MenuPanView_Hangup_Cancel";
        model.disableImageName = @"MenuPanView_Hangup_Cancel";
        model.title = @"Cancel";
    }else{
        model.normalImageName = @"MenuPanView_Hangup";
        model.selectedImageName = @"MenuPanView_Hangup";
        model.disableImageName =  @"MenuPanView_Hangup";
        model.title = @"End Call";
    }
    model.normalColor = [UIColor colorWithRGB:0xF63B3B];
    model.selectedColor = [UIColor colorWithRGB:0xCF272D];
    model.selected = NO;
    model.enabled = YES;
    return model;
}

- (MenuPanModel *)addModel {
    MenuPanModel *model = [[MenuPanModel alloc] init];
    model.type = MenuPanViewTypeAddCall;
    model.title = @"Add Participant";
    model.normalImageName = @"MenuPanView_Add_Normal";
    model.selectedImageName = @"MenuPanView_Add_Selected";
    model.disableImageName = @"MenuPanView_Add_Disable";
    model.normalColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.13];
    model.selectedColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.93];
    model.selected = NO;
    if (self.currentCall.status == CallStatusBridge && !self.transfer && !self.waiting) {
        if (self.multiCall) {
            if ([YLSSDK sharedYLSSDK].callManager.multiSipCalls.count < 4 && [[YLSSDK sharedYLSSDK].callManager.currentSipCalls.lastObject.multiCallStatus isEqualToString:MultiCallAnswer]) {
                model.enabled = YES;
            }else{
                model.enabled = NO;
            }
        }else{
            model.enabled = YES;
        }
    }else{
        model.enabled = NO;
    }
    model.fontColor = model.enabled ? [UIColor colorWithRGB:0xFFFFFF alpha:0.87] : [UIColor colorWithRGB:0xFFFFFF alpha:0.6];
    return model;
}

- (MenuPanModel *)cameraModel {
    MenuPanModel *model = [[MenuPanModel alloc] init];
    model.type = MenuPanViewTypeCamera;
    model.title = @"Video";
    model.normalImageName = @"MenuPanView_Camera_Normal";
    model.selectedImageName = @"MenuPanView_Camera_Selected";
    model.disableImageName = @"MenuPanView_Camera_Disable";
    model.normalColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.13];
    model.selectedColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.93];
    model.enabled = NO;
    model.selected = NO;
    model.showLockView = !NO;
    model.fontColor = model.enabled ? [UIColor colorWithRGB:0xFFFFFF alpha:0.87] : [UIColor colorWithRGB:0xFFFFFF alpha:0.6];
    return model;
}

- (MenuPanModel *)keypadModel {
    MenuPanModel *model = [[MenuPanModel alloc] init];
    model.type = MenuPanViewTypeKeypad;
    model.title = @"Dialpad";
    model.normalImageName = @"MenuPanView_Dialpad_Normal";
    model.selectedImageName = @"MenuPanView_Dialpad_Selected";
    model.disableImageName = @"MenuPanView_Dialpad_Disable";
    model.normalColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.13];
    model.selectedColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.93];
    model.selected = NO;
    model.enabled = self.currentCall.status == CallStatusBridge;
    model.fontColor = model.enabled ? [UIColor colorWithRGB:0xFFFFFF alpha:0.87] : [UIColor colorWithRGB:0xFFFFFF alpha:0.6];
    return model;
}

- (MenuPanModel *)recordModel {
    MenuPanModel *model = [[MenuPanModel alloc] init];
    model.type = MenuPanViewTypeRecord;
    model.title = @"Record";
    model.normalImageName = @"MenuPanView_Record_Normal";
    model.selectedImageName = @"MenuPanView_Record_Selected";
    model.disableImageName = @"MenuPanView_Record_Disable";
    model.normalColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.13];
    model.selectedColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.93];
    if (self.currentCall.status == CallStatusBridge) {
        if (self.currentCall.callRecordConferenceType) {
            if (self.currentCall.callRecordType == CallRecordTypeRecording) {
                model.disableImageName = @"MenuPanView_Recording_Disable";
                model.selected = NO;
                model.enabled = NO;
            }else{
                model.selected = NO;
                model.enabled = NO;
            }
        }else{
            if (self.currentCall.callRecordType == CallRecordTypeStop) {
                if ([[YLSSDK sharedYLSSDK] callManager].adminRecord) {
                    model.selected = NO;
                    model.enabled = YES;
                }else{
                    model.selected = NO;
                    model.enabled = NO;
                }
            }else if (self.currentCall.callRecordType == CallRecordTypeRecording) {
                if ([[YLSSDK sharedYLSSDK] callManager].enableRecord) {
                    model.selected = YES;
                    model.enabled = YES;
                }else{
                    model.disableImageName = @"MenuPanView_Recording_Disable";
                    model.selected = NO;
                    model.enabled = NO;
                }
            }else if (self.currentCall.callRecordType == CallRecordTypePause) {
                if ([[YLSSDK sharedYLSSDK] callManager].enableRecord) {
                    model.selected = NO;
                    model.enabled = YES;
                }else{
                    model.selected = NO;
                    model.enabled = NO;
                }
            }
        }
    }else{
        model.selected = NO;
        model.enabled = NO;
    }
    model.fontColor = model.enabled ? [UIColor colorWithRGB:0xFFFFFF alpha:0.87] : [UIColor colorWithRGB:0xFFFFFF alpha:0.6];
    return model;
}

- (MenuPanModel *)attendedModel {
    MenuPanModel *model = [[MenuPanModel alloc] init];
    model.type = MenuPanViewTypeAttended;
    model.title = @"Attended";
    model.normalImageName = @"MenuPanView_Attended_Normald";
    model.selectedImageName = @"MenuPanView_Attended_Normald";
    model.disableImageName = @"MenuPanView_Attended_Disable";
    model.normalColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.13];
    if (self.transfer) {
        model.selectedColor = [UIColor colorWithRGB:0x20C161];
        model.selected = YES;
        model.enabled = YES;
    }else{
        model.selectedColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.93];
        model.selected = NO;
        model.enabled = self.currentCall.status == CallStatusBridge;
    }
    model.fontColor = model.enabled ? [UIColor colorWithRGB:0xFFFFFF alpha:0.87] : [UIColor colorWithRGB:0xFFFFFF alpha:0.6];
    return model;
}

- (MenuPanModel *)blindModel {
    MenuPanModel *model = [[MenuPanModel alloc] init];
    model.type = MenuPanViewTypeBlind;
    model.title = @"Blind";
    model.normalImageName = @"MenuPanView_Blind_Normal";
    model.selectedImageName = @"MenuPanView_Blind_Selected";
    model.disableImageName = @"MenuPanView_Blind_Disable";
    model.normalColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.13];
    model.selectedColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.93];
    model.selected = NO;
    model.enabled = self.currentCall.status == CallStatusBridge && !self.transfer;
    model.fontColor = model.enabled ? [UIColor colorWithRGB:0xFFFFFF alpha:0.87] : [UIColor colorWithRGB:0xFFFFFF alpha:0.6];
    return model;
}

- (MenuPanModel *)callFlipModel {
    MenuPanModel *model = [[MenuPanModel alloc] init];
    model.type = MenuPanViewTypeCallFlip;
    model.title = @"Call Flip";
    model.normalImageName = @"MenuPanView_Flip_Normal";
    model.selectedImageName = @"MenuPanView_Flip_Selected";
    model.disableImageName = @"MenuPanView_Flip_Disable";
    model.normalColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.13];
    model.selectedColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.93];
    model.selected = NO;
    model.enabled = NO;
    model.fontColor = model.enabled ? [UIColor colorWithRGB:0xFFFFFF alpha:0.87] : [UIColor colorWithRGB:0xFFFFFF alpha:0.6];
    return model;
}

- (NSArray<MenuPanModel *> *)dataArr {
    if (!_dataArr) {
        if (self.transfer) {
            _dataArr = @[[self muteModel], [self speakerModel], [self attendedModel], [self hangupModel], [self addModel], [self cameraModel], [self keypadModel], [self recordModel], [self holdModel], [self blindModel], [self callFlipModel]];
        }else{
            _dataArr = @[[self holdModel], [self muteModel], [self speakerModel], [self hangupModel], [self addModel], [self cameraModel], [self keypadModel], [self recordModel], [self attendedModel], [self blindModel], [self callFlipModel]];
        }
    }
    return _dataArr;
}

#pragma mark - private
- (void)addDragBorder {
    self.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.38];
    CGFloat cornerRadius = self.collectionView.layer.cornerRadius;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    //上边
    [path moveToPoint:CGPointMake(cornerRadius, 16)];
    [path addLineToPoint:CGPointMake(self.width/2 - 16, 16)];
    [path addArcWithCenter:CGPointMake(self.width/2, 16) radius:16 startAngle:M_PI endAngle:0 clockwise:YES];
    [path addLineToPoint:CGPointMake(self.width - cornerRadius, 16)];
    //右上角
    [path addArcWithCenter:CGPointMake(self.width - cornerRadius, 16+cornerRadius) radius:cornerRadius startAngle:-M_PI_2 endAngle:0 clockwise:YES];
    //右边
    [path addLineToPoint:CGPointMake(self.width, self.height-cornerRadius)];
    //右下角
    [path addArcWithCenter:CGPointMake(self.width-cornerRadius, self.height-cornerRadius) radius:cornerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    //下边
    [path addLineToPoint:CGPointMake(cornerRadius, self.height)];
    //左下角
    [path addArcWithCenter:CGPointMake(cornerRadius, self.height-cornerRadius) radius:cornerRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    //左边
    [path addLineToPoint:CGPointMake(0, 16+cornerRadius)];
    //左上角
    [path addArcWithCenter:CGPointMake(cornerRadius, 16+cornerRadius) radius:cornerRadius startAngle:M_PI endAngle:M_PI_2*3 clockwise:YES];
    CAShapeLayer *mask = [CAShapeLayer new];
    mask.frame = CGRectMake(0, 0, self.width, self.height);
    mask.path = [path CGPath];
    self.layer.mask = mask;
}

- (AVRoutePickerView *)castView {
    if(!_castView){
        _castView = [[AVRoutePickerView alloc] initWithFrame:CGRectMake(0, 0, MenuPanViewCellWidth, MenuPanViewCellWidth)];
        for (UIView *view in _castView.subviews) {
             if ([view isKindOfClass:[UIButton class]]) {
                 UIButton *button = (UIButton *)view;
                 [button removeFromSuperview];
              }
        }
    }
    return _castView;
}

@end
