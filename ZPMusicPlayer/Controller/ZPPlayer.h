//
//  ZPPlayer.h
//  ZPMusicPlayer
//
//  Created by Cass on 2017/7/19.
//  Copyright © 2017年 周鹏. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface ZPPlayer : AVAudioPlayer

+ (ZPPlayer *)shareSingleton;

@end
