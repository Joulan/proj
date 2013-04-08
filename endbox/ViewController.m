//
//  ViewController.m
//  endbox
//
//  Created by Mac on 05.04.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "Base64.h"


@implementation ViewController
@synthesize landscape;
@synthesize portrait;
@synthesize tableView1;
@synthesize tableView2;
@synthesize tableView3;
@synthesize changeBarButton1;
@synthesize changeBarButton2;
@synthesize linkBarButton1;
@synthesize linkBarButton2;
@synthesize listDataOfDirectories;
@synthesize listDataOfFiles;
@synthesize listDataOfAll;
@synthesize openedFolder;


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
//    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
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
    openedFolder = @"/";
    isFolIOS = TRUE;
    self.linkBarButton1.title = self.linkBarButton2.title = ([[DBSession sharedSession] isLinked]) ? @"Unlink DB" : @"Link to DB";
    self.changeBarButton1.title = self.changeBarButton2.title = (isFolIOS) ? @"To DB" : @"To IOS";
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
    if(url == nil)
        return nil;
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

- (NSString *)GetContentOfFile:(NSString *)path {
    NSError *error;
    NSString *text = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    return text;
}

- (void)SetContentOfFile:(NSString *)path Text:(NSString *)txt {
    NSError *error;
    [txt writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
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
        cell.imageView.image = [UIImage imageNamed:@"Folder.png"];
        cell.textLabel.text = [self.listDataOfDirectories objectAtIndex:row];
    } else 
        if([self.listDataOfDirectories containsObject:[self.listDataOfAll objectAtIndex:row]])
            cell.imageView.image = [UIImage imageNamed:@"Folder.png"];
        else
            cell.imageView.image = [UIImage imageNamed:@"File.png"];
        cell.textLabel.text = [self.listDataOfAll objectAtIndex:row];
    
    return cell;
}

- (void)reloadTables {
    if (isFolIOS) {
        self.listDataOfDirectories = [self GetListOfDirectories:openedFolder];
        self.listDataOfFiles = [self GetListOfFiles:openedFolder];
        self.listDataOfAll = [self GetListOfAll:openedFolder];
        [tableView1 reloadData];
        [tableView2 reloadData];
        [tableView3 reloadData];
    } else {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate GetList:openedFolder];
    }
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
    else {
        if([self.listDataOfDirectories containsObject:[self.listDataOfAll objectAtIndex:row]])
            self.openedFolder = [openedFolder stringByAppendingPathComponent:[self.listDataOfAll objectAtIndex:row]];
        else {
            NSString *path = [openedFolder stringByAppendingPathComponent:[self.listDataOfAll objectAtIndex:row]];
            if(isFolIOS) {
                [self Uploading:path Destination:@"/"];
            } else {
                [self Downloading:path Destination:@"/Users/mac/Desktop/test.txtdbx"];
            }
        }
    }
    [self reloadTables];
}

- (void)Downloading:(NSString *)path Destination:(NSString *)dest {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate downloadFile:path Destination:dest];
}

- (void)Uploading:(NSString *)path Destination:(NSString *)dest {
    NSString *pth = path;
    NSData *datacontent = [[NSData alloc] initWithContentsOfFile:pth];
    NSString *result = [Base64 encode:datacontent];
    pth = [pth stringByAppendingString:@"dbx"];
    [self SetContentOfFile:pth Text:result];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate uploadFile:pth Destination:dest];
}

- (IBAction)backButtonPressed:(id)sender {
    self.openedFolder = [openedFolder stringByDeletingLastPathComponent];
    [self reloadTables];
}

- (IBAction)changeButtonPressed:(id)sender {
    if (![[DBSession sharedSession] isLinked])
        return;
    self.openedFolder = @"/";
    isFolIOS = !isFolIOS;
    [self reloadTables];
    if(isFolIOS)
        self.changeBarButton1.title = self.changeBarButton1.title = @"To DB";
    else
        self.changeBarButton1.title = self.changeBarButton1.title = @"To IOS";
}

- (IBAction)linkButtonPressed:(id)sender {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
        self.linkBarButton1.title = self.linkBarButton2.title = @"Unlink to DB";
    } else 
        self.linkBarButton1.title = self.linkBarButton2.title = @"Link to DB";
}

@end
