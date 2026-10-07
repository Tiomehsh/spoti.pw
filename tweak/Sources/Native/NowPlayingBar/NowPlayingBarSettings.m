#import "Core/SGCore.h"
#import "Settings/SGModPage.h"
#import "NowPlayingBar.h"

UIViewController *SGNowPlayingBarSettingsPage(void) {
    return [[SGModPage alloc] initWithTitle:@"正在播放栏" intro:SGRestartNote sections:@[
        SGSection(nil, @[
            SGHideRow(@"隐藏设备按钮", nil, SGHideBarConnect),
        ]),
        SGSection(@"Spotify 的开关", @[
            SGFlagRow(@"两行曲目信息", @"ios-feature-nowplayingbar.two_lines_information_unit"),
            SGFlagRow(@"保存按钮", @"ios-feature-nowplayingbar.add_button"),
            SGFlagRow(@"队列徽章", @"ios-feature-nowplayingbar.queue_badge"),
            SGFlagRow(@"长按拖动调整大小", @"ios-feature-nowplayingbar.hold_and_drag_to_resize"),
            SGFlagRow(@"迷你播放器中的视频", @"ios-feature-nowplaying.video_in_miniplayer"),
            SGFlagRow(@"栏到封面动画", @"ios-feature-nowplaying.bartocoverart_animation_enabled"),
            SGFlagRow(@"迷你播放器过渡动画", @"ios-feature-nowplaying.miniplayer_transition_animations"),
        ]),
    ] footer:nil];
}
