#import "Core/SGCore.h"
#import "Settings/SGPageStyle.h"
#import "About.h"
#import "App/Onboarding/Onboarding.h"

// Every key of the mod's is under one prefix, so a reset is a sweep of the defaults with the stock
// marker of SGPrefs.h left behind; the hooks read them at launch, so it ends in a restart.
static void resetAll(void) {
    NSUserDefaults *store = NSUserDefaults.standardUserDefaults;
    NSUInteger removed = 0;
    for (NSString *key in [store persistentDomainForName:NSBundle.mainBundle.bundleIdentifier].allKeys) {
        if (![key hasPrefix:@"spotifyglass."]) continue;
        [store removeObjectForKey:key];
        removed++;
    }
    [store setBool:YES forKey:SGKeyStock];
    SGLog(@"reset: removed %lu keys", (unsigned long)removed);
    SGRestartSpotify();
}

static void confirmReset(void) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"重置所有设置?"
                                                                  message:@"Every switch goes off, flag overrides and the tab bar layout are cleared, and Spotify restarts as it came, with the mod doing nothing until asked. Spotify's own settings are untouched."
                                                           preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"重置并重启" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) { resetAll(); }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [SGTopController() presentViewController:alert animated:YES completion:nil];
}

static SGModRow *withSymbol(SGModRow *row, NSString *symbol) {
    row.symbol = symbol;
    return row;
}

// Which build this is, whether GitHub has a newer release, and where to reach the mod: without these
// rows a build that is already installed has no way of telling its user that anything moved on.
UIViewController *SGAboutPage(void) {
    SGModRow *reset = withSymbol(SGActionRow(@"重置所有设置", nil, ^{ confirmReset(); }), @"trash");
    reset.color = SGRed();
    NSString *spotify = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"] ?: @"unknown";
    // The row reads out where the build stands and opens the changelog of everything newer than it.
    SGModRow *updates = SGPageRow(@"更新", ^UIViewController *{ return SGUpdatePage(); });
    updates.value = ^NSString *{ return SGUpdateStatus(); };
    NSMutableArray<SGModSection *> *sections = [NSMutableArray arrayWithObject:SGSection(nil, @[
        updates,
        SGStatRow(@"版本", ^NSString *{ return @(SG_VERSION); }),
        SGStatRow(@"Spotify", ^NSString *{ return spotify; }),
    ])];
    SGModRow *appIcon = SGAppIconRow();
    if (appIcon) [sections addObject:SGSection(nil, @[withSymbol(appIcon, @"app")])];
    [sections addObjectsFromArray:@[
        SGSection(nil, @[
            withSymbol(SGLinkRow(@"网站", nil, SGSiteURL), @"safari"),
            withSymbol(SGLinkRow(@"Discord", nil, SGDiscordURL), @"bubble.left.and.bubble.right"),
            withSymbol(SGLinkRow(@"GitHub", nil, SGRepoURL), @"chevron.left.forwardslash.chevron.right"),
            withSymbol(SGPageRow(@"许可证", ^UIViewController *{ return SGLicensesPage(); }), @"doc.text"),
            withSymbol(SGActionRow(@"欢迎引导", nil, ^{ SGShowOnboarding(); }), @"map"),
        ]),
        SGSection(nil, @[
            withSymbol(SGActionRow(@"导出设置", nil, ^{ SGExportSettings(); }), @"square.and.arrow.up"),
            withSymbol(SGActionRow(@"导入设置", nil, ^{ SGImportSettings(); }), @"square.and.arrow.down"),
        ]),
        SGSection(nil, @[reset]),
    ]];
    return [[SGModPage alloc] initWithTitle:@"Mod" intro:nil sections:sections footer:nil];
}
