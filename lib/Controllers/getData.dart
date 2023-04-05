import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';
import 'package:test_apk/Models/Character.dart';
import 'package:test_apk/Models/comics.dart';



class GetData{


Future<Character> fetchMarvelCharacters(String offset,String limit) async {
  const String publicKey = '596430e1766289263a0908af2f7c5dea';
  const String privateKey = 'ed6c6d20cdabf866fa7237a354585458c53c7d44';
  final int timestamp = DateTime.now().millisecondsSinceEpoch;
  final String hash = generateHash(timestamp, publicKey, privateKey);

  final String url="https://gateway.marvel.com:443/v1/public/characters?apikey=$publicKey&ts=$timestamp&hash=$hash&offset=$offset&limit=$limit";
 
       print(url);

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final characters = Character.fromJson(jsonData);
    //print(characters.toJson());
    return characters;
    // final String characterName = data['data']['results'][0]['name'];
    // print(characterName);
  } else {
    print('Failed to fetch characters: ${response.statusCode}');
   throw Exception('Failed to load data');
  }
}
Future<Comi> fetchComics(String idCharacter) async {

  final String url="https://gateway.marvel.com:443/v1/public/characters/$idCharacter/comics?apikey=596430e1766289263a0908af2f7c5dea&ts=1680359047904&hash=f5a34a347b7361f648a415b10d822694";
 
      

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final comics = Comi.fromJson(jsonData);
    //print(characters.toJson());
    return comics;
    // final String characterName = data['data']['results'][0]['name'];
    // print(characterName);
  } else {
    print('Failed to fetch characters: ${response.statusCode}');
   throw Exception('Failed to load data');
  }
}
String generateHash(int timestamp, String publicKey, String privateKey) {
  final bytes = utf8.encode('$timestamp$privateKey$publicKey');
  final digest = md5.convert(bytes);
  return hex.encode(digest.bytes).toLowerCase();
}




}