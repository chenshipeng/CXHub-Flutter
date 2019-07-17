import 'package:json_annotation/json_annotation.dart';
import "builtBy.dart";
part 'trending.g.dart';

@JsonSerializable()
class Trending {
    Trending();

    String author;
    String name;
    String avatar;
    String url;
    String description;
    String language;
    String languageColor;
    num stars;
    num forks;
    num currentPeriodStars;
    List<BuiltBy> builtBy;
    
    factory Trending.fromJson(Map<String,dynamic> json) => _$TrendingFromJson(json);
    Map<String, dynamic> toJson() => _$TrendingToJson(this);
}
