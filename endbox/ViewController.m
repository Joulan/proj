//
//  ViewController.m
//  endbox
//
//  Created by Mac on 05.04.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize landscape;
@synthesize portrait;
@synthesize tableView1;
@synthesize tableView2;
@synthesize tableView3;
@synthesize listData1;
@synthesize listData2;
@synthesize openedFolder;


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view = self.portrait;
        self.view.transform = CGAffineTransformIdentity;
        self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(0));
        self.view.bounds = CGRectMake(0.0, 0.0, 320.0, 460.0);
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.view = self.landscape;
        self.view.transform = CGAffineTransformIdentity;
        self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(-90));
        self.view.bounds = CGRectMake(0.0, 0.0, 480.0, 300.0);
    } else if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.view = self.portrait;
        self.view.transform = CGAffineTransformIdentity;
        self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(180));
        self.view.bounds = CGRectMake(0.0, 0.0, 320.0, 460.0);
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.view = self.landscape;
        self.view.transform = CGAffineTransformIdentity;
        self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(90));
        self.view.bounds = CGRectMake(0.0, 0.0, 480.0, 300.0);
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{    
    //get files
    openedFolder = @"/";//[[NSBundle mainBundle] resourcePath];
    [self _refreshTables];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    self.portrait = nil;
    self.landscape = nil;
    self.tableView1 = nil;
    self.tableView2 = nil;
    self.tableView3 = nil;
    self.listData1 = nil;
    self.listData2 = nil;
    self.openedFolder = nil;
    [super viewDidUnload];
}

- (void)dealloc {
    [portrait release];
    [landscape release];
    [tableView1 release];
    [tableView2 release];
    [tableView3 release];
    [listData1 release];
    [listData2 release];
    [openedFolder release];
    [super dealloc];
}

- (void)_refreshTables {
    NSError * error;
    //NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:openedFolder error:&error];  
    
    NSURL * url = [[NSURL alloc] initWithString:openedFolder];
    NSArray * directoryContents = [ [NSFileManager defaultManager] contentsOfDirectoryAtURL:url includingPropertiesForKeys: [NSArray arrayWithObjects: NSURLCreationDateKey, NSURLNameKey, nil] options:0 error:&error ];
    
    NSMutableArray *ld1 = [[NSMutableArray alloc] init];
    NSMutableArray *ld2 = [[NSMutableArray alloc] init];
    for (int i = 0; i < [directoryContents count]; i++) {
        NSString *str = [[directoryContents objectAtIndex:i] path];
        //NSRange res = [str rangeOfString:@"."];
  //     if( ![[directoryContents objectAtIndex:i] ])
            [ld1 addObject:str];
        [ld2 addObject:str];
    }
    
    self.listData1 = ld1;
    self.listData2 = ld2;
    [ld1 release];
    [ld2 release];
//    [url release];
//    [directoryContents release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark Table View Data Sourse Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView2) {
        return [self.listData1 count];
    } else{
        return [self.listData2 count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier =
    @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if(cell == nil) {
        cell = [[[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:SimpleTableIdentifier] autorelease];
    }
    NSUInteger row = [indexPath row];
    if(tableView == self.tableView2) {
        UIImage *image = [UIImage imageNamed:@"Box.png"];
        cell.imageView.image = image;
        cell.textLabel.text = [self.listData1 objectAtIndex:row];
    } else {
        cell.textLabel.text = [self.listData2 objectAtIndex:row];
    }
    
    return cell;
    
}

//will selected table item
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    return indexPath;
}

//did selected table item
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier =
    @"SimpleTableIdentifier";
    NSUInteger row = [indexPath row];
    
    //NSString *rowValue = [listData objectAtIndex:row];
    
    //NSString *message = [[NSString alloc] initWithFormat:@"You selected %@", rowValue];
    //UIAlertView *alert = [[UIAlertView alloc]
    //                      initWithTitle:@"Row Selected!" message:message delegate:nil cancelButtonTitle:@"Yes I did"
    //otherButtonTitles:nil];
    //[alert show];
    
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    NSMutableString *tmp = [[NSMutableString alloc] initWithCapacity:30];
    [tmp appendString: openedFolder];
    NSString *nn = [self.listData2 objectAtIndex:row];
    [tmp appendString:nn];
    [tmp appendString: @"/"];
    
    
    //openedFolder = nil;
    self.openedFolder = [tmp retain];
    
    [self _refreshTables];
    
    [tableView1 reloadData];
    [tableView2 reloadData];
    [tableView3 reloadData];
    
}

- (IBAction)backButtonPressed:(id)sender {
    NSMutableString *tmp = [[NSMutableString alloc] init];
    [tmp appendString:openedFolder];
    NSInteger i = tmp.length - 1; 
    
    if(i <= 0)
        return;
    
    while(i > -1) {
        if([tmp characterAtIndex: --i] == '/')
            break;
    }
    tmp = [tmp substringToIndex: i + 1];
    
    //openedFolder = nil;
    self.openedFolder = [tmp retain];
    
    [self _refreshTables];
    
    [tableView1 reloadData];
    [tableView2 reloadData];
    [tableView3 reloadData];
}



@end
