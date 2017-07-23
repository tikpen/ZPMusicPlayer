//
//  ZPMusicTool.h
//  ZPMusicPlayer
//
//  Created by Cass on 2017/7/9.
//  Copyright © 2017年 周鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZPMusic;
@interface ZPMusicTool : NSObject

//所有歌曲
+ (NSArray *) musics;

//当前播放歌曲
+ (ZPMusic *) playingMusic;

//设置默认歌曲
+ (void)setupPlayingMusic:(ZPMusic *)playingMusic;

//播放上一首
+ (ZPMusic *)aboveMusic;

//播放下一首
+ (ZPMusic *)nextMusic;
@end
