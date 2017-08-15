//
//  ViewController.m
//  KMCFuFilterDemo
//
//  Created by ksyun on 17/5/12.
//  Copyright © 2017年 ksyun. All rights reserved.
//

#import "streamerViewController.h"
#import <KMCFuFilter/KMCFilter.h>
#import "KSYGPUStreamerKit.h"
#import "FilterManager.h"
#import "filterView.h"
#import "beautyView.h"
#import "sharpView.h"
#import "FilterManager.h"

@interface streamerViewController ()<sharpViewDelegate,filterViewDelegate,beautyViewDelegate,UIGestureRecognizerDelegate>{
    NSTimer *_playbackProgressTimer;
    int time;
}

@property (nonatomic, strong) KSYGPUStreamerKit *streamerKit;
@property (nonatomic, strong) UIButton* startButton;
@property (nonatomic, strong) UIButton* filterButton;
@property (nonatomic, strong) UIButton* beautyButton;
@property (nonatomic, strong) UIButton* sharpButton;
@property (nonatomic, strong) UIView* topView;
@property (nonatomic, strong) filterView * filterView;
@property (nonatomic, strong) beautyView * beautyView;
@property (nonatomic, strong) sharpView * sharpView;
@property (nonatomic, readwrite) BOOL topViewIsShowing;
@property (nonatomic, strong) UILabel* recordLabel;

@end


@implementation streamerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化金山云推流sdk
    [self prepareStreamerKit];

    [self setupUI];
    //初始化手势
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewPressed:)];
    tapGes.delegate = self;
    [self.view addGestureRecognizer:tapGes];
    
    NSNotificationCenter* dc = [NSNotificationCenter defaultCenter];
    [dc addObserver:self
           selector:@selector(onStreamStateChange)
               name:KSYStreamStateDidChangeNotification
             object:nil];
    
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
    //faceunity美颜
    [_streamerKit setupFilter:[FilterManager instance].kmcFitler.filter];
    // 开启预览
    [_streamerKit startPreview:self.view];
}


