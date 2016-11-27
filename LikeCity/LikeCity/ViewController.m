//
//  ViewController.m
//  LikeCity
//
//  Created by Виктор Мишустин on 27.11.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import "ViewController.h"
#import "APIGetClass.h"
#import "Country.h"
#import "Parser.h"
#import "CustomButton.h"

static NSString * kCityName = @"cityName";

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray * arrayCountrys;

//Доп массив для скрытия ячеек
@property (strong, nonatomic) NSMutableArray * arrayHiden;


@end

@implementation ViewController

- (void) loadView {
    [super loadView];
    
    self.mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 3, 0);
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.scrollEnabled = NO;
    
    [self.tableViewCities setSeparatorInset:UIEdgeInsetsZero];
    
    //Table Bookmark------------
    CGRect frameTableBookmark = CGRectZero;
    frameTableBookmark.size = self.tableViewCities.bounds.size;
    frameTableBookmark.origin.x = self.view.bounds.size.width;
    UITableView * tableBookmark = [[UITableView alloc] initWithFrame:frameTableBookmark
                                                               style:UITableViewStylePlain];
    tableBookmark.dataSource = self;
    tableBookmark.delegate = self;
    [tableBookmark setSeparatorInset:UIEdgeInsetsZero];
    tableBookmark.allowsSelection = NO;
    [self.mainScrollView addSubview:tableBookmark];
    self.tableBookmark = tableBookmark;
    
    //Settings
    CGRect frameSettingsView = CGRectZero;
    frameSettingsView.size = self.tableViewCities.bounds.size;
    frameSettingsView.origin.x = self.view.bounds.size.width * 2;
    UIView * settingView = [[UIView alloc] initWithFrame:frameSettingsView];
    [self.mainScrollView addSubview:settingView];
    UILabel * labelSettins = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 40)];
    labelSettins.text = @"Настройки";
    labelSettins.textAlignment = NSTextAlignmentCenter;
    labelSettins.textColor = [UIColor blackColor];
    [settingView addSubview:labelSettins];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayCountrys = [NSMutableArray array];
    self.arrayHiden = [NSMutableArray array];
    self.arrayBookmarks = [NSMutableArray array];
    
    [self loadCity];
    
    [self getMethodWithBlock:^(id response) {
        Parser * parser = [[Parser alloc] init];
        self.arrayCountrys = [parser parsWithData:response];
        
        [self createArrayHiden];

        [self.tableViewCities reloadData];
        [self.tableBookmark reloadData];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView isEqual:self.tableViewCities]) {
        return self.arrayCountrys.count;
    } else {
        return 1;
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    if ([tableView isEqual:self.tableViewCities]) {
        Country * country = [self.arrayCountrys objectAtIndex:section];
        return country.name;
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([tableView isEqual:self.tableViewCities]) {
        NSInteger intCount = [[self.arrayHiden objectAtIndex:section] integerValue];
        return intCount;
    } else {
        return self.arrayBookmarks.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"Cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if ([tableView isEqual:self.tableViewCities]) {
        Country * country = [self.arrayCountrys objectAtIndex:indexPath.section];
        NSString * nameCity = [country.arrayCities objectAtIndex:indexPath.row];
        
        cell.textLabel.text = nameCity;
        
        CustomButton * buttonBookmark = [self createButtonForCellWithImage:@"bookmarkAdd.png"];
        [buttonBookmark addTarget:self action:@selector(actionAddBookmark:)
                 forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:buttonBookmark];
    } else {
        NSDictionary * dictData = [self.arrayBookmarks objectAtIndex:indexPath.row];
        cell.textLabel.text = [dictData objectForKey:@"name"];
        CustomButton * buttonCalcel = [self createButtonForCellWithImage:@"cancelImage.png"];
        [buttonCalcel addTarget:self action:@selector(actionCancelBookmark:)
                 forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:buttonCalcel];
    }
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if ([tableView isEqual:self.tableViewCities]) {
        CGRect frame = tableView.frame;
        
        Country * country = [self.arrayCountrys objectAtIndex:section];
        CustomButton *hideButton = [CustomButton buttonWithType:UIButtonTypeSystem];
        
        UILabel * labelIdentifier = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 13.f, 20.f, 20.f)];
        hideButton.frame = CGRectMake(0.f, 0.f, frame.size.width, 40.f);
        [hideButton setTitle:country.name forState:UIControlStateNormal];
        [hideButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        if ([[self.arrayHiden objectAtIndex:section] integerValue] > 0) {
            hideButton.isBool = YES;
            labelIdentifier.text = @"-";
        } else {
            hideButton.isBool = NO;
            labelIdentifier.text = @"+";
        }
        labelIdentifier.textColor = [UIColor blackColor];
        labelIdentifier.textAlignment = NSTextAlignmentCenter;
        labelIdentifier.font = [UIFont fontWithName:@"" size:15];
        hideButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
        hideButton.tag = 20 + section;
        [hideButton addTarget:self action:@selector(hideButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, 40)];
        [headerView addSubview:hideButton];
        [hideButton addSubview:labelIdentifier];
        
        return headerView;
    } else {
        return nil;
    }
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableViewCities]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        Country * country = [self.arrayCountrys objectAtIndex:indexPath.section];
        [self saveCityWithText:[country.arrayCities objectAtIndex:indexPath.row]];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableViewCities]) {
        return 40.f;
    } else {
        return 0.f;
    }    
}


