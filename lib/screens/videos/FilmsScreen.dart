import 'package:flutter/material.dart';
import 'package:khadamat_app/mixins/FunctionsMixin.dart';
import 'package:khadamat_app/models/FilmCategory.dart';
import 'package:khadamat_app/providers/FilmsProvider.dart';
import 'package:khadamat_app/widgets/FilmPosterWidget.dart';
import 'package:khadamat_app/widgets/IsEmptyWidget.dart';
import 'package:khadamat_app/widgets/IsErrorWidget.dart';
import 'package:khadamat_app/widgets/IsLoadingWidget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:khadamat_app/screens/videos/FilmDetailsScreen.dart';

class FilmsScreen extends StatefulWidget {

  final FilmCategory category;

  const FilmsScreen({Key key, this.category}) : super(key: key);
  @override
  _FilmsScreenState createState() => _FilmsScreenState();
}

class _FilmsScreenState extends State<FilmsScreen> {
  final _refreshController = RefreshController();


  @override
  void initState() {
    context.read<FilmsProvider>().films(context , widget.category.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Consumer<FilmsProvider>(
        builder: (context, value, child) {
          if (value.filmsResponse == null) {
            return IsLoadingWidget();
          }

          if (value.filmsResponse.isError ||
              value.filmsResponse.error != null) {

            return IsErrorWidget(
              error: value.filmsResponse.error,
              onRetry: () => value..films(context , widget.category.id),
            );
          }

          if (value.filmsResponse.isLoading) {
            return IsLoadingWidget();
          }

          if (value.filmsResponse.isEmpty) {
            return IsEmptyWidget();
          }

          return SmartRefresher(
              enablePullDown: true,
              onRefresh: () async {
                await value.films(context , widget.category.id);
                _refreshController.refreshCompleted();
              },
              header: WaterDropMaterialHeader(),
              controller: _refreshController,
              child: GridView.builder(
                  itemCount: value.filmsResponse.data.length,
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.0 / 3.0,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  padding: EdgeInsets.only(
                      left: 10, right: 10, top: kToolbarHeight + 10),
                  itemBuilder: (BuildContext context, int index) {
                    return FilmPosterWidget(
                      image: value.filmsResponse.data.elementAt(index).image,
                      title:value.filmsResponse.data.elementAt(index).name,
                      hd: false,
                      titleInPoster: false,
                      onTap: (){
                        goTo(context, FilmDetailsScreen(film: value.filmsResponse.data.elementAt(index),category: widget.category,));
                      },
                    );
                  }),
          );
        },
      ),
    );
  }

}
