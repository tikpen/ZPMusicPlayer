//
//  ZPLrcTool.m
//  ZPMusicPlayer
//
//  Created by Cass on 2017/7/13.
//  Copyright © 2017年 周鹏. All rights reserved.
//

#import "ZPLrcTool.h"
#import "ZPLrcLine.h"

@implementation ZPLrcTool
+ (NSArray *)lrcToolWithLrcName:(NSString *)lrcName{
    //获取路径
    NSString *path = [[NSBundle mainBundle]pathForResource:lrcName ofType:nil];
    
    //获取歌词
    NSString *lrcString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    //转化成歌词数组
    NSArray *lrcArray = [lrcString componentsSeparatedByString:@"\n"];
    NSMutableArray *tempArray = [NSMutableArray array];

    for (NSString *lrcLineString in lrcArray) {
            //过滤不需要的字符串
        if ([lrcLineString hasPrefix:@"[ti:"] ||
            [lrcLineString hasPrefix:@"[ar:"] ||
            [lrcLineString hasPrefix:@"[al:"] ||
            ![lrcLineString hasPrefix:@"["]) {
            continue;
        }
        
        NSString * str = [[NSString alloc] initWithData:[lrcLineString dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding] ;
        //将歌词转化成模型
        ZPLrcLine *lrcLine = [ZPLrcLine LrcLineString:str];
        [tempArray addObject:lrcLine];
    }
    return tempArray;
}
@end
