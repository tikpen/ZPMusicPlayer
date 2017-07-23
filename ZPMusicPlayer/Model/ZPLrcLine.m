//
//  ZPLrcLine.m
//  ZPMusicPlayer
//
//  Created by Cass on 2017/7/13.
//  Copyright © 2017年 周鹏. All rights reserved.
//

#import "ZPLrcLine.h"

@implementation ZPLrcLine
- (instancetype)initWithLrcLineString:(NSString *)lrcLineString{
    if (self = [super init]) {
        // [01:02.38]想你时你在天边
        NSArray *lrcArray = [lrcLineString componentsSeparatedByString:@"]"];
        self.text = lrcArray[1];
        self.time =[self timeWithString:[lrcArray[0] substringFromIndex:1]];
    }
    return self;
}

+ (instancetype)LrcLineString:(NSString *)lrcLineString{
    return [[self alloc] initWithLrcLineString:lrcLineString];
}

- (NSTimeInterval)timeWithString:(NSString *)timeString
{
    // 01:02.38
    NSInteger min = [[timeString componentsSeparatedByString:@":"][0] integerValue];
    NSInteger sec = [[timeString substringWithRange:NSMakeRange(3, 2)] integerValue];
    NSInteger hs = [[timeString componentsSeparatedByString:@"."][1] integerValue];
    return min * 60 + sec + hs * 0.01;
}

@end
