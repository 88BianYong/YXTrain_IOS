//
//  DownloadResourceViewController.m
//  TrainApp
//
//  Created by ZLL on 2016/11/18.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "DownloadResourceViewController.h"
#import "ActivityListRequest.h"
#import "ResourceMessageView.h"
#import "DownloadResourceRequest.h"
#import "CommentPageListViewController.h"
@interface DownloadResourceViewController ()
@property (nonatomic, strong) DownloadResourceRequestItem *requestItem;
@property (nonatomic, strong) DownloadResourceRequest *request;
@property (nonatomic, strong) YXDatumCellModel *dataModel;
@property (nonatomic, strong) ResourceMessageView *resourceMessageView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) YXFileItemBase *fileItem;
@end

@implementation DownloadResourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资源下载";
    self.dataModel = [self cachedItem];
    [self setupUI];
    if (self.dataModel) {
        self.resourceMessageView.data = self.dataModel;
    }
    [self requestResource];
}
- (void)setupUI {
    self.emptyView = [[YXEmptyView alloc]init];
    self.emptyView.imageName = @"暂无资源";
    self.emptyView.title = @"没有符合条件的资源";
    WEAK_SELF
    self.errorView = [[YXErrorView alloc]init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self requestResource];
    };
    self.dataErrorView = [[DataErrorView alloc]init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self requestResource];
    };
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self setupBottomView];
    [self setupTopView];
    if (isEmpty(self.dataModel)) {
        self.resourceMessageView.hidden = YES;
    }
}
- (void)setupTopView {
    self.topView = [[UIView alloc]init];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    self.resourceMessageView = [[ResourceMessageView alloc]initWithFrame:CGRectZero];
    [self.topView addSubview:self.resourceMessageView];
    [self.resourceMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view).offset(-22);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kScreenWidthScale(345.0f));
        make.height.mas_equalTo(201);
    }];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.resourceMessageView addGestureRecognizer:tapGesture];
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
    [viewCommentsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [viewCommentsButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0070c9"]] forState:UIControlStateHighlighted];
    viewCommentsButton.layer.cornerRadius = 2.0f;
    viewCommentsButton.layer.borderColor = [UIColor colorWithHexString:@"0070c9"].CGColor;
    viewCommentsButton.layer.borderWidth = 1;
    viewCommentsButton.layer.masksToBounds = YES;
    [viewCommentsButton addTarget:self action:@selector(viewCommentsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:viewCommentsButton];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
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
- (void)requestResource {
    [self.request stopRequest];
    [self startLoading];
    self.request = [[DownloadResourceRequest alloc] init];
    self.request.aid = self.tool.aid;
    self.request.toolId = self.tool.toolid;
    self.request.stageId = self.stageId;
    WEAK_SELF
    [self.request startRequestWithRetClass:[DownloadResourceRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        
        DownloadResourceRequestItem *item = retItem;
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = !isEmpty(item.body.resource);
        data.localDataExist = !isEmpty(self.dataModel);
        data.error = error;
        if ([self handleRequestData:data inView:self.topView]) {
            return;
        }
        self.resourceMessageView.hidden = NO;
        self.requestItem = item;
        [self saveToCache];
        YXDatumCellModel *model = [YXDatumCellModel modelFromDownloadResourceRequestItemBodyResource:item.body.resource];
        self.dataModel = model;
        self.resourceMessageView.data = self.dataModel;
    }];
}
#pragma mark - CommentsButtonAction
- (void)viewCommentsButtonAction:(UIButton *)sender {
    DDLogDebug(@"查看评论");
    CommentPageListViewController *commentVc = [[CommentPageListViewController alloc]init];
    commentVc.tool = self.tool;
    commentVc.status = self.status;
    commentVc.stageId = self.stageId;
    [self.navigationController pushViewController:commentVc animated:YES];
    
}
#pragma mark - tapGesture
-(void)tapGesture:(UITapGestureRecognizer *)sender {
    YXFileType type = [YXAttachmentTypeHelper fileTypeWithTypeName:self.dataModel.type];
    if(type == YXFileTypeUnknown) {
        [self showToast:@"暂不支持该格式文件预览"];
        return;
    }
    YXFileItemBase *fileItem = [FileBrowserFactory browserWithFileType:type];
    fileItem.name = self.dataModel.title;
    fileItem.url = self.dataModel.previewUrl;
    fileItem.baseViewController = self;
    if (!self.dataModel.isFavor) {
        [fileItem addFavorWithData:self.dataModel completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:YXFavorSuccessNotification object:self.dataModel userInfo:nil];
            [self reloadData];
        }];
    }
    [fileItem browseFile];
    self.fileItem = fileItem;
}

- (void)reloadData {
    self.resourceMessageView.data = self.dataModel;
}
#pragma mark - Cache
- (void)saveToCache {
    NSString *cachedJson = [self.requestItem toJSONString];
    NSString *cashedSign = [NSString stringWithFormat:@"%@%@",self.request.aid,self.request.toolId];
    NSDictionary *dict = @{cashedSign:cachedJson};
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"资源下载 cache"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (YXDatumCellModel *)cachedItem {
    NSString *cashedSign = [NSString stringWithFormat:@"%@%@",self.tool.aid,self.tool.toolid];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"资源下载 cache"];
    NSString *cachedJson = dict[cashedSign];
    DownloadResourceRequestItem *item = [[DownloadResourceRequestItem alloc] initWithString:cachedJson error:nil];
    if (!item) {
        return nil;
    }
    self.requestItem = item;
    YXDatumCellModel *model = [YXDatumCellModel modelFromDownloadResourceRequestItemBodyResource:item.body.resource];
    return model;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
