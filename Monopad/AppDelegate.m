//
//  AppDelegate.m
//  Monopad
//
//  Created by Masato Ikeda on 2022/06/04.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@property (strong) IBOutlet NSTextView *textView;

- (IBAction)save:(id)sender;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self.textView setFont:[NSFont fontWithName:@"SF Mono Medium" size:12.0]];
    
    NSError *error = nil;
    NSString *text = [self loadFile:&error];
    if (error != nil) {
        NSLog(@"Failed to load %@: err = %@", [self savedFilepath], error);
        [[NSApplication sharedApplication] terminate:nil];
    }
    
    [self.textView setString:text];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [self save:aNotification];
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}

- (IBAction)save:(id)sender {
    NSError *error = nil;
    [self saveFile:&error];
    if (error != nil) {
        NSLog(@"Failed to load %@: err = %@", [self savedFilepath], error);
    }
}

- (NSString *)savedFilepath {
    NSArray *components = [NSArray arrayWithObjects: NSHomeDirectory(), @"Documents", @"monopad.txt", nil];
    return [NSString pathWithComponents:components];
}

- (NSString *)loadFile:(NSError **)error {
    NSString *filepath = [self savedFilepath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        [[NSFileManager defaultManager] createFileAtPath:filepath contents:[NSData data] attributes:nil];
    }
    return [NSString stringWithContentsOfFile:[self savedFilepath] encoding:NSUTF8StringEncoding error:error];
}

- (void)saveFile:(NSError **)error {
    [self.textView.string writeToFile:[self savedFilepath] atomically:YES encoding:NSUTF8StringEncoding error:error];
}

@end
