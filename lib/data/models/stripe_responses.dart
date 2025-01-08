import 'dart:convert';
import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:equatable/equatable.dart';

@jsonSerializable
class PaymentIntentResponse extends Equatable {
  // @JsonProperty(name: 'id')
  // final String id;

  // @JsonProperty(name: "amount")
  // final double amount;

  @JsonProperty(name: "clientSecret")
  final String clientSecret;

  // @JsonProperty(name: "livemode")
  // final bool livemode;

  @JsonProperty(name: "customerId")
  final String customer;

  // @JsonProperty(name: "currency")
  // final String currency;

  @JsonProperty(name: "ephemeralKey")
  final String ephemeralKeySecret;

  const PaymentIntentResponse(
      {
      //   this.id = '',
      // this.amount = 0.0,
      this.clientSecret = '',
      // this.currency = '',
      this.customer = '',
      // this.livemode = false,
      this.ephemeralKeySecret = ''});

  PaymentIntentResponse copyWith(
      {String? id,
      double? amount,
      String? clientSecret,
      String? currency,
      String? customer,
      bool? livemode,
      String? ephemeralKeySecret}) {
    return PaymentIntentResponse(
        // id: this.id,
        // amount: this.amount,
        clientSecret: this.clientSecret,
        // currency: this.currency,
        customer: this.customer,
        // livemode: this.livemode,
        ephemeralKeySecret: this.ephemeralKeySecret);
  }

  static PaymentIntentResponse? fromJson(Map<String, dynamic> json) {
    var result = JsonMapper.fromMap<PaymentIntentResponse>(json);
    if (result == null) {
      return null;
    }
    return result;
  }

  static PaymentIntentResponse? fromJsonString(String json) {
    var result =
        JsonMapper.deserialize<PaymentIntentResponse>(jsonDecode(json));
    if (result == null) {
      return null;
    }
    return result;
  }

  Map<String, dynamic>? toJson() => JsonMapper.toMap(this);

  @override
  List<Object?> get props => [clientSecret, customer];
}

@jsonSerializable
class TokenId extends Equatable {
  @JsonProperty(name: "TokenId")
  final String tokenId;
  const TokenId({this.tokenId = ''});

  TokenId copyWith({tokenId}) {
    return TokenId(tokenId: this.tokenId);
  }

  static TokenId? fromJson(Map<String, dynamic> json) {
    var result = JsonMapper.fromMap<TokenId>(json);
    if (result == null) {
      return null;
    }
    return result;
  }

  static TokenId? fromJsonString(String json) {
    var result = JsonMapper.deserialize<TokenId>(jsonDecode(json));
    if (result == null) {
      return null;
    }
    return result;
  }

  @override
  List<Object?> get props => [tokenId];
}

@jsonSerializable
class CardList extends Equatable {
  @JsonProperty(name: "cards")
  List<CardDetail> cards = [];

  CardList({required this.cards});

  CardList copyWith({cards}) {
    return CardList(cards: this.cards);
  }

  static CardList? fromJson(Map<String, dynamic> json) {
    var result = JsonMapper.fromMap<CardList>(json);
    if (result == null) {
      return null;
    }
    return result;
  }

  static CardList? fromJsonString(String json) {
    var data = jsonDecode(json);
    var result = JsonMapper.deserialize<CardList>(data);

    if (result == null) {
      return null;
    }
    return result;
  }

  @override
  List<Object?> get props => [];
}

@jsonSerializable
class CardDetail extends Equatable {
  @JsonProperty(name: "id")
  final String id;
  @JsonProperty(name: "brand")
  final String brand;
  @JsonProperty(name: "last4")
  final String last4;
  @JsonProperty(name: "expMonth")
  final int expMonth;
  @JsonProperty(name: "expYear")
  final int expYear;

  const CardDetail(
      {this.id = '',
      this.brand = '',
      this.last4 = '',
      this.expMonth = 0,
      this.expYear = 0});

  CardDetail copyWith({id, brand, last4, expMonth, expYear}) {
    return CardDetail(
        id: this.id,
        brand: this.brand,
        last4: this.last4,
        expMonth: this.expMonth,
        expYear: this.expYear);
  }

  static CardDetail? fromJson(Map<String, dynamic> json) {
    var result = JsonMapper.fromMap<CardDetail>(json);
    if (result == null) {
      return null;
    }
    return result;
  }

  static CardDetail? fromJsonString(String json) {
    var result = JsonMapper.deserialize<CardDetail>(jsonDecode(json));
    if (result == null) {
      return null;
    }
    return result;
  }

  static List<CardDetail?> fromJsonList(List<dynamic> json) =>
      json.map((value) {
       return CardDetail.fromJson(value);
      }).toList();

  static List<CardDetail?> fromJsonStringList(String json) =>
      fromJsonList(jsonDecode(json));

  @override
  List<Object?> get props => [id, brand, last4, expMonth, expYear];
}
