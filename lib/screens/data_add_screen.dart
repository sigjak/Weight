import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../screens/data_list_screen.dart';
//import '../widgets/app_drawer.dart';
import '../Providers/dataProvider.dart';
import '../models/bio.dart';

class AddEdit extends StatefulWidget {
  static const routeName = '/add_edit';
  @override
  _AddEditState createState() => _AddEditState();
}

class _AddEditState extends State<AddEdit> {
  final _formKey = GlobalKey<FormState>();
  final FocusScopeNode _node = FocusScopeNode();
  Bio bio = Bio();
  var isLoading = false;
  var init = {
    'weight': '',
    'systolic': '',
    'daiastolic': '',
    'pulse': '',
  };

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
    Navigator.of(context).pushReplacementNamed(ListScreen.routeName);
  }

  String validateNumber(String val) {
    if (double.tryParse(val) == null) {
      return ('Enter a valid number');
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text(
          'Enter Data',
          textAlign: TextAlign.center,
        ),
      ),
      // drawer: AppDrawer(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 50.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: FocusScope(
                      node: _node,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            validator: validateNumber,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: _node.nextFocus,
                            initialValue: init['weight'],
                            decoration: InputDecoration(
                              labelText: 'Weight',
                            ),
                            onSaved: (value) {
                              bio.weight = value;
                            },
                          ),
                          TextFormField(
                            validator: validateNumber,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: _node.nextFocus,
                            initialValue: init['systolic'],
                            decoration: InputDecoration(
                              labelText: 'Systolic',
                            ),
                            onSaved: (value) {
                              bio.syst = value;
                            },
                          ),
                          TextFormField(
                            validator: validateNumber,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: _node.nextFocus,
                            initialValue: init['diastolic'],
                            decoration: InputDecoration(
                              labelText: 'Diastolic',
                            ),
                            onSaved: (value) {
                              bio.diast = value;
                            },
                          ),
                          TextFormField(
                            validator: validateNumber,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            onEditingComplete: _node.nextFocus,
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
                                  SystemChannels.textInput
                                      .invokeMethod('TextInput.hide');
                                  if (!_formKey.currentState.validate()) {
                                    return;
                                  }
                                  saveFormData();

                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('New data added!'),
                                    ),
                                  );
                                });
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
