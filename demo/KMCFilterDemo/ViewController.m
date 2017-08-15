//
//  ViewController.m
//  KMCFuFilterDemo
//
//  Created by ksyun on 17/5/12.
//  Copyright © 2017年 ksyun. All rights reserved.
//

#import "ViewController.h"
#import <KMCFuFilter/KMCFilter.h>
#import "KSYGPUStreamerKit.h"
#import "FilterManager.h"
#import "StickerView.h"
#import "UIColor+Expanded.h"
#import "UIButton+init.h"
#import "Masonry.h"
#import "FilterManager.h"
#import "MBProgressHUD.h"

#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size

#define kScreenSizeHeight (SCREEN_SIZE.height)
#define kScreenSizeWidth (SCREEN_SIZE.width)
#define kalgoHeight 49
#define kEffectCFGViewHeight 98
#define FONT(value) [UIFont systemFontOfSize:value]
#define kBeautyCFGViewHideFrame CGRectMake(0, kScreenSizeHeight, kScreenSizeWidth, kEffectCFGViewHeight)
#define kBeautyCFGViewShowFrame CGRectMake(0, kScreenSizeHeight - kEffectCFGViewHeight- kalgoHeight, kScreenSizeWidth, kEffectCFGViewHeight)
#define RGBCOLOR(r,g,b)                      [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define kWhiteColor         RGBCOLOR(255,255,255)


#define WeakObj(o) autoreleasepool{} __weak typeof(o) weak##o = o;
#define kGetAkURI       @"https://kmc.api.ksyun.com?APIAction=GetAuthInfo&Action=GetDemoAKSign&Version=2017-05-31"

#ifdef FUFILTER
#define buttonCount 1
#define TOKEID @"bd5f5bb6bbbd33360645a7eaee517ac0"
#endif

#ifdef STFILTER
#define buttonCount 2
#define TOKEID @"98e1692a90e3c404201391208e0346f2"
#endif


@interface ViewController ()<StickerViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) KSYGPUStreamerKit *streamerKit;
@property (nonatomic, strong) UIButton* faceButton;
@property (nonatomic, strong) StickerView * faceView;
@property (nonatomic, readwrite) BOOL faceViewIsShowing;
#ifdef STFILTER
@property (nonatomic, strong) UIButton* actionButton;
@property (nonatomic, strong) StickerView * actionView;
@property (nonatomic, readwrite) BOOL actionViewIsShowing;

#endif

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化金山云推流sdk
    [self prepareStreamerKit];
    //鉴权，完成后初始化UI，因为拿meterail需要时间
    [self Auth];
    //初始化手势
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewPressed:)];
    tapGes.delegate = self;
    [self.view addGestureRecognizer:tapGes];
}

- (void)prepareStreamerKit{
    
    _streamerKit = [[KSYGPUStreamerKit alloc] initWithDefaultCfg];
    //采集参数
    _streamerKit.capPreset           = AVCaptureSessionPreset640x480;
    _streamerKit.previewDimension   = CGSizeMake(640, 360);
    _streamerKit.videoOrientation   = UIInterfaceOrientationPortrait;
    _streamerKit.streamOrientation  = UIInterfaceOrientationPortrait;
    _streamerKit.previewOrientation = UIInterfaceOrientationPortrait;
    _streamerKit.capturePixelFormat   = kCVPixelFormatType_32BGRA;
    //推流参数
    _streamerKit.streamerBase.videoCodec = KSYVideoCodec_AUTO;
    _streamerKit.streamerBase.bwEstimateMode = KSYBWEstMode_Default;
    _streamerKit.streamerBase.audioCodec = KSYAudioCodec_AAC_HE;
    //基础美颜
    KSYBeautifyProFilter* beautyFilter = [[KSYBeautifyProFilter alloc] init];
    beautyFilter.grindRatio  = 0.5;
    beautyFilter.whitenRatio = 0.5;
    beautyFilter.ruddyRatio  = 0.5;
    [_streamerKit setupFilter:beautyFilter];
    // 开启预览
    [_streamerKit startPreview:self.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_streamerKit.streamerBase startStream:[NSURL URLWithString:@"rtmp://test.uplive.ksyun.com/live/456"]];
    });
}

-(void)Auth{
    [[FilterManager instance] setupWithTokeID:TOKEID Onsuccess:^{
            NSLog(@"获取列表成功，设置UI");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupUI];
            });
        }];
}

