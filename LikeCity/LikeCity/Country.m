//
//  Countries.m
//  LikeCity
//
//  Created by Виктор Мишустин on 27.11.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import "Country.h"

@implementation Country

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.arrayCities = [NSMutableArray array];
    }
    return self;
}

@end
