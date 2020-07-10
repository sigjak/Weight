import 'package:flutter/material.dart';
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
  var _isInit = true;
  Bio bio = Bio();
  //final url = 'https://weight-8da08.firebaseio.com/weights.json';
  var init = {
    'weight': '',
    'systolic': '',
    'daiastolic': '',
    'pulse': '',
  };
  @override
  void didChangeDependencies() {
    if (_isInit) {
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
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void saveFormData() async {
    _formKey.currentState.save();
    print('start');
    bio.day = DateTime.now();
    if (bio.id != null) {
      await Provider.of<Data>(context, listen: false)
          .updateOldData(bio.id, bio);
      print('update');
    } else {
      await Provider.of<Data>(context, listen: false).addNewData(bio);
      print('new');
    }

    print(bio.id);
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
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
                    textInputAction: TextInputAction.next,
                    initialValue: init['pulse'],
                    decoration: InputDecoration(
                      labelText: 'Pulse',
                    ),
                    onSaved: (value) {
                      bio.pulse = value;
                    },
                  ),
                  RaisedButton(
                    child: Text('Submit'),
                    onPressed: saveFormData,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
