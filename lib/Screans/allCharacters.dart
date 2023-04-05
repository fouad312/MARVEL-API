
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:test_apk/Controllers/getData.dart';

import 'package:test_apk/Models/Character.dart';
import 'package:test_apk/Screans/CardImage.dart';
import 'package:test_apk/constant.dart';

class AllCharacters extends StatefulWidget {
  const AllCharacters({super.key});

  @override
  State<AllCharacters> createState() => _AllCharactersState();
}

class _AllCharactersState extends State<AllCharacters> {
  int nbrPage = 0;
  List<ResultsCharacter> characters = [];
  final ScrollController _scrollController = ScrollController();

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
       _scrollController.addListener(() {
      if (_scrollController.offset >=
              (_scrollController.position.maxScrollExtent) &&
          !_scrollController.position.outOfRange) {
        _loadMore();
      }
    });
  }

  void _loadMore() async {

      setState(() {
        nbrPage += 10;
      
      });
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [getCharacters(), 100.h],
          ),
        ),
      ),
    );
  }

  SizedBox numberPage() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        itemCount: 500,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: RawMaterialButton(
              onPressed: () {
                nbrPage=index*10;
                _scrollToTop();
                setState(() {});
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              fillColor: secondColor,
              splashColor: Colors.white,
              child: FittedBox(
                  child: Text(
                'Page ${index + 1}',
                style: const TextStyle(color: Colors.white),
              )),
            ),
          );
        },
      ),
    );
  }

  Widget getCharacters() {
    return FutureBuilder(
        future: GetData().fetchMarvelCharacters(nbrPage.toString(),10.toString()),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(color: secondColor),
            );
          } else {
            
            for (var element in snapshot.data!.data!.resultsCharacter!) {
             if(characters.indexWhere((e) => element.id==e.id)==-1) {
               characters.add(element);
             }
              
            }
            return Column(
              children: [
                AnimationLimiter(
                  child: StaggeredGridView.countBuilder(
                      staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
                      physics: const BouncingScrollPhysics(),
                      mainAxisSpacing: 8,
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      itemCount: characters.length,
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
                                characters: characters[index],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                20.h,
                  if (snapshot.connectionState == ConnectionState.waiting)
               Center(
                child: CircularProgressIndicator(color: secondColor,),
              ),
                //  numberPage()
              ],
            );
          }
        });
  }
}
