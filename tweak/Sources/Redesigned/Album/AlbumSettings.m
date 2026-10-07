#import "Core/SGCore.h"
#import "Settings/SGModPage.h"
#import "Album.h"

UIViewController *SGRAlbumSettingsPage(void) {
    NSArray<SGModSection *> *sections = @[
        SGNotedSection(@"头部", @[
            SGSwitchRow(@"动态封面", @"Apple Music 的(若专辑有)", SGRKeyAnimatedCovers),
        ], @"Apple Music gets only the artist and album name. Nothing is downloaded in Low Data or Low Power Mode."),
    ];
    return [[SGModPage alloc] initWithTitle:@"专辑" intro:nil sections:sections footer:nil];
}
