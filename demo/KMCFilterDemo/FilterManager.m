//
//  LoginManager.m
//  Nemo
//
//  Created by iVermisseDich on 16/11/24.
//  Copyright © 2016年 com.ksyun. All rights reserved.
//

#import "FilterManager.h"

@interface FilterManager ()

@property (nonatomic, strong) NSMutableArray<KMCArMaterial *>* faceMaterialList;
@property (nonatomic, strong) NSMutableArray<KMCArMaterial *>* actionMaterialList;

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
        _faceMaterialList = [[NSMutableArray alloc]init];
        _actionMaterialList = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)setupWithTokeID:(NSString *)tokeID
             Onsuccess:(void (^)(void))completeSuccess{
    [_kmcFitler authorizeWithTokeID:tokeID onSuccess:^{
        NSLog(@"鉴权成功,开始获取列表");
        [_kmcFitler fetchMaterialsWithGroupID:@"SE_LIST"
                                    OnSuccess:^(NSArray<KMCArMaterial *> *arrMaterials) {
                                        NSLog(@"获取列表成功");
                                        for (KMCArMaterial* material in arrMaterials) {
                                            if(material.triggerAction == 0){
                                                [_faceMaterialList addObject:material];
                                            }else{
                                                [_actionMaterialList addObject:material];
                                            }
                                        }
                                        if(completeSuccess)
                                            completeSuccess();
                                    } onFailure:^(int iErrorCode , NSString *strMessage){
                NSString * errorMessage = [[NSString alloc]initWithFormat:@"鉴权失败，错误码:%d,错误信息:%@",iErrorCode,strMessage];
             
                    dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:errorMessage delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                                        [alert show];
                                        });

                                    }];
    } onFailure:^(AuthorizeError iErrorCode){
        NSString * errorMessage = [[NSString alloc]initWithFormat:@"鉴权失败，错误码:%d",iErrorCode];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:errorMessage delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        });
    }];
}



-(NSInteger)faceMaterialCount{
    return (NSInteger)_faceMaterialList.count;
}

-(KMCArMaterial *)faceMaterialAtIndex:(NSInteger)index{
    return _faceMaterialList[index];
}

-(NSInteger)actionMaterialCount{
    return (NSInteger)_actionMaterialList.count;
}

-(KMCArMaterial *)actionMaterialAtIndex:(NSInteger)index{
    return _actionMaterialList[index];
}

@end