#pragma mark - APIGetClasses

- (void) getMethodWithBlock: (void (^) (id response)) timeBlock {
    
    APIGetClass * apiObject = [[APIGetClass alloc] init];
    [apiObject getDataFromServerWithBlock:^(id response) {
        
        timeBlock (response);
        
    }];
}

#pragma mark - Save and Load

- (void) saveCityWithText: (NSString*) text {
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:text forKey:kCityName];
    self.labelCityName.text = text;

    [userDefaults synchronize];
}

- (void) loadCity {
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:kCityName] != nil) {
        self.labelCityName.text = [userDefaults objectForKey:kCityName];
    }
}

#pragma mark - Actions

- (IBAction)actionButtonCity:(id)sender {
    [self moveScrollViewWithPoint:0];
}

- (IBAction)actionButtonBookmark:(id)sender {
    [self moveScrollViewWithPoint:self.view.frame.size.width];
}

- (IBAction)actionButtonSettings:(id)sender {
    [self moveScrollViewWithPoint:self.view.frame.size.width * 2];
}

- (void) hideButtonAction: (CustomButton*) button {
    for (int i = 0; i < self.arrayCountrys.count; i++) {
        if (button.tag == 20 + i) {
            if (!button.isBool) {
                Country * country = [self.arrayCountrys objectAtIndex:i];
                [self.arrayHiden replaceObjectAtIndex:i withObject:[NSNumber numberWithInteger:country.arrayCities.count]];
            } else {
                [self.arrayHiden replaceObjectAtIndex:i withObject:[NSNumber numberWithInteger:0]];
            }
            
            [self animationHideTableView:self.tableViewCities withSection: button.tag - 20];
            button.isBool = YES;
            
        }
    }
}

- (void) actionAddBookmark: (CustomButton*) button {
    
    CGPoint buttonPosition = [button convertPoint:CGPointZero toView:self.tableViewCities];
    NSIndexPath *indexPath = [self.tableViewCities indexPathForRowAtPoint:buttonPosition];
    
    Country * country = [self.arrayCountrys objectAtIndex:indexPath.section];
    NSString * nameCity = [country.arrayCities objectAtIndex:indexPath.row];
    
    NSDictionary * dictDataCell = [NSDictionary dictionaryWithObjectsAndKeys:nameCity, @"name", button, @"button", nil];
    
    if (button.isBool) {
        [self.arrayBookmarks addObject:dictDataCell];
        [button setImage:[UIImage imageNamed:@"bookmarkDel.png"]
                                    forState:UIControlStateNormal];
        button.isBool = NO;
    } else {
        [self.arrayBookmarks removeObject:dictDataCell];
        [button setImage:[UIImage imageNamed:@"bookmarkAdd.png"]
                                    forState:UIControlStateNormal];
        button.isBool = YES;
    }
    
    [self.tableBookmark reloadData];
}

- (void) actionCancelBookmark: (CustomButton*) button {
    
    CGPoint buttonPosition = [button convertPoint:CGPointZero toView:self.tableBookmark];
    NSIndexPath *indexPath = [self.tableBookmark indexPathForRowAtPoint:buttonPosition];
    
    NSDictionary * dictData = [self.arrayBookmarks objectAtIndex:indexPath.row];
    
    CustomButton * bustomButton = [dictData objectForKey:@"button"];
    if (!bustomButton.isBool) {
        [bustomButton setImage:[UIImage imageNamed:@"bookmarkAdd.png"]
                forState:UIControlStateNormal];
        bustomButton.isBool = YES;
    }
    
    [self.arrayBookmarks removeObjectAtIndex:indexPath.row];
    [self animationHideTableView:self.tableBookmark withSection:0];
    
    if (self.arrayBookmarks.count == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.mainScrollView.contentOffset = CGPointMake(0, 0);
        }];
    }
    
}

#pragma mark - Other

- (void) createArrayHiden {
    
    for (int i = 0; i < self.arrayCountrys.count; i++) {
        Country * country = [self.arrayCountrys objectAtIndex:i];
        NSNumber * number = [NSNumber numberWithInteger:country.arrayCities.count];
        [self.arrayHiden addObject:number];
    }
}

- (void) animationHideTableView: (UITableView*) tableView withSection: (NSInteger) section {
    
    [tableView beginUpdates];
    NSInteger newSectionIndex = section;
    NSIndexSet * insertSections = [NSIndexSet indexSetWithIndex:newSectionIndex];
        [tableView reloadSections: insertSections withRowAnimation:UITableViewRowAnimationFade];
    
    [tableView endUpdates];
}

- (CustomButton*) createButtonForCellWithImage: (NSString*) imageName {
    
    CustomButton * buttonBookmark = [CustomButton buttonWithType:UIButtonTypeCustom];
    buttonBookmark.frame = CGRectMake(CGRectGetWidth(self.view.bounds) - 50, 7, 30, 30);
    buttonBookmark.isBool = YES;
    buttonBookmark.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [buttonBookmark setImage:[UIImage imageNamed:imageName]
                    forState:UIControlStateNormal];
    
    return buttonBookmark;
}

- (void) moveScrollViewWithPoint: (CGFloat) point {
    [UIView animateWithDuration:0.3 animations:^{
        self.mainScrollView.contentOffset = CGPointMake(point, 0);
    }];
    
}
@end
