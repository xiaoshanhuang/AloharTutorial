//
//  ATAppDelegate.h
//  AloharTutorial
//
//  Created by Xiaoshan Huang on 5/3/13.
//  Copyright (c) 2013 Xiaoshan Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Alohar/Alohar.h>
#import <Alohar/ALLog.h>

@interface ATAppDelegate : UIResponder <UIApplicationDelegate, ALSessionDelegate, ALLogDelegate, ALUserStayDelegate>
@property (strong, nonatomic) UIWindow *window;

@end
