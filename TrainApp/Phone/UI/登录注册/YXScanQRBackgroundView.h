//
//  YXScanQRBackgroundView.h
//  YanXiuApp
//
//  Created by 李五民 on 15/10/12.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXScanQRBackgroundView : UIView

@property (nonatomic,strong)NSTimer *scanTimer;
@property (nonatomic, copy) NSString *titleString;


@end
