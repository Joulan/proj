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
@synthesize listDataOfDirectories;
@synthesize listDataOfFiles;
@synthesize listDataOfAll;
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
    self.listDataOfDirectories = [self GetListOfDirectories:openedFolder];
    self.listDataOfFiles = [self GetListOfFiles:openedFolder];
    self.listDataOfAll = [self GetListOfAll:openedFolder];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    self.portrait = nil;
    self.landscape = nil;
    self.tableView1 = nil;
    self.tableView2 = nil;
    self.tableView3 = nil;
    self.listDataOfDirectories = nil;
    self.listDataOfFiles = nil;
    self.listDataOfAll = nil;
    self.openedFolder = nil;
    [super viewDidUnload];
}

- (void)dealloc {
    [portrait release];
    [landscape release];
    [tableView1 release];
    [tableView2 release];
    [tableView3 release];
    [listDataOfDirectories release];
    [listDataOfFiles release];
    [listDataOfAll release];
    [openedFolder release];
    [super dealloc];
}

- (NSArray*) GetListOfDirectories:(NSString*)path {
    NSMutableArray *lod = [self GetList:path Mode:1];
    NSArray *reslod = [lod copy];
    [lod release];
    return reslod;
}

- (NSArray*) GetListOfFiles:(NSString*)path {
    NSMutableArray *lof = [self GetList:path Mode:2];
    NSArray *reslof = [lof copy];
    [lof release];
    return reslof;
}

- (NSArray*) GetListOfAll:(NSString*)path {
    NSMutableArray *loa = [self GetList:path Mode:3];
    NSArray *resloa = [loa copy];
    [loa release];
    return resloa;
}

//mode : 1-directoeies, 2-files, other-all
- (NSMutableArray*) GetList:(NSString*)path Mode:(NSInteger)mode {
    NSError * error;
    NSURL * url = [[NSURL alloc] initWithString:openedFolder];
    NSArray * directoryContents = [ [NSFileManager defaultManager] contentsOfDirectoryAtURL:url includingPropertiesForKeys: [NSArray arrayWithObjects: NSURLCreationDateKey, NSURLNameKey, nil] options:0 error:&error ];
    NSMutableArray *ld1 = [[NSMutableArray alloc] init];
    NSMutableArray *ld2 = [[NSMutableArray alloc] init];
    for (int i = 0; i < [directoryContents count]; i++) {
        BOOL isDir;
        [[NSFileManager defaultManager] fileExistsAtPath:[[directoryContents objectAtIndex:i] path] isDirectory:&isDir];
        if(isDir)
            [ld1 addObject:[[directoryContents objectAtIndex:i] lastPathComponent]];
        else
            [ld2 addObject:[[directoryContents objectAtIndex:i] lastPathComponent]];
    }
    [url release];
    switch (mode) {
        case 1:
            [ld2 release];
            return ld1;
        case 2:
            [ld1 release];
            return ld2;
    }
    [ld1 addObjectsFromArray:ld2];
    [ld2 release];
    return ld1;
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
    if (tableView == self.tableView2)
        return [self.listDataOfDirectories count];
    else
        return [self.listDataOfAll count];
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
        cell.textLabel.text = [self.listDataOfDirectories objectAtIndex:row];
    } else 
        cell.textLabel.text = [self.listDataOfAll objectAtIndex:row];
    
    return cell;
}

- (void)reloadTables {
    self.listDataOfDirectories = [self GetListOfDirectories:openedFolder];
    self.listDataOfFiles = [self GetListOfFiles:openedFolder];
    self.listDataOfAll = [self GetListOfAll:openedFolder];
    [tableView1 reloadData];
    [tableView2 reloadData];
    [tableView3 reloadData];
}

//will selected table item
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

//did selected table item
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    if (tableView == tableView2)
        self.openedFolder = [openedFolder stringByAppendingPathComponent:[self.listDataOfDirectories objectAtIndex:row]];
    else
        self.openedFolder = [openedFolder stringByAppendingPathComponent:[self.listDataOfAll objectAtIndex:row]];
    [self reloadTables];
}

- (IBAction)backButtonPressed:(id)sender {
    self.openedFolder = [openedFolder stringByDeletingLastPathComponent];
    [self reloadTables];
}



@end
