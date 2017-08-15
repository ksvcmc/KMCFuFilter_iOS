//
//  beautyView.m
//  KMCFuFilter
//
//  Created by ksyun on 2017/8/11.
//  Copyright © 2017年 ksyun. All rights reserved.
//

#import "sharpView.h"

@interface sharpView(){
}

@property (nonatomic, strong) UILabel * faceLabel;
@property (nonatomic, strong) UIView * cutOffLine;

@property (nonatomic, strong) UILabel * label1;
@property (nonatomic, strong) UILabel * label2;
@property (nonatomic, strong) UILabel * label11;
@property (nonatomic, strong) UILabel * label21;


@end


@implementation sharpView

-(instancetype)init{
    self = [super init];
    if(self){
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    _faceLabel = [[UILabel alloc] init];
    _faceLabel.text = @"脸型";
    _faceLabel.font = [UIFont systemFontOfSize:14];
    _faceLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];

    _faceButton1 = [UIButton createButtonwithTitle:@"默认" target:self  selector:@selector(facebuttonSelectd:) tag:3];
    _faceButton2 = [UIButton createButtonwithTitle:@"女神" target:self  selector:@selector(facebuttonSelectd:)tag:0];
    _faceButton3 = [UIButton createButtonwithTitle:@"网红" target:self  selector:@selector(facebuttonSelectd:)tag:1];
    _faceButton4 = [UIButton createButtonwithTitle:@"自然" target:self  selector:@selector(facebuttonSelectd:)tag:2];
    
    _cutOffLine = [[UIView alloc] init];
    _cutOffLine.backgroundColor = [UIColor blackColor];
    
    _label1 = [[UILabel alloc] init];
    _label1.text = @"大眼";
    _label1.font = [UIFont systemFontOfSize:14];
    _label1.textColor = [UIColor colorWithHexString:@"#ffffff"];

    _label2 = [[UILabel alloc] init];
    _label2.text = @"瘦脸";
    _label2.font = [UIFont systemFontOfSize:14];
    _label2.textColor = [UIColor colorWithHexString:@"#ffffff"];
    
    _label11 = [[UILabel alloc] init];
    _label11.text = @"0";
    _label11.font = [UIFont systemFontOfSize:14];
    _label11.textColor = [UIColor colorWithHexString:@"#ffffff"];
    
    _label21 = [[UILabel alloc] init];
    _label21.text = @"0";
    _label21.font = [UIFont systemFontOfSize:14];
    _label21.textColor = [UIColor colorWithHexString:@"#ffffff"];
    
   
    _label12 = [[UILabel alloc] init];
    _label12.font = [UIFont systemFontOfSize:14];
    _label12.textColor = [UIColor colorWithHexString:@"#ffffff"];
    
    _label22 = [[UILabel alloc] init];
    _label22.font = [UIFont systemFontOfSize:14];
    _label22.textColor = [UIColor colorWithHexString:@"#ffffff"];
    
    _slider1 = [[UISlider alloc] init];
    [_slider1 addTarget:self action:@selector(eyeEnlargingChanged:) forControlEvents:UIControlEventValueChanged];
    _slider1.minimumValue = 0;
    _slider1.maximumValue = 2;
    
    _slider2 = [[UISlider alloc] init];
    [_slider2 addTarget:self action:@selector(cheekThinningChanged:) forControlEvents:UIControlEventValueChanged];
    _slider2.minimumValue = 0;
    _slider2.maximumValue = 2;
    
    [self addSubview:_faceLabel];
    [self addSubview:_faceButton1];
    [self addSubview:_faceButton2];
    [self addSubview:_faceButton3];
    [self addSubview:_faceButton4];
    [self addSubview:_cutOffLine];

    [self addSubview:_label1];
    [self addSubview:_label2];
    [self addSubview:_label11];
    [self addSubview:_label21];
    [self addSubview:_label12];
    [self addSubview:_label22];
    [self addSubview:_slider1];
    [self addSubview:_slider2];

    [_faceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(16);
        make.leading.equalTo(self).offset(31);
    }];
    
    [_faceButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(16);
        make.leading.equalTo(self.faceLabel.mas_trailing).offset(16);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    [_faceButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(16);
        make.leading.equalTo(self.faceButton1.mas_trailing).offset(32);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    [_faceButton3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(16);
        make.leading.equalTo(self.faceButton2.mas_trailing).offset(32);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    [_faceButton4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(16);
        make.leading.equalTo(self.faceButton3.mas_trailing).offset(32);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    
    [_cutOffLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.faceLabel.mas_bottom).offset(16);
        make.leading.trailing.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cutOffLine.mas_bottom).offset(16);
        make.leading.equalTo(self).offset(31);
    }];
    [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label1.mas_bottom).offset(25);
        make.leading.equalTo(self).offset(31);
    }];
    
    [_label11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cutOffLine.mas_bottom).offset(16);
        make.leading.equalTo(self.label1.mas_trailing).offset(10);
    }];
    [_label21 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label11.mas_bottom).offset(25);
        make.leading.equalTo(self.label2.mas_trailing).offset(10);
    }];
    
    [_label12 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cutOffLine.mas_bottom).offset(16);
        make.trailing.equalTo(self.mas_trailing).offset(-39);
    }];
    [_label22 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label12.mas_bottom).offset(25);
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
    
}

-(void)facebuttonSelectd:(id)sender{
    UIButton * button = ( UIButton * )sender;
    if(button == _faceButton1){
        _faceButton1.selected = YES;
        _faceButton2.selected = NO;
        _faceButton3.selected = NO;
        _faceButton4.selected = NO;
    }else if(button == _faceButton2){
        _faceButton1.selected = NO;
        _faceButton2.selected = YES;
        _faceButton3.selected = NO;
        _faceButton4.selected = NO;
    }
    else if(button == _faceButton3){
        _faceButton1.selected = NO;
        _faceButton2.selected = NO;
        _faceButton3.selected = YES;
        _faceButton4.selected = NO;
    }else if(button == _faceButton4){
        _faceButton1.selected = NO;
        _faceButton2.selected = NO;
        _faceButton3.selected = NO;
        _faceButton4.selected = YES;
    }
    
    if(self.delegate)
        [self.delegate sharpChanged:(button.tag - 100)];
}


-(void)cheekThinningChanged:(id)sender{
    UISlider* slider = (UISlider *)sender;
    self.label22.text = [NSString stringWithFormat:@"%.2lf",slider.value];
    if(self.delegate)
        [self.delegate cheekThinningChanged:slider.value];
}

-(void)eyeEnlargingChanged:(id)sender{
    UISlider* slider = (UISlider *)sender;
    self.label12.text = [NSString stringWithFormat:@"%.2lf",slider.value];
    if(self.delegate)
        [self.delegate eyeEnlargingChanged:slider.value];
}



@end
