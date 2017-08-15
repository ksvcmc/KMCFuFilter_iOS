//
//  LoginManager.h
//  Nemo
//
//  Created by iVermisseDich on 16/11/24.
//  Copyright © 2016年 com.ksyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KMCFuFilter/KMCFilter.h>
#import <KMCFuFilter/KMCArMaterial.h>

@interface FilterManager : NSObject

+ (instancetype)instance;

-(void)setupWithTokeID:(NSString *)tokeID
             Onsuccess:(void (^)(void))completeSuccess;

@property (nonatomic, strong) KMCFilter * kmcFitler; //filter

@end
