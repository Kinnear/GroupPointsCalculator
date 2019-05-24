import 'package:scoped_model/scoped_model.dart';

class Person
{ 
  String _name = "";
  List<int> _scores = new List<int>();

  Person(String name)
  {
    this._name = name;
  }

  String getName()
  {
    return _name;
  }

  List<int> getListOfScores()
  {
    return _scores;
  }

  void addNewScore(int newScore)
  {
    _scores.add(newScore);
  }

  int getTotalScore()
  {
    int totalScore = 0;
    for(int i = 0; i < _scores.length; i++)
    {
      totalScore += _scores[i];
    }
    return totalScore;
  }
}

class ScoreModel extends Model
{
    List<Person> _allPeople = new List<Person>();

    // Adds a brand new person to our score list
    bool addNewPerson(String name)
    {
      for(int i = 0; i < _allPeople.length; i++)
      {
        if(_allPeople[i].getName() == name)
        {
          return false;
        }
      }

      _allPeople.add(new Person(name));
      notifyListeners();
      return true;
    }

    // adds a new score to an existing person
    bool addNewScoreToPerson(int score, String name)
    {
      for(int i = 0; i < _allPeople.length; i++)
      {
        if(_allPeople[i].getName() == name)
        {
          _allPeople[i].addNewScore(score);

          notifyListeners();
          return true;
        }
      }
      return false;
    }

    List<Person> getPeopleScores()
    {
      return _allPeople;
    }

}