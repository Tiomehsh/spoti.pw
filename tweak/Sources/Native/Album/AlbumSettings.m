#import "Core/SGCore.h"
#import "Settings/SGModPage.h"
#import "Album.h"

UIViewController *SGAlbumSettingsPage(void) {
    NSArray<SGModSection *> *sections = @[
        SGSection(@"头部", @[
            SGOptionRow(@"封面背景", nil, SGKeyAlbumBackdrop),
        ]),
        SGSection(@"在头部隐藏", @[
            SGHideRow(@"Explore (video deck)", nil, SGHideAlbumExplore),
            SGHideRow(@"添加到音乐库", nil, SGHideAlbumAddTo),
            SGHideRow(@"下载", nil, SGHideAlbumDownload),
            SGHideRow(@"更多选项", nil, SGHideAlbumMore),
        ]),
        SGNotedSection(@"在页面隐藏", @[
            SGHideRow(@"该艺人更多作品", nil, SGHideAlbumMoreBy),
            SGHideRow(@"相关音乐视频", nil, SGHideAlbumVideos),
            SGHideRow(@"演出", nil, SGHideAlbumConcerts),
            SGHideRow(@"周边", nil, SGHideAlbumMerch),
            SGHideRow(@"你可能也喜欢", nil, SGHideAlbumYouMightLike),
        ], @"仅在 Spotify 为英文时有效。"),
    ];
    return [[SGModPage alloc] initWithTitle:@"专辑" intro:nil sections:sections footer:nil];
}
