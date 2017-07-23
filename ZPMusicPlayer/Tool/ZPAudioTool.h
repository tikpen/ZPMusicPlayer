//
//  ZPAudioTool.h
//  ZPMusicPlayer
//
//  Created by Cass on 2017/7/9.
//  Copyright © 2017年 周鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface ZPAudioTool : NSObject

//播放音乐
+ (void)playMusic:(NSString *)fileName;
//暂停音乐
+ (void)pauseMusic:(NSString *)filename;
//停止音乐
+ (void)stopMusic:(NSString *)filename;
//
@end
