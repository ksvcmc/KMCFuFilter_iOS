//
//  UIButton+init.m
//  Nemo
//
//  Created by iVermisseDich on 16/11/23.
//  Copyright © 2016年 com.ksyun. All rights reserved.
//

#import "UIButton+init.h"
#import "UIColor+Expanded.h"

@implementation UIButton (init)

// 创建一个button
+ (UIButton *)buttonWithFrame:(CGRect)rect target:(id)target normal:(NSString *)image_nm highlited:(NSString *)image_hl selected:(NSString *)image_sel selector:(SEL)sel{
    // frame
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
//    //设置为上图片下文字
//     btn.frame = rect;
//    CGFloat totalHeight = (btn.imageView.frame.size.height + btn.titleLabel.frame.size.height);
//     [btn setImageEdgeInsets:UIEdgeInsetsMake(-(totalHeight - btn.imageView.frame.size.height), 0.0, 0.0, -btn.titleLabel.frame.size.width)];
//    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -btn.imageView.frame.size.width, -(totalHeight - btn.titleLabel.frame.size.height),0.0)];
    
    // target
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    // image
    if(image_nm)
        [btn setImage:[UIImage imageNamed:image_nm] forState:UIControlStateNormal];
    if(image_hl)
        [btn setImage:[UIImage imageNamed:image_hl] forState:UIControlStateHighlighted];
    if(image_sel)
        [btn setImage:[UIImage imageNamed:image_sel] forState:UIControlStateSelected];
    [btn sizeToFit];
    return btn;
}

+ (UIButton *)createButtonwithTitle:(NSString *)title
                             target:(id)target
                             normal:(NSString *)image_nm
                          highlited:(NSString *)image_hl
                           selected:(NSString *)image_sel
                           selector:(SEL)sel{
    UIButton * button = [[UIButton alloc] init];
    
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button setImage:[UIImage imageNamed:image_nm] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [button setImage:[UIImage imageNamed:image_hl] forState:UIControlStateHighlighted];
    [button sizeToFit];
    
    //选中状态
    [button setImage:[UIImage imageNamed:image_sel] forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateSelected];
    [button setTitleColor:[UIColor colorWithHexString:@"#4C98F0"]  forState:UIControlStateSelected];
    
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);


    [button sizeToFit];
    
//    button.imageEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.frame.size.width - button.frame.size.width + button.titleLabel.frame.size.width, 0, 0);
//    
//    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -button.titleLabel.frame.size.width - button.frame.size.width + button.imageView.frame.size.width);
//    
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

@end
