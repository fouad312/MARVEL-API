import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:test_apk/Screans/CardImage.dart';
import 'package:test_apk/constant.dart';

class FavorateList extends StatelessWidget {
  const FavorateList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        leading: backbutton(context, secondColor),
        centerTitle: true,
        title:const Text("Favorate",style: TextStyle(fontSize: 22,color: Colors.white),),
      ),
      body:  AnimationLimiter(
                  child: StaggeredGridView.countBuilder(
                      staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
                      physics: const BouncingScrollPhysics(),
                      mainAxisSpacing: 8,
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      itemCount: listFavorite.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          columnCount: 2,
                          child: ScaleAnimation(
                            duration: const Duration(milliseconds: 900),
                            curve: Curves.fastLinearToSlowEaseIn,
                            child: FadeInAnimation(
                              child: ItemImage(
                                characters: listFavorite[index],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
    );
  }
}