//
//  YXLoginByScanQRViewController.m
//  YanXiuApp
//
//  Created by 李五民 on 15/10/10.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXLoginByScanQRViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "YXScanQRBackgroundView.h"
//#import "YXLoginTopBarView.h"
//#import "UIViewController+YXNavigationItem.h"
//#import "UIImage+YXImage.h"
//#import "YXLoginWithLearningCodeViewController.h"
//#import "AppDelegate.h"
//#import "NSString+YXString.h"
#import "YXUserProfileRequest.h"
#import "YXUserManager.h"
#import "YXAlertView.h"

@interface YXLoginByScanQRViewController ()<AVCaptureMetadataOutputObjectsDelegate>{
    YXScanQRBackgroundView *_scanBackgroundView;
    //YXLoginTopBarView *_topBarView;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureSession *_session;
    AVCaptureVideoPreviewLayer *_preview;
}
@end

@implementation YXLoginByScanQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setupLeftBack];
    self.view.backgroundColor = [UIColor blackColor];
//    [self yx_setupLeftBackBarButtonItem];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage yx_createImageWithColor:[UIColor clearColor]]];
   // self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.title = @"扫描二维码登录";

    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied)
    {
//        YXAlertView *alertView = [YXAlertView alertViewWithTitle:@"无法访问相机" message:@"请到“设置->隐私->相机”中设置为允许访问相机！"];
//        [alertView addButtonWithTitle:@"确定"];
//        [alertView show];
    }else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (!_session) {
                [self setupCamera];
            } else{
                [_session startRunning];
            }
        });
        
    }
    _scanBackgroundView = [[YXScanQRBackgroundView alloc] init];
    [self.view addSubview:_scanBackgroundView];
    _scanBackgroundView.backgroundColor = [UIColor clearColor];
    [_scanBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];    
}

- (void)naviLeftAction {
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_scanBackgroundView.scanTimer) {
        [_scanBackgroundView.scanTimer invalidate];
    }
    if (_session) {
        [_session stopRunning];
        _session = nil;
    }
    if (_preview) {
        [_preview removeFromSuperlayer];
        _preview = nil;
    }
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    NSURL *resultURL = [NSURL URLWithString:stringValue];
    if ([[resultURL scheme] isEqualToString:@"srtAction"]) {
        NSString *query = [resultURL query];
        NSDictionary *paraDic = [self urlInfo:query];
        [self registerNotifications];
        if (((NSString *)[paraDic objectForKey:@"token"]).length > 0) {
            [_session stopRunning];
            [_scanBackgroundView.scanTimer setFireDate:[NSDate distantFuture]];
            [YXUserManager sharedManager].userModel.token = [paraDic objectForKey:@"token"];
            [[YXUserProfileHelper sharedHelper] requestCompeletion:^(NSError *error) {
                [self removeNotifications];
                if (error) {
                    double delayInSeconds = 1.f;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [_session startRunning];
                        [_scanBackgroundView.scanTimer setFireDate:[NSDate date]];
                    });
                    [self showToast:error.localizedDescription];
                    return;
                }
                [self saveUserDataAndLogin];
                //[self dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    }
}

#pragma mark - Private

- (void)saveUserDataAndLogin
{
    YXUserModel *userModel = [YXUserManager sharedManager].userModel;
    userModel.uid = userModel.profile.uid;
    userModel.uname = userModel.profile.name;
    userModel.head = userModel.profile.head;
    [[YXUserManager sharedManager] login];
}

- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if(_device == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"未检测到相机" message:@"请检查相机设备是否正常" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return ;
    }
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //限制扫描区域（上左下右）
    [ _output setRectOfInterest : CGRectMake ( 50 / [UIScreen mainScreen].bounds.size.height ,50/ [UIScreen mainScreen].bounds.size.width , (self.view.bounds.size.width - 100) /[UIScreen mainScreen].bounds.size.height , (self.view.bounds.size.width - 100) / [UIScreen mainScreen].bounds.size.width)];
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:_input])
    {
        [_session addInput:_input];
    }
    if ([_session canAddOutput:_output])
    {
        [_session addOutput:_output];
    }
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    // Preview
    dispatch_async(dispatch_get_main_queue(), ^{
        _preview.frame =CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
        [self.view.layer insertSublayer:_preview atIndex:0];
    });
    [_session startRunning];
}
- (void)registerNotifications
{
    [self removeNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scanLoginFail)
                                                 name:YXUserLogoutSuccessNotification
                                               object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)scanLoginFail{
    YXAlertView *alertView = [YXAlertView alertViewWithTitle:@"非常抱歉，格式不正确或token已过期，请重新扫描"];
    [alertView addButtonWithTitle:@"返回" action:^{
        [_scanBackgroundView.scanTimer invalidate];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertView addButtonWithTitle:@"继续扫码" action:^{
        [_scanBackgroundView.scanTimer setFireDate:[NSDate date]];
        [_session startRunning];
    }];
    [alertView show];
    [self removeNotifications];
}

#pragma mark- 链接内容
- (NSDictionary *)urlInfo:(NSString *)query{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    // 检测字符串中是否包含 ‘&’
    if([query rangeOfString:@"&"].location != NSNotFound){
        // 以 & 来分割字符，并放入数组中
        NSArray *pairs = [query componentsSeparatedByString:@"&"];
        // 遍历字符数组
        for (NSString *pair in pairs) {
            // 以等号来分割字符
            NSArray *elements = [pair componentsSeparatedByString:@"="];
            NSString *key = [elements objectAtIndex:0];
            NSString *val = [elements objectAtIndex:1];
            NSLog(@"%@  %@",key, val);
            // 添加到字典中
            [dict setObject:val forKey:key];
        }
    }
    else if([query rangeOfString:@"="].location != NSNotFound){
        // 以等号来分割字符
        NSArray *elements = [query componentsSeparatedByString:@"="];
        NSString *key = [elements objectAtIndex:0];
        NSString *val = [elements objectAtIndex:1];
        NSLog(@"%@  %@",key, val);
        // 添加到字典中
        [dict setObject:val forKey:key];
    }
    return dict;
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
