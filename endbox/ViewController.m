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
@synthesize sendBarButton1;
@synthesize sendBarButton2;
@synthesize listDataOfDirectories;
@synthesize listDataOfFiles;
@synthesize listDataOfAll;
@synthesize appdelegate;


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
//    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view = self.portrait;
        self.view.transform = CGAffineTransformIdentity;
        self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(0));
        self.view.bounds = CGRectMake(0.0, 0.0, 740.0, 960.0);
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.view = self.landscape;
        self.view.transform = CGAffineTransformIdentity;
        self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(-90));
        self.view.bounds = CGRectMake(0.0, 0.0, 980.0, 720.0);
    } else if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.view = self.portrait;
        self.view.transform = CGAffineTransformIdentity;
        self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(180));
        self.view.bounds = CGRectMake(0.0, 0.0, 740.0, 960.0);
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.view = self.landscape;
        self.view.transform = CGAffineTransformIdentity;
        self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(90));
        self.view.bounds = CGRectMake(0.0, 0.0, 980.0, 720.0);
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {    
    [super viewDidLoad];
    self.appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.listDataOfDirectories = [appdelegate GetListOfDirectories:appdelegate.openedFolder];
    self.listDataOfFiles = [appdelegate GetListOfFiles:appdelegate.openedFolder];
    self.listDataOfAll = [appdelegate GetListOfAll:appdelegate.openedFolder];
    
    self.tableView1.rowHeight = self.tableView2.rowHeight = self.tableView3.rowHeight = 40;
    self.tableView1.separatorStyle = self.tableView2.separatorStyle = self.tableView3.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView1.backgroundColor = self.tableView2.backgroundColor = self.tableView3.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gradientBackground.png"]];
    self.linkBarButton1.title = self.linkBarButton2.title = @"Unlink to DB";
    [self linkButtonPressed:nil];
    
    UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 30)] autorelease];
	UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)] autorelease];
	headerLabel.text = @"DBEncode";
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.shadowColor = [UIColor blackColor];
	headerLabel.shadowOffset = CGSizeMake(0, 1);
	headerLabel.font = [UIFont boldSystemFontOfSize:20];
	headerLabel.backgroundColor = [UIColor clearColor];
	[containerView addSubview:headerLabel];
	self.tableView1.tableHeaderView = self.tableView2.tableHeaderView = self.tableView3.tableHeaderView = containerView;

}

- (void)viewDidUnload {
    self.portrait = nil;
    self.landscape = nil;
    self.tableView1 = nil;
    self.tableView2 = nil;
    self.tableView3 = nil;
    self.sendBarButton1 = nil;
    self.sendBarButton2 = nil;
    self.linkBarButton1 = nil;
    self.linkBarButton2 = nil;
    self.changeBarButton1 = nil;
    self.changeBarButton2 = nil;
    self.listDataOfDirectories = nil;
    self.listDataOfFiles = nil;
    self.listDataOfAll = nil;
    [super viewDidUnload];
}

