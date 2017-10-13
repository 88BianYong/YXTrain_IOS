//
//  YXMyDatumCell.h
//  YanXiuApp
//
//  Created by niuzhaowang on 15/9/1.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXDatumCellModel.h"

@class YXMyDatumCell;

@protocol YXMyDatumCellDelegate <NSObject>

- (void)myDatumCellDownloadButtonClicked:(YXMyDatumCell *)myDatumCell;

@end

@interface YXMyDatumCell : UITableViewCell
@property (nonatomic, strong) YXDatumCellModel *cellModel;
@property (nonatomic, weak) id<YXMyDatumCellDelegate> delegate;

@property (nonatomic, copy) void(^canOpenDatumToast)(void);

- (void)hiddenBottomView:(BOOL)hidden;
@end