-(void)setupUI{
    //摄像头切换按钮
    UIButton* switchCameraBtn = [UIButton buttonWithFrame:CGRectMake(0,0,50,50) target:self normal:@"camera" highlited:nil selected:nil selector:@selector(switchCamera:)];
    //推流按钮
    _startButton =[UIButton buttonWithFrame:CGRectMake(kScreenSizeWidth/2-35,kScreenSizeHeight-70-36-kalgoHeight,70,70) target:self normal:@"start" highlited:nil selected:nil selector:@selector(start:)];
    [_startButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateSelected];
    _startButton.frame = CGRectMake(kScreenSizeWidth/2-35,kScreenSizeHeight-70-36-kalgoHeight,70,70);
    //录制按钮
    _recordLabel = [[UILabel alloc] init];
    _recordLabel.font = [UIFont systemFontOfSize:18];
    _recordLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    _recordLabel.backgroundColor = [UIColor colorWithHexString:@"#07080B"];
    _recordLabel.hidden = YES;
    _recordLabel.alpha = 0.7;
    _recordLabel.layer.cornerRadius = 12;
    _recordLabel.layer.masksToBounds = YES;
    _recordLabel.textAlignment = NSTextAlignmentCenter;
    
    //顶部view
    _topView = [[UIView alloc] init];
    _topView.backgroundColor = [UIColor colorWithHexString:@"#07080B"];
    _topView.frame = kBeautyCFGViewHideFrame;
    _topView.alpha = 0.7f;
    _topViewIsShowing = NO;
    
    //滤镜view
    _filterView = [[filterView alloc] init];
    _filterView.delegate = self;
    
    //美颜view
    _beautyView = [[beautyView alloc] init];
    _beautyView.delegate = self;
    _beautyView.slider1.value = [FilterManager instance].kmcFitler.blurLevel;
    _beautyView.label12.text = [NSString stringWithFormat:@"%.2lf",_beautyView.slider1.value];
    _beautyView.slider2.value = [FilterManager instance].kmcFitler.colorLevel;
    _beautyView.label22.text = [NSString stringWithFormat:@"%.2lf",_beautyView.slider2.value];
    _beautyView.slider3.value = [FilterManager instance].kmcFitler.redLevel;
    _beautyView.label32.text = [NSString stringWithFormat:@"%.2lf",_beautyView.slider3.value];
    
    //美型view
    _sharpView = [[sharpView alloc] init];
    _sharpView.delegate = self;
    switch ([FilterManager instance].kmcFitler.faceShape) {
        case 3://默认
            _sharpView.faceButton1.selected = YES;
            break;
        case 0:
            _sharpView.faceButton2.selected = YES;
            break;
        case 1:
            _sharpView.faceButton3.selected = YES;
            break;
        case 2:
            _sharpView.faceButton4.selected = YES;
            break;
        default:
            break;
    }
    _sharpView.slider1.value = [FilterManager instance].kmcFitler.eyeEnlarging;
    _sharpView.label12.text = [NSString stringWithFormat:@"%.2lf",_sharpView.slider1.value];
    _sharpView.slider2.value = [FilterManager instance].kmcFitler.cheekThinning;
    _sharpView.label22.text = [NSString stringWithFormat:@"%.2lf",_sharpView.slider2.value];
    
    //底部view
    UIView *algoView = [[UIView alloc] init];
    algoView.backgroundColor = [UIColor colorWithHexString:@"#18181d"];

    //添加人脸按钮
    _filterButton = [UIButton createButtonwithTitle:@"滤镜" target:self normal:@"filter" highlited:@"Hfilter" selected:@"Hfilter" selector:@selector(filterBtnSelected:)];

    _beautyButton = [UIButton createButtonwithTitle:@"美颜" target:self normal:@"beauty" highlited:@"Hbeauty" selected:@"Hbeauty" selector:@selector(beautyBtnSelected:)];

    _sharpButton = [UIButton createButtonwithTitle:@"美型" target:self normal:@"sharp" highlited:@"Hsharp" selected:@"Hsharp" selector:@selector(sharpBtnSelected:)];

    //addsubview
    [self.view addSubview:switchCameraBtn];
    [self.view addSubview:_startButton];
    [self.view addSubview:_topView];
    [self.view addSubview:_recordLabel];
    [_topView addSubview:_filterView];
    [_topView addSubview:_beautyView];
    [_topView addSubview:_sharpView];
    [self.view addSubview:algoView];
    [algoView addSubview:_filterButton];
    [algoView addSubview:_beautyButton];
    [algoView addSubview:_sharpButton];

    
    [switchCameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(23);
    }];
    
    [_recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(switchCameraBtn.mas_bottom).offset(16);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(38);
    }];
    
    [algoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.mas_equalTo(kalgoHeight);
    }];
    
    [_filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.topView);
    }];
    
    [_beautyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.topView);
    }];
    
    [_sharpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.topView);
    }];
    
    [_filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(algoView);
        make.width.equalTo(algoView.mas_width).multipliedBy(1.0/buttonCount);
    }];
    
    [_beautyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(algoView);
        make.leading.equalTo(_filterButton.mas_trailing);
        make.width.equalTo(algoView.mas_width).multipliedBy(1.0/buttonCount);
    }];
    [_sharpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(algoView);
        make.leading.equalTo(_beautyButton.mas_trailing);
        make.width.equalTo(algoView.mas_width).multipliedBy(1.0/buttonCount);
    }];
}

-(void)switchCamera:(UIButton* )sender{
    if(_streamerKit)
        [_streamerKit switchCamera];
}

-(void)start:(UIButton* )sender{
    UIButton* button = (UIButton*) sender;
    if(button.selected){
        button.selected = NO;
        [self stopTimer];
        [_streamerKit.streamerBase stopStream];
        if(_localRecord)
            [self saveToPhotoLibrary];
    }else{
        button.selected = YES;
        [_streamerKit.streamerBase startStream:[NSURL URLWithString:self.streamerUrl]];
    }
}


