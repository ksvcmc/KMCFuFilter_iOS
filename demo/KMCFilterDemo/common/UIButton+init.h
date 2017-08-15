//
//  UIButton+init.h
//  Nemo
//
//  Created by iVermisseDich on 16/11/23.
//  Copyright © 2016年 com.ksyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (init)

+ (UIButton *)buttonWithFrame:(CGRect)rect target:(id)target normal:(NSString *)image_nm highlited:(NSString *)image_hl selected:(NSString *)image_sel selector:(SEL)sel;

+ (UIButton *)createButtonwithTitle:(NSString *)title
                         target:(id)target
                         normal:(NSString *)image_nm
                      highlited:(NSString *)image_hl
                       selected:(NSString *)image_sel
                       selector:(SEL)sel;
@end
