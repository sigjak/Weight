import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../screens/data_list_screen.dart';
import '../widgets/app_drawer.dart';
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

  List<String> systThree = [];
  List<String> diastThree = [];
  List<String> pulseThree = [];
  int visCount = 0;

  Bio bio = Bio();
  var isLoading = false;
  var init = {
    'weight': '',
    'systolic': '',
    'diastolic': '',
    'pulse': '',
  };

  String toAverage(List<String> threeList) {
    double total = 0;
    double ave = 0;
    double count = 0;
    threeList.forEach((element) {
      if (element.isNotEmpty && element != null) {
        double temp = (double.tryParse(element));
        count++;
        total += temp;
      }
    });
    ave = total / count;

    String value = ave.toStringAsFixed(0);
    return value;
  }

  void saveFormData() async {
    setState(() {
      isLoading = true;
    });
    _formKey.currentState.save();
    DateTime now = DateTime.now();
    //DateTime bb = DateTime(now.year, now.month, now.day);
    // more than once a day

    bio.syst = toAverage(systThree);
    bio.diast = toAverage(diastThree);
    bio.pulse = toAverage(pulseThree);

    if (bio.id != null) {
      await Provider.of<Data>(context, listen: false)
          .updateOldData(bio.id, bio);
    } else {
      //bio.day = bb;
      bio.day = now;
      await Provider.of<Data>(context, listen: false).addNewData(bio);
      await Provider.of<Data>(context, listen: false).getTableSize();
    }

    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pushReplacementNamed(ListScreen.routeName);
  }

  String validateNumber(var val) {
    if (val.isNotEmpty && double.tryParse(val) == null) {
      return ('Invalid entry!');
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
      drawer: AppDrawer(),
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
                          Row(children: [
                            Expanded(
                              child: TextFormField(
                                validator: validateNumber,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: _node.nextFocus,
                                initialValue: init['systolic'],
                                decoration: InputDecoration(
                                  labelText: 'Systolic 1',
                                ),
                                onSaved: (value) {
                                  systThree.insert(0, value);
                                },
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: TextFormField(
                                validator: validateNumber,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: _node.nextFocus,
                                initialValue: init['diastolic'],
                                decoration: InputDecoration(
                                  labelText: 'Diastolic 1',
                                ),
                                onSaved: (value) {
                                  diastThree.insert(0, value);
                                },
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: TextFormField(
                                validator: validateNumber,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: _node.nextFocus,
                                initialValue: init['pulse'],
                                decoration: InputDecoration(
                                  labelText: 'Pulse 1',
                                ),
                                onSaved: (value) {
                                  pulseThree.insert(0, value);
                                },
                              ),
                            ),
                          ]),
                          Visibility(
                            visible: visCount > 0 ? true : false,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    validator: validateNumber,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: _node.nextFocus,
                                    initialValue: init['systolic'],
                                    decoration: InputDecoration(
                                      labelText: 'Systolic 2',
                                    ),
                                    onSaved: (value) {
                                      systThree.insert(1, value);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    validator: validateNumber,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: _node.nextFocus,
                                    initialValue: init['diastolic'],
                                    decoration: InputDecoration(
                                      labelText: 'Diastolic 2',
                                    ),
                                    onSaved: (value) {
                                      diastThree.insert(1, value);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    validator: validateNumber,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: _node.nextFocus,
                                    initialValue: init['pulse'],
                                    decoration: InputDecoration(
                                      labelText: 'Pulse 2',
                                    ),
                                    onSaved: (value) {
                                      pulseThree.insert(1, value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: visCount > 1 ? true : false,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    validator: validateNumber,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: _node.nextFocus,
                                    initialValue: init['systolic'],
                                    decoration: InputDecoration(
                                      labelText: 'Systolic 3',
                                    ),
                                    onSaved: (value) {
                                      systThree.insert(2, value);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    validator: validateNumber,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: _node.nextFocus,
                                    initialValue: init['diastolic'],
                                    decoration: InputDecoration(
                                      labelText: 'Diastolic 3',
                                    ),
                                    onSaved: (value) {
                                      diastThree.insert(2, value);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    validator: validateNumber,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: _node.nextFocus,
                                    initialValue: init['pulse'],
                                    decoration: InputDecoration(
                                      labelText: 'Pulse 3',
                                    ),
                                    onSaved: (value) {
                                      pulseThree.insert(2, value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RaisedButton(
                                  child: Text('Submit'),
                                  onPressed: () {
                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide');
                                    if (!_formKey.currentState.validate()) {
                                      return;
                                    }
                                    saveFormData();
                                  }),
                              Visibility(
                                visible: visCount > 1 ? false : true,
                                child: RaisedButton(
                                  onPressed: () {
                                    setState(() {
                                      visCount++;
                                    });
                                  },
                                  child: Text('More Bp'),
                                ),
                              ),
                            ],
                          ),
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
