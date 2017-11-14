//
//  ActivityEnclosureViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/22.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityEnclosureViewController.h"
#import "ResourceMessageView.h"
@interface ActivityEnclosureViewController ()
@property (nonatomic, strong) ResourceMessageView *resourceMessageView;
@property (nonatomic, strong) YXDatumCellModel *dataModel;
@property (nonatomic, strong) YXFileItemBase *fileItem;
@end

@implementation ActivityEnclosureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附件";
    [self setupUI];
    [self setupLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupUI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.resourceMessageView = [[ResourceMessageView alloc]initWithFrame:CGRectMake((kScreenWidth - 345) *  0.5,(kScreenHeight - 144 - 201) * 0.5, 345, 201)];
    self.dataModel = [YXDatumCellModel modelFromActivityToolVideoRequestItemBodyResource:self.content];
    self.resourceMessageView.data = self.dataModel;
    [self.view addSubview:self.resourceMessageView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTapsRequired = 1; //点击次数
    [self.resourceMessageView addGestureRecognizer:tapGesture];
    
}
- (void)setupLayout {
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.resourceMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15.0f);
        make.right.equalTo(self.view.mas_right).offset(-15.0f);
        make.height.equalTo(self.resourceMessageView.mas_width).multipliedBy(402.0f/690.0f);
        make.centerY.equalTo(self.view.mas_centerY).offset(-32.0f);
    }];
}

-(void)tapGesture:(UITapGestureRecognizer *)sender {
    YXDatumCellModel *data = self.dataModel;
    YXFileType type = [YXAttachmentTypeHelper fileTypeWithTypeName:data.type];
    if(type == YXFileTypeUnknown) {
        [self showToast:@"暂不支持该格式文件预览"];
        return;
    }
    YXFileItemBase *fileItem = [FileBrowserFactory browserWithFileType:type];
    fileItem.name = data.title;
    fileItem.url = data.previewUrl;
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
@end
