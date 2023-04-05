
import 'package:flutter/material.dart';
import 'package:test_apk/Controllers/getData.dart';
import 'package:test_apk/Controllers/storeData.dart';
import 'package:test_apk/Models/Character.dart';

import 'package:test_apk/Models/comics.dart';

import 'package:test_apk/constant.dart';

class Detailscharacters extends StatefulWidget {
  final ResultsCharacter character;
  const Detailscharacters({super.key,required this.character});


  @override
  State<Detailscharacters> createState() => _DetailscharactersState();
}

class _DetailscharactersState extends State<Detailscharacters> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Image.network(
                 "${widget.character.thumbnail!.path!}.${widget.character.thumbnail!.extension!}",
                  height: MediaQuery.of(context).size.height / 2,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
                Positioned(left: 5, child: backbutton(context, secondColor))
              ],
            ),
            10.h,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.character.name!,
                  style:const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),),),
                    
                   InkWell(
                    borderRadius: BorderRadius.circular(32),
                    onTap: () {
                      if(checkItem()){
                        listFavorite.removeAt(listFavorite.indexWhere((element) => element.id==widget.character.id));
                      }else{
                        listFavorite.add(widget.character);
                      }
                     LocalData.saveData();
                     setState(() {});
                   }, child: Padding(
                     padding: const EdgeInsets.all(16.0),
                     child: Icon(
                      checkItem()
                      ?
                      Icons.favorite_rounded
                      :Icons.favorite_border_outlined  
                      
                      ,color: secondColor,size: 40,
                     ),
                   ))
              ],
            ),
                
            FutureBuilder<Comi>(
              future: GetData().fetchComics(widget.character.id.toString()),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: secondColor,
                    ),
                  );
                }
                if (snapshot.hasData) {
                  return  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    const Padding(
                      padding:  EdgeInsets.all(8.0),
                      child: Text('List Of Comics : ',
                               style:TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                              ),
                    ),
                      ListView.builder(
                        itemCount: snapshot.data!.data!.results!.length,
                        shrinkWrap: true,
                        physics:const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(snapshot.data!.data!.results![index].series!.name!,
                                                           style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                                          ),
                              ),
                            subtitle : SizedBox(
                                  height: 40,
                                  child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  physics:const BouncingScrollPhysics(),
                                  itemCount: snapshot.data!.data!.results![index].urls!.length,
                                  itemBuilder:(context, i) {
                                  return  Container(
                                    margin:const EdgeInsets.symmetric(horizontal: 8),
                                    child: RawMaterialButton(
                                      onPressed: () {
                                      launchInBrowser(Uri.parse(snapshot.data!.data!.results![index].urls![i].url!));
                                    },
                                    fillColor: secondColor,
                                    splashColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    child:  FittedBox(child: Text(snapshot.data!.data!.results![index].urls![i].type!,style:const TextStyle(fontSize: 14,color: Colors.white),)),
                                    ),
                                  );
                                }, ),
                              )

                         
                            ),
                            Divider(color: secondColor,
                            endIndent: 50,indent: 50,thickness: 2,
                            )
                          ],
                        );
                      },),
                    ],
                  );
           
                
                      
                } else {
                  return const Text(
                    'error',
                    style: TextStyle(color: Colors.white),
                  );
                }
              },
            )
          ],
        ),
      )),
    );
  }
  bool checkItem(){
    if(listFavorite.indexWhere((element) => element.id==widget.character.id)==-1)
    {return false;}
    else
    {return true;}
  }
}

