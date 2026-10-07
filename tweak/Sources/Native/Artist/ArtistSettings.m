#import "Core/SGCore.h"
#import "Settings/SGModPage.h"
#import "Artist.h"

UIViewController *SGArtistSettingsPage(void) {
    NSArray<SGModSection *> *sections = @[
        SGSection(@"照片", @[
            SGOptionRow(@"淡入模糊", nil, SGKeyArtistPhotoFade),
        ]),
        SGSection(@"在头部隐藏", @[
            SGHideRow(@"Explore (video deck)", nil, SGHideArtistExplore),
            SGHideRow(@"关注", nil, SGHideArtistFollow),
            SGHideRow(@"更多选项", nil, SGHideArtistMore),
            SGHideRow(@"随机播放", nil, SGHideArtistShuffle),
            SGHideRow(@"认证徽章", nil, SGHideArtistVerified),
            SGHideRow(@"月度听众", nil, SGHideArtistListeners),
        ]),
        SGSection(@"标签页", @[
            SGHideRow(@"隐藏标签栏", nil, SGHideArtistTabBar),
        ]),
        SGNotedSection(@"在页面隐藏", @[
            SGHideRow(@"你点赞的歌曲", nil, SGHideArtistLikedSongs),
            SGHideRow(@"热门", nil, SGHideArtistPopular),
            SGHideRow(@"艺人精选", nil, SGHideArtistPick),
            SGHideRow(@"热门发行", nil, SGHideArtistReleases),
            SGHideRow(@"客串", nil, SGHideArtistFeaturing),
            SGHideRow(@"音乐视频", nil, SGHideArtistVideos),
            SGHideRow(@"关于", nil, SGHideArtistAbout),
            SGHideRow(@"艺人歌单", nil, SGHideArtistPlaylists),
            SGHideRow(@"粉丝也喜欢", nil, SGHideArtistFansAlsoLike),
            SGHideRow(@"出现于", nil, SGHideArtistAppearsOn),
            SGHideRow(@"被发现于", nil, SGHideArtistDiscoveredOn),
        ], @"仅在 Spotify 为英文时有效。"),
        SGSection(@"Spotify 自带", @[
            SGFlagRow(@"头部分享按钮", @"ios-creator-impl.share_in_action_row_enabled_artist"),
            SGFlagRow(@"导航栏中的更多选项", @"ios-creator-impl.context_menu_in_navigation_bar_enabled_artist"),
            SGFlagRow(@"热门协作者", @"ios-creator-impl.is_top_collaborators_enabled"),
            SGFlagRow(@"艺人资料", @"ios-creator-impl.is_artist_facts_enabled"),
        ]),
    ];
    return [[SGModPage alloc] initWithTitle:@"艺人" intro:nil sections:sections footer:nil];
}
