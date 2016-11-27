//
//  APIClass.m
//  Sadovod
//
//  Created by Кирилл Ковыршин on 18.01.16.
//  Copyright © 2016 Viktor. All rights reserved.
//

#import "APIGetClass.h"


@implementation APIGetClass

//Запрос на сервер
-(void) getDataFromServerWithBlock: (void (^) (id response)) compitionBack {
    
    NSString * url = [NSString stringWithFormat:@"https://atw-backend.azurewebsites.net/api/countries"];
    NSString * encodedURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [manager GET:encodedURL parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        compitionBack(responseObject);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

@end
