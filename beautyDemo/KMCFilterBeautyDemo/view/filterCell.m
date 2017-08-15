//
//  NemoFilterCell.m
//  Nemo
//
//  Created by ksyun on 17/4/20.
//  Copyright © 2017年 com.ksyun. All rights reserved.
//

#import "filterCell.h"
#import "Masonry.h"

@interface filterCell(){
    
}

@property (nonatomic, strong) UIImageView * filterView;
@property (nonatomic, strong) UILabel * nameLabel;

@end

@implementation filterCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    _filterView = [[UIImageView alloc]init];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.width.mas_equalTo(KFilterCellWidth);
        make.height.mas_equalTo(KFilterCellHeight);
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:_filterView];
    [self.contentView addSubview:_nameLabel];

    [_filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(35);
        make.leading.equalTo(self.contentView);
        make.width.mas_equalTo(KFilterCellWidth);
        make.height.mas_equalTo(63);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.filterView.mas_bottom).offset(9);
        make.leading.equalTo(self.filterView);
        make.width.mas_equalTo(KFilterCellWidth);
    }];
}

-(void)setEffectName:(NSString *)effectName{
    _effectName = effectName;
    _filterView.image = [UIImage imageNamed:_effectName];
    _nameLabel.text = _effectName;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        self.filterView.layer.borderWidth = 1.5;
        self.filterView.layer.borderColor = [[UIColor colorWithHexString:@"#ff8c10"]CGColor];
    }else{
        self.filterView.layer.borderWidth = 0;
        self.filterView.layer.borderColor = [[UIColor clearColor]CGColor];
    }
}
@end
