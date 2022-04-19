import 'dart:convert';

class Drink {
  String name;
  String glass;
  String recipe;
  String urlImg;

  Drink(this.name, this.glass, this.recipe, this.urlImg);

  factory Drink.fromJson(dynamic json) {
    return Drink(json['strDrink'], json['strGlass'], json['strInstructions'], json['strDrinkThumb']);
  }

  @override
  String toString() {
    return '{ ${this.name}, ${this.glass}, ${this.recipe} }';
  }
  /*Note.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        body = json['text'];*/
}
