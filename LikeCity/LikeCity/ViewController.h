//
//  ViewController.h
//  LikeCity
//
//  Created by Виктор Мишустин on 27.11.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableViewCities;
@property (weak, nonatomic) IBOutlet UILabel *labelCityName;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (weak, nonatomic) UITableView * tableBookmark;
@property (strong, nonatomic) NSMutableArray * arrayBookmarks;

//ButtonsMenu

- (IBAction)actionButtonCity:(id)sender;
- (IBAction)actionButtonBookmark:(id)sender;
- (IBAction)actionButtonSettings:(id)sender;

@end

