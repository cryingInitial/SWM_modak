import 'package:flutter/material.dart';
import 'package:modak_flutter_app/constant/coloring.dart';
import 'package:modak_flutter_app/provider/album_provider.dart';
import 'package:modak_flutter_app/provider/home_provider.dart';
import 'package:modak_flutter_app/ui/common/common_medias_screen.dart';
import 'package:modak_flutter_app/widgets/common/media_widget_for_album.dart';
import 'package:modak_flutter_app/widgets/common/scalable_text_widget.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import '../../constant/font.dart';
import '../../utils/easy_style.dart';
import '../modal/theme_modal_widget.dart';

class AlbumDayWidget extends StatefulWidget {
  const AlbumDayWidget({Key? key}) : super(key: key);

  @override
  State<AlbumDayWidget> createState() => _AlbumDayWidgetState();
}

class _AlbumDayWidgetState extends State<AlbumDayWidget> {
  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return Consumer<AlbumProvider>(
      builder: (context, provider, child) {
        return Container(
          color: Coloring.gray_50,
          margin: EdgeInsets.all(5),
          child: RefreshIndicator(
            onRefresh: provider.initTotalData,
            child: Column(
              children: [
                if (provider.albumBuildFileList.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: ScalableTextWidget(
                      "채팅방에서 사진을 보내보세요!",
                      style: EasyStyle.text(
                        Coloring.gray_20,
                        Font.size_mediumText,
                        Font.weight_medium,
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    controller: provider.scrollController,
                    itemCount: provider.albumBuildFileList.length,
                    itemBuilder: (BuildContext context, int dateIndex) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.all(12),
                            child: ScalableTextWidget(
                              "${provider.albumBuildFileList[dateIndex][0].absolute.path.split('/').last.split('T')[0]}",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: Font.size_largeText),
                            ),
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            controller: scrollController,
                            itemCount:
                                provider.albumBuildFileList[dateIndex].length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                            ),
                            itemBuilder:
                                (BuildContext context, int mediaIndex) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CommonMediasScreen(
                                        files: provider
                                            .albumBuildFileList[dateIndex],
                                        initialIndex: mediaIndex,
                                      ),
                                    ),
                                  );
                                },
                                onLongPress: () {
                                  if (!(provider
                                          .albumBuildFileList[dateIndex]
                                              [mediaIndex]
                                          .path
                                          .toString()
                                          .toLowerCase()
                                          .endsWith("mp4") ||
                                      provider
                                          .albumBuildFileList[dateIndex]
                                              [mediaIndex]
                                          .path
                                          .toString()
                                          .toLowerCase()
                                          .endsWith("mov"))) {
                                    themeModalWidget(
                                      context,
                                      title: "가족 대표 사진으로 등록하기",
                                      onOkPress: () {
                                        provider.setFamilyImage(
                                          provider
                                              .albumBuildFileList[dateIndex]
                                                  [mediaIndex]
                                              .path
                                              .toString()
                                              .split("/")
                                              .last,
                                        );
                                        context
                                            .read<HomeProvider>()
                                            .familyImage = provider
                                                .albumBuildFileList[dateIndex]
                                            [mediaIndex];
                                      },
                                      okText: "확인",
                                    );
                                  }
                                },
                                child: (() {
                                  if (provider
                                          .albumBuildFileList[dateIndex]
                                              [mediaIndex]
                                          .path
                                          .toString()
                                          .toLowerCase()
                                          .endsWith("mp4") ||
                                      provider
                                          .albumBuildFileList[dateIndex]
                                              [mediaIndex]
                                          .path
                                          .toString()
                                          .toLowerCase()
                                          .endsWith("mov")) {
                                    return MediaWidgetForAlbum(
                                      width: double.infinity,
                                      height: double.infinity,
                                      radius: 5,
                                      file: provider.thumbnailList[
                                          path.basename(provider
                                              .albumBuildFileList[dateIndex]
                                                  [mediaIndex]
                                              .path)],
                                      isIconShown: true,
                                    );
                                  } else {
                                    return MediaWidgetForAlbum(
                                      width: double.infinity,
                                      height: double.infinity,
                                      radius: 5,
                                      file:
                                          provider.albumBuildFileList[dateIndex]
                                              [mediaIndex],
                                    );
                                  }
                                })(),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    context.read<AlbumProvider>().addScrollListener();
  }
}
