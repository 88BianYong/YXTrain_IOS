//
//  MasterServiceAgreementViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2018/3/7.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MasterServiceAgreementViewController_17.h"
#import "MasterSignAgreementRequest_17.h"
#import "MasterThemeViewController_17.h"
@interface MasterServiceAgreementViewController_17 ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) NSString *contentString;
@property (nonatomic, strong) MasterSignAgreementRequest_17 *signAgreementRequest;
@end

@implementation MasterServiceAgreementViewController_17

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"中国教师研修网服务协议";
    self.contentString = @"    中国教师研修网（由北京尚睿通教育科技股份有限公司运营）为了更好地开展远程培训工作，为线上学习的老师提供更优质的服务，特邀请您作为本培训项目的辅导教师（坊主）/管理员。请您同研修网一起并肩作战\n辅导教师（坊主）服务内容如下：\n一、准备工作 \n1. 读文件，明要求\n阅读培训实施方案、学习安排和考核要求，了解培训要求，明确工作职责。2. 听视频，明操作\n观看预热课程“小研伴你行：平台操作演示（辅导教师篇）”，熟悉网络环境，明确操作方法。\n3. 建QQ群，助联络\n建立班级（工作坊）QQ群，引导学员加入，建立联络渠道。\n4.理学情，定计划\n了解学员情况，借鉴他人工作经验，制定适合本班（坊）的辅导计划。\n5.根据研修网的安排完成本培训项目的其他工作。\n二、工作职责\n1.传信息，督学情\n通过工作坊公告、QQ群等方式与学员积极沟通，及时传达学习通知、活动安排等；关注本班（坊）学情，及时督促学员上线学习，保证学员的参训率和合格率。\n2.发话题，促研讨\n根据项目实施方案发起或组织话题研讨，引导督促学员参与交流讨论。\n3.批作业，解疑惑\n及时解答学员问题，指导、批阅本坊学员的自荐作业，并推荐优秀作业至项目组。\n4.写简报，享成果\n根据项目方案要求，撰写班级（坊）简报，及时通报学情，培育并分享学习成果。\n5.遵守研修网的各项工作制度。\n管理员服务内容如下：\n一、建章立制\n制订本区域、校（园）项目实施方案。结合本区域、学校（园）实际与项目要求，制定组织管理、考核激励等制度和办法，将本次学员和指导教师的培训纳入本地继续教育管理，并给予学时学分认定；提供研修的活动经费、场地、设施、设备及时间等必要保障。\n二、组建团队\n确定分学科（主题）指导团队负责人，分学科（主题）建立教师工作坊。支持并推动工作坊组织跨校主题研修或成果展示、经验交流现场活动。\n三、督促学情\n参与研修网组织的学情通报会，了解项目进展，督促学情，及时回答并解决相关问题。\n四、培育典型\n提炼区域、校（园）工作经验，推出样板学校（园）、样板教师工作坊，遴选并提炼优质生成性资源成果；根据实施方案编写研修简报，包括研修计划、总结。\n五、根据研修网的安排完成本培训项目的其他工作并遵守各项工作制度。\n北京尚睿通教育科技股份有限公司在此非常感谢您给予中国教师研修网的支持！";
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self setupAndLayoutInterface];
    [self setupNavgationLeftView];
    [self setupNavgationRightView];
}
- (void)setupNavgationRightView {
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor colorWithHexString:@"0070c9"] forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor colorWithHexString:@"a1a7ae"] forState:UIControlStateDisabled];
    [confirmButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    confirmButton.frame = CGRectMake(0, 0, 40.0f, 30.0f);
    WEAK_SELF
    [[confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        [self requestForSignAgreement];
    }];
    [self setupRightWithCustomView:confirmButton];
}
- (void)setupNavgationLeftView {
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor colorWithHexString:@"a1a7ae"] forState:UIControlStateNormal];
    [cancleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    cancleButton.frame = CGRectMake(0, 0, 40.0f, 30.0f);
    WEAK_SELF
    [[cancleButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
         [self showAlertView];
    }];
    [self setupLeftWithCustomView:cancleButton];
}

#pragma mark - setupUI
- (void)setupAndLayoutInterface{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.scrollView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.offset(10.0f);
    }];
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.backgroundColor = [UIColor clearColor];
    self.contentLabel.font = [UIFont systemFontOfSize:14.0f];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.contentLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.contentLabel];;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.contentString];
    NSMutableParagraphStyle *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineHeightMultiple:1.2f];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.contentString length])];
    NSRange range1 = [self.contentString rangeOfString:@"辅导教师（坊主）服务内容如下："];
    NSRange range2 = [self.contentString rangeOfString:@"管理员服务内容如下："];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14.0f] range:range1];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14.0f] range:range2];
    self.contentLabel.attributedText = attributedString;
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top).offset(20.0f);
        make.left.equalTo(self.view.mas_left).offset(15.0f);
        make.right.equalTo(self.view.mas_right).offset(-15.0f);
    }];
    CGFloat heightFloat = [self.contentLabel sizeThatFits:CGSizeMake(kScreenWidth - 15.0f - 15.0f , MAXFLOAT)].height;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth - 15.0f - 15.0f, heightFloat + 50.0f);
}
- (void)showAlertView {
    WEAK_SELF
    LSTAlertView *alertView = [[LSTAlertView alloc]init];
    alertView.title = @"确定退出[手机研修]吗?";
    alertView.imageName = @"失败icon";
    [alertView addButtonWithTitle:@"取消" style:LSTAlertActionStyle_Cancel action:^{
        STRONG_SELF
    }];
    [alertView addButtonWithTitle:@"确定" style:LSTAlertActionStyle_Default action:^{
        STRONG_SELF
        [[LSTSharedInstance  sharedInstance].webSocketManger close];
        [[LSTSharedInstance sharedInstance].userManger logout];
        [YXDataStatisticsManger trackEvent:@"退出登录" label:@"成功登出" parameters:nil];
    }];
    [alertView show];
}
#pragma mark - request
- (void)requestForSignAgreement {
    MasterSignAgreementRequest_17 *request = [[MasterSignAgreementRequest_17 alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.roleId = [LSTSharedInstance sharedInstance].trainManager.currentProject.role;
    [self startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            [self showToast:error.localizedDescription];
        }else {
            if ([LSTSharedInstance sharedInstance].trainManager.currentProject.isOpenTheme) {
                WEAK_SELF
                MasterThemeViewController_17 *VC = [[MasterThemeViewController_17 alloc] init];
                VC.masterThemeReloadBlock = ^{
                    STRONG_SELF
                    BLOCK_EXEC(self.masterServiceAgreementReloadBlock);
                };
                [self.navigationController pushViewController:VC animated:YES];
                return;
            }
            BLOCK_EXEC(self.masterServiceAgreementReloadBlock);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    self.signAgreementRequest = request;
}
@end
