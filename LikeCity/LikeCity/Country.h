//
//  Countries.h
//  LikeCity
//
//  Created by Виктор Мишустин on 27.11.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Country : NSObject

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSMutableArray * arrayCities;

@end
