//
//  NemoFilterView.m
//  Nemo
//
//  Created by ksyun on 17/4/20.
//  Copyright © 2017年 com.ksyun. All rights reserved.
//

#import "filterView.h"
#import "filterCell.h"

@interface filterView()<filterViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    
}
@property (nonatomic, strong) NSMutableDictionary *cellDic;

@property (nonatomic, strong) NSArray * nameList;
//当前选中的cell号，号码唯一，当前只能选中一个号
@property(nonatomic,assign) NSInteger *selectedCount;

@end


@implementation filterView

- (instancetype)init{
    if (self = [super init]) {
        [self initConfigView];
        self.cellDic = [[NSMutableDictionary alloc] init];
        self.nameList =  [[NSArray alloc] initWithObjects:@"nature",@"delta",@"electric",@"slowlived",@"tokyo", @"warm",nil];
    }
    return self;
}

- (void)initConfigView{
    self.backgroundColor = [UIColor colorWithHexString:@"#07080B"];
    self.alpha = 0.7f;
    // flow Layout
    UICollectionViewFlowLayout *allFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    allFlowLayout.headerReferenceSize = CGSizeMake(30, KFilterCellHeight);
    allFlowLayout.itemSize = CGSizeMake(KFilterCellWidth, KFilterCellHeight);
  //  allFlowLayout.sectionInset = UIEdgeInsetsMake(0, 16, 16, 16);//zw
    allFlowLayout.minimumLineSpacing = kFilterSpaceWidth;
    allFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _filterConfigView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:allFlowLayout];
    _filterConfigView.showsHorizontalScrollIndicator = NO;
    _filterConfigView.backgroundColor = [UIColor clearColor];
    _filterConfigView.dataSource = self;
    _filterConfigView.allowsMultipleSelection = NO;
    _filterConfigView.delegate = self;
    _filterConfigView.scrollsToTop = NO;

    [self addSubview:_filterConfigView];
    
    [_filterConfigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_filterConfigView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return kEffectNum;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    // 每次先从字典中根据IndexPath取出唯一标识符
    NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"filterCell%@", [NSString stringWithFormat:@"%@", indexPath]];
        [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        // 注册Cell
        [self.filterConfigView registerClass:[filterCell class] forCellWithReuseIdentifier:identifier];
    }
    
    filterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.effectName = self.nameList[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(specialEffectFilterChanged:)]){
        [self.delegate specialEffectFilterChanged:(int)indexPath.row];
    }
}


@end
