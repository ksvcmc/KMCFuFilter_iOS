## 项目背景
金山魔方是一个多媒体能力提供平台，通过统一接入API、统一鉴权、统一计费等多种手段，降低客户接入多媒体处理能力的代价，提供多媒体能力供应商的效率。 本文档主要针对统一FILTER功能而说明。
## 名词解释
- **贴纸资源**:下图右侧，选中icon后下载下来并且出现在人脸上的图案为贴纸资源。
- **缩略图**:下图左侧下方十个格子中，每个格子中的的icon即为滤镜缩略图。
- **贴纸特效动作**:贴纸里可能含有点头，摇头，张嘴等触发特效的动作，KMCArMaterial里详细定义了具体的触发动作和tips.

## 安装
安装包分为三部分:
- **demo**:可运行的示例程序
- **doc**:说明文档

目前sdk支持pod导入.
- pod 'KMCFuFilter'


## SDK包总体介绍
目前无论是哪个厂家的贴纸资源，接口都是一致的，只是framework不同。
- KMCFilter.h  ---- sdk包头
- KMCArMaterial.h  ---- 资源索引文件类


## SDK使用指南
目前本sdk集成多家厂家信息,厂家的贴纸信息有的托管在金山的服务器，有的托管在厂家的服务器，具体信息可以咨询商务，本sdk只是提供统一的贴纸鉴权,下载，显示服务。
+ **鉴权**
  本sdk包采用鉴权加密方式，需要通过商务渠道拿到授权的AK/SK信息，方可以使用，具体请咨询商务。
鉴权函数如下，其中accessKey为ak信息，date为过期时间。
```
(void)authorizeWithAccessKey:(NSString *)accessKey
                       amzDate:(NSString *)date
                     onSuccess:(void (^)(void))completeSuccess
                     onFailure:(void (^)(int iErrorCode))completeFailure;
```

+ **上传贴纸**（不在本sdk范围内,请参考控制台文档）
 客户根据自己选择的厂家，按照厂家要求，自己设计好贴纸，通过金山控制台上传贴纸。
+ **拉取贴纸索引信息**
 客户可以在控制台把贴纸放入一个group里面，sdk通过groupID进行拉取，相关函数为：
```
 - (void)fetchMaterialsWithGroupID:(NSString *)strGroupID
                         OnSuccess:(void (^)(NSArray <KMCArMaterial *>* arrMaterials))completeSuccess
                         onFailure:(void (^)(int iErrorCode , NSString *strMessage))completeFailure;
```
拉取成功后，资源索引文件，包括贴纸的下载地址，缩略图的下载地址，贴纸的手势ID,手势描述信息等，可以在此处设置UI相关信息。
+ **下载贴纸**
贴纸资源大小不固定，大的可能几M，小的可能几十K,相关函数：
```
(void)downloadMaterial:(KMCArMaterial *)material
               onSuccess:(void (^)(KMCArMaterial *material))completeSuccess
               onFailure:(void (^)(KMCArMaterial *material , int iErrorCode , NSString *strMessage))completeFailure
              onProgress:(void (^)(KMCArMaterial *material , float fProgress , int64_t iSize))processingCallBack;
```
+ **显示贴纸**
下载完成后，需要调用显示贴纸设置进推流SDK中，相关函数：
```
-(void)startShowingMaterial:(KMCArMaterial *)material;
```
## 接入流程
![金山魔方接入流程](https://raw.githubusercontent.com/wiki/ksvcmc/KMCSTFilter_Android/all.jpg "金山魔方接入流程")
## 接入步骤  
1.登录[金山云控制台]( https://console.ksyun.com)，选择视频服务-金山魔方
![步骤1](https://raw.githubusercontent.com/wiki/ksvcmc/KMCSTFilter_Android/step1.png "接入步骤1")

2.在金山魔方控制台中挑选所需服务。
![步骤2](https://raw.githubusercontent.com/wiki/ksvcmc/KMCSTFilter_Android/step2.png "接入步骤2")

3.点击申请试用，填写申请资料。
![步骤3](https://raw.githubusercontent.com/wiki/ksvcmc/KMCSTFilter_Android/step3.png "接入步骤3")

![步骤4](https://raw.githubusercontent.com/wiki/ksvcmc/KMCSTFilter_Android/step4.png "接入步骤4")

4.待申请审核通过后，金山云注册时的邮箱会收到邮件及试用token。
![步骤5](https://raw.githubusercontent.com/wiki/ksvcmc/KMCSTFilter_Android/step5.png "接入步骤5")

5.下载安卓/iOS版本的SDK集成进项目。
![步骤6](https://raw.githubusercontent.com/wiki/ksvcmc/KMCSTFilter_Android/step6.png "接入步骤6")

6.参照文档和DEMO填写TOKEN，就可以Run通项目了。  
7.试用中或试用结束后，有意愿购买该服务可以与我们的商务人员联系购买。  
（商务Email:KSC-VBU-KMC@kingsoft.com）

## 反馈与建议
主页：https://docs.ksyun.com/read/latest/142/_book/index.html  
邮箱：ksc-vbu-kmc-dev@kingsoft.com  
QQ讨论群：574179720 [视频云技术交流群]  
