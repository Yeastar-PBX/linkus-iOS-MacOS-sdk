//
//  LocalPathConfig.h
//  Linkus
//

#ifndef LocalPathConfig_h
#define LocalPathConfig_h

/************************************基础路径******************************************/
#define HomePath     NSHomeDirectory()

#define DocumentPath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define LibraryPath   [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define CachePath  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define TmpPath  NSTemporaryDirectory()



/************************************文件路径******************************************/

#define LogsFilePath                [NSString stringWithFormat:@"%@/Logs",DocumentPath]
#define LogsCompressFilePath        [NSString stringWithFormat:@"%@/Logs",TmpPath]
#define PJSIPLogFilePath            [NSString stringWithFormat:@"%@/pjsip.log",LogsFilePath]
#define LinkusSDKDBPath             [DocumentPath stringByAppendingPathComponent:@"linkus_sdk.db"]

//UDT、PJSip文件存放路径
#define InnerSDKPath                [NSString stringWithFormat:@"%@/InnerSDK",DocumentPath]

//头像下载地址
#define HeadPicturePath             [NSString stringWithFormat:@"%@/Avatar",DocumentPath]

#define VoiceMailPath               [DocumentPath stringByAppendingPathComponent:@"VoiceMail"]//语音文件存放路径
#define VoiceMailDownloadListPath   [VoiceMailPath stringByAppendingPathComponent:@"VoiceMailDownloadList.plist"]//语音文件列表存放路径

#define RecordingsPath              [DocumentPath stringByAppendingPathComponent:@"Recordings"]//录音文件存放路径
#define RecordingsDownloadListPath  [RecordingsPath stringByAppendingPathComponent:@"RecordingsDownloadList.plist"] //录音文件列表存放路径

#endif /* LocalPathConfig_h */
