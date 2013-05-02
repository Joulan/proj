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
    UIBarButtonItem *sendBarButton1;
    UIBarButtonItem *sendBarButton2;
    
    NSArray *listDataOfDirectories;
    NSArray *listDataOfFiles;
    NSArray *listDataOfAll;
    
    AppDelegate *appdelegate;
    
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
@property (nonatomic, retain) IBOutlet UIBarButtonItem *sendBarButton1;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *sendBarButton2;
@property (nonatomic, retain) NSArray *listDataOfDirectories;
@property (nonatomic, retain) NSArray *listDataOfFiles;
@property (nonatomic, retain) NSArray *listDataOfAll;
@property (nonatomic, retain) AppDelegate *appdelegate;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)sendButtonPressed:(id)sender;
- (IBAction)linkButtonPressed:(id)sender;
- (IBAction)changeButtonPressed:(id)sender;

@end
