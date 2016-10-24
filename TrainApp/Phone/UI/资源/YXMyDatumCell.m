//
//  YXMyDatumCell.m
//  YanXiuApp
//
//  Created by niuzhaowang on 15/9/1.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXMyDatumCell.h"
#import "YXAttachmentTypeHelper.h"
#import "YXStoreLikeProgressView.h"


@interface YXMyDatumCell()

@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, strong) NSMutableArray *disposeArray;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UIView *cellSeperatorView;
@property (nonatomic, strong) YXStoreLikeProgressView *downloadProcessView;

@property (nonatomic, strong) UIView *leftAreaView;

@end

@implementation YXMyDatumCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.disposeArray = [NSMutableArray array];
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    self.selectedBackgroundView = selectedBgView;
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];
    
    self.typeImageView = [[UIImageView alloc]init];
    //self.typeImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.typeImageView];
    
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.font = [UIFont systemFontOfSize:12];
    self.dateLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.dateLabel];
    
    self.sizeLabel = [[UILabel alloc]init];
    self.sizeLabel.font = [UIFont systemFontOfSize:12];
    self.sizeLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.sizeLabel];
    
    self.leftAreaView = [[UIView alloc] init];
    self.leftAreaView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer * tapLeftGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLeftGesture:)];
    [self.leftAreaView addGestureRecognizer:tapLeftGesture];
    [self.contentView addSubview:self.leftAreaView];
    
    self.cellSeperatorView = [[UIView alloc]init];
    self.cellSeperatorView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.contentView addSubview:self.cellSeperatorView];
    
    self.downloadButton = [[UIButton alloc] init];
    [self.downloadButton setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
    self.downloadButton.userInteractionEnabled = NO;
    self.downloadButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.downloadButton.layer.cornerRadius = YXTrainCornerRadii;
    self.downloadButton.layer.borderColor = [UIColor colorWithHexString:@"0e7ac9"].CGColor;
    self.downloadButton.layer.borderWidth = 1;
    self.downloadButton.layer.masksToBounds = YES;
    [self.leftAreaView addSubview:self.downloadButton];
    
    self.downloadProcessView = [[YXStoreLikeProgressView alloc] init];
    self.downloadProcessView.userInteractionEnabled = NO;
    self.downloadProcessView.hidden = YES;
    [self.leftAreaView addSubview:self.downloadProcessView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeImageView.mas_right).offset(13);
        make.top.mas_equalTo(18);
        //make.right.mas_equalTo(-20);
    }];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(11);
        make.bottom.equalTo(self.cellSeperatorView.mas_top).offset(-18);
    }];
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dateLabel.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.dateLabel);
        make.right.mas_lessThanOrEqualTo(20);
    }];
    [self.cellSeperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dateLabel.mas_left);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [self.leftAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.titleLabel.mas_right);
    }];
    [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(22);
        make.size.mas_equalTo(CGSizeMake(44, 22));
    }];
    [self.downloadButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.downloadButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.downloadProcessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.centerX.equalTo(self.downloadButton.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
}

- (void)setCellModel:(YXDatumCellModel *)cellModel{
    _cellModel = cellModel;
    self.titleLabel.text = cellModel.title;
    self.dateLabel.text = cellModel.date;
    self.sizeLabel.text = [BaseDownloader sizeStringForBytes:cellModel.size];
    self.typeImageView.image = cellModel.image;
    [self configCellForDownloadState:cellModel.downloadState];
    [self setupObservers];
}

- (void)setupObservers{
    for (RACDisposable *d in self.disposeArray) {
        [d dispose];
    }
    [self.disposeArray removeAllObjects];
    @weakify(self);
    RACDisposable *r1 = [RACObserve(self.cellModel, downloadState) subscribeNext:^(id x) {
        @strongify(self);
        if (!self) {
            return;
        }
        [self configCellForDownloadState:self.cellModel.downloadState];
    }];
    RACDisposable *r2 = [RACObserve(self.cellModel, downloadedSize) subscribeNext:^(id x) {
        @strongify(self);
        if (!self) {
            return;
        }
        [self updateDownloadProgressWithDownloadedSize:self.cellModel.downloadedSize totalSize:self.cellModel.size];
    }];
    
    [self.disposeArray addObject:r1];
    [self.disposeArray addObject:r2];
}

- (void)configCellForDownloadState:(DownloaderState)state{
    if (state == DownloadStatusFinished) {
        self.downloadProcessView.hidden = YES;
        self.downloadButton.hidden = NO;
        [self.downloadButton setTitleColor:[UIColor colorWithHexString:@"a1a7ae"] forState:UIControlStateNormal];
        self.downloadButton.layer.borderColor = [UIColor colorWithHexString:@"b9bfc7"].CGColor;
        [self.downloadButton setTitle:@"打开" forState:UIControlStateNormal];
        self.leftAreaView.userInteractionEnabled = NO;
    }else if (state == DownloadStatusDownloading){
        self.downloadProcessView.hidden = NO;
        self.downloadButton.hidden = YES;
        self.leftAreaView.userInteractionEnabled = YES;
    }else{
        self.downloadProcessView.hidden = YES;
        self.downloadButton.hidden = NO;
        self.leftAreaView.userInteractionEnabled = YES;
        [self.downloadButton setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
        self.downloadButton.layer.borderColor = [UIColor colorWithHexString:@"0e7ac9"].CGColor;
        [self.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
        YXFileType type = [YXAttachmentTypeHelper fileTypeWithTypeName:self.cellModel.type];
        if (type == YXFileTypeVideo || type == YXFileTypeAudio) {
            [self.downloadButton setTitleColor:[UIColor colorWithHexString:@"cccdd0"] forState:UIControlStateNormal];
            [self.downloadButton setTitleColor:[UIColor colorWithHexString:@"cccdd0"] forState:UIControlStateHighlighted];
            self.downloadButton.layer.borderColor = [UIColor colorWithHexString:@"cccdd0"].CGColor;
        }
    }
}

- (void)updateDownloadProgressWithDownloadedSize:(unsigned long long)downloadedSize totalSize:(unsigned long long)totalSize{
    [self.downloadProcessView setProgress:downloadedSize/(float)totalSize];
}

- (void)tapLeftGesture:(UIButton *)sender {
    // 只有文档类的可以下载，视频音频不能下载
    YXFileType type = [YXAttachmentTypeHelper fileTypeWithTypeName:self.cellModel.type];
    if (type == YXFileTypeVideo || type == YXFileTypeAudio) {
        if (self.canOpenDatumToast) {
            self.canOpenDatumToast();
        }
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(myDatumCellDownloadButtonClicked:)]) {
        [self.delegate myDatumCellDownloadButtonClicked:self];
    }
}

- (void)hiddenBottomView:(BOOL)hidden {
    self.cellSeperatorView.hidden = hidden;
}

@end