-(void)filterBtnSelected:(UIButton* )sender{
    _filterButton.selected = YES;
    if (!_topViewIsShowing) {
        @WeakObj(self);
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakself.topView.frame = kBeautyCFGViewShowFrame;
        } completion:^(BOOL finished) {
            weakself.topViewIsShowing = YES;
        }];
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakself.startButton.frame = CGRectMake(kScreenSizeWidth/2-35,kScreenSizeHeight-70-36-kalgoHeight-kEffectCFGViewHeight,70,70);
        } completion:^(BOOL finished) {
        }];
    }
    [self btnSelected:sender];
}

-(void)beautyBtnSelected:(UIButton* )sender{
    _beautyButton.selected = YES;
    if (!_topViewIsShowing) {
        @WeakObj(self);
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakself.topView.frame = kBeautyCFGViewShowFrame;
        } completion:^(BOOL finished) {
            weakself.topViewIsShowing = YES;
        }];
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakself.startButton.frame = CGRectMake(kScreenSizeWidth/2-35,kScreenSizeHeight-70-36-kalgoHeight-kEffectCFGViewHeight,70,70);
        } completion:^(BOOL finished) {
        }];
    }
    [self btnSelected:sender];
}


-(void)sharpBtnSelected:(UIButton* )sender{
    _sharpButton.selected = YES;
    if (!_topViewIsShowing) {
        @WeakObj(self);
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakself.topView.frame = kBeautyCFGViewShowFrame;
        } completion:^(BOOL finished) {
            weakself.topViewIsShowing = YES;
        }];
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakself.startButton.frame = CGRectMake(kScreenSizeWidth/2-35,kScreenSizeHeight-70-36-kalgoHeight-kEffectCFGViewHeight,70,70);
        } completion:^(BOOL finished) {
        }];
    }
    [self btnSelected:sender];
}

-(void)btnSelected:(UIButton* )sender{
    
    if(sender == _filterButton){
        _filterButton.selected = YES;
        _beautyButton.selected = NO;
        _sharpButton.selected = NO;
        _filterView.hidden = NO;
        _beautyView.hidden = YES;
        _sharpView.hidden = YES;
    }else if(sender == _beautyButton){
        _filterButton.selected = NO;
        _beautyButton.selected = YES;
        _sharpButton.selected = NO;
        _filterView.hidden = YES;
        _beautyView.hidden = NO;
        _sharpView.hidden = YES;
    }else if(sender == _sharpButton){
        _filterButton.selected = NO;
        _beautyButton.selected = NO;
        _sharpButton.selected = YES;
        _filterView.hidden = YES;
        _beautyView.hidden = YES;
        _sharpView.hidden = NO;
    }
}


- (void)bgViewPressed:(UITapGestureRecognizer *)tapGes{
    if (_topViewIsShowing) {
        @WeakObj(self);
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakself.topView.frame = kBeautyCFGViewHideFrame;
        } completion:^(BOOL finished) {
            weakself.topViewIsShowing = NO;
        }];
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakself.startButton.frame = CGRectMake(kScreenSizeWidth/2-35,kScreenSizeHeight-70-36-kalgoHeight,70,70);
        } completion:^(BOOL finished) {
        }];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer* )gestureRecognizer shouldReceiveTouch:(UITouch*)
touch
{
    if (touch.view.superview.superview ==self.filterView.filterConfigView || touch.view.superview.superview.superview == self.filterView.filterConfigView || touch.view.superview == self.filterView.filterConfigView || touch.view == self.filterView.filterConfigView) {
        return NO;
    }
    
    if (touch.view.superview.superview ==self.beautyView || touch.view.superview.superview.superview == self.beautyView || touch.view.superview == self.beautyView || touch.view == self.beautyView) {
        return NO;
    }
    if (touch.view.superview.superview ==self.sharpView || touch.view.superview.superview.superview == self.sharpView || touch.view.superview == self.sharpView || touch.view == self.sharpView) {
        return NO;
    }
    return YES;
}

