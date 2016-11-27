//
//  CustomButton.h
//  Sadovod
//
//  Created by Виктор Мишустин on 19/08/16.
//  Copyright © 2016 Виктор Мишустин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton

@property (assign, nonatomic) BOOL isBool;
@property (strong, nonatomic) NSString* customName;
@property (strong, nonatomic) NSString* customValue;
@property (strong, nonatomic) NSString* customValueTwo;
@property (strong, nonatomic) NSString* customID;
@property (assign, nonatomic) int group;


+ (CustomButton*) createButtonCustomImageWithImage: (NSString*) imageName
                                           andRect: (CGRect) rect;
@end
