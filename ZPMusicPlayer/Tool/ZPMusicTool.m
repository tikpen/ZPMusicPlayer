//
//  ZPMusicTool.m
//  ZPMusicPlayer
//
//  Created by Cass on 2017/7/9.
//  Copyright © 2017年 周鹏. All rights reserved.
//

#import "ZPMusicTool.h"
#import "ZPMusic.h"
#import "MJExtension.h"

@implementation ZPMusicTool

static NSArray *_musics;
static ZPMusic *_playingMusic;

+ (void)initialize{
    if (_musics == nil) {
        _musics = [ZPMusic mj_objectArrayWithFilename:@"Musics.plist"];
    }
    if (_playingMusic == nil) {
        _playingMusic = _musics[0];
    }

}


+ (NSArray *) musics{
    return _musics;
}

+ (ZPMusic *) playingMusic{
    return _playingMusic;
}

+ (void)setupPlayingMusic:(ZPMusic *)playingMusic{
    _playingMusic = playingMusic;
    

}

+ (ZPMusic *)aboveMusic{
    //获取当前音乐的下标值
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    NSInteger aboveIndex = --currentIndex;
    ZPMusic *aboveMusic = nil;
    if (aboveIndex < 0) {
        aboveIndex = _musics.count-1;
    }
    aboveMusic = _musics[aboveIndex];
    
    return aboveMusic;
}


+ (ZPMusic *)nextMusic{
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    NSInteger nextIndex = ++currentIndex;
    ZPMusic *nextMusic = nil;
    if (nextIndex >= _musics.count) {
        nextIndex = 0;
    }
    nextMusic = _musics[nextIndex];
    
    return nextMusic;
}


//重写key
//- (id)valueForUndefinedKey:(NSString *)key{
//    if ([key isEqualToString: @"filename"]) {
//        key = [NSString stringWithFormat:@"fileName"];
//    }
//    if ([key isEqualToString:@"lrcname"]) {
//        key = [NSString stringWithFormat:@"lrcName"];
//    }
//    return self;
//}

@end
