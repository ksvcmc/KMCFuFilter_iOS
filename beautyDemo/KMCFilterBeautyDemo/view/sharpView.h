//
//  beautyView.h
//  KMCFuFilter
//
//  Created by ksyun on 2017/8/11.
//  Copyright © 2017年 ksyun. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol sharpViewDelegate <NSObject>

- (void)sharpChanged:(int)type;
- (void)cheekThinningChanged:(float)value;
- (void)eyeEnlargingChanged:(float)value;

@end

@interface sharpView : UIView

@property (nonatomic, weak) id <sharpViewDelegate>delegate;
@property (nonatomic, strong) UIButton * faceButton1;
@property (nonatomic, strong) UIButton * faceButton2;
@property (nonatomic, strong) UIButton * faceButton3;
@property (nonatomic, strong) UIButton * faceButton4;
@property (nonatomic, strong) UISlider * slider1;
@property (nonatomic, strong) UISlider * slider2;
@property (nonatomic, strong) UILabel * label12;
@property (nonatomic, strong) UILabel * label22;
@end
