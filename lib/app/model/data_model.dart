class Company {
  Company({
    required this.metaData,
    required this.timeSeriesDaily,
  });

  MetaDataModel metaData;
  Map<String, TimeSeriesDaily> timeSeriesDaily;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        metaData: MetaDataModel.fromJson(json["Meta Data"]),
        timeSeriesDaily: Map.from(json["Time Series (Daily)"]).map((k, v) =>
            MapEntry<String, TimeSeriesDaily>(k, TimeSeriesDaily.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "Meta Data": metaData.toJson(),
        "Time Series (Daily)": Map.from(timeSeriesDaily)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class MetaDataModel {
  MetaDataModel({
    this.the1Information,
    this.the2Symbol,
    this.the3LastRefreshed,
    this.the4OutputSize,
    this.the5TimeZone,
  });

  String? the1Information;
  String? the2Symbol;
  DateTime? the3LastRefreshed;
  String? the4OutputSize;
  String? the5TimeZone;

  factory MetaDataModel.fromJson(Map<String, dynamic> json) => MetaDataModel(
        the1Information: json["1. Information"],
        the2Symbol: json["2. Symbol"],
        the3LastRefreshed: DateTime.parse(json["3. Last Refreshed"]),
        the4OutputSize: json["4. Output Size"],
        the5TimeZone: json["5. Time Zone"],
      );

  Map<String, dynamic> toJson() => {
        "1. Information": the1Information,
        "2. Symbol": the2Symbol,
        "3. Last Refreshed":
            "${the3LastRefreshed?.year.toString().padLeft(4, '0')}-${the3LastRefreshed?.month.toString().padLeft(2, '0')}-${the3LastRefreshed?.day.toString().padLeft(2, '0')}",
        "4. Output Size": the4OutputSize,
        "5. Time Zone": the5TimeZone,
      };
}

class TimeSeriesDaily {
  TimeSeriesDaily({
    this.the1Open,
    this.the2High,
    this.the3Low,
    this.the4Close,
    this.the5AdjustedClose,
    this.the6Volume,
    this.the7DividendAmount,
    this.the8SplitCoefficient,
  });

  String? the1Open;
  String? the2High;
  String? the3Low;
  String? the4Close;
  String? the5AdjustedClose;
  String? the6Volume;
  String? the7DividendAmount;
  String? the8SplitCoefficient;

  factory TimeSeriesDaily.fromJson(Map<String, dynamic> json) =>
      TimeSeriesDaily(
        the1Open: json["1. open"],
        the2High: json["2. high"],
        the3Low: json["3. low"],
        the4Close: json["4. close"],
        the5AdjustedClose: json["5. adjusted close"],
        the6Volume: json["6. volume"],
        the7DividendAmount: json["7. dividend amount"],
        the8SplitCoefficient: json["8. split coefficient"],
      );

  Map<String, dynamic> toJson() => {
        "1. open": the1Open,
        "2. high": the2High,
        "3. low": the3Low,
        "4. close": the4Close,
        "5. adjusted close": the5AdjustedClose,
        "6. volume": the6Volume,
        "7. dividend amount": the7DividendAmount,
        "8. split coefficient": the8SplitCoefficient,
      };
}
