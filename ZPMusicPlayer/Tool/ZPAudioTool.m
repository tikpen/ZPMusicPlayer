//
//  ZPAudioTool.m
//  ZPMusicPlayer
//
//  Created by Cass on 2017/7/9.
//  Copyright © 2017年 周鹏. All rights reserved.
//

#import "ZPAudioTool.h"
#import "ZPPlayer.h"

@implementation ZPAudioTool

static NSMutableDictionary *_players;

+ (void)initialize{
    _players = [NSMutableDictionary dictionary];
}

+ (void)playMusic:(NSString *)fileName{
    //创建一个空的播放器
    ZPPlayer *player = nil;
    
    //从字典中获取播放器
    player = _players[fileName];
    
    //判断播放器是否为空
    if (player == nil) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        if (url == nil) {
            return;
        }
        
        //创建播放器
        player = [[ZPPlayer shareSingleton] initWithContentsOfURL:url error:nil];
        
        //保存到字典
        [_players setObject:player forKey:fileName];
        
        //准备播放
        [player prepareToPlay];
    }
    
    
    //播放
    //[player play];
    
 //   return player;
}



+ (void)pauseMusic:(NSString *)filename{
    AVAudioPlayer *player = _players[filename];
    if (player) {
        [player pause];
    }
    
}

+ (void)stopMusic:(NSString *)filename{
    AVAudioPlayer *player = _players[filename];
    if (player) {
        [player stop];
        [_players removeObjectForKey:filename];
        player = nil;
    }
    
}
@end
