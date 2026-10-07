#import "Core/SGCore.h"
#import "Settings/SGModPage.h"
#import "Settings/SGPageStyle.h"
#import "Appearance.h"

// Going back to Spotify's green is offered only once a colour of the mod's is set, so a stray tap
// cannot wipe it.
static void chooseAccent(void) {
    if (!SGAccentColor()) {
        SGPickAccent();
        return;
    }
    UIViewController *top = SGTopController();
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"强调色" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [sheet addAction:[UIAlertAction actionWithTitle:@"选择颜色" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) { SGPickAccent(); }]];
    [sheet addAction:[UIAlertAction actionWithTitle:@"Spotify 的绿色" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) { SGSetInt(SGKeyAccent, -1); }]];
    [sheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    sheet.popoverPresentationController.sourceView = top.view;
    sheet.popoverPresentationController.sourceRect = CGRectMake(CGRectGetMidX(top.view.bounds), CGRectGetMidY(top.view.bounds), 0, 0);
    sheet.popoverPresentationController.permittedArrowDirections = 0;
    [top presentViewController:sheet animated:YES completion:nil];
}

// The native look's rows of the Appearance card (App/Pages.m).
NSArray<SGModRow *> *SGNativeAppearanceRows(void) {
    return @[
        SGWithSymbol(SGOptionRow(@"AMOLED 背景", nil, SGKeyAmoled), @"moon"),
        SGWithSymbol(SGStatActionRow(@"强调色", nil, ^NSString *{ return SGAccentLabel(); }, ^{ chooseAccent(); }), @"paintpalette"),
    ];
}
