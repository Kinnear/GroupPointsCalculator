import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'scoreModel.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<ScoreModel>(
        model: new ScoreModel(),
        child: MaterialApp(
          title: 'Points Tracker',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage(title: 'Points Tracker'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Return the a row that describes the person's row
  Widget buildPersonRow(int personIndex) {
    return Container(
      child:
          ScopedModelDescendant<ScoreModel>(builder: (context, child, model) {
        // This would contain the entire row with the person's name the list of scores and the final score
        return Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 2.0, bottom: 2.0),
                padding : EdgeInsets.all(20),
                width: 100,
                color: Colors.blue[50],
                child: Text(model.getPersonName(personIndex))),
                Expanded(
                  child:Container(
                  margin: EdgeInsets.only(top: 2.0, bottom: 2.0),
                width: 200,
                color: Colors.blue[100],
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: model
                      .getPeopleScores()[personIndex]
                      .getListOfScores()
                      .length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 30.0,
                      child: Center(
                        child: Text(model
                            .getPeopleScores()[personIndex]
                            .getListOfScores()[index]
                            .toString()),
                      ),
                    );
                  },
                )),),
            Container(
                color: Colors.blue[200],
                margin: EdgeInsets.only(top: 2.0, bottom: 2.0),
                padding : EdgeInsets.all(15.0),
                width: 60.0,
                child: Text(
                    model
                        .getPeopleScores()[personIndex]
                        .getTotalScore()
                        .toString(),
                    style: TextStyle(fontSize: 17))),
            Container(
                width: 80.0,
                child: FlatButton(
                color: Colors.blue[300],
                padding : EdgeInsets.all(15.0),
                  child: Text('Add'),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: Text('Add Score Amount'), 
                            content: TextField(
                              keyboardType: TextInputType.numberWithOptions(),
                              onSubmitted: (text) {
                                model.addNewScoreToPersonByIndex(
                                    int.parse(text), personIndex);
                                Navigator.pop(context);
                              },
                            ),
                          );
                        });
                    // launch pop up
                  },
                )),
          ],
        ));
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          child: Align(
              alignment: Alignment.topCenter,
              child: ScopedModelDescendant<ScoreModel>(
                builder: (context, child, model) {
                  return Container(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      // shrinkWrap: true,
                      itemCount: model.getPeopleScores().length,
                      itemBuilder: (context, index) {
                        // size of the Row
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: buildPersonRow(index));
                      },
                    ),
                  );
                },
              ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("pressed");
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('Add Person'),
                content: TextField(
                  keyboardType: TextInputType.text,
                  onSubmitted: (text) {
                    ScoreModel model = ScopedModel.of<ScoreModel>(context);
                    model.addNewPerson(text);
                    Navigator.pop(context);
                  },
                ),
              );
            },
          );
        },
        tooltip: 'Add Person',
        child: Icon(Icons.add),
      ),
    );
  }
}
