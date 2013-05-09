//
//  CMMotionManager+Shared.m
//  AloharTutorial
//
//  Created by Xiaoshan Huang on 5/9/13.
//  Copyright (c) 2013 Xiaoshan Huang. All rights reserved.
//

#import "CMMotionManager+Shared.h"

@implementation CMMotionManager (Shared)

+ (CMMotionManager *)sharedMotionManager
{
    static CMMotionManager *shared = nil;
    if (!shared) {
        shared = [[CMMotionManager alloc] init];
    }
    return shared;
}

@end
