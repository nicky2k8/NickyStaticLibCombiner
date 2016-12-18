//
//  ViewController.m
//  NickyStaticLibCombiner
//
//  Created by NickyTsui on 16/11/7.
//  Copyright © 2016年 NickyTsui. All rights reserved.
//

#import "ViewController.h"
#import "TextFieldDrag.h"

@interface ViewController ()
@property (weak) IBOutlet TextFieldDrag *arm64Textfield;
@property (weak) IBOutlet TextFieldDrag *x86Textfield;
@property (weak) IBOutlet TextFieldDrag *outputTextfield;
@property (weak) IBOutlet NSTextField *outputName;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}
- (IBAction)combine:(id)sender {
    NSString *s = [NSString stringWithFormat:@"lipo -create %@ %@ -output %@/%@",self.arm64Textfield.stringValue,self.x86Textfield.stringValue,self.outputTextfield.stringValue,self.outputName.stringValue.length?self.outputName.stringValue:@"output.a"];
    
    NSTask *execution = [NSTask new];

    execution.launchPath = @"/bin/sh";
    execution.arguments = @[@"-c",s];
    
    execution.terminationHandler = ^(NSTask *task){
        NSLog(@"task = %@",task.standardError);
    };
    [execution launch];
    [execution waitUntilExit];
//    NSLog(@"s = \n %@",s);'
    
    
    
    [self showMessage:@"ok!"];
}
-(void)showMessage:(NSString*)message{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:message];
    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        
    }];
    
}
- (IBAction)selectFileAction:(id)sender {
    if ([sender isKindOfClass:[NSButton class]]){
        NSButton *btn = sender;
        switch (btn.tag) {
            case 1:
            {
                [self.arm64Textfield setStringValue:[self browseDone:YES]];
            }
                break;
            case 2:{
                [self.x86Textfield setStringValue:[self browseDone:YES]];

            }
                break;
            case 3:
            {
                [self.outputTextfield setStringValue:[self browseDone:NO]];
            }
                break;
            default:
                break;
        }
    }
}
-(NSString*)browseDone:(BOOL)chooseFile{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    [openDlg setCanChooseFiles:chooseFile];
    [openDlg setCanChooseDirectories:!chooseFile];
    [openDlg setAllowsMultipleSelection:FALSE];
    [openDlg setAllowsOtherFileTypes:FALSE];
    [openDlg setAllowedFileTypes:@[@"a"]];
    
    NSString* fileNameOpened;
    if ([openDlg runModal] == NSModalResponseOK)
    {
        fileNameOpened = [[[openDlg URLs] objectAtIndex:0] path];
        //[self.productCer setStringValue:fileNameOpened];
    }
    return fileNameOpened?:@"";
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
