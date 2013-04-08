//
//  ViewController.h
//  endbox
//
//  Created by Mac on 05.04.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#define degreesToRadians(x) (M_PI * (x) / 180.0)

@interface ViewController : UIViewController 
<UITableViewDelegate, UITableViewDataSource>  {
    
    UIView *landscape;
    UIView *portrait;
    
    UITableView *tableView1;
    UITableView *tableView2;
    UITableView *tableView3;
    
    UIBarButtonItem *changeBarButton1;
    UIBarButtonItem *changeBarButton2;
    UIBarButtonItem *linkBarButton1;
    UIBarButtonItem *linkBarButton2;
    
    
    NSArray *listDataOfDirectories;
    NSArray *listDataOfFiles;
    NSArray *listDataOfAll;
    
    NSString *openedFolder;
    
    BOOL isFolIOS;
    
}

@property (nonatomic, retain) IBOutlet UIView *landscape;
@property (nonatomic, retain) IBOutlet UIView *portrait;
@property (nonatomic, retain) IBOutlet UITableView *tableView1;
@property (nonatomic, retain) IBOutlet UITableView *tableView2;
@property (nonatomic, retain) IBOutlet UITableView *tableView3;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *changeBarButton1;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *changeBarButton2;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *linkBarButton1;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *linkBarButton2;
@property (nonatomic, retain) NSArray *listDataOfDirectories;
@property (nonatomic, retain) NSArray *listDataOfFiles;
@property (nonatomic, retain) NSArray *listDataOfAll;
@property (nonatomic, retain) NSString *openedFolder;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)linkButtonPressed:(id)sender;
- (IBAction)changeButtonPressed:(id)sender;

- (NSArray*) GetListOfDirectories:(NSString*)path;
- (NSArray*) GetListOfFiles:(NSString*)path;- (NSArray*) GetListOfAll:(NSString*)path;
- (NSMutableArray*) GetList:(NSString*)path Mode:(NSInteger)mode;
- (void)reloadTables;

- (NSString *)GetContentOfFile:(NSString *)path;
- (void)SetContentOfFile:(NSString *)path Text:(NSString *)txt;

@end
