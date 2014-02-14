//
//  AppViewController.h
//  DBExample
//
//  Created by Administrator on 12/19/13.
//  Copyright (c) 2013 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"



@interface AppViewController : UIViewController<UITextFieldDelegate>{
 
    sqlite3 *database;
    
}

@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *address;
@property (strong, nonatomic) IBOutlet UITextField *mobile;
@property (strong, nonatomic) IBOutlet UILabel *status;

@property  (retain,nonatomic)NSMutableArray *dataArray;
- (IBAction)saveData:(id)sender;
- (IBAction)findData:(id)sender;

@property(strong, nonatomic)NSString *databasePath;



@end
