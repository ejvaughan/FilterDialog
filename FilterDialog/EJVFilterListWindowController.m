//
//  EVTabSearchWindowController.m
//  SearchTab
//
//  Created by Ethan Vaughan on 12/16/14.
//  Copyright (c) 2014 Ethan James Vaughan. All rights reserved.
//

#import "EJVFilterListWindowController.h"
#import "EJVTableRowView.h"
#import "EJVTableView.h"

static NSString * const kFilterListCellIdentifier = @"FilterListCell";

@interface EJVFilterListWindowController () <NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate>

@property (weak) IBOutlet NSTextField *searchField;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@property (strong) NSArrayController *arrayController;
@property (strong) NSTableCellView *(^cellViewBlock)(EJVFilterListWindowController *, NSTableCellView *, id);
@property (strong) NSPredicate *(^filterPredicateBlock)(NSString *);

@end

@implementation EJVFilterListWindowController

- (instancetype)initWithArrayController:(NSArrayController *)controller
                   filterPredicateBlock:(NSPredicate *(^)(NSString *searchText))filterPredicateBlock
                          cellViewBlock:(NSTableCellView *(^)(EJVFilterListWindowController *dialog, NSTableCellView *reusingView, id object))cellViewBlock
{
    self = [super initWithWindowNibName:@"EJVFilterListWindowController"];
    
    if (self) {
        _arrayController = controller;
        _filterPredicateBlock = filterPredicateBlock;
        _rowHeight = 44.0;
        _cellViewBlock = cellViewBlock;
        
        [_arrayController addObserver:self
                           forKeyPath:@"arrangedObjects"
                              options:NSKeyValueObservingOptionNew
                              context:NULL];
    }
    
    return self;
}

- (void)dealloc {
    [self.arrayController removeObserver:self forKeyPath:@"arrangedObjects"];
}

#pragma mark - Window management

/* 
   NSWindow -hidesOnDeactivate is set to NO (in the nib file) because the window needs to be shown even when
   the application is not active.
 
   NSWindow -level is set to NSPopUpMenuWindowLevel so that the panel will display above all other windows.
 
   The window is ordered out when the window resigns key status.
 */

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.window.level = NSPopUpMenuWindowLevel;
    self.window.animationBehavior = NSWindowAnimationBehaviorUtilityWindow;
    
    // We need to receive the delegate method control:textView:doCommandBySelector:
    self.searchField.delegate = self;
    
    // Sent when the user clicks a cell
    self.tableView.target = self;
    self.tableView.action = @selector(tableViewCellSelected:);
    
    self.tableView.rowHeight = self.rowHeight;
    
    // Set up bindings for table view
    [self.tableView bind:NSContentBinding
                toObject:self.arrayController
             withKeyPath:@"arrangedObjects"
                 options:nil];
    [self.tableView bind:NSSelectionIndexesBinding
                toObject:self.arrayController
             withKeyPath:@"selectionIndexes"
                 options:nil];
    
    [self recomputeHeightConstraint];
}

- (void)windowDidBecomeKey:(NSNotification *)notification
{
    [self.searchField becomeFirstResponder];
}

- (void)windowDidResignKey:(NSNotification *)notification;
{
    [self dismiss];
}

#pragma mark - Search field

- (NSString *)searchText
{
    return self.searchField.stringValue;
}

- (void)updateFilterPredicateForText:(NSString *)text
{
    self.arrayController.filterPredicate = ([text length] == 0) ? nil : self.filterPredicateBlock(text);
}

- (IBAction)searchFieldTextDidChange:(NSSearchField *)sender
{
    [self willChangeValueForKey:@"searchText"];
    [self didChangeValueForKey:@"searchText"];
    
    [self updateFilterPredicateForText:sender.stringValue];
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector
{
    if (commandSelector == @selector(moveUp:)) {
        NSInteger nextIndex = (self.tableView.selectedRow - 1 > 0) ? self.tableView.selectedRow - 1 : 0;
        [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:nextIndex] byExtendingSelection:NO];
        [self.tableView scrollRowToVisible:nextIndex];
        
        return YES;
    } else if (commandSelector == @selector(moveDown:)) {
        NSInteger nextIndex = (self.tableView.selectedRow + 1 < [self.arrayController.arrangedObjects count]) ? self.tableView.selectedRow + 1 : [self.arrayController.arrangedObjects count] - 1;
        [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:nextIndex] byExtendingSelection:NO];
        [self.tableView scrollRowToVisible:nextIndex];
        
        return YES;
    } else if (commandSelector == @selector(insertNewline:)) {
        if (self.tableView.selectedRow != -1) {
            [self commitSelectionForRow:self.tableView.selectedRow];
        }
        
        return YES;
    } else if (commandSelector == @selector(cancelOperation:)) {
        [self dismiss];
        
        return YES;
    }
    
    return NO;
}

- (void)tableViewCellSelected:(id)sender
{
    [self commitSelectionForRow:self.tableView.selectedRow];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *cell = [tableView makeViewWithIdentifier:tableColumn.identifier owner:nil];
    id object = [self.arrayController.arrangedObjects objectAtIndex:row];
    cell = self.cellViewBlock(self, cell, object);
    
    // Set the reuse identifier
    cell.identifier = tableColumn.identifier;
    
    return cell;
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row
{
    static NSString * const kEJVTableRowViewIdentifier = @"RowView";
    
    EJVTableRowView *rowView = [tableView makeViewWithIdentifier:kEJVTableRowViewIdentifier owner:nil];
    
    if (rowView == nil) {
        rowView = [[EJVTableRowView alloc] initWithFrame:NSZeroRect];
        rowView.identifier = kEJVTableRowViewIdentifier;
    }
    
    return rowView;
}

// The user's selection is "committed" when the user presses the enter key, or when a cell is clicked
- (void)commitSelectionForRow:(NSInteger)rowIndex
{
    [NSApp sendAction:self.selectionCommittedAction to:self.target from:self];
    [self dismiss];
}

- (void)setRowHeight:(CGFloat)rowHeight
{
    _rowHeight = rowHeight;
    
    self.tableView.rowHeight = rowHeight;
    [self recomputeHeightConstraint];
}

- (void)recomputeHeightConstraint
{
    const int maximumRows = 5;
    CGFloat adjustedRowHeight = self.rowHeight + 2;
    
    self.tableViewHeightConstraint.constant = MIN(adjustedRowHeight * maximumRows, adjustedRowHeight * [self.arrayController.arrangedObjects count]);
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    if (object == self.arrayController) {
        if ([self.arrayController.arrangedObjects count] > 0) {
            [self.arrayController setSelectionIndex:0];
        }
        
        [self recomputeHeightConstraint];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dismiss
{
    if (self.clearsSearchTextOnDismiss) {
        self.searchField.stringValue = @"";
        [self searchFieldTextDidChange:self.searchField];
    }
    
    [self.window orderOut:nil];
}

@end
