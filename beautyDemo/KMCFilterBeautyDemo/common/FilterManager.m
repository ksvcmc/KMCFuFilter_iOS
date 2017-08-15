//
//  LoginManager.m
//  Nemo
//
//  Created by iVermisseDich on 16/11/24.
//  Copyright © 2016年 com.ksyun. All rights reserved.
//

#import "FilterManager.h"

@interface FilterManager ()

@end

@implementation FilterManager

+ (instancetype)instance{
    static FilterManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FilterManager alloc] init];
        });
    return instance;
}

-(instancetype)init{
    self = [super init];
    if(self){
        _kmcFitler = [[KMCFilter alloc]init];
    }
    return self;
}

-(void)setupWithTokeID:(NSString *)tokeID
             Onsuccess:(void (^)(void))completeSuccess{
    [_kmcFitler authorizeWithTokeID:tokeID onSuccess:^{
        NSLog(@"鉴权成功,可以使用");
          } onFailure:^(AuthorizeError iErrorCode){
        NSString * errorMessage = [[NSString alloc]initWithFormat:@"鉴权失败，错误码:%lu",(unsigned long)iErrorCode];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:errorMessage delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        });
    }];
}
@end