#pragma filterViewDelegate
- (void)specialEffectFilterChanged:(int) effectIndex{
     //"nature", "delta", "electric", "slowlived", "tokyo", "warm"
    switch (effectIndex) {
        case 0:
            [[FilterManager instance].kmcFitler setFilterType:@"nature"];
            break;
        case 1:
            [[FilterManager instance].kmcFitler setFilterType:@"delta"];
            break;
        case 2:
            [[FilterManager instance].kmcFitler setFilterType:@"electric"];
            break;
        case 3:
            [[FilterManager instance].kmcFitler setFilterType:@"slowlived"];
            break;
        case 4:
            [[FilterManager instance].kmcFitler setFilterType:@"tokyo"];
            break;
        case 5:
            [[FilterManager instance].kmcFitler setFilterType:@"warm"];
            break;
        default:
            [[FilterManager instance].kmcFitler setFilterType:@"nature"];
            break;
    }
}

- (void) onStreamStateChange {
    if(_streamerKit.streamerBase.streamState == KSYStreamStateConnected){
        //设置录制时间
        [self startTimer];
        if(_localRecord){
            NSLog(@"录制到本地");
            [self startRecordToLocalFile];
        }
    }
}

#pragma 本地录制
-(void)startRecordToLocalFile{
    BOOL bRec = _streamerKit.streamerBase.bypassRecordState == KSYRecordStateRecording;
    if ( _streamerKit.streamerBase.isStreaming && !bRec){
        // 如果启动录像时使用和上次相同的路径,则会覆盖掉上一次录像的文件内容
        NSString *ourDocumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES) objectAtIndex:0];
        NSString *FilePath=[ourDocumentPath stringByAppendingPathComponent:@"temp.mp4"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([fileManager fileExistsAtPath:FilePath]){
            [fileManager removeItemAtPath:FilePath error:nil];
        }
        
        NSURL *url =[[NSURL alloc] initFileURLWithPath:FilePath];
        [_streamerKit.streamerBase startBypassRecord:url];
    }
    else {
        NSLog(@"推流过程中才能旁路录像");
    }
}

-(void)startTimer{
    if(_playbackProgressTimer){
        [_playbackProgressTimer invalidate];
        time = 0;
    }
    NSTimeInterval timeInterval = 1;
    _playbackProgressTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                              target:self
                                                            selector:@selector(handleProgressTimer:)
                                                            userInfo:nil
                                                             repeats:YES];
    
}

-(void)stopTimer{
    if(_playbackProgressTimer){
        [_playbackProgressTimer invalidate];
        time = 0;
    }
    self.recordLabel.hidden = YES;
    time = 0;
}

- (void)handleProgressTimer:(NSTimer *)timer {
    self.recordLabel.hidden = NO;
    time++;
    
    int minutes = (int)(time/60);
    int seconds = (int)(time- 60*minutes);
    
    self.recordLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
}

-(void)saveToPhotoLibrary{
    [_streamerKit.streamerBase stopBypassRecord];
    
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHud.mode = MBProgressHUDModeIndeterminate;
    progressHud.labelText = [NSString stringWithFormat:@"保存到相册"];
    progressHud.color = [UIColor colorWithHexString:@"#1a2845"];
    progressHud.dimBackground = YES;
    progressHud.cornerRadius =10;
    
    NSString *ourDocumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES) objectAtIndex:0];
    NSString *FilePath=[ourDocumentPath stringByAppendingPathComponent:@"temp.mp4"];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:FilePath]
                                completionBlock:^(NSURL *assetURL, NSError *error) {
                                    if (error) {
                                        NSLog(@"Save video fail:%@",error);
                                    } else {
                                        NSLog(@"Save video succeed.");
                                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                    }
                                }];
}

#pragma beautyViewDelegate
- (void)colorLevelChanged:(float)value{
    [FilterManager instance].kmcFitler.colorLevel = value;
}
- (void)blurLevelChanged:(float)value{
    [FilterManager instance].kmcFitler.blurLevel = value;
}
- (void)redLevelChanged:(float)value{
    [FilterManager instance].kmcFitler.redLevel = value;

}

#pragma sharpViewDelegate
- (void)sharpChanged:(int)type{
    [FilterManager instance].kmcFitler.faceShape = type;
}
- (void)cheekThinningChanged:(float)value{
    [FilterManager instance].kmcFitler.cheekThinning = value;
}
- (void)eyeEnlargingChanged:(float)value{
    [FilterManager instance].kmcFitler.eyeEnlarging = value;
}

@end
