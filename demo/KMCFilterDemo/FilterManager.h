//
//  LoginManager.h
//  Nemo
//
//  Created by iVermisseDich on 16/11/24.
//  Copyright © 2016年 com.ksyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMCFilter.h"
#import "KMCArMaterial.h"

@interface FilterManager : NSObject

+ (instancetype)instance;

-(void)setupWithTokeID:(NSString *)tokeID
             Onsuccess:(void (^)(void))completeSuccess;

//人脸识别类
-(NSInteger)faceMaterialCount;
-(KMCArMaterial *)faceMaterialAtIndex:(NSInteger)index;

//动作类
-(NSInteger)actionMaterialCount;
-(KMCArMaterial *)actionMaterialAtIndex:(NSInteger)index;

@property (nonatomic, strong) KMCFilter * kmcFitler; //贴纸filter

@end
