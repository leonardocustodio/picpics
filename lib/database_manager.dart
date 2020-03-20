import 'package:flutter/cupertino.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class DatabaseManager extends ChangeNotifier {
  DatabaseManager._();

  static DatabaseManager _instance;

  static DatabaseManager get instance {
    return _instance ??= DatabaseManager._();
  }

  bool hasGalleryPermission = false;

//  int swiperIndex = 0;
//
//  void changeSwiperIndex(int index) {
//    swiperIndex = index;
//    notifyListeners();
//  }

//  Future<String> sendUser(String uid) {
//    return Firestore.instance.collection('User').add({
//      'uid': uid,
//      'name': createUser.name,
//      'email': createUser.email,
//      'passLength': createUser.passLength,
//    }).catchError((error) {
//      print('Error has happened on save');
//      return null;
//    }).then((ref) async {
//      user = User(
//        documentId: ref.documentID,
//        uid: uid,
//        name: createUser.name,
//        email: createUser.email,
//        passLength: createUser.passLength,
//      );
//      await saveUser();
//      return ref.documentID;
//    });
//  }
//
//  Future<User> getUser({String uid, bool save = false}) async {
//    var docRef = await Firestore.instance.collection('User').where('uid', isEqualTo: uid).getDocuments();
//    if (docRef.documents.length > 0) {
//      user = User.fromData(docRef.documents.first.documentID, docRef.documents.first.data);
//      print('user data: ${docRef.documents.first.data}');
//
//      if (save == true) {
//        print('saving user');
//        saveUser();
//      }
//
//      getCards();
//      return user;
//    }
//    return null;
//  }
//
//  Future<void> saveUser() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    prefs.setString('uid', user.uid);
//    print('save user uid: ${user.uid}');
//  }
//
//  void unsaveUser() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    prefs.remove('uid');
//  }
//
//  void disconnectUser() {
//    unsaveUser();
//    user = null;
//  }
//
//  Future<void> getCards() async {
//    var query = await Firestore.instance.collection('Card').getDocuments();
//
//    List<FlashCard> allCards = [];
//
//    for (var card in query.documents) {
//      print('Card: ${card.data}');
//      FlashCard newCard = FlashCard.fromData(card.documentID, card.data);
//      if (newCard.live == true) {
//        allCards.add(newCard);
//      } else if (user != null) {
//        if (newCard.createdBy == user.documentId) {
//          allCards.add(newCard);
//        }
//      }
//    }
//
//    game.cards = allCards;
//    notifyListeners();
//  }
//
//  Future<void> getAreas() async {
//    var query = await Firestore.instance.collection('Area').getDocuments();
//
//    areas.clear();
//
//    for (var area in query.documents) {
//      print('Area: ${area.data}');
//      Area newArea = Area.fromData(area.documentID, area.data);
//      newArea.specialities = await getSpeciality(area.documentID);
//      areas.add(newArea);
//    }
//  }
//
//  Future<List<Speciality>> getSpeciality(String documentId) async {
//    var query = await Firestore.instance.collection('Area').document(documentId).collection('speciality').getDocuments();
//
//    List<Speciality> specialities = [];
//
//    for (var speciality in query.documents) {
//      print('Speciality: ${speciality.data}');
//      specialities.add(Speciality.fromData(speciality.documentID, speciality.data));
//    }
//    return specialities;
//  }
//
//  List<String> getAreasName() {
//    List<String> names = [];
//
//    for (var area in areas) {
//      names.add(area.name);
//    }
//
//    return names;
//  }
//
//  Future<void> sendCard(FlashCard card) async {
//    print('sendNoteWithImages');
//
//    await Firestore.instance.runTransaction((Transaction tx) async {
//      var documentRef = await Firestore.instance.collection('Card').add({
//        'question': card.question,
//        'answer': card.answer,
//        'area': card.area,
//        'speciality': card.speciality,
//        'likesIds': card.likesIds,
//        'live': card.live,
//        'version': card.version,
//        'createdAt': card.createdAt,
//        'createdBy': card.createdBy,
//        'createdByName': card.createdByName,
//      });
//
//      print('added card');
//      game.cards.add(card);
//      notifyListeners();
//    });
//  }
//
//  void answered(int cardIndex, bool right) {
//    FlashCard card = game.cards[cardIndex];
//
//    if (card.answered == false) {
//      if (right) {
//        game.correct += 1;
//      } else {
//        game.incorrect += 1;
//      }
//    } else {
//      if (right && card.answeredRight == false) {
//        game.correct += 1;
//        game.incorrect -= 1;
//      } else if (!right && card.answeredRight == true) {
//        game.correct -= 1;
//        game.incorrect += 1;
//      }
//    }
//
//    game.cards[cardIndex].answered = true;
//    game.cards[cardIndex].answeredRight = right;
//
//    notifyListeners();
//  }
//
//  void restartGame() {
//    game.correct = 0;
//    game.incorrect = 0;
//
//    for (var card in game.cards) {
//      card.answeredRight = false;
//      card.answered = false;
//    }
//
//    notifyListeners();
//  }
//
//  void likeCard(int cardIndex) async {
//    if (user.likedCards.contains(game.cards[cardIndex].documentId)) {
//      print('user already liked this card');
//
////      game.cards[cardIndex].likes -= 1;
//      user.likedCards.remove(game.cards[cardIndex].documentId);
//      notifyListeners();
//
//      await Firestore.instance.runTransaction((Transaction tx) async {
//        var cardUpdateData = {
//          'likes': FieldValue.arrayRemove([user.documentId]),
//        };
//
//        var userUpdateData = {
//          'likedCards': FieldValue.arrayRemove([game.cards[cardIndex].documentId]),
//        };
//
//        var documentRef = await Firestore.instance.collection('Card').document(game.cards[cardIndex].documentId).updateData(cardUpdateData);
//
//        var userRef = await Firestore.instance.collection('User').document(user.documentId).updateData(userUpdateData);
//
//        print('reverted like');
//      });
//    } else {
//      user.likedCards.add(game.cards[cardIndex].documentId);
////      game.cards[cardIndex].likes += 1;
//      notifyListeners();
//
//      await Firestore.instance.runTransaction((Transaction tx) async {
//        var cardUpdateData = {
//          'likes': FieldValue.arrayUnion([user.documentId]),
//        };
//
//        var userUpdateData = {
//          'likedCards': FieldValue.arrayUnion([game.cards[cardIndex].documentId]),
//        };
//
//        print('liked card');
//      });
//    }
//  }
//
//  void dislikeCard(int cardIndex, int reason) async {
////    if (user.dislikedCards.contains(game.cards[cardIndex].documentId)) {
////      print('user already disliked this card');
////    } else {
////      bool likedBefore = user.likedCards.contains(game.cards[cardIndex].documentId);
////
////      if (likedBefore == true) {
////        game.cards[cardIndex].likes -= 1;
////        user.likedCards.remove(game.cards[cardIndex].documentId);
////      }
////
////      user.dislikedCards.add(game.cards[cardIndex].documentId);
////      game.cards[cardIndex].dislikes += 1;
////      notifyListeners();
////
////      String dislikeReason = '';
////      if (reason == 1) {
////        dislikeReason = 'BadQuestion';
////      } else if (reason == 2) {
////        dislikeReason = 'BadAnswer';
////      } else if (reason == 3) {
////        dislikeReason = 'WrongSpeciality';
////      } else if (reason == 4) {
////        dislikeReason = 'DidNotLike';
////      }
////
////      await Firestore.instance.runTransaction((Transaction tx) async {
////        var cardUpdateData = {
////          'dislikes': FieldValue.increment(1),
////          'dislikeReason': FieldValue.arrayUnion([dislikeReason]),
////        };
////
////        var userUpdateData = {
////          'dislikedCards': FieldValue.arrayUnion([game.cards[cardIndex].documentId]),
////        };
////
////        if (likedBefore == true) {
////          cardUpdateData['likes'] = FieldValue.increment(-1);
////          userUpdateData['likedCards'] = FieldValue.arrayRemove([game.cards[cardIndex].documentId]);
////          print('reverted like');
////        }
////
////        var documentRef = await Firestore.instance.collection('Card').document(game.cards[cardIndex].documentId).updateData(cardUpdateData);
////
////        var userRef = await Firestore.instance.collection('User').document(user.documentId).updateData(userUpdateData);
////
////        print('disliked card');
////      });
////    }
//  }
//
//  bool isLiked(int cardIndex) {
//    if (user == null) {
//      return false;
//    } else if (user.likedCards == null) {
//      return false;
//    } else if (!user.likedCards.contains(game.cards[cardIndex].documentId)) {
//      return false;
//    }
//    return true;
//  }
//
////  bool isDisliked(int cardIndex) {
////    if (user == null) {
////      return false;
////    } else if (user.dislikedCards == null) {
////      return false;
////    } else if (!user.dislikedCards.contains(game.cards[cardIndex].documentId)) {
////      return false;
////    }
////    return true;
////  }
}
