//
//  NemoFilterView.h
//  Nemo
//
//  Created by ksyun on 17/4/20.
//  Copyright © 2017年 com.ksyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol filterViewDelegate <NSObject>

- (void)specialEffectFilterChanged:(int) effectIndex;

@end


@interface filterView : UIView

@property (nonatomic, weak) id <filterViewDelegate>delegate;
@property (nonatomic, strong) UICollectionView * filterConfigView;

@end
