//
//  CMMotionManager+Shared.h
//  AloharTutorial
//
//  Created by Xiaoshan Huang on 5/9/13.
//  Copyright (c) 2013 Xiaoshan Huang. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>

@interface CMMotionManager (Shared)

+ (CMMotionManager *)sharedMotionManager;

@end
