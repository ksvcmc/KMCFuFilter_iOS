//
//  UIButton+init.m
//  Nemo
//
//  Created by iVermisseDich on 16/11/23.
//  Copyright © 2016年 com.ksyun. All rights reserved.
//

#import "UIButton+initBeauty.h"
#import "UIColor+Expanded.h"

@implementation UIButton (init_beauty)

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
    [btn setImage:[UIImage imageNamed:image_nm] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:image_hl] forState:UIControlStateHighlighted];
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
    [button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];

    [button setImage:[UIImage imageNamed:image_hl] forState:UIControlStateHighlighted];
    [button sizeToFit];
    
    //选中状态
    [button setImage:[UIImage imageNamed:image_sel] forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateSelected];
    [button setTitleColor:[UIColor colorWithHexString:@"#ffffff"]  forState:UIControlStateSelected];
    
    button.titleLabel.font = [UIFont systemFontOfSize:10];

    [button sizeToFit];
    
    button.titleEdgeInsets = UIEdgeInsetsMake(button.imageView.frame.size.height,-button.imageView.frame.size.width,0,0);
    button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.frame.size.height, 0, 0,-button.titleLabel.frame.size.width);
    
    
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (UIButton *)createButtonwithTitle:(NSString *)title
                             target:(id)target
                           selector:(SEL)sel
                                tag:(int)tag{
    UIButton * button = [[UIButton alloc] init];
    
    //正常状态
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [button setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#9d9da3"]] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button sizeToFit];
    
    //选中状态
    [button setTitle:title forState:UIControlStateSelected];
    [button setTitleColor:[UIColor colorWithHexString:@"#ffffff"]  forState:UIControlStateSelected];
    [button setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#50e3c2"]] forState:UIControlStateSelected];
    [button sizeToFit];
    
    button.layer.cornerRadius = 10;
    button.layer.masksToBounds = YES;
    button.tag = 100+tag;
    
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (UIImage *)createImageWithColor:(UIColor *)color
{
    //图片尺寸
    CGRect rect = CGRectMake(0, 0, 50, 20);
    //填充画笔
    UIGraphicsBeginImageContext(rect.size);
    //根据所传颜色绘制
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    //显示区域
    CGContextFillRect(context, rect);
    // 得到图片信息
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    //消除画笔
    UIGraphicsEndImageContext();
    return image;
}
@end
