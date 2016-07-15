//
//  YXWorkshopDetailGroupCell.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/5.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

@interface YXWorkshopDetailMemberCell  : UICollectionViewCell
@property (nonatomic,strong)UIImageView *imageView;
@end
@implementation YXWorkshopDetailMemberCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.layer.cornerRadius = 17.0f;
        self.imageView.clipsToBounds = YES;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.image = [UIImage imageNamed:@"工作坊详情成员小头像"];
        [self addSubview:self.imageView];
    }
    return self;
}
@end

#import "YXWorkshopDetailGroupCell.h"
#import "YXWorkshopMemberRequest.h"
@interface YXWorkshopDetailGroupCell()
<
UICollectionViewDataSource,
UICollectionViewDelegate
>
{
    UILabel *_titleLabel;
    UICollectionView *_collectionView;
    UILabel *_contentLabel;
    UIImageView *_imageView;
}
@end

@implementation YXWorkshopDetailGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *selectedBgView = [[UIView alloc]init];
        selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
        self.selectedBackgroundView = selectedBgView;
        [self setupUI];
        [self layoutInterface];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (!selected) {
        _imageView.image = [UIImage imageNamed:@"工作坊列表展开箭头"];
    }
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        _imageView.image = [UIImage imageNamed:@"工作坊列表展开箭头-点击态"];
    }
    else{
        _imageView.image = [UIImage imageNamed:@"工作坊列表展开箭头"];
    }
}
#pragma mark - UI setting
- (void)setupUI{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    _titleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:_titleLabel];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(34.0f, 34.0f);
    layout.minimumInteritemSpacing = 2.0f;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.userInteractionEnabled = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[YXWorkshopDetailMemberCell class] forCellWithReuseIdentifier:@"YXWorkshopDetailMemberCell"];
    [self.contentView addSubview:_collectionView];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    _contentLabel.textAlignment = NSTextAlignmentRight;
    _contentLabel.textColor = [UIColor colorWithHexString:@"0067be"];
    [self.contentView addSubview:_contentLabel];
    
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
}

- (void)layoutInterface{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_right).offset(20.0f);
        make.height.offset(34.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(_contentLabel.mas_left).offset(-15.0f);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(_imageView.mas_left).offset(-10.0f);
    }];

    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.height.width.mas_equalTo(16.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}
#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _memberMutableArray.count > 7 ? 7 : _memberMutableArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YXWorkshopDetailMemberCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXWorkshopDetailMemberCell" forIndexPath:indexPath];
    if (_memberMutableArray.count > indexPath.row) {
        YXWorkshopMemberRequestItem_memberList *member = _memberMutableArray[indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:member.head] placeholderImage:[UIImage imageNamed:@"工作坊详情成员小头像"]];
    }
    return cell;
}
- (void)reloadWithTitle:(NSString *)titleString
                content:(NSString *)contentString{
    _titleLabel.text = titleString;
    _contentLabel.text = contentString;
}
- (void)setMemberMutableArray:(NSMutableArray *)memberMutableArray{
    _memberMutableArray = memberMutableArray;
    [_collectionView reloadData];
}
@end
