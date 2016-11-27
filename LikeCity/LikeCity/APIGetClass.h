//
//  APIClass.h
//  Sadovod
//
//  Created by Кирилл Ковыршин on 18.01.16.
//  Copyright © 2016 Viktor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>

@interface APIGetClass : NSObject
//Метод получающий данные с сервера
-(void) getDataFromServerWithBlock: (void (^) (id response)) compitionBack;

@end
