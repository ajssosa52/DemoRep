//
//  ListViewController.m
//  WebDataJSONXML
//
//  Created by Thor on 4/30/13.
//  Copyright (c) 2013 unlimited. All rights reserved.
//

#import "ListViewController.h"
#define jsonURL [NSURL URLWithString:@"http://itunes.apple.com/us/rss/topalbums/limit=20/json"]

#define xmlURL [NSURL URLWithString:@"http://itunes.apple.com/us/rss/topalbums/limit=20/xml"]

@interface ListViewController ()
@property dispatch_queue_t globalQ;
@end

@implementation ListViewController

@synthesize currentArray;
@synthesize xmlData;
@synthesize myParser;
@synthesize currentelement;
@synthesize pastcounter;
@synthesize pastelement;

NSString *Name;
NSString *Artist;
bool inAreaCheck;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentArray = [[NSMutableArray alloc]init];
    _globalQ =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    xmlData = [[NSMutableData alloc] init];
    pastcounter = 0;
    pastelement = @"";
    //myParser = [[myParser alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.currentArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"WebCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        return cell;
    }else{
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        cell.textLabel.text = [[currentArray objectAtIndex:indexPath.row-1] objectAtIndex:0];
        cell.detailTextLabel.text=[[currentArray objectAtIndex:indexPath.row-1] objectAtIndex:1];
        return cell;
    }

    
    // Configure the cell...
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)WebContChoice:(UISegmentedControl *)sender {
    [self.currentArray removeAllObjects];
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self.currentArray addObject: [[NSArray alloc] initWithObjects:@"JSON",@"JSON", nil]];
            [self getJSONData];
            break;
        case 1:
            [self getXMLData];
            break;
        default:
            break;
    }
}

- (void) getJSONData{
    dispatch_async(_globalQ,^{
        NSData *data = [NSData dataWithContentsOfURL:jsonURL];
        [self performSelectorOnMainThread:@selector(retrieveJSONData:) withObject:data waitUntilDone:YES];
    });
}
- (void) retrieveJSONData:(NSData *)DataResponse{
    NSError *error;
    NSDictionary *jsonResponse =[NSJSONSerialization JSONObjectWithData:DataResponse options:0 error:&error];
    //NSLog(@"Dictionary %@", jsonResponse);
    //NSArray *keys = [jsonResponse keysSortedByValueUsingSelector:<#(SEL)#>];
    //NSLog(@"keys %@", keys);
    NSDictionary *entryarray = [jsonResponse objectForKey:@"feed"];
    NSLog(@"e keys%@", entryarray.allKeys);
    NSArray *authorarray = [entryarray objectForKey:@"entry"];
    
    for (int i = 0; i< authorarray.count; i++) {
        
    
        //NSLog(@"a keys%@", [authorarray objectAtIndex:0]);
        NSDictionary *itemsamp = [authorarray objectAtIndex:i];
        //NSLog(@"item keys%@", itemsamp.allKeys);
        NSDictionary *titles = [itemsamp objectForKey:@"title"];
        //NSLog(@"titles %@", titles.allKeys);
        NSString *title = [titles objectForKey:@"label"];
        NSDictionary *names = [itemsamp objectForKey:@"im:artist"];
        //NSLog(@"names %@", names.allKeys);
        NSString *artist =[names objectForKey:@"label"];
        //NSLog(@"artist %@",artist);
        title = [title stringByReplacingOccurrencesOfString:[NSString stringWithFormat: @" - %@",artist] withString:@""];
        [self.currentArray addObject:[[NSArray alloc] initWithObjects:title, artist, nil]];
    }
    NSLog(@"array %@", self.currentArray);
    [self.tableView reloadData];
}


- (void) getXMLData{
    //NSLog(@"Hi");
    NSData *data = [NSData dataWithContentsOfURL:xmlURL];
   // NSLog(@"Hi");
    self.myParser = [[NSXMLParser alloc] initWithData:data];
    NSLog(@"init %@", myParser);
    self.myParser.delegate = self;
    [self.currentArray removeAllObjects];
    [self.currentArray addObject: [[NSArray alloc] initWithObjects:@"XML",@"XML", nil]];
    [self.myParser parse];
    [self.tableView reloadData];
   // NSLog(@"parsed?");
    //myParser = [;
                   // loadxml:data;
}
# pragma methods

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    currentelement =[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(pastcounter == 0) {
        if ([currentelement isEqualToString:@"&"]) {
            currentelement = [currentelement stringByAppendingString:@" "];
            pastelement = [pastelement stringByAppendingString:@" "];
            currentelement = [pastelement stringByAppendingString:currentelement];
        }else if ([string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]].location != NSNotFound ) {
            currentelement = [pastelement stringByAppendingString:currentelement];
        }else if ([string rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]].location != NSNotFound ) {
            currentelement = [pastelement stringByAppendingString:currentelement];
        }else if ([string rangeOfCharacterFromSet:[NSCharacterSet punctuationCharacterSet]].location != NSNotFound ) {
            //currentelement = [currentelement stringByAppendingString:@" "];
            //pastelement = [pastelement stringByAppendingString:@" "];
            currentelement = [pastelement stringByAppendingString:currentelement];
        }
        pastelement = currentelement;
    }
    
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{

    if ([elementName isEqualToString:@"entry"]) {
        Name = @"";
        Artist = [NSString alloc];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    NSLog(@"element %@ string %@",elementName,currentelement);

    if ([elementName isEqualToString:@"title"]) {
        //pastcounter = YES;
    }
    
    if ([elementName isEqualToString:@"im:name"]) {
       // currentelement = [[pastelement objectAtIndex:(pastcounter%3)] stringByAppendingString:currentelement ];;
        //currentelement = [[pastelement objectAtIndex:((pastcounter+2)%3)] stringByAppendingString:currentelement ];
        Name = [Name stringByAppendingString: currentelement];
        NSLog(@"title %@",Name);
        pastcounter = 0;
    }
    if ([elementName isEqualToString:@"im:artist"]) {
        //currentelement = [[pastelement objectAtIndex:(pastcounter%3)] stringByAppendingString:currentelement ];
        Artist = currentelement;
        NSLog(@"art %@",Artist);
        pastcounter = 0;
    }
    if ([elementName isEqualToString:@"content"]) {
        [self.currentArray addObject: [[NSArray alloc] initWithObjects:Name,Artist, nil]];
        Name = nil;
        Artist =nil;
    }
    
    
}

/*
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"%@", response.description);
    [xmlData setLength:0];

}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [xmlData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{

    [xmlData setLength:0];
    NSLog(@"%@",error);
}
*/

@end
