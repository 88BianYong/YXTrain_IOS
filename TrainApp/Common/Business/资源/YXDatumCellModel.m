//
//  YXDatumCellModel.m
//  YanXiuApp
//
//  Created by niuzhaowang on 15/8/28.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXDatumCellModel.h"
#import "PersistentUrlDownloader.h"
#import "YXAttachmentTypeHelper.h"
NSString *const YXFavorSuccessNotification = @"YXFavorSuccessNotification";

@implementation YXDatumCellModel

- (instancetype)init{
    if (self = [super init]) {
        self.title = @"";
        self.date = @"";
        self.size = 0;
        self.downloadedSize = 0;
        self.isFavor = FALSE;
        self.downloadState = DownloadStatusNA;
    }
    return self;
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
+ (YXDatumCellModel *)modelFromSearchRequestItemData:(YXDatumSearchRequestItem_data *)data{
    YXDatumCellModel *model = [[YXDatumCellModel alloc]init];
    model.title = data.filename;
    model.size = data.filesize.longLongValue;
    model.isFavor = data.isCollection.boolValue;
    model.url = data.url;
    model.aid = data.datumId;
    model.uid = data.uid;
    model.type = data.filetype;
    // set image
    NSString *imageName = [YXAttachmentTypeHelper picNameWithTypeName:data.filetype];
    model.image = [UIImage imageNamed:imageName];
    // set date
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:data.time.doubleValue/1000];
    model.date = [formatter stringFromDate:date];
    return model;
}

+ (YXDatumCellModel *)modelFromMyDatumRequestResultList:(YXMyDatumRequestItem_result_list *)list{
    YXDatumCellModel *model = [[YXDatumCellModel alloc]init];
    model.title = list.title;
    model.size = list.fileSize.longLongValue;
    model.isFavor = list.isCollection.boolValue;
    model.url = list.previewUrl;
    if ([PersistentUrlDownloader fileExist:model.url]) {
        model.downloadState = DownloadStatusFinished;
    }
    model.aid = list.aid;
    model.uid = list.uid;
    model.type = list.type;
    // set image
    NSString *imageName = [YXAttachmentTypeHelper picNameWithTypeName:list.type];
    model.image = [UIImage imageNamed:imageName];
    // set date
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:list.pubTime.doubleValue/1000];
    model.date = [formatter stringFromDate:date];
    return model;
}
+ (YXDatumCellModel *)modelFromShareResourceRequestItemBodyResource:(ShareResourcesRequestItem_body_resource *)resource {
    YXDatumCellModel *model = [[YXDatumCellModel alloc]init];
    model.title = resource.resName;
    model.size = resource.resSize.longLongValue;
    model.aid = resource.resId;
    model.previewUrl = resource.previewUrl;
    model.url = resource.downloadUrl;
    model.type = resource.resType;
    NSString *imageName = [YXAttachmentTypeHelper picNameWithTypeName:resource.resType];
    model.image = [UIImage imageNamed:imageName];
    model.date = resource.publishTime;
    model.isFavor = resource.isCollection.boolValue;
    return model;
}
@end
