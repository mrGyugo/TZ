//
//  CustomButton.m
//  Sadovod
//
//  Created by Виктор Мишустин on 19/08/16.
//  Copyright © 2016 Виктор Мишустин. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

+ (CustomButton*) createButtonCustomImageWithImage: (NSString*) imageName
                                       andRect: (CGRect) rect
{
    UIImage *imageBarButton = [UIImage imageNamed:imageName];
    CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    [button setImage:imageBarButton forState:UIControlStateNormal];
    
    return button;
}

@end
