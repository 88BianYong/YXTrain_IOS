//
//  YXMyDatumCell.m
//  YanXiuApp
//
//  Created by niuzhaowang on 15/9/1.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXMyDatumCell.h"
#import "YXMyDatumNormalInfoView.h"
#import "YXMyDatumDownloadingInfoView.h"
#import "YXAttachmentTypeHelper.h"

@interface YXMyDatumCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, strong) UIView *seperatorView;
@property (nonatomic, strong) UIView *cellSeperatorView;
@property (nonatomic, strong) YXMyDatumNormalInfoView *normalInfoView;
@property (nonatomic, strong) YXMyDatumDownloadingInfoView *downloadInfoView;
@property (nonatomic, strong) NSMutableArray *disposeArray;
@end

@implementation YXMyDatumCell

- (void)awakeFromNib {
    // Initialization code
}

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
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];
    
    self.normalInfoView = [[YXMyDatumNormalInfoView alloc]init];
    [self.contentView addSubview:self.normalInfoView];
    
    self.downloadInfoView = [[YXMyDatumDownloadingInfoView alloc]init];
    [self.contentView addSubview:self.downloadInfoView];
    
    self.downloadButton = [[UIButton alloc]init];
    self.downloadButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.downloadButton setTitleColor:[UIColor colorWithHexString:@"2c97dd"] forState:UIControlStateNormal];
    [self.downloadButton setTitleColor:[[UIColor colorWithHexString:@"2c97dd"] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [self.downloadButton addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.downloadButton];
    
    self.seperatorView = [[UIView alloc]init];
    self.seperatorView.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    [self.contentView addSubview:self.seperatorView];
    
    self.cellSeperatorView = [[UIView alloc]init];
    self.cellSeperatorView.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    [self.contentView addSubview:self.cellSeperatorView];
    
    [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(60);
    }];
    [self.seperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(1/[UIScreen mainScreen].scale);
        make.right.mas_equalTo(self.downloadButton.mas_left);
    }];
    [self.cellSeperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
}

- (void)setCellModel:(YXDatumCellModel *)cellModel{
    _cellModel = cellModel;
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
        self.titleLabel.text = self.cellModel.title;
        self.normalInfoView.dateLabel.text = self.cellModel.date;
        self.normalInfoView.sizeLabel.text = self.cellModel.size;
        self.normalInfoView.typeImageView.image = self.cellModel.image;
        self.seperatorView.hidden = YES;
        self.downloadButton.hidden = YES;
        [self.downloadInfoView removeFromSuperview];
        [self.contentView addSubview:self.normalInfoView];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-10);
        }];
        [self.normalInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(15);
            make.bottom.mas_equalTo(-10);
        }];
    }else if (state == DownloadStatusDownloading){
        self.titleLabel.text = self.cellModel.title;
        [self.downloadButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.downloadButton setTitleColor:[UIColor colorWithHexString:@"2c97dd"] forState:UIControlStateNormal];
        [self.downloadButton setTitleColor:[[UIColor colorWithHexString:@"2c97dd"] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        self.downloadInfoView.downloadingLabel.text = @"正在下载中";
        [self updateDownloadProgressWithDownloadedSize:self.cellModel.downloadedSize totalSize:self.cellModel.size];
        self.seperatorView.hidden = NO;
        self.downloadButton.hidden = NO;
        [self.normalInfoView removeFromSuperview];
        [self.contentView addSubview:self.downloadInfoView];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(self.seperatorView.mas_left).mas_offset(-10);
        }];
        [self.downloadInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(10);
            make.right.mas_equalTo(self.seperatorView.mas_left).mas_offset(-10);
            make.height.mas_equalTo(15);
            make.bottom.mas_equalTo(-10);
        }];
    }else{
        self.titleLabel.text = self.cellModel.title;
        [self.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
        [self.downloadButton setTitleColor:[UIColor colorWithHexString:@"2c97dd"] forState:UIControlStateNormal];
        [self.downloadButton setTitleColor:[[UIColor colorWithHexString:@"2c97dd"] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        self.normalInfoView.dateLabel.text = self.cellModel.date;
        self.normalInfoView.sizeLabel.text = self.cellModel.size;
        self.normalInfoView.typeImageView.image = self.cellModel.image;
        self.seperatorView.hidden = NO;
        self.downloadButton.hidden = NO;
        [self.downloadInfoView removeFromSuperview];
        [self.contentView addSubview:self.normalInfoView];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(self.seperatorView.mas_left).mas_offset(-10);
        }];
        [self.normalInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(10);
            make.right.mas_equalTo(self.seperatorView.mas_left).mas_offset(-10);
            make.height.mas_equalTo(15);
            make.bottom.mas_equalTo(-10);
        }];
        
        // 只有文档类的可以下载，视频音频不能下载
        YXFileType type = [YXAttachmentTypeHelper fileTypeWithTypeName:self.cellModel.type];
        if (type == YXFileTypeVideo || type == YXFileTypeAudio) {
            [self.downloadButton setTitleColor:[UIColor colorWithHexString:@"cccccc"] forState:UIControlStateNormal];
            [self.downloadButton setTitleColor:[UIColor colorWithHexString:@"cccccc"] forState:UIControlStateHighlighted];
        }
    }
}

- (void)updateDownloadProgressWithDownloadedSize:(NSString *)downloadedSize totalSize:(NSString *)totalSize{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@/%@",downloadedSize,totalSize]];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"2c97dd"] range:NSMakeRange(0, downloadedSize.length)];
    self.downloadInfoView.downloadProgressLabel.attributedText = attrString;
}

- (void)downloadAction:(UIButton *)sender{
    // 只有文档类的可以下载，视频音频不能下载
    YXFileType type = [YXAttachmentTypeHelper fileTypeWithTypeName:self.cellModel.type];
    if (type == YXFileTypeVideo || type == YXFileTypeAudio) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(myDatumCellDownloadButtonClicked:)]) {
        [self.delegate myDatumCellDownloadButtonClicked:self];
    }
}

@end