-(void)setupUI{
    //摄像头切换按钮
    UIButton* switchCameraBtn = [UIButton buttonWithFrame:CGRectMake(0,0,50,50) target:self normal:@"camera" highlited:nil selected:nil selector:@selector(switchCamera:)];
    //人脸view
    _faceView = [[StickerView alloc] initWithType:0];
    _faceView.delegate = self;
    _faceView.frame = kBeautyCFGViewHideFrame;
    _faceView.userInteractionEnabled = YES;
    
    //底部view
    UIView *algoView = [[UIView alloc] init];
    algoView.backgroundColor = kWhiteColor;

    //添加人脸按钮
    _faceButton = [UIButton createButtonwithTitle:@"人脸贴纸" target:self normal:@"人物" highlited:@"H人物" selected:@"H人物" selector:@selector(faceBtnSelected:)];

    //addsubview
    [self.view addSubview:_faceView];
    [self.view addSubview:switchCameraBtn];
    [self.view addSubview:algoView];
    [algoView addSubview:_faceButton];
    
    [switchCameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(23);
    }];
    
    [algoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.mas_equalTo(kalgoHeight);
    }];
    
    [_faceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(algoView);
        make.width.equalTo(algoView.mas_width).multipliedBy(1.0/buttonCount);
    }];

//商汤有动作贴纸
#ifdef STFILTER
    //动作view
    _actionView = [[StickerView alloc] initWithType:1];
    _actionView.delegate = self;
    _actionView.frame = kBeautyCFGViewHideFrame;
    _actionView.userInteractionEnabled = YES;
    
    //添加动作按钮
    _actionButton = [UIButton createButtonwithTitle:@"动作贴纸" target:self normal:@"动作" highlited:@"H动作" selected:@"H动作" selector:@selector(actionBtnSelected:)];
    [self.view addSubview:_actionView];
    [algoView addSubview:_actionButton];

    [_actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(algoView);
        make.leading.equalTo(_faceButton.mas_trailing);
        make.width.equalTo(algoView.mas_width).multipliedBy(1.0/buttonCount);
    }];
#endif
}

#ifdef STFILTER

-(void)actionBtnSelected:(UIButton* )sender{
    _faceButton.selected = NO;
    _actionButton.selected = YES;
    if (!_actionViewIsShowing) {
        @WeakObj(self);
        weakself.faceView.frame = kBeautyCFGViewHideFrame;
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakself.actionView.frame = kBeautyCFGViewShowFrame;
        } completion:^(BOOL finished) {
            weakself.faceViewIsShowing = NO;
            weakself.actionViewIsShowing = YES;
        }];
    }

}
#endif

-(void)switchCamera:(UIButton* )sender{
    if(_streamerKit)
        [_streamerKit switchCamera];
}

-(void)faceBtnSelected:(UIButton* )sender{
    _faceButton.selected = YES;
    if (!_faceViewIsShowing) {
        @WeakObj(self);
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakself.faceView.frame = kBeautyCFGViewShowFrame;
        } completion:^(BOOL finished) {
            weakself.faceViewIsShowing = YES;
        }];
    }
#ifdef STFILTER
    _actionButton.selected = NO;
    if(_actionViewIsShowing){
        @WeakObj(self);
        weakself.actionView.frame = kBeautyCFGViewHideFrame;
        weakself.actionViewIsShowing = NO;
    }
#endif

}

- (void)bgViewPressed:(UITapGestureRecognizer *)tapGes{
    if (_faceViewIsShowing) {
        @WeakObj(self);
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakself.faceView.frame = kBeautyCFGViewHideFrame;
        } completion:^(BOOL finished) {
            weakself.faceViewIsShowing = NO;
        }];
    }
#ifdef STFILTER
    if(_actionViewIsShowing){
        @WeakObj(self);
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakself.actionView.frame = kBeautyCFGViewHideFrame;
        } completion:^(BOOL finished) {
            weakself.actionViewIsShowing = NO;
        }];
    }
#endif

  
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)StickerChanged:(KMCArMaterial*)material{
    if(material){

        if(material.strTriggerActionTip && material.strTriggerActionTip.length != 0){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.color = [UIColor clearColor];
            hud.labelText = material.strTriggerActionTip;
            hud.labelColor = [UIColor colorWithHexString:@"#FFFFFF"];
            hud.labelFont = FONT(24);
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            });
        }
        
        if([[FilterManager instance].kmcFitler isMaterialDownloaded:material]){
            [[FilterManager instance].kmcFitler startShowingMaterial:material];
        }
        [_streamerKit setupFilter:[FilterManager instance].kmcFitler.filter];
    }else{
        KSYBeautifyProFilter* beautyFilter = [[KSYBeautifyProFilter alloc] init];
        beautyFilter.grindRatio  = 0.5;
        beautyFilter.whitenRatio = 0.5;
        beautyFilter.ruddyRatio  = 0.5;
        [_streamerKit setupFilter:beautyFilter];
    }
  
}

#pragma UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer* )gestureRecognizer shouldReceiveTouch:(UITouch*)
touch
{
    NSString* superClass = NSStringFromClass(touch.view.superview.superview.superview.class);
    if ([superClass isEqualToString:@"UICollectionView"]) {
        return NO;
    }
    return YES;
}

@end
