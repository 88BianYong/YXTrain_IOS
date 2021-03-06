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
    if ([resource.fileType isEqualToString:@"html"]) {
        model.previewUrl = resource.externalUrl;
        model.url = resource.externalUrl;
    }else {
        model.previewUrl = resource.previewUrl;
        model.url = resource.previewUrl;
    }
    model.type = resource.fileType;
    NSString *imageName = [YXAttachmentTypeHelper picNameWithTypeName:resource.fileType];
    model.image = [UIImage imageNamed:imageName];
    model.date = resource.publishTime;
    model.isFavor = resource.isCollection.boolValue;
    model.createUsername = resource.createUsername;
    return model;
}
+ (YXDatumCellModel *)modelFromDownloadResourceRequestItemBodyResource:(DownloadResourceRequestItem_body_resource *)resource {
    YXDatumCellModel *model = [[YXDatumCellModel alloc]init];
    model.title = resource.resName;
    model.size = resource.resSize.longLongValue;
    model.aid = resource.resId;
    if ([resource.fileType isEqualToString:@"html"]) {
        model.previewUrl = resource.externalUrl;
        model.url = resource.externalUrl;
    }else {
        model.previewUrl = resource.previewUrl;
        model.url = resource.previewUrl;
    }
    model.type = resource.fileType;
    NSString *imageName = [YXAttachmentTypeHelper picNameWithTypeName:resource.fileType];
    model.image = [UIImage imageNamed:imageName];
    model.date = resource.publishTime;
    model.isFavor = resource.isCollection.boolValue;
    model.createUsername = resource.createUsername;
    return model;
}

+ (YXDatumCellModel *)modelFromActivityToolVideoRequestItemBodyResource:( ActivityToolVideoRequestItem_Body_Content *)resource {
    YXDatumCellModel *model = [[YXDatumCellModel alloc]init];
    model.title = resource.resname;
    model.size = resource.res_size.longLongValue;
    model.aid = resource.resid;
    model.previewUrl = resource.previewurl;
    model.url = resource.downloadurl;
    model.type = resource.filetype;
    NSString *imageName = [YXAttachmentTypeHelper picNameWithTypeName:resource.filetype];
    model.image = [UIImage imageNamed:imageName];
    model.date = resource.publishTime;
    model.isFavor = resource.isCollection.boolValue;
    model.createUsername = resource.createUsername;
    return model;
}
@end
