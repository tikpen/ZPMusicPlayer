//
//  ZPTableView.m
//  ZPMusicPlayer
//
//  Created by Cass on 2017/7/18.
//  Copyright © 2017年 周鹏. All rights reserved.
//

#import "ZPTableView.h"
#import "ZPMusicTool.h"
#import "ZPPlayerViewController.h"
#import "ZPPlayer.h"
#import "ZPMusic.h"

@interface ZPTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) NSArray *arrayList;

@end

@implementation ZPTableView

- (NSArray *)arrayList{
    if (_arrayList == nil) {
        NSArray * musicList= [ZPMusicTool musics];
         _arrayList = [NSArray arrayWithArray:musicList];
  
    }
    return _arrayList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
//    UITableView *tableView = [[UITableView alloc]init];
//     tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height)];
//    tableView.dataSource = self;
    self.listTableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    ZPMusic *music =self.arrayList[indexPath.row];
    //NSString *string = self.arrayList[indexPath.row];
    cell.textLabel.text = music.name;
    cell.detailTextLabel.text = music.singer;
    cell.imageView.image = [UIImage imageNamed:music.icon];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZPMusic *music = self.arrayList[indexPath.row];
    
//    UITableViewCell * cell =  [tableView cellForRowAtIndexPath:indexPath];
    //NSString *musicName = [NSString stringWithFormat:@"%@",cell.textLabel.text];

   
    ZPPlayerViewController * cv = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"main"];
    

    [self presentViewController:cv animated:YES completion:^{
        
    }];
    
    ZPMusic * playingMusic = [ZPMusicTool playingMusic];
    if ([music.filename isEqualToString:playingMusic.filename]) {
        if (![ZPPlayer shareSingleton].isPlaying) {
            [[ZPPlayer shareSingleton] play];
        }
        [cv playMUsic:nil];
    }else{
        [cv playMUsic:music];
    }

   
}



#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.arrayList.count;
}



@end
