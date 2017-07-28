//
//  NemoFilterCell.m
//  Nemo
//
//  Created by ksyun on 17/4/20.
//  Copyright © 2017年 com.ksyun. All rights reserved.
//

#import "StickerCell.h"
#import "Masonry.h"
#import <KMCFuFilter/KMCFilter.h>
#import "UIImageView+WebCache.h"
#import "FilterManager.h"
#import "MBProgressHUD.h"
#import "UIColor+Expanded.h"


@interface StickerCell(){
    
}

@property (nonatomic, strong) UIImageView * filterView;
@property(nonatomic,strong)UIButton * downloadBtn;
@property(nonatomic,strong) UIImageView * selectView;

@end

@implementation StickerCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    UIView *maskView = [[UIView alloc]init];
//    maskView.backgroundColor = [UIColor blackColor];
//    maskView.alpha = 0.15;
    [self.contentView addSubview:maskView];
    
    _filterView = [[UIImageView alloc] init];
    [self.contentView addSubview:_filterView];

    //选中框
    _selectView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"choose"]];

    //添加一个下载按钮
    CGRect btnFram = CGRectMake(0, 0, 24, 24);
    _downloadBtn = [[UIButton alloc]initWithFrame:btnFram];
    [_downloadBtn setBackgroundImage:[UIImage imageNamed:@"下载"] forState:UIControlStateNormal];
    _downloadBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:_downloadBtn];
    _downloadBtn.hidden = YES;
    
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [_downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-8);
        make.bottom.equalTo(self.contentView).offset(-8);
    }];
    
    [_filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView);
        make.width.mas_equalTo(74);
        make.height.mas_equalTo(74);
    }];

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}

-(void)setMaterial:(KMCArMaterial *)material{
    _material = material;
    
    //设置缩略图
    if(!_material){
        [self.filterView setImage:[UIImage imageNamed:@"禁用"]];
    }else{
        [self.filterView sd_setImageWithURL:[NSURL URLWithString:_material.strThumbnailURL] placeholderImage:nil options:SDWebImageRefreshCached];
    }
    
    //设置下载图标
    if ( !_material ||[[FilterManager instance].kmcFitler isMaterialDownloaded:_material] ) {
        _downloadBtn.hidden = YES;
    }else{
        _downloadBtn.hidden = NO;
        
    }
}

-(void)downloadMaterial{
        //判断是否已经下载
        if(_material && ![[FilterManager instance].kmcFitler isMaterialDownloaded:_material]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showHud];
                _downloadBtn.hidden = YES;
            });

            [[FilterManager instance].kmcFitler downloadMaterial:_material onSuccess:^(KMCArMaterial *material) {
                dispatch_async(dispatch_get_main_queue(), ^{
                     [MBProgressHUD hideHUDForView:self.contentView animated:NO];
                });
                [[FilterManager instance].kmcFitler startShowingMaterial:material];
            } onFailure:nil onProgress:^(KMCArMaterial *material, float fProgress, int64_t iSize) {
                [MBProgressHUD HUDForView:self.contentView].progress = fProgress;
            }];
        }
}

-(void)showHud{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.contentView animated:NO];
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    
    //1,设置背景框的透明度  默认0.8
    HUD.opacity = 0.8;
    //3,设置背景框的圆角值，默认是10
    HUD.cornerRadius = 20.0;
    //6，设置菊花颜色  只能设置菊花的颜色
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor blackColor];
    //7,设置一个渐变层
    //HUD.dimBackground = YES;
    //10，设置各个元素距离矩形边框的距离
    HUD.margin = 0;
    //13,是否强制背景框宽高相等
    HUD.square = YES;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        [self.contentView addSubview:_selectView];
        [_selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView);
            make.width.mas_equalTo(74);
            make.height.mas_equalTo(74);
        }];
    }else{
        [_selectView removeFromSuperview];

    }
}
@end
