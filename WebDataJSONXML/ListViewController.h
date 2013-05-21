//
//  ListViewController.h
//  WebDataJSONXML
//
//  Created by Thor on 4/30/13.
//  Copyright (c) 2013 unlimited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UITableViewController<NSXMLParserDelegate>

@property (strong, nonatomic) NSMutableData *xmlData;
@property (strong, nonatomic) NSMutableArray *currentArray;
@property (strong, nonatomic) NSXMLParser *myParser;
@property (strong, nonatomic) NSString *currentelement;
@property (strong, nonatomic) NSString *pastelement;
@property (nonatomic) NSInteger pastcounter;
- (IBAction)WebContChoice:(UISegmentedControl *)sender;

@end
