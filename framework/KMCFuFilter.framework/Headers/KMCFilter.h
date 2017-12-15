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
    AUTHORIZE_SERVICE_EXCEPTION = 1008,
    /**
     网络异常
     */
    AUTHORIZE_NETWORK_ERROR = 1009
} AuthorizeError;


typedef enum : NSUInteger {
    /**
     兼容之前版本,默认设置为下载之后的贴纸沙盒路径
     */
    BundlePathMode_Default=2000,
    /**
     自定义贴纸模式
     */
    BundlePathMode_Custom,
    
} BundlePathMode;


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
- (void)startShowingMaterial:(KMCArMaterial *)material;

/**
 获取人脸信息
 @param faceId 被检测的人脸 ID ，未开启多人检测时传 0 ，表示检测第一个人的人脸信息；当开启多人检测时，其取值范围为 [0 ~ maxFaces-1] ，取其中第几个值就代表检测第几个人的人脸信息
 @param name 人脸信息参数名： "landmarks" , "eye_rotation" , "translation" , "rotation" ....
 @param pret 作为容器使用的 float 数组指针，获取到的人脸信息会被直接写入该 float 数组。
 @param number float 数组的长度
 @return 返回 1 代表获取成功，返回 0 代表获取失败
 */
- (int)KmcGetFaceInfo:(int)faceId name:(char *)name pret:(float *)pret number:(int)number;

/**
 判断是否检测到人脸：
 @return 检测到的人脸个数，返回 0 代表没有检测到人脸
 */
- (int)KmcIsTracking;
/**
 贴纸自定义路径：
 @param bundlePath 贴纸路径 如 a/b/c.bundle 路径，bundlePath 请输入a/b/
 */
- (void)setCustomloadBundlePath:(NSString *)bundlePath;

/**
 贴纸模式：
 @param bundlePathMode 贴纸模式  使用 下载之后的路径 还是 本地路径 加载贴纸
 */

- (void)setCustomBundlePathMode:(BundlePathMode) bundlePathMode;

/**
 可以用来设置的filter
 */
@property(nonatomic,strong) GPUImageOutput<GPUImageInput>* filter;

#pragma 美颜接口
@property (nonatomic,strong) NSString* filterType;
//美白接口（0-10）
@property (nonatomic,assign) float colorLevel;
// 磨皮 取值范围为0-6
@property (nonatomic,assign) float blurLevel;
// 红润 取值范围为0-10
@property (nonatomic,assign) float redLevel;
// 瘦脸 （大于等于0的浮点数，0为关闭效果，1为默认效果，大于1为进一步增强效果）
@property (nonatomic,assign) float cheekThinning;
// 大眼 （大于等于0的浮点数，0为关闭效果，1为默认效果，大于1为进一步增强效果）
@property (nonatomic,assign) float eyeEnlarging;
// 脸型等级 用以控制变化到指定基础脸型的程度，取值范围为0-1.0, 0为无效果，即关闭美型，1为指定脸型
@property (nonatomic,assign) float faceShapeLevel;
// 美型  默认（3）、女神（0）、网红（1）、自然（2）
@property (nonatomic,assign) int faceShape;

@end
