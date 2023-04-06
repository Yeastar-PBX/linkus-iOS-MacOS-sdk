//
//  LoginTypefCode.h
//  Linkus
//
//  Created by ygf on 2018/9/16.
//  Copyright © 2018年 Yeastar Technology Co., Ltd. All rights reserved.
//

/**
 *  被踢下线的原因
 */
typedef NS_ENUM(NSInteger, KickReason) {
    KickReasonByDefault                  = 0,
    KickReasonByTokenInvalid             = 1,
    KickReasonByACCOUNTILLEGAL           = 2,
    KickReasonByPasswordChange           = 3,
    KickReasonByNOPERMISSIONS            = 4,
    KickReasonByPasswordLock             = 5,
    KickReasonByOtherUserLogin           = 6,
    KickReasonByLoginModeChange          = 7,
    KickReasonByLCSServerDisabled        = 8,
    KickReasonByLCSServerExpires         = 9,
    KickReasonByLCSServerTimeException   = 10,
    KickReasonByDeleteExtension          = 11,
    KickReasonByLoginEmailChange         = 12,
    KickReasonByRASServerDisabled        = 13,
    KickReasonByRASServerExpires         = 14,
    KickReasonByAllowedCountryIp         = 15,
    KickReasonByDeviceInactive           = 16,
};

/**
 *  登录步骤
 */
typedef NS_ENUM(NSInteger, LoginStep) {
    LoginStepLogining,
    LoginStepLoginSuccess,
    LoginStepSyncing,
    LoginStepSyncOK,
    LoginStepLoginFail,
};

/**
 *  退出登录
 */
typedef NS_ENUM(NSInteger, logoutError) {
    logoutErrorFail                  = 1,
    logoutErrorUnreachable           = 2,
    logoutErrorNoNetwork             = 3,
};

/**
 *  客户端类型
 */
typedef NS_ENUM(NSInteger, LoginClientType) {
    LoginClientTypeNONE        = 0,
    LoginClientTypeAOS         = 1 << 0,
    LoginClientTypeiOS         = 1 << 1,
    LoginClientTypePC          = 1 << 2,
    LoginClientTypemacOS       = 1 << 3,
    LoginClientTypeWeb         = 1 << 4,
};

/**
 *  忘记密码
 */
typedef NS_ENUM(NSInteger, ForgetPasswordError) {
    ForgetPasswordErrorUnreachable            = 1,
    ForgetPasswordErrorUserNameOrEmail        = 2,
    ForgetPasswordErrorLock                   = 3,
    ForgetPasswordErrorEmail                  = 4,
    ForgetPasswordErrorVerification           = 5,
    ForgetPasswordErrorVerificationExpire     = 6,
    ForgetPasswordErrorRule                   = 7,
    ForgetPasswordErrorTheSame                = 8,
    ForgetPasswordErrorAccessRAS              = 9,
};

#define APPSDK_ERROR_CODE_SERVER_DISCONNECT                             1
#define APPSDK_ERROR_CODE_GEN_REQ_FAIL                                 -1
#define APPSDK_ERROR_CODE_SEND_REQ_FAIL                                -2
#define APPSDK_ERROR_CODE_GET_RSP_TIMEOUT                              -3
#define APPSDK_ERROR_CODE_RSP_PARSE_FAIL                               -4
#define APPSDK_ERROR_CODE_GET_RSA_FILE_FAIL                            -5
#define APPSDK_ERROR_CODE_CHG_AES_KEY_FAIL                             -6
#define APPSDK_ERROR_CODE_LOGIN_FAILED_MessageParsingError             -9

#define APPSDK_ERROR_CODE_LOGIN_EVENT_ACCOUNT_ILLEGAL                  -101  //客户端登录信息有误

//登陆返回码定义
#define APPSDK_ERROR_CODE_LOGIN_SUCCESS                                 0
#define APPSDK_ERROR_CODE_LOGIN_FAILED_VERSION_LOW                     402
#define APPSDK_ERROR_CODE_LOGIN_FAILED_PASSWORD_ERROR                  403
#define APPSDK_ERROR_CODE_LOGIN_FAILED_USER_NOT_EXIST                  404
#define APPSDK_ERROR_CODE_LOGIN_FAILED_USER_NOT_ACCORTERY              405  //没有登录权限
#define APPSDK_ERROR_CODE_LOGIN_FAILED_USER_login_lockPwd              407  //密码锁定
#define APPSDK_ERROR_CODE_LOGIN_FAILED_Invalid_QR_code_or_link         408  //无效二维码或链接
#define APPSDK_ERROR_CODE_LOGIN_FAILED_PASSWORD_CHANGE                 409  //修改默认密码

#define APPSDK_ERROR_CODE_LOGIN_FAILED_LCS_SERVER_DISABLED             411  //LCS服务器禁用
#define APPSDK_ERROR_CODE_LOGIN_FAILED_LCS_SERVER_EXPIRES              412  //LCS服务器过期
#define APPSDK_ERROR_CODE_LOGIN_FAILED_LCS_SERVER_TIMEEXCEPTION        413  //LCS客户端时间与标准时间相差超过10分钟不予许登录

#define APPSDK_ERROR_CODE_LOGIN_FAILED_Device_Inactive                 417

#define APPSDK_ERROR_CODE_LOGIN_FAILED_RAS_SERVER_DISABLED             421  //RAS服务器禁用
#define APPSDK_ERROR_CODE_LOGIN_FAILED_RAS_SERVER_EXPIRES              422  //RAS服务器过期

#define APPSDK_ERROR_CODE_LOGIN_FAILED_NONE_NetWork                    471

#define APPSDK_ERROR_CODE_LOGIN_FAILED_RequestParsingError             501
#define APPSDK_ERROR_CODE_LOGIN_FAILED_ModeChange                      504
