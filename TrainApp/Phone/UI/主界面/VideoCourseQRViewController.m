//
//  VideoCourseQRViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoCourseQRViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "YXScanQRBackgroundView.h"
#import "YXUserProfileRequest.h"
#import "YXUserManager.h"
#import "YXAlertView.h"
#import "VideoCourseDetailViewController.h"
@interface VideoCourseQRViewController ()<AVCaptureMetadataOutputObjectsDelegate>{
    YXScanQRBackgroundView *_scanBackgroundView;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureSession *_session;
    AVCaptureVideoPreviewLayer *_preview;
}
@end

@implementation VideoCourseQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setupLeftBack];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"扫描二维码观看课程";
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied)
    {
        YXAlertView *alertView = [YXAlertView alertViewWithTitle:@"无法访问相机" message:@"请到“设置->隐私->相机”中设置为允许访问相机！"];
        [alertView addButtonWithTitle:@"确定"];
        [alertView show];
    }else if(authStatus == AVAuthorizationStatusNotDetermined)
    {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        if (!self->_session) {
                            [self setupCamera];
                        } else{
                            [self->_session startRunning];
                        }
                    });
                } else {
                    [self dismissViewControllerAnimated:YES completion:^{
                        //
                    }];
                }
            });
        }];
    }else if(authStatus == AVAuthorizationStatusAuthorized){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (!self->_session) {
                [self setupCamera];
            } else{
                [self->_session startRunning];
            }
        });
        
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            //
        }];
    }
    _scanBackgroundView = [[YXScanQRBackgroundView alloc] init];
    _scanBackgroundView.titleString = @"将课程二维码放入扫描框内\n扫描后将自动播放该课程";

    [self.view addSubview:_scanBackgroundView];
    _scanBackgroundView.backgroundColor = [UIColor clearColor];
    [_scanBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)naviLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
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
    if ([[resultURL scheme] isEqualToString:@"http"]) {
        NSString *query = [resultURL query];
        NSDictionary *paraDic = [self urlInfo:query];
        [self registerNotifications];
        if (((NSString *)[paraDic objectForKey:@"courseId"]).length > 0) {
            [_session stopRunning];
            [_scanBackgroundView.scanTimer setFireDate:[NSDate distantFuture]];
            if ( [[YXTrainManager sharedInstance] setupProjectId:[paraDic objectForKey:@"projectId"]]) {
                VideoCourseDetailViewController *vc = [[VideoCourseDetailViewController alloc]init];
                YXCourseListRequestItem_body_module_course *course = [[YXCourseListRequestItem_body_module_course alloc] init];
                course.courses_id = [paraDic objectForKey:@"courseId"];
                vc.course = course;
                vc.seekInteger = [[paraDic objectForKey:@"cInx"] integerValue];
                vc.fromWhere = VideoCourseFromWhere_QRCode;
                [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainCurrentProjectIndex object:[paraDic objectForKey:@"projectId"]];
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                [self showToast:@"没有找到该课程"];
            }
        } else {
            [self showToast:@"无法识别该二维码"];
        }
    } else {
        [self showToast:@"无法识别该二维码"];
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
        self->_preview.frame =CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
        [self.view.layer insertSublayer:self->_preview atIndex:0];
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
    YXAlertView *alertView = [YXAlertView alertViewWithTitle:@"非常抱歉,格式不正确或token已过期,请重新扫描"];
    [alertView addButtonWithTitle:@"返回" action:^{
        [self->_scanBackgroundView.scanTimer invalidate];
        [self dismissViewControllerAnimated:YES completion:^{
            //
        }];
    }];
    [alertView addButtonWithTitle:@"继续扫码" action:^{
        [self->_scanBackgroundView.scanTimer setFireDate:[NSDate date]];
        [self->_session startRunning];
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
            DDLogDebug(@"%@  %@",key, val);
            // 添加到字典中
            [dict setObject:val forKey:key];
        }
    }
    else if([query rangeOfString:@"="].location != NSNotFound){
        // 以等号来分割字符
        NSArray *elements = [query componentsSeparatedByString:@"="];
        NSString *key = [elements objectAtIndex:0];
        NSString *val = [elements objectAtIndex:1];
        DDLogDebug(@"%@  %@",key, val);
        // 添加到字典中
        [dict setObject:val forKey:key];
    }
    return dict;
}
@end
