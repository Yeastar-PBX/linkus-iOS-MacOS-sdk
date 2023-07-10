//
//  ConfBottomView.m
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/5.
//

#import "ConfBottomView.h"
#import "AudioRouteHandler.h"
#import <AVKit/AVKit.h>

@interface ConfBottomView () <AVRoutePickerViewDelegate,AudioRouteHandlerDelegate>

@property (nonatomic,strong) UIButton *speakerButton;

@property (nonatomic,strong) UIButton *exitButton;

@property (nonatomic,strong) AVRoutePickerView *castView;

@property (nonatomic,strong) AudioRouteHandler *audioHandler;

@end

@implementation ConfBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupControls];
    }
    return self;
}

- (void)setupControls {
    UIButton *exitButton = [[UIButton alloc] init];
    self.exitButton = exitButton;
    exitButton.backgroundColor = [UIColor colorWithRGB:0xD23E37];
    exitButton.layer.cornerRadius  = 4;
    exitButton.layer.masksToBounds = YES;
    [exitButton addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
    [exitButton setTitle:@"Exit" forState:UIControlStateNormal];
    [exitButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self addSubview:exitButton];
    
    UIButton *speakerButton=[[UIButton alloc] init];
    self.speakerButton = speakerButton;
    [speakerButton addTarget:self action:@selector(speakerAction:) forControlEvents:UIControlEventTouchUpInside];
    [speakerButton setImage:[UIImage imageNamed:@"BottomView_Speaker_Normal"] forState:UIControlStateNormal];
    [speakerButton setImage:[UIImage imageNamed:@"BottomView_Speaker_Select"] forState:UIControlStateSelected];
    [self addSubview:speakerButton];
    
    UIButton *muteButton = [[UIButton alloc] init];
    self.muteButton = muteButton;
    [muteButton addTarget:self action:@selector(muteAction:) forControlEvents:UIControlEventTouchUpInside];
    [muteButton setImage:[UIImage imageNamed:@"BottomView_Mute_Normal"] forState:UIControlStateNormal];
    [muteButton setImage:[UIImage imageNamed:@"BottomView_Mute_Select"] forState:UIControlStateSelected];
    [self addSubview:muteButton];
    
    _audioHandler = [[AudioRouteHandler alloc] init];
    _audioHandler.delegate = self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.exitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.width.mas_equalTo(200);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.speakerButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.left.mas_equalTo(self.exitButton.mas_right).offset(20);
        make.centerY.mas_equalTo(self.exitButton.mas_centerY);
    }];
        
    [self.muteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.right.mas_equalTo(self.exitButton.mas_left).offset(-20);
        make.centerY.mas_equalTo(self.exitButton.mas_centerY);
    }];
}

- (void)exitAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(conferenceHangup)]) {
        [self.delegate conferenceHangup];
    }
}

- (void)speakerAction:(UIButton *)button {
    self.speakerButton.selected = !button.selected;
    if (button.selected) {
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    }else{
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    }
}

- (void)muteAction:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(conferenceMute:)]) {
        [self.delegate conferenceMute:button.selected];
    }
}

#pragma mark- AudioRouteHandlerDelegate
- (void)audioRouteHandlerRefresh:(AudioRouteHandler *)handler {
    if (self.audioHandler.bluetoothHeadsetConnected) {
        [self.speakerButton addSubview:self.castView];
        self.speakerButton.selected = YES;
        if (self.audioHandler.type == AudioRouteTypeSpeaker) {
            [self.speakerButton setImage:[UIImage imageNamed:@"BottomView_Speaker_Select"] forState:UIControlStateSelected];
        }else if (self.audioHandler.type == AudioRouteTypeBluetooth) {
            [self.speakerButton setImage:[UIImage imageNamed:@"BottomView_Bluetooth"] forState:UIControlStateSelected];
        }else if (self.audioHandler.type == AudioRouteTypeHeadset) {
            [self.speakerButton setImage:[UIImage imageNamed:@"BottomView_Headset"] forState:UIControlStateSelected];
        }else if (self.audioHandler.type == AudioRouteTypeMic) {
            [self.speakerButton setImage:[UIImage imageNamed:@"BottomView_Receiver"] forState:UIControlStateSelected];
        }
        [self.speakerButton setImage:[UIImage imageNamed:@"BottomView_Speaker_Normal"] forState:UIControlStateNormal];
    }else{
        [self.castView removeFromSuperview];
        [self.speakerButton setImage:[UIImage imageNamed:@"BottomView_Speaker_Normal"] forState:UIControlStateNormal];
        [self.speakerButton setImage:[UIImage imageNamed:@"BottomView_Speaker_Select"] forState:UIControlStateSelected];
    }
}

- (AVRoutePickerView *)castView {
    if(!_castView){
        _castView = [[AVRoutePickerView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
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
