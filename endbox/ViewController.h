//
//  ViewController.h
//  endbox
//
//  Created by Mac on 05.04.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define degreesToRadians(x) (M_PI * (x) / 180.0)

@interface ViewController : UIViewController 
<UITableViewDelegate, UITableViewDataSource>  {
    
    UIView *landscape;
    UIView *portrait;
    
    UITableView *tableView1;
    UITableView *tableView2;
    UITableView *tableView3;
    
    NSArray *listData1;
    NSArray *listData2;
    
    NSString *openedFolder;
    
}

@property (nonatomic, retain) IBOutlet UIView *landscape;
@property (nonatomic, retain) IBOutlet UIView *portrait;
@property (nonatomic, retain) IBOutlet UITableView *tableView1;
@property (nonatomic, retain) IBOutlet UITableView *tableView2;
@property (nonatomic, retain) IBOutlet UITableView *tableView3;
@property (nonatomic, retain) NSArray *listData1;
@property (nonatomic, retain) NSArray *listData2;
@property (nonatomic, retain) NSString *openedFolder;
- (IBAction)backButtonPressed:(id)sender;

@end