- (void)dealloc {
    [portrait release];
    [landscape release];
    [tableView1 release];
    [tableView2 release];
    [tableView3 release];
    [sendBarButton1 release];
    [sendBarButton2 release];
    [linkBarButton1 release];
    [linkBarButton2 release];
    [changeBarButton1 release];
    [changeBarButton2 release];
    [listDataOfDirectories release];
    [listDataOfFiles release];
    [listDataOfAll release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
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
    
    UILabel *topLabel;
    UILabel *bottomLabel;
    
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if(cell == nil) {
        cell = [[[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:SimpleTableIdentifier] autorelease];

        //Помещение картинки indicator.png в accessoryView
        UIImage *indicatorImage = [UIImage imageNamed:@"indicator.png"];
        cell.accessoryView = [[[UIImageView alloc] initWithImage:indicatorImage] autorelease];
        
        //Создание константы для хранения высоты надписей
        const CGFloat LABEL_HEIGHT = 20;
        //Получение картинки Folder.png (она нужна будет для получения размеров этой картинки)
        UIImage *image = [UIImage imageNamed:@"Folder.png"];
        
        //Инициализация верхней надписи
        CGRect topLabelFrame = CGRectMake(60, //image.size.width + 1.0 * cell.indentationWidth, 
                                          5,//0.5 * (tableView.rowHeight - 2 * LABEL_HEIGHT), 
                                          tableView.bounds.size.width - image.size.width - 
                                          4.0 * cell.indentationWidth - indicatorImage.size.width, 
                                          LABEL_HEIGHT);
        //CGRect topLabelFrame = CGRectMake(30, 30, 290, LABEL_HEIGHT);
        
        topLabel = [[[UILabel alloc] initWithFrame:topLabelFrame] autorelease];
        [cell.contentView addSubview:topLabel];
        
        //установка значений для верхней надписи
        topLabel.tag = 1;
        topLabel.backgroundColor = [UIColor clearColor];
        topLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        topLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
        topLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        
        //Инициализация нижней надписи
        CGRect bottomLabelFrame = CGRectMake(80,//image.size.width + 2.0 * cell.indentationWidth,
                                             0.5 * (tableView.rowHeight - 2 * LABEL_HEIGHT) + LABEL_HEIGHT, 
                                             tableView.bounds.size.width - image.size.width - 
                                             4.0 * cell.indentationWidth - indicatorImage.size.width, 
                                             LABEL_HEIGHT);
        bottomLabel = [[[UILabel alloc] initWithFrame:bottomLabelFrame] autorelease];
        [cell.contentView addSubview:bottomLabel];
        
        //установка значений для нижней надписи
        bottomLabel.tag = 2;
        bottomLabel.backgroundColor = [UIColor clearColor];
        bottomLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        bottomLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
        bottomLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 2];
        
        //инициализация фонов
        cell.backgroundView = [[UIImageView new] autorelease];
        cell.selectedBackgroundView = [[UIImageView new] autorelease];
        
    } else {
        //получение надписей по тэгу
        topLabel = (UILabel *)[cell viewWithTag:1];
        bottomLabel = (UILabel *)[cell viewWithTag:2];
    }
    
    if(tableView == self.tableView2) {
        cell.imageView.image = [UIImage imageNamed:@"Folder.png"];
        topLabel.text = [self.listDataOfDirectories objectAtIndex:indexPath.row];
        bottomLabel.text = @"folder";
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        if([self.listDataOfDirectories containsObject:[self.listDataOfAll objectAtIndex:indexPath.row]]) {
            cell.imageView.image = [UIImage imageNamed:@"Folder.png"];
            bottomLabel.text = @"folder";
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.imageView.image = [UIImage imageNamed:@"File.png"];
            bottomLabel.text = @"file";
        }
        topLabel.text = [self.listDataOfAll objectAtIndex:indexPath.row];
    }
    
    
    //создание картинок которые будем помещать в ячейки
	UIImage *rowBackground;
	UIImage *selectionBackground;
	NSInteger sectionRows = [tableView numberOfRowsInSection:[indexPath section]];
    NSUInteger row = [indexPath row];
    
    if (row == 0 && row == sectionRows - 1) {
        //Если ячейка одна в группе - устанавилваем ей картинку со всеми закругленными углами
		rowBackground = [UIImage imageNamed:@"topAndBottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"topAndBottomRowSelected.png"];
	}
	else if (row == 0) {
        //для первой ячейки в группе - устанавливаем картинку с верхними закругленными углами
		rowBackground = [UIImage imageNamed:@"topRow.png"];
		selectionBackground = [UIImage imageNamed:@"topRowSelected.png"];
	}
	else if (row == sectionRows - 1) {
        //всем ячейкам, которые в середине группы устанавливаем картинки без закругленных углов
		rowBackground = [UIImage imageNamed:@"bottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"bottomRowSelected.png"];
	}
	else {
        //последней ячейке устанавливаем картинку с закругленными нижними углами
		rowBackground = [UIImage imageNamed:@"middleRow.png"];
		selectionBackground = [UIImage imageNamed:@"middleRowSelected.png"];
	}
    
    //установка картинок
    if ([self.appdelegate.toSending containsObject:[self.listDataOfAll objectAtIndex:row]])
        ((UIImageView *)cell.backgroundView).image = selectionBackground;
    else
        ((UIImageView *)cell.backgroundView).image = rowBackground;
	((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;


    return cell;
}

//will selected table item
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

//did selected table item
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.appdelegate RowSelected:tableView AtIndexPath:indexPath];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.appdelegate BackSelected];
    //NSLog(@"%@",[[DBSession sharedSession] userIds]);
}

- (IBAction)changeButtonPressed:(id)sender {
    [self.appdelegate ChangeFileSystem];
}

- (IBAction)linkButtonPressed:(id)sender {
    if (self.appdelegate.netStatus == NotReachable)
        return;
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
        if ([[DBSession sharedSession] isLinked])
            self.linkBarButton1.title = self.linkBarButton2.title = @"Unlink to DB";
        else
            self.linkBarButton1.title = self.linkBarButton2.title = @"Link to DB";
    } else {
        [[DBSession sharedSession] unlinkAll];
        self.linkBarButton1.title = self.linkBarButton2.title = @"Link to DB";
    }
}

- (IBAction)sendButtonPressed:(id)sender {
    [self.appdelegate SendFiles];
}

@end
