// The native player's settings: Spotify's own player screen and the parts of it to hide, and the queue
// and devices flags. The Player page that holds them is App/Pages.m's.
#import "Core/SGCore.h"
#import "Settings/SGModPage.h"
#import "NowPlaying.h"

NSArray<SGModSection *> *SGNativePlayerScreenSections(void) {
    return @[
        SGSection(@"播放器界面", @[
            SGOptionRow(@"封面背景", nil, SGKeyPlayerBackdrop),
            SGOptionRow(@"玻璃头部按钮", nil, SGKeyPlayer),
            SGKillRow(@"禁用 Canvas", @"ios-feature-canvas.canvas_enabled"),
            SGFlagRow(@"弹层风格播放器", @"ios-feature-nowplaying.sheet_style_npv"),
            SGFlagRow(@"重设计头部", @"ios-feature-nowplaying.new_redesign_header_with_context_menu_enabled"),
            SGFlagRow(@"新进度滑块", @"ios-feature-encoreexperiments.new_npv_slider_enabled"),
            SGFlagRow(@"点按展开吸顶头部", @"ios-feature-nowplaying.expand_sticky_header_on_tap"),
        ]),
        SGSection(@"隐藏播放器下方卡片", @[
            SGHideRow(@"歌词", nil, SGHideLyricsCard),
            SGHideRow(@"关于艺人", nil, SGHideAboutArtist),
            SGHideRow(@"相关视频", nil, SGHideRelatedVideos),
            SGHideRow(@"SongDNA", nil, SGHideSongDNA),
            SGHideRow(@"现场活动", nil, SGHideLiveEvents),
            SGHideRow(@"探索艺人", nil, SGHideExploreArtist),
            SGHideRow(@"署名", nil, SGHideCredits),
            SGHideRow(@"周边", nil, SGHideMerch),
            SGHideRow(@"推荐", nil, SGHideRecommendations),
        ]),
        SGSection(@"在播放器隐藏", @[
            SGHideRow(@"歌词预览", nil, SGHideLyricsInline),
            SGHideRow(@"随机播放", nil, SGHideShuffle),
            SGHideRow(@"重复", nil, SGHideRepeat),
            SGHideRow(@"添加到播放列表", nil, SGHideAddTo),
            SGHideRow(@"队列", nil, SGHideQueue),
            SGHideRow(@"分享", nil, SGHideShare),
            SGHideRow(@"连接到设备", nil, SGHideConnect),
        ]),
    ];
}

SGModRow *SGGlassLyricsRow(void) {
    return SGOptionRow(@"玻璃歌词", nil, SGKeyLyricsCard);
}

UIViewController *SGQueueSettingsPage(void) {
    return [[SGModPage alloc] initWithTitle:@"队列与设备" intro:SGRestartNote sections:@[
        SGSection(@"底部弹层", @[
            SGFlagRow(@"队列为底部弹层", @"ios-feature-nowplaying.bottom_sheet_queue_enabled"),
            SGFlagRow(@"连接为底部弹层", @"ios-feature-nowplaying-elements.enable_connect_bottom_sheet"),
            SGFlagRow(@"视频切换器的连接弹层", @"ios-playbackcontrol-audiovideoswitcher-impl.enable_connect_bottom_sheet"),
        ]),
        SGSection(@"队列", @[
            SGFlagRow(@"队列翻转过渡", @"ios-feature-nowplaying.queue_flip_transition_enabled"),
            SGFlagRow(@"上下文菜单中的下一首播放", @"ios-feature-queue.is_play_next_context_menu_enabled"),
        ]),
    ] footer:nil];
}
