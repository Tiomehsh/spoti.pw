#import "Settings/SGModPage.h"
#import "Playlist.h"

UIViewController *SGPlaylistSettingsPage(void) {
    return [[SGModPage alloc] initWithTitle:@"播放列表" intro:nil sections:@[
        SGSection(@"头部", @[
            SGOptionRow(@"封面背景", nil, SGKeyPlaylistBackdrop),
        ]),
        SGSection(@"在歌单头部隐藏", @[
            SGHideRow(@"封面图", nil, SGHidePlaylistArtwork),
            SGHideRow(@"描述", nil, SGHidePlaylistDescription),
            SGHideRow(@"创作者与协作者", nil, SGHidePlaylistCreator),
            SGHideRow(@"长度与保存", nil, SGHidePlaylistLength),
        ]),
        SGSection(@"隐藏歌单按钮", @[
            SGHideRow(@"视频", nil, SGHidePlaylistVideo),
            SGHideRow(@"添加到音乐库", nil, SGHidePlaylistAddTo),
            SGHideRow(@"下载", nil, SGHidePlaylistDownload),
            SGHideRow(@"分享", nil, SGHidePlaylistShare),
            SGHideRow(@"更多", nil, SGHidePlaylistMore),
        ]),
        SGSection(@"在曲目上方隐藏", @[
            SGHideRow(@"精选标签", nil, SGHidePlaylistPills),
            SGHideRow(@"查找与排序栏", nil, SGHidePlaylistFind),
        ]),
    ] footer:nil];
}
