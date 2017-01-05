//
//  AppDelegate.m
//  FilterDialog
//
//  Created by Ethan Vaughan on 1/5/17.
//  Copyright © 2017 Ethan James Vaughan. All rights reserved.
//

#import "AppDelegate.h"
#import "EJVFilterListWindowController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong) NSArray<NSString *> *stuff;
@property (strong) EJVFilterListWindowController *filterDialog;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    // Data that we will be filtering
    self.stuff = @[ @"Hello", @"Foo", @"Bar", @"Baz", @"World" ];
    
    // Create the array controller that will supply data to the filter dialog
    NSArrayController *arrayController = [[NSArrayController alloc] init];
    [arrayController bind:NSContentArrayBinding
                 toObject:self
              withKeyPath:@"stuff"
                  options:nil];
    
    // Set up a filter predicate to drive searching
    // A special substitution variable is replaced with the search text
    NSPredicate *filterPredicate =
    [NSPredicate predicateWithFormat:
     [NSString stringWithFormat:
      @"self contains[cd] $%@",
      kEJVFilterListPredicateSubstitutionVariableName]];
    
    self.filterDialog =
    [[EJVFilterListWindowController alloc]
     initWithArrayController:arrayController
     filterPredicate:filterPredicate
     cellClass:nil
     cellNib:[[NSNib alloc] initWithNibNamed:@"TableCell" bundle:nil]];
}

- (IBAction)openDialog:(id)sender
{
    [self.filterDialog.window makeKeyAndOrderFront:nil];
}

@end
