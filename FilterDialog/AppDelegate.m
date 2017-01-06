//
//  AppDelegate.m
//  FilterDialog
//
//  Created by Ethan Vaughan on 1/5/17.
//  Copyright © 2017 Ethan James Vaughan. All rights reserved.
//

#import "AppDelegate.h"
#import "EJVFilterListWindowController.h"
#import "EJVHighlightingTextField.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong) NSArray<NSString *> *stuff;
@property (strong) NSArrayController *arrayController;
@property (strong) EJVFilterListWindowController *filterDialog;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    // Data that we will be filtering
    self.stuff = @[ @"Hello", @"Foo", @"Bar", @"Baz", @"World" ];
    
    // Create the array controller that will supply data to the filter dialog
    self.arrayController = [[NSArrayController alloc] init];
    [self.arrayController bind:NSContentArrayBinding
                      toObject:self
                   withKeyPath:@"stuff"
                       options:nil];
    
    self.filterDialog =
    [[EJVFilterListWindowController alloc]
     initWithArrayController:self.arrayController
     filterPredicateBlock:^NSPredicate * _Nonnull(NSString * _Nonnull searchText) {
         NSMutableString *fuzzySearch = [NSMutableString stringWithString:@"*"];
         [searchText enumerateSubstringsInRange:NSMakeRange(0, [searchText length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
             [fuzzySearch appendFormat:@"%@*", substring];
         }];
         return [NSPredicate predicateWithFormat:@"self like[cd] %@", fuzzySearch];
     }
     cellViewBlock:^NSTableCellView * _Nonnull(NSTableCellView * _Nullable reusingView, id  _Nonnull object) {
         if (reusingView) {
             return reusingView;
         }
         
         NSNib *nib = [[NSNib alloc] initWithNibNamed:@"TableCell" bundle:nil];
         
         NSArray *views = nil;
         [nib instantiateWithOwner:nil topLevelObjects:&views];
         
         NSTableCellView *view = views[[views indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             return [obj isKindOfClass:[NSTableCellView class]];
         }]];
         
         ((EJVHighlightingTextField *)view.textField).underlineMatches = YES;
         
         [view.textField bind:@"searchString"
                     toObject:self.filterDialog
                  withKeyPath:@"searchText"
                      options:nil];
         
         return view;
     }];
    
    self.filterDialog.target = self;
    self.filterDialog.selectionCommittedAction = @selector(filterDialogDidSelectRow:);
}

- (void)filterDialogDidSelectRow:(EJVFilterListWindowController *)sender
{
    // Get the selected object from the array controller
    NSString *selection = [[self.arrayController selectedObjects] firstObject];
    
    NSLog(@"You selected: %@", selection);
}

- (IBAction)openDialog:(id)sender
{
    [self.filterDialog.window makeKeyAndOrderFront:nil];
}

@end
