import 'package:flutter/material.dart';
import 'package:weight_2/screens/edit.dart';
import '../widgets/app_drawer.dart';
import '../Providers/dataProvider.dart';
import 'package:provider/provider.dart';
import '../models/bio.dart';

class AddEdit extends StatefulWidget {
  static const routeName = '/add_edit';
  @override
  _AddEditState createState() => _AddEditState();
}

class _AddEditState extends State<AddEdit> {
  final _formKey = GlobalKey<FormState>();
  //var _isInit = true;
  Bio bio = Bio();
  var isLoading = false;
  var init = {
    'weight': '',
    'systolic': '',
    'daiastolic': '',
    'pulse': '',
  };
  //@override
  // void didChangeDependencies() {
  //   print('dep');
  //   if (_isInit) {
  //     final bioId = ModalRoute.of(context).settings.arguments as String;
  //     if (bioId != null) {
  //       bio = Provider.of<Data>(context).findById(bioId);
  //       init = {
  //         'weight': bio.weight,
  //         'systolic': bio.syst,
  //         'diastolic': bio.diast,
  //         'pulse': bio.pulse,
  //       };
  //     }
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  void saveFormData() async {
    setState(() {
      isLoading = true;
    });
    _formKey.currentState.save();
    DateTime now = DateTime.now();
    DateTime bb = DateTime(now.year, now.month, now.day);
    bio.day = bb;
    if (bio.id != null) {
      await Provider.of<Data>(context, listen: false)
          .updateOldData(bio.id, bio);
    } else {
      await Provider.of<Data>(context, listen: false).addNewData(bio);
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pushReplacementNamed(EditScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final bioId = ModalRoute.of(context).settings.arguments as String;
    if (bioId != null) {
      bio = Provider.of<Data>(context).findById(bioId);
      init = {
        'weight': bio.weight,
        'systolic': bio.syst,
        'diastolic': bio.diast,
        'pulse': bio.pulse,
      };
    }
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text(
          'Enter Data',
          textAlign: TextAlign.center,
        ),
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 50.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          initialValue: init['weight'],
                          decoration: InputDecoration(
                            labelText: 'Weight',
                          ),
                          onSaved: (value) {
                            bio.weight = value;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          initialValue: init['systolic'],
                          decoration: InputDecoration(
                            labelText: 'Systolic',
                          ),
                          onSaved: (value) {
                            bio.syst = value;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          initialValue: init['diastolic'],
                          decoration: InputDecoration(
                            labelText: 'Diastolic',
                          ),
                          onSaved: (value) {
                            bio.diast = value;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          initialValue: init['pulse'],
                          decoration: InputDecoration(
                            labelText: 'Pulse',
                          ),
                          onSaved: (value) {
                            bio.pulse = value;
                          },
                        ),
                        SizedBox(height: 20),
                        Builder(builder: (BuildContext context) {
                          return RaisedButton(
                              child: Text('Submit'),
                              onPressed: () {
                                saveFormData();
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text('New data added!')));
                              });
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
