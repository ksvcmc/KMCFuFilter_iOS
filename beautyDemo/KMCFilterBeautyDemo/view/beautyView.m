//
//  beautyView.m
//  KMCFuFilter
//
//  Created by ksyun on 2017/8/11.
//  Copyright © 2017年 ksyun. All rights reserved.
//

#import "beautyView.h"

@interface beautyView(){
}

@property (nonatomic, strong) UILabel * label1;
@property (nonatomic, strong) UILabel * label2;
@property (nonatomic, strong) UILabel * label3;
@property (nonatomic, strong) UILabel * label11;
@property (nonatomic, strong) UILabel * label21;
@property (nonatomic, strong) UILabel * label31;

@end


@implementation beautyView

-(instancetype)init{
    self = [super init];
    if(self){
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    _label1 = [[UILabel alloc] init];
    _label1.text = @"磨皮";
    _label1.font = [UIFont systemFontOfSize:14];
    _label1.textColor = [UIColor colorWithHexString:@"#ffffff"];

    _label2 = [[UILabel alloc] init];
    _label2.text = @"美白";
    _label2.font = [UIFont systemFontOfSize:14];
    _label2.textColor = [UIColor colorWithHexString:@"#ffffff"];
    
    _label3 = [[UILabel alloc] init];
    _label3.text = @"红润";
    _label3.font = [UIFont systemFontOfSize:14];
    _label3.textColor = [UIColor colorWithHexString:@"#ffffff"];
    
    _label11 = [[UILabel alloc] init];
    _label11.text = @"0";
    _label11.font = [UIFont systemFontOfSize:14];
    _label11.textColor = [UIColor colorWithHexString:@"#ffffff"];
    
    _label21 = [[UILabel alloc] init];
    _label21.text = @"0";
    _label21.font = [UIFont systemFontOfSize:14];
    _label21.textColor = [UIColor colorWithHexString:@"#ffffff"];
    
    _label31 = [[UILabel alloc] init];
    _label31.text = @"0";
    _label31.font = [UIFont systemFontOfSize:14];
    _label31.textColor = [UIColor colorWithHexString:@"#ffffff"];
    
    _label12 = [[UILabel alloc] init];
    _label12.font = [UIFont systemFontOfSize:14];
    _label12.textColor = [UIColor colorWithHexString:@"#ffffff"];
    
    _label22 = [[UILabel alloc] init];
    _label22.font = [UIFont systemFontOfSize:14];
    _label22.textColor = [UIColor colorWithHexString:@"#ffffff"];
    
    _label32 = [[UILabel alloc] init];
    _label32.font = [UIFont systemFontOfSize:14];
    _label32.textColor = [UIColor colorWithHexString:@"#ffffff"];
    
    _slider1 = [[UISlider alloc] init];
    [_slider1 addTarget:self action:@selector(changeBlurLevel:) forControlEvents:UIControlEventValueChanged];
    _slider1.minimumValue = 0;
    _slider1.maximumValue = 6;
    
    _slider2 = [[UISlider alloc] init];
    _slider2.minimumValue = 0;
    _slider2.maximumValue = 2;
    [_slider2 addTarget:self action:@selector(changeColorLevel:) forControlEvents:UIControlEventValueChanged];
    
    _slider3 = [[UISlider alloc] init];
    [_slider3 addTarget:self action:@selector(changeRedLevel:) forControlEvents:UIControlEventValueChanged];
    _slider3.minimumValue = 0;
    _slider3.maximumValue = 2;
    
    [self addSubview:_label1];
    [self addSubview:_label2];
    [self addSubview:_label3];
    [self addSubview:_label11];
    [self addSubview:_label21];
    [self addSubview:_label31];
    [self addSubview:_label12];
    [self addSubview:_label22];
    [self addSubview:_label32];
    [self addSubview:_slider1];
    [self addSubview:_slider2];
    [self addSubview:_slider3];
    
    [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(25);
        make.leading.equalTo(self).offset(31);
    }];
    [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label1.mas_bottom).offset(25);
        make.leading.equalTo(self).offset(31);
    }];
    [_label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label2.mas_bottom).offset(25);
        make.leading.equalTo(self).offset(31);
    }];
    
    [_label11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(25);
        make.leading.equalTo(self.label1.mas_trailing).offset(10);
    }];
    [_label21 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label11.mas_bottom).offset(25);
        make.leading.equalTo(self.label2.mas_trailing).offset(10);
    }];
    [_label31 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label2.mas_bottom).offset(25);
        make.leading.equalTo(self.label3.mas_trailing).offset(10);
    }];
    
    [_label12 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(25);
        make.trailing.equalTo(self.mas_trailing).offset(-39);
    }];
    [_label22 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label12.mas_bottom).offset(25);
        make.trailing.equalTo(self.mas_trailing).offset(-39);
    }];
    [_label32 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label22.mas_bottom).offset(25);
        make.trailing.equalTo(self.mas_trailing).offset(-39);
    }];
    
    [_slider1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.label1);
        make.leading.equalTo(self.label11.mas_trailing).offset(13);
        make.trailing.equalTo(self.label12.mas_leading).offset(-10);
    }];
    [_slider2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.label2);
        make.leading.equalTo(self.label21.mas_trailing).offset(13);
        make.trailing.equalTo(self.label22.mas_leading).offset(-10);
    }];
    [_slider3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.label3);
        make.leading.equalTo(self.label31.mas_trailing).offset(13);
        make.trailing.equalTo(self.label32.mas_leading).offset(-10);
    }];
    
}

-(void)changeColorLevel:(id)sender{
    UISlider* slider = (UISlider *)sender;
    self.label22.text = [NSString stringWithFormat:@"%.2lf",slider.value];
    if(self.delegate)
        [self.delegate colorLevelChanged:slider.value];
}

-(void)changeBlurLevel:(id)sender{
    UISlider* slider = (UISlider *)sender;
    self.label12.text = [NSString stringWithFormat:@"%.2lf",slider.value];
    if(self.delegate)
        [self.delegate blurLevelChanged:slider.value];
}
-(void)changeRedLevel:(id)sender{
    UISlider* slider = (UISlider *)sender;
    self.label32.text = [NSString stringWithFormat:@"%.2lf",slider.value];
    if(self.delegate)
        [self.delegate redLevelChanged:slider.value];
}

@end
