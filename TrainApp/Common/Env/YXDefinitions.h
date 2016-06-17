//
//  YXDefinitions.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/13.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#ifndef YXDefinitions_h
#define YXDefinitions_h

#define SAFE_CALL(obj,method) \
([obj respondsToSelector:@selector(method)] ? [obj method] : nil)

#define SAFE_CALL_OneParam(obj,method,firstParam) \
([obj respondsToSelector:@selector(method:)] ? [obj method:firstParam] : nil)

#define WEAK_SELF @weakify(self);
#define STRONG_SELF @strongify(self); if(!self) {return;};

#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };

#endif /* YXDefinitions_h */
