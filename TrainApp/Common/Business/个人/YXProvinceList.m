//
//  YXProvinceList.m
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/14.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXProvinceList.h"

@implementation YXCounty

@end

@implementation YXCity

@end

@implementation YXProvince

@end

@interface YXProvinceList ()<NSXMLParserDelegate>

@property (nonatomic, strong) NSXMLParser *parser;

@property (nonatomic, strong) YXProvince *currentProvince;
@property (nonatomic, strong) YXCity *currentCity;
@property (nonatomic, strong) YXCounty *currentCounty;

@end

@implementation YXProvinceList

- (void)dealloc
{
    self.parser.delegate = nil;
    self.parser = nil;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"province_data" ofType:@"xml"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        self.parser = [[NSXMLParser alloc] initWithData:data];
        self.parser.delegate = self;
    }
    return self;
}

- (BOOL)startParse
{
    return [self.parser parse];
}

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.provinces = [NSMutableArray array];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"province"]) {
        _currentProvince = [[YXProvince alloc] init];
        _currentProvince.citys = [NSMutableArray array];
        _currentProvince.name = [attributeDict objectForKey:@"name"];
    } else if ([elementName isEqualToString:@"city"]) {
        _currentCity = [[YXCity alloc] init];
        _currentCity.counties = [NSMutableArray array];
        _currentCity.name = [attributeDict objectForKey:@"name"];
    } else if ([elementName isEqualToString:@"district"]) {
        _currentCounty = [[YXCounty alloc] init];
        _currentCounty.name = [attributeDict objectForKey:@"name"];
        _currentCounty.zipcode = [attributeDict objectForKey:@"zipcode"];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"province"]) {
        [self.provinces addObject:self.currentProvince];
        self.currentProvince = nil;
    } else if ([elementName isEqualToString:@"city"]) {
        [self.currentProvince.citys addObject:self.currentCity];
        self.currentCity = nil;
    } else if ([elementName isEqualToString:@"district"]) {
        [self.currentCity.counties addObject:self.currentCounty];
        self.currentCounty = nil;
    }
}

@end
