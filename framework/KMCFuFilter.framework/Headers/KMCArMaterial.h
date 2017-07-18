//
//  KMCArMaterial.h
//  KMCFilter
//
//  Created by ksyun on 17/5/10.
//  Copyright © 2017年 ksyun. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 触发动作
 */
typedef enum : NSUInteger {
    //无动作
    KMC_NO_ACTION = 0,
    // 张嘴
    KMC_MOUTH_AH,
    
    // 眨眼
    KMC_EYE_BLINK,
    
    // 点头
    KMC_HEAD_PITCH,
    
    // 摇头
    KMC_HEAD_YAW,
    
    // 挑眉
    KMC_BROW_JUMP,
    
    // 手掌
    KMC_HAND_PALM,
    
    // 大拇哥
    KMC_HAND_GOOD,
    
    // 托手
    KMC_HAND_HOLDUP,
    
    // 爱心手
    KMC_HAND_LOVE,
    
    // 恭贺(抱拳)
    KMC_HAND_CONGRATULATE,
    
    // 单手比爱心
    KMC_HAND_FINGER_HEART
    
    
} KMCArTriggerAction;


@interface KMCArMaterial : NSObject

/**
 *  MaterialID
 */
@property (nonatomic , copy) NSString *strID;
/**
 *  缩略图地址
 */
@property (nonatomic , copy) NSString *strThumbnailURL;
/**
 *  素材地址
 */
@property (nonatomic , copy) NSString *strMeterialURL;
/**
 *  素材名称
 */
@property (nonatomic , copy) NSString *strName;
/**
 *  素材描述
 */
@property (nonatomic , copy) NSString *strInstructions;

/**
 *  触发动作
 */
@property (nonatomic , assign) KMCArTriggerAction triggerAction;

/**
 *  触发动作描述，没有动作则为空
 */
@property (nonatomic , copy) NSString *strTriggerActionTip;

@end
