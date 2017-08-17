//
//  NemoAboutView.m
//  Nemo
//
//  Created by iVermisseDich on 16/12/21.
//  Copyright © 2016年 com.ksyun. All rights reserved.
//

#import "NemoAboutView.h"
#import "KSYGPUStreamerKit.h"
#import "UIColor+Expanded.h"
#import "Masonry.h"

#define FONT(value) [UIFont systemFontOfSize:value]

@implementation NemoAboutView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    // 0. bgview
    UIView *bgView = [[UIView alloc] init];
    bgView.layer.cornerRadius = 10;
    bgView.clipsToBounds = YES;
    bgView.backgroundColor = [UIColor colorWithHexString:@"#18181d"];
   
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 8;
    titleLabel.text = @"faceunity提供的AR贴纸、美颜功能可\n运用在金山直播SDK、短视频SDK上，\n其他SDK要根据其开放性决定\n\n若想进一步了解请联系我们\n邮件：KSC-VBU-KMC@kingsoft.com";
    [titleLabel sizeToFit];
    titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    titleLabel.font = FONT(16);
    [self changeLineSpaceForLabel:titleLabel WithSpace:5];
   
    UIButton* closeButton = [[UIButton alloc] init];
    [closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:bgView];
    [bgView addSubview:titleLabel];
    [bgView addSubview:closeButton];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(330);
        make.height.mas_equalTo(231);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(bgView).offset(23);
        make.trailing.equalTo(bgView).offset(-23);
        make.top.bottom.equalTo(bgView);
    }];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView);
        make.trailing.equalTo(bgView);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(48);
    }];
    
 }

- (void)close{
    [_hud hide:YES];
}

-(void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}
@end
