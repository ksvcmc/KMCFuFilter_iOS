//
//  ViewController.m
//  KMCFuFilter
//
//  Created by ksyun on 2017/8/9.
//  Copyright © 2017年 ksyun. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "UIColor+Expanded.h"
#import "streamerViewController.h"
#import "MBProgressHUD.h"
#import "NemoAboutView.h"
#import "FilterManager.h"


#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size

#define kScreenSizeHeight (SCREEN_SIZE.height)
#define kScreenSizeWidth (SCREEN_SIZE.width)
#define TOKEID @"40cc5de2e197678ea0f9da1ff70a2672"

@interface ViewController ()

@property (nonatomic, strong) UIImageView * showView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * addressLabel;
@property (nonatomic, strong) UITextField * addressTextField;
@property (nonatomic, strong) UILabel * saveLabel;
@property (nonatomic, strong) UISwitch * saveSwitch;
@property (nonatomic, strong) UIButton * beautyButton;
@property (nonatomic, strong) UIButton * helpButton;
@property (nonatomic, assign) BOOL localRecord;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewDidPressed)];
    [self.view addGestureRecognizer:tapGes];
    
    [self Auth];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)setupUI{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#18181d"];
    _showView = [[UIImageView alloc] init];
    _showView.image = [UIImage imageNamed:@"首页展示"];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"faceunity Demo(美颜)";
    _titleLabel.font = [UIFont systemFontOfSize:20];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    _addressLabel = [[UILabel alloc] init];
    _addressLabel.text = @"推流地址";
    _addressLabel.font = [UIFont systemFontOfSize:16];
    _addressLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    _addressTextField = [[UITextField alloc] init];
    _addressTextField.backgroundColor = [UIColor colorWithHexString:@"#2e2e35"];
    _addressTextField.layer.cornerRadius = 4;
    _addressTextField.textColor =[UIColor colorWithHexString:@"#686877"];
    NSString * uuidStr =[[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *devCode  = [[uuidStr substringToIndex:3] lowercaseString];
    NSString *streamSrv  = @"rtmp://120.92.224.235/live";
    NSString *streamUrl      = [ NSString stringWithFormat:@"%@/%@", streamSrv, devCode];
    _addressTextField.text = streamUrl;
    
    _saveLabel = [[UILabel alloc] init];
    _saveLabel.text = @"保存本地";
    _saveLabel.font = [UIFont systemFontOfSize:16];
    _saveLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    _saveSwitch = [[UISwitch alloc] init];
    [_saveSwitch addTarget:self action:@selector(switchChangeValue:) forControlEvents:UIControlEventValueChanged];
    
    _beautyButton = [[UIButton alloc] init];
    _beautyButton.backgroundColor = [UIColor clearColor];
    [_beautyButton setTitle:@"体验美颜" forState:UIControlStateNormal];
    [_beautyButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    _beautyButton.layer.cornerRadius = 22;
    _beautyButton.layer.borderWidth = 1;
    _beautyButton.layer.borderColor = [UIColor colorWithHexString:@"#979797"].CGColor;
    [_beautyButton addTarget:self action:@selector(startSteamer) forControlEvents:UIControlEventTouchUpInside];
    
    _helpButton = [[UIButton alloc] init];
    [_helpButton setImage:[UIImage imageNamed:@"help"] forState:UIControlStateNormal];
    [_helpButton setTitle:@"Demo说明" forState:UIControlStateNormal];
    [_helpButton setTintColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    [_helpButton addTarget:self action:@selector(help) forControlEvents:UIControlEventTouchUpInside];
    _helpButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);

    
    [self.view addSubview:_showView];
    [self.view addSubview:_titleLabel];
    [self.view addSubview:_addressLabel];
    [self.view addSubview:_addressTextField];
    [self.view addSubview:_saveLabel];
    [self.view addSubview:_saveSwitch];
    [self.view addSubview:_beautyButton];
    [self.view addSubview:_helpButton];

    [_showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.view);
        make.height.mas_equalTo(156);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(116);
        make.centerX.equalTo(self.view);
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showView.mas_bottom).offset(25);
        make.leading.equalTo(self.view).offset(28);
    }];
    
    [_addressTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_bottom).offset(20);
        make.leading.equalTo(self.view).offset(28);
        make.trailing.equalTo(self.view).offset(-28);
        make.height.mas_equalTo(60);
    }];
    
    [_saveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressTextField.mas_bottom).offset(33);
        make.leading.equalTo(self.view).offset(28);
    }];
    
    [_saveSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressTextField.mas_bottom).offset(28);
        make.leading.equalTo(self.saveLabel.mas_trailing).offset(14);
        make.centerY.equalTo(self.saveLabel);
    }];
    
    [_beautyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.saveSwitch.mas_bottom).offset(36);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(200);
    }];
    
    [_helpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-27);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(150);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startSteamer{
    streamerViewController * vc = [[streamerViewController alloc] init];
    vc.streamerUrl = _addressTextField.text;
    vc.localRecord = self.localRecord;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)help{
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    hud.color = [UIColor colorWithHexString:@"#18181d" alpha:0.4];
    [self.view.window addSubview:hud];
    hud.mode = MBProgressHUDModeCustomView;
    NemoAboutView *aboutView = [[NemoAboutView alloc] initWithFrame:self.view.window.bounds];
    aboutView.hud = hud;
    hud.customView = aboutView;
    hud.frame = CGRectMake(0, 0, kScreenSizeWidth, kScreenSizeHeight);
    [hud show:YES];
}

-(void)bgViewDidPressed{
    [self.addressTextField resignFirstResponder];
}

-(void)Auth{
    [[FilterManager instance] setupWithTokeID:TOKEID Onsuccess:^{
        NSLog(@"获取列表成功，设置UI");
        
    }];
}

-(void)switchChangeValue:(id)sender{
    UISwitch* myswitch = (UISwitch *)sender;
    self.localRecord = myswitch.on;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
