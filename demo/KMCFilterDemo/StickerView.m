//
//  NemoFilterView.m
//  Nemo
//
//  Created by ksyun on 17/4/20.
//  Copyright © 2017年 com.ksyun. All rights reserved.
//

#import "StickerView.h"
#import "StickerCell.h"
#import "Masonry.h"
#import "FilterManager.h"
#import "UIColor+Expanded.h"

#define KFilterCellHeight 74
#define KFilterCellWidth 74
#define KFilterCellTop 12
#define KFilterCellBottom 12
#define KFilterCellLeft 10
#define kFilterSpaceWidth 18
#define kEffectNum  7
#define RGBCOLOR(r,g,b)                      [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define kWhiteColor         RGBCOLOR(255,255,255)


@interface StickerView()<UICollectionViewDataSource,UICollectionViewDelegate>{
    
}
@property (nonatomic, strong) UICollectionView * stickerConfigView;// 贴纸view
@property (nonatomic, strong) NSMutableDictionary *cellDic;
@property (nonatomic, assign) int action;//0:人脸 1:动作

@end


@implementation StickerView

- (instancetype)initWithType:(int)type{
    if (self = [super init]) {
        [self initConfigView];
        _action = type;
    }
    return self;
}

- (void)initConfigView{
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = kWhiteColor;
    
    //分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGBCOLOR(219, 219, 219);

    // flow Layout
    UICollectionViewFlowLayout *allFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    allFlowLayout.itemSize = CGSizeMake(KFilterCellWidth, KFilterCellHeight);
    allFlowLayout.sectionInset = UIEdgeInsetsMake(KFilterCellTop, kFilterSpaceWidth, kFilterSpaceWidth, KFilterCellBottom);
    allFlowLayout.minimumLineSpacing = kFilterSpaceWidth;
    allFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _stickerConfigView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:allFlowLayout];
    _stickerConfigView.showsHorizontalScrollIndicator = NO;
    _stickerConfigView.backgroundColor = [UIColor clearColor];
    _stickerConfigView.dataSource = self;
    _stickerConfigView.delegate = self;
    _stickerConfigView.scrollsToTop = NO;
    
    [self addSubview:topView];
    [topView addSubview:lineView];
    [topView addSubview:_stickerConfigView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.top.equalTo(self);
    }];
    
    [_stickerConfigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(topView);
        make.bottom.equalTo(lineView.mas_top);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(topView);
        make.height.mas_equalTo(1);
    }];
    
    [_stickerConfigView registerClass:[StickerCell class] forCellWithReuseIdentifier:@"stickerCell"];
    
    [_stickerConfigView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(_action)
        return [[FilterManager instance] actionMaterialCount]+1;
    return [[FilterManager instance] faceMaterialCount]+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    // 每次先从字典中根据IndexPath取出唯一标识符
    NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"stickerCell%@", [NSString stringWithFormat:@"%@", indexPath]];
        [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        // 注册Cell
        [self.stickerConfigView registerClass:[StickerCell class] forCellWithReuseIdentifier:identifier];
        
    }
    
    StickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    KMCArMaterial * material;
    if(indexPath.row >0){
        if(_action)
            material= [[FilterManager instance]actionMaterialAtIndex:(indexPath.row -1)];
        else
            material= [[FilterManager instance]faceMaterialAtIndex:(indexPath.row -1)];
    }else{
        material = nil;
    }
    cell.material = material;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    StickerCell * cell = (StickerCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [cell downloadMaterial];
    
    if([self.delegate respondsToSelector:@selector(StickerChanged:)]){
        [self.delegate StickerChanged:cell.material];
    }
}




@end
