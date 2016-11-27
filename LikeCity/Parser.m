//
//  Parser.m
//  LikeCity
//
//  Created by Виктор Мишустин on 27.11.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import "Parser.h"
#import "Country.h"

@implementation Parser

- (NSMutableArray*) parsWithData: (id) response {
    
    NSMutableArray * mailDataArray = [NSMutableArray array];
    
    if ([response isKindOfClass:[NSDictionary class]]) {
        NSDictionary * mainDataDict = response;
        NSArray * arrayResult = [mainDataDict objectForKey:@"Result"];
        
        //Парсинг Страна
        for (int i = 0; i < arrayResult.count; i++) {
            
            NSDictionary * countryDict = [arrayResult objectAtIndex:i];
            NSString * nameCountry = [countryDict objectForKey:@"Name"];
            
            Country * country = [[Country alloc] init];
            country.name = nameCountry;
            
            //Парсинг город
            NSArray * arrayCities = [countryDict objectForKey:@"Cities"];
            
            for (int j = 0; j < arrayCities.count; j++) {
                NSDictionary * cityDict = [arrayCities objectAtIndex:j];
                [country.arrayCities addObject:[cityDict objectForKey:@"Name"]];
            }
            
            [mailDataArray addObject:country];
            
        }
        
    } else {
        NSLog(@"Error class");
    }

    return mailDataArray;
 
}

@end
