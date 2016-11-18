//
//  ResourcesDownloadViewController.m
//  TrainApp
//
//  Created by ZLL on 2016/11/18.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ResourcesDownloadViewController.h"
#import "ResourceMessageView.h"
#import "ActivityListRequest.h"
#import "ResourcesDownloadRequest.h"
@interface ResourcesDownloadViewController ()
@property (nonatomic, strong) ResourcesDownloadRequest *request;
@property (nonatomic, strong) YXDatumCellModel *dataModel;
@property (nonatomic, strong) ResourceMessageView *resourceMessageView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) ResourcesDownloadRequest *page0RetItem;
@end

@implementation ResourcesDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.tool.title;
    [self setupUI];
//    [self requestResource];
    // Do any additional setup after loading the view.
}
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.resourceMessageView = [[ResourceMessageView alloc]initWithFrame:CGRectMake((kScreenWidth - 345) *  0.5,(kScreenHeight - 144 - 201) * 0.5, 345, 201)];
    [self.view addSubview:self.resourceMessageView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTapsRequired = 1; //点击次数
//    tapGesture.numberOfTouchesRequired = 1; //点击手指数
    [self.resourceMessageView addGestureRecognizer:tapGesture];
    [self setupBottomView];
}
- (void)setupBottomView {
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"f2f4f7"];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"d0d2d5"];
    [self.bottomView addSubview:lineView];
    
    UIButton *viewCommentsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    viewCommentsButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [viewCommentsButton setTitle:@"查看评论" forState:UIControlStateNormal];
    [viewCommentsButton setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
    viewCommentsButton.layer.cornerRadius = 2.0f;
    viewCommentsButton.layer.borderColor = [UIColor colorWithHexString:@"0070c9"].CGColor;
    viewCommentsButton.layer.borderWidth = 1;
    viewCommentsButton.layer.masksToBounds = YES;
    [viewCommentsButton addTarget:self action:@selector(viewCommentsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewCommentsButton addTarget:self action:@selector(changeViewCommentsButtonAction:) forControlEvents:UIControlEventTouchDown];
    [self.bottomView addSubview:viewCommentsButton];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.bottomView);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
    [viewCommentsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bottomView);
        make.size.mas_equalTo(CGSizeMake(170, 32));
    }];
}
- (void)viewCommentsButtonAction:(UIButton *)sender {
    DDLogDebug(@"查看评论");
    sender.backgroundColor = [UIColor clearColor];
    [sender setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
}
- (void)changeViewCommentsButtonAction:(UIButton *)sender {
    sender.backgroundColor = [UIColor colorWithHexString:@"0070c9"];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//轻击手势触发方法
-(void)tapGesture:(UITapGestureRecognizer *)sender
{
    //your code
    DDLogDebug(@"点击");
}
- (void)requestResource {
    self.request = [[ResourcesDownloadRequest alloc] init];
    self.request.aid = self.tool.aid;
    self.request.toolId = self.tool.toolid;
    self.request.w = [YXTrainManager sharedInstance].currentProject.w;
    WEAK_SELF
    [self.request startRequestWithRetClass:[ResourcesDownloadRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            return;
        }
//            self.page0RetItem = retItem;
//            [self saveToCache];
//        }
        YXDatumCellModel *model = [YXDatumCellModel modelFromResourceDownloadRequestItemBodyResource:retItem];
        self.dataModel = model;
    }];
    
}
//- (void)saveToCache {
//    // 只cache第一页结果
//    NSString *cachedJson = [self.page0RetItem toJSONString];
//    [[NSUserDefaults standardUserDefaults] setObject:cachedJson forKey:@"资源分享 first page cache"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

//- (NSArray *)cachedItemArray {
//    NSString *cachedJson = [[NSUserDefaults standardUserDefaults] objectForKey:@"资源分享 first page cache"];
//    ShareResourcesRequestItem *item = [[ShareResourcesRequestItem alloc] initWithString:cachedJson error:nil];
//    self.page0RetItem = item;
//    if (!item) {
//        return nil;
//    }
//    NSMutableArray *array = [NSMutableArray array];
//    for (ShareResourcesRequestItem_body_resource *resource in item.body.resources) {
//        YXDatumCellModel *model = [YXDatumCellModel modelFromShareResourceRequestItemBodyResource:resource];
//        [array addObject:model];
//    }
//    return [NSArray arrayWithArray:array];
//}

@end
