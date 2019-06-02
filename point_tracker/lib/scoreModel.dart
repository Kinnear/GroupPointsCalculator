import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Person {
  String _name = "";
  List<int> _scores = new List<int>();

  Person(String name) {
    this._name = name;
  }

  String getName() {
    return _name;
  }

  List<int> getListOfScores() {
    return _scores;
  }

  void addNewScore(int newScore) {
    _scores.add(newScore);
  }

  int getTotalScore() {
    int totalScore = 0;
    for (int i = 0; i < _scores.length; i++) {
      totalScore += _scores[i];
    }
    return totalScore;
  }

  void modifyScore(int index, int updatedScore) {
    _scores[index] = updatedScore;
  }
}

class ScoreModel extends Model {
  final firebaseSessionInstance = Firestore.instance.collection('session');

  // Future<List<Person>> syncFirebaseSessionCollection() async
  // {

  // }

  ScoreModel() {
    // Set transaction to update the model whenever firebase sends us any updated data about the model
    // In other words. create a listener

    firebaseSessionInstance.snapshots().listen((onData) {
      print(onData.documents.map((DocumentSnapshot document) {
        print(document);
      }));
    });

    // addNewPerson('Kinnear');
    // addNewScoreToPersonByName(10, 'Kinnear');
    // addNewScoreToPersonByName(20, 'Kinnear');
    // addNewScoreToPersonByName(20, 'Kinnear');
    // addNewScoreToPersonByName(20, 'Kinnear');
    // addNewScoreToPersonByName(20, 'Kinnear');
    // addNewScoreToPersonByName(20, 'Kinnear');
    // addNewScoreToPersonByName(20, 'Kinnear');
    // addNewScoreToPersonByName(20, 'Kinnear');
    // addNewScoreToPersonByName(20, 'Kinnear');
    // addNewScoreToPersonByName(20, 'Kinnear');
    // addNewScoreToPersonByName(20, 'Kinnear');
    // addNewScoreToPersonByName(20, 'Kinnear');
    // addNewScoreToPersonByName(20, 'Kinnear');
    // addNewScoreToPersonByName(30, 'Kinnear');

    // addNewPerson('Mika');
    // addNewScoreToPersonByName(20, 'Mika');
    // addNewScoreToPersonByName(20, 'Mika');
    // addNewScoreToPersonByName(30, 'Mika');

    // addNewPerson('Mika1');
    // addNewScoreToPersonByName(20, 'Mika1');
    // addNewScoreToPersonByName(20, 'Mika1');
    // addNewScoreToPersonByName(30, 'Mika1');
  }

  List<Person> _allPeople = new List<Person>();

  String getPersonName(int index) {
    return _allPeople[index].getName();
  }

  // Adds a brand new person to our score list
  bool addNewPerson(String name) {
    for (int i = 0; i < _allPeople.length; i++) {
      if (_allPeople[i].getName() == name) {
        return false;
      }
    }

    _allPeople.add(new Person(name));

    // Firebase Test - Set the document ID as the person's name
    firebaseSessionInstance.document(name).setData({'name': name});

    notifyListeners();
    return true;
  }

  // adds a new score to an existing person (via index identifier)
  void addNewScoreToPersonByIndex(int score, int index) {
    _allPeople[index].addNewScore(score);

    // Get a reference of the document id with the name of the person

    // 1. Check to see if array is there
    // 2. If array isnt there create score with array of new score
    // 3. If array is there create a new array with the new score pushed

    firebaseSessionInstance
        .document(_allPeople[index].getName())
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.data['score'] == null) {
        // Not our first score
        firebaseSessionInstance
            .document(_allPeople[index].getName())
            .updateData({
          'score': [score]
        });
      } else {
        List<int> scoreList =
            new List<int>.from(documentSnapshot.data['score']);
        scoreList.add(score);

        // add an additional score element to the array
        firebaseSessionInstance
            .document(_allPeople[index].getName())
            .updateData({'score': scoreList});
      }
    });

    notifyListeners();
  }

  //******** */ Currently not used */ ********
  // adds a new score to an existing person (via string name identifier)
  bool addNewScoreToPersonByName(int score, String name) {
    for (int i = 0; i < _allPeople.length; i++) {
      if (_allPeople[i].getName() == name) {
        _allPeople[i].addNewScore(score);

        firebaseSessionInstance
            .document(name)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.data['score'] == null) {
            // Not our first score
            firebaseSessionInstance.document(name).updateData({
              'score': [score]
            });
          } else {
            List<int> scoreList =
                new List<int>.from(documentSnapshot.data['score']);
            scoreList.add(score);

            // add an additional score element to the array
            firebaseSessionInstance
                .document(name)
                .updateData({'score': scoreList});
          }
        });

        notifyListeners();
        return true;
      }
    }
    return false;
  }

  void updatePersonScore(int personIndex, int scoreIndex, int updatedScore) {
    _allPeople[personIndex].modifyScore(scoreIndex, updatedScore);

    firebaseSessionInstance
        .document(_allPeople[personIndex].getName())
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.data['score'] != null) {
        List<int> scoreList =
            new List<int>.from(documentSnapshot.data['score']);
        scoreList[scoreIndex] = updatedScore;

        // add an additional score element to the array
        firebaseSessionInstance
            .document(_allPeople[personIndex].getName())
            .updateData({'score': scoreList});
      }
    });

    notifyListeners();
  }

  List<Person> getPeopleScores() {
    return _allPeople;
  }
}
