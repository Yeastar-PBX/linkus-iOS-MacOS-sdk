//
//  YLSSDKConfig.h
//  linkus-vivo
//
//  Created by 杨桂福 on 2023/4/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLSSDKConfig : NSObject

/**
 *  配置项
 */
+ (instancetype)sharedConfig;

/// Localized name of the provider
@property (nonatomic,copy,nullable) NSString *localizedName;

/// Image should be a square with side length of 40 points
@property (nonatomic,copy,nullable) NSData *iconTemplateImageData;

/// 日志文件路径,外层需创建文件夹
@property (nonatomic,copy) NSString *logPath;

/// 数据文件路径,外层需创建文件夹
@property (nonatomic,copy) NSString *dataPath;

/// 来电声音频文件
@property (nonatomic,copy) NSString *comeAudioFileName API_AVAILABLE(macos(10.13));

/// 挂断声音频文件
@property (nonatomic,copy) NSString *hangupAudioFileName;

/// 呼叫等待声音频文件
@property (nonatomic,copy) NSString *alertAudioFileName;

/// 编码
@property (nonatomic,copy) NSString *sipCode;

@end

NS_ASSUME_NONNULL_END
