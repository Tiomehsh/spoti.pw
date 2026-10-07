// The player's settings that do not depend on the look: the lock screen widget's flags.
#import "Core/SGCore.h"
#import "Settings/SGModPage.h"
#import "PlayerSettings.h"
#import "Shared/LockScreenArtwork/LockScreenArtwork.h"

UIViewController *SGLockScreenWidgetPage(void) {
    return [[SGModPage alloc] initWithTitle:@"锁屏小组件" intro:SGRestartNote sections:@[
        SGSection(@"控制", @[
            SGFlagRow(@"喜欢与不喜欢按钮", @"ios-feature-lockscreen.like_dislike_enabled"),
            SGFlagRow(@"播客上的跳过按钮", @"ios-feature-lockscreen.skip_button_on_podcasts"),
            SGFlagRow(@"章节跳过控制", @"ios-feature-lockscreen.enable_chapter_skip_controls"),
            SGFlagRow(@"连续跳过", @"ios-feature-lockscreen.burst_skip_enabled"),
        ]),
        SGSection(@"封面", [SGAnimatedArtworkRows() arrayByAddingObject:
            SGFlagRow(@"附属内容", @"ios-feature-lockscreen.companion_content_enabled")]),
    ] footer:nil];
}
