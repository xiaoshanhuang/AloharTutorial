//
//  ATSettingsViewController.h
//  AloharTutorial
//
//  Created by Xiaoshan Huang on 5/7/13.
//  Copyright (c) 2013 Xiaoshan Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Alohar/Alohar.h>

@interface ATSettingsViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *uidLabel;
@property (strong, nonatomic) IBOutlet UILabel *userIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *tokenLabel;
@property (strong, nonatomic) IBOutlet UISwitch *moniteringUserSwitch;

- (IBAction)toggleMoniteringUser:(UISwitch *)sender;

@end
