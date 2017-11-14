//
//  YXDatumOrderModel.h
//  TrainApp
//
//  Created by 李五民 on 16/6/20.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXDatumOrder : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, assign) BOOL selected;

@end

@interface YXDatumOrderModel : NSObject

@property (nonatomic, strong) NSArray *orderArray;

@end
