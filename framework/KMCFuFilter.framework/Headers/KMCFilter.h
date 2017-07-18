//
//  KMCFilter.h
//  KMCFilter
//
//  Created by ksyun on 17/5/8.
//  Copyright © 2017年 ksyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "KMCArMaterial.h"
#import "GPUImage/GPUImage.h"
#import <libksygpulive/libksystreamerengine.h>

typedef enum : NSUInteger {
    /**
     错误参数
     */
    AUTH_ERROR_WRONG_PARAMETER = 1001,
    /**
     token不匹配
     */
    AUTH_ERROR_TOKEN_NOT_MATCHED = 1002,
    /**
     token无效
     */
    AUTH_ERROR_TOKEN_NOT_VALID = 1003,
    /**
     未知错误
     */
    AUTH_ERROR_KMCS_ERROR_UNKONWN = 1004,
    /**
     第三方鉴权错误
     */
    AUTHORIZE_ERROR_FACTORY_ERROR = 1005,
    /**
     内部服务器错误
     */
    AUTHORIZE_SERVER_ERROR = 1006,
    /**
     token过期
     */
    AUTHORIZE_TOKEN_EXPIRE = 1007,
    /**
     服务器异常
     */
    AUTHORIZE_SERVICE_EXCEPTION = 1008
} AuthorizeError;

@interface KMCFilter : NSObject

/** 
 @param tokeID 控制台分配的tokeID
 @param completeSuccess 注册成功后的回调
 @param completeFailure 注册失败后的回调
 */
- (void)authorizeWithTokeID:(NSString *)tokeID
                  onSuccess:(void (^)(void))completeSuccess
                  onFailure:(void (^)(AuthorizeError iErrorCode))completeFailure;


/**
 获取 Material 列表
 
 @param strGroupID  素材列表
 @param completeSuccess 获取素材列表成功 , arrMaterias 素材列表 .
 @param completeFailure 获取素材列表失败 , iErrorCode 错误码 , strMessage 错误描述 .
 iErrorCode定义: 错误码
 -1:未鉴权
 其他:内部服务器错误。
 */
- (void)fetchMaterialsWithGroupID:(NSString *)strGroupID
                        OnSuccess:(void (^)(NSArray <KMCArMaterial *>* arrMaterials))completeSuccess
                        onFailure:(void (^)(int iErrorCode , NSString *strMessage))completeFailure;


/**
 素材是否已下载
 
 @param material 需要判断是否已下载的素材
 
 @return YES 已下载 , NO 未下载或下载中 .
 */
- (BOOL)isMaterialDownloaded:(KMCArMaterial *)material;

/**
 下载素材
 
 @param material        下载的素材
 @param completeSuccess 下载成功 , material 下载的素材
 @param completeFailure 下载失败 , material 下载的素材 , iErrorCode 错误码 , strMessage 错误描述
 @param processingCallBack 下载中 , material 下载的素材 , fProgress 下载进度 , iSize 已下载大小
 iErrorCode定义: 错误码
 -1:未鉴权
 其他:内部服务器错误。
 */
- (void)downloadMaterial:(KMCArMaterial *)material
               onSuccess:(void (^)(KMCArMaterial *material))completeSuccess
               onFailure:(void (^)(KMCArMaterial *material , int iErrorCode , NSString *strMessage))completeFailure
              onProgress:(void (^)(KMCArMaterial *material , float fProgress , int64_t iSize))processingCallBack;


/**
 激活素材
 @param material        需要展示的素材
 */
-(void)startShowingMaterial:(KMCArMaterial *)material;


/**
 可以用来设置的filter
 */
@property(nonatomic,strong) GPUImageOutput<GPUImageInput>* filter;

@end
