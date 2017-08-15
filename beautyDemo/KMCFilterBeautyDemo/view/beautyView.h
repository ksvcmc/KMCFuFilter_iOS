//
//  beautyView.h
//  KMCFuFilter
//
//  Created by ksyun on 2017/8/11.
//  Copyright © 2017年 ksyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol beautyViewDelegate <NSObject>

- (void)colorLevelChanged:(float)value;
- (void)blurLevelChanged:(float)value;
- (void)redLevelChanged:(float)value;

@end


@interface beautyView : UIView
@property (nonatomic, weak) id <beautyViewDelegate>delegate;

@property (nonatomic, strong) UISlider * slider1;
@property (nonatomic, strong) UISlider * slider2;
@property (nonatomic, strong) UISlider * slider3;
@property (nonatomic, strong) UILabel * label12;
@property (nonatomic, strong) UILabel * label22;
@property (nonatomic, strong) UILabel * label32;
@end
