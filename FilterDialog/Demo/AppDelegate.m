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
    self.arrayController = [[NSArrayController alloc] initWithContent:self.stuff];
    
    [self.arrayController addObserver:self
                           forKeyPath:@"selectionIndexes"
                              options:0
                              context:nil];
    
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
     cellViewBlock:^NSTableCellView * _Nonnull(EJVFilterListWindowController *dialog, NSTableCellView * _Nullable reusingView, id  _Nonnull object) {
         if (reusingView) {
             return reusingView;
         }
         
         NSNib *nib = [[NSNib alloc] initWithNibNamed:@"TableCell" bundle:nil];
         
         NSArray *views = nil;
         [nib instantiateWithOwner:nil topLevelObjects:&views];
         
         NSTableCellView *view = views[[views indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             return [obj isKindOfClass:[NSTableCellView class]];
         }]];
         
         // The reason we don't utilize the textField outlet of NSTableCellView is because
         // the table view's source list style will muck with the text field's text attributes
         EJVHighlightingTextField *textField = [view viewWithTag:1000];
         textField.underlineMatches = YES;
         
         [textField bind:@"searchString"
                     toObject:self.filterDialog
                  withKeyPath:@"searchText"
                      options:nil];
         
         return view;
     }];
    
    self.filterDialog.clearsSearchTextOnDismiss = YES;
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

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    if (object == self.arrayController) {
        if ([self.arrayController.selectionIndexes count] > 0) {
            NSLog(@"Hot item: %@", [self.arrayController.arrangedObjects objectAtIndex:self.arrayController.selectionIndex]);
        }
    }
}

@end
