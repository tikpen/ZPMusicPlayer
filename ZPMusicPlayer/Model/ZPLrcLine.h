//
//  ZPLrcLine.h
//  ZPMusicPlayer
//
//  Created by Cass on 2017/7/13.
//  Copyright © 2017年 周鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPLrcLine : NSObject
@property(nonatomic, copy) NSString *text;
@property(nonatomic, assign) NSTimeInterval time;

- (instancetype)initWithLrcLineString:(NSString *)lrcLineString;
+ (instancetype)LrcLineString:(NSString *)lrcLineString;

@end
