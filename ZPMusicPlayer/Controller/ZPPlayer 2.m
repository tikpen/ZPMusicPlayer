//
//  ZPPlayer.m
//  ZPMusicPlayer
//
//  Created by Cass on 2017/7/19.
//  Copyright © 2017年 周鹏. All rights reserved.
//

#import "ZPPlayer.h"

@implementation ZPPlayer
static ZPPlayer *_singleton = nil;

//重写allocWithZone
+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [super allocWithZone:zone];
    });
    return _singleton;
}

//重写类方法
+ (ZPPlayer *)shareSingleton{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[ZPPlayer alloc]init];
    });
    return _singleton;
};

//重写copyWithZone方法
+ (id)copyWithZone:(struct _NSZone *)zone{
    return _singleton;
}
@end
