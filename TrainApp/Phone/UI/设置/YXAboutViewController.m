//
//  YXAboutViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXAboutViewController.h"
#import "YXAboutHeaderView.h"
#import "YXAboutCell.h"
#import "YXActionSheet.h"
#import "YXAlertView.h"
#import "YXWebViewController.h"
static  NSString *const trackPageName = @"关于我们页面";
@interface YXAboutViewController ()
<
  UITableViewDelegate,
  UITableViewDataSource,
  YXAboutCellDelegate
>
{
    UITableView *_tableView;
    NSString *_phoneString;
}

@end

@implementation YXAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关于我们";
    _phoneString = YXTrainServiceTelephone;
    [self setupUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:YES];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:NO];
    self.navigationController.navigationBar.shadowImage = [UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f6fa"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Setting
- (void)setupUI{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.layoutMargins = UIEdgeInsetsZero;
    _tableView.scrollEnabled = NO;
    [_tableView registerClass:[YXAboutCell class] forCellReuseIdentifier:@"YXAboutCell"];
    [self.view addSubview:_tableView];
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    YXAboutHeaderView *headerView = [[YXAboutHeaderView alloc] init];
    headerView.frame = CGRectMake(0, 0, 320.0f, 300/667.0f * height);
    _tableView.tableHeaderView = headerView;
    
    
    UIButton *footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    footerButton.frame = CGRectMake(0, 0, 150, 30.0f);
    footerButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    footerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [footerButton setTitle:@"使用条款和隐私策略" forState:UIControlStateNormal];
    [footerButton setTitleColor:[UIColor colorWithHexString:@"a53027"] forState:UIControlStateNormal];
    [footerButton addTarget:self action:@selector(goProvisionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footerButton];
    [footerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(28.0f);
        make.width.mas_equalTo(150.0f);
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-24.0f);
    }];
}

#pragma mark - tableView dataSorce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXAboutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXAboutCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
        cell.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.titleLabel.text = [NSString stringWithFormat:@"官方微信  %@",YXTrainWechatName];
        cell.titleLabel.textAlignment = NSTextAlignmentCenter;
        cell.delegate = self;
    }
    else{
        NSString *phoneString = [NSString stringWithFormat:@"客服电话  %@",_phoneString];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:phoneString];
        [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"334466"]} range:NSMakeRange(0, 4)];
        [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"a53027"]} range:NSMakeRange(5, 13)];
        cell.titleLabel.attributedText = attributeString;
        cell.titleLabel.textAlignment = NSTextAlignmentCenter;
        cell.delegate = nil;
    }
    return cell;
}
#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        YXActionSheet * sheet = [YXActionSheet actionSheetWithTitle:nil];
        NSString * title = [NSString stringWithFormat:@"呼叫:  %@",_phoneString];
        [sheet addDestructiveButtonWithTitle:title action:^{
            NSString *telUrl = [NSString stringWithFormat:@"tel://%@",self->_phoneString];
            if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]]) {
                [YXAlertView showAlertViewWithMessage:@"此设备不支持通话！"];
            }
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            [YXDataStatisticsManger trackEvent:@"客服热线" label:@"客服热线拨打时" parameters:nil];
        }];
        [sheet addCancelButtonWithTitle:@"取消" action:^{
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }];
        [sheet showInView:self.view];

    }
}
#pragma mark -YXAboutTableViewCellDelegate
- (void)showMenu:(id)cell {
    if ([cell isHighlighted]) {
        [cell becomeFirstResponder];
        
        UIMenuController * menu = [UIMenuController sharedMenuController];
        [menu setTargetRect: [cell frame] inView: [self view]];
        [menu setMenuVisible: YES animated: YES];
//        [YXDataStatisticsManger trackEvent:@"官方微信" label:@"成功拷贝官方微信号" parameters:nil];
    }
}

- (void)goProvisionButtonAction:(UIButton *)sender{
    YXWebViewController *provisionVC = [[YXWebViewController alloc] init];
    provisionVC.urlString = YXTrainProtocolAddress;
    provisionVC.titleString = @"服务条款";
    provisionVC.isUpdatTitle = YES;
    [self.navigationController pushViewController:provisionVC animated:YES];
}
@end
