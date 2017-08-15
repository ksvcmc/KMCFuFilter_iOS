//
//  NemoFilterCell.h
//  Nemo
//
//  Created by ksyun on 17/4/20.
//  Copyright © 2017年 com.ksyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KMCFuFilter/KMCFilter.h>

@interface StickerCell : UICollectionViewCell

@property(nonatomic,strong)KMCArMaterial * material;

-(void)downloadMaterial;
@end
