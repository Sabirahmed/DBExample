//
//  AppViewController.m
//  DBExample
//
//  Created by Administrator on 12/19/13.
//  Copyright (c) 2013 Administrator. All rights reserved.
//

#import "AppViewController.h"

@interface AppViewController ()

@end

@implementation AppViewController

@synthesize databasePath;
@synthesize name, address,mobile,status, dataArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.name.delegate = self;
    self.address.delegate = self;
    self.mobile.delegate = self;
	// Do any additional setup after loading the view, typically from a nib.
    NSString *fileDir;
    NSArray *dirPaths;
   
    //Get the documents directory
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    fileDir = [dirPaths objectAtIndex:0];
    
    // Build the database path
    databasePath = [[NSString alloc]initWithString:[fileDir stringByAppendingPathComponent:@"student.db"]];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    if([fileMgr fileExistsAtPath:databasePath] == NO)
    {
        const char *dbPath = [databasePath UTF8String];
        if (sqlite3_open(dbPath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS(ID INTEGER PRIMARY KEY , NAME TEXT, ADDRESS TEXT, MOBILE TEXT)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
               status.text = @"Failed to create table";                
            }
            sqlite3_close(database);
            
        }else
        {           
            status.text = @"Failed to open/create database";
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)saveData:(id)sender {
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &database)== SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO CONTACTS (name, address, mobile) VALUES (\"%@\",\"%@\",\"%@\")", name.text, address.text, mobile.text];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            status.text = @"contact added";
            name.text = @"";
            address.text = @"";
            mobile.text = @"";
            
        }else
        {
            status.text = @"Failed to add contact.";
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
}

- (IBAction)findData:(id)sender {
}

- (IBAction)findContact:(id)sender {
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT * FROM contacts"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    NSString *nameField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    name.text = nameField;
                    [dict setObject:nameField forKey:@"name"];
                    NSString *addressField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    address.text = addressField;
                    [dict setObject:addressField forKey:@"address"];
                    NSString *phoneField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                    mobile.text = phoneField;
                    [dict setObject:phoneField forKey:@"phone"];
                    status.text = @"Match found";
                    [dataArray addObject:dict];
                    NSLog(@"dataArray=%@",dataArray);
                }
            } else {
                status.text = @"Match not found";
                address.text = @"";
                mobile.text = @"";
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
}

@end
