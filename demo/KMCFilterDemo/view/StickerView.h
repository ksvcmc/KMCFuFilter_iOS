//
//  NemoFilterView.h
//  Nemo
//
//  Created by ksyun on 17/4/20.
//  Copyright © 2017年 com.ksyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KMCFuFilter/KMCArMaterial.h>

@protocol StickerViewDelegate <NSObject>

- (void)StickerChanged:(KMCArMaterial*)material;

@end


@interface StickerView : UIView

- (instancetype)initWithType:(int)type;

@property (nonatomic, weak) id <StickerViewDelegate>delegate;

@end
