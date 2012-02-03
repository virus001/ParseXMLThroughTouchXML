//
//  ViewController.m
//  ChkTouchXML
//
//  Created by Vishwanath Uddanti on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "TouchXML.h"

@implementation ViewController

@synthesize respData, respArray, activityIndicator;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.title = @"Rss Reader";
    
    //Initialize Data and array to load appropriate values in it
    respData = [[NSMutableData alloc]init];
    respArray = [[NSMutableArray alloc]init];
    
    
    
    activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(350, 500, 50, 50)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
    
    //For understanding, a simple RSS Feed is used
    
    NSString *urlStr = @"http://rss.news.yahoo.com/rss/entertainment";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    
    
    
    
}



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Connection Failed" 
                                                       message:[error localizedDescription] 
                                                      delegate:self 
                                             cancelButtonTitle:@"OK" 
                                             otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [respData appendData:data];   
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //Check what is in Response
    
    NSString *tempStr = [[NSString alloc]initWithBytes:[respData bytes] 
                                                length:[respData length] 
                                              encoding:NSUTF8StringEncoding];
    
    NSLog(@"Final Data = %@",tempStr);
    
    [tempStr release];
    
    //Parse the downloaded Info
    [self readFromXML];
    
}

-(void)readFromXML 
{
    //The following line is to initialize touchxml document with response data captured above
    CXMLDocument *docXML = [[CXMLDocument alloc]initWithData:respData options:0 error:nil];
    
    //Array to get respective Node(s)
    NSArray *nodes = NULL;
    
    //copy all the nodes of title tag from xmldocument
    nodes = [docXML nodesForXPath:@"//title" error:nil];
    
    //loop to get the value found inside the title tag
    for (CXMLElement *node in nodes) {
        //populate all the values taking from the node(element) into the array
        [respArray addObject:[node stringValue]];
    }
    
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    [activityIndicator release];
    activityIndicator = nil;
    
    //Programmatic table view creation and loading of values to it
    UITableView *tblView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
    tblView.delegate = self;
    tblView.dataSource = self;
    [self.view addSubview:tblView];
    
    [tblView reloadData];
    
    [tblView release];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [respArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
    }
    cell.textLabel.text = [respArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)dealloc
{
    [respArray release];
    [respData release];
    
    respArray = nil;
    respData = nil;
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return NO;
}

@end
