import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nowapps_sqllite/bloc/index.dart';
import 'package:nowapps_sqllite/data_model/index.dart';
import 'package:nowapps_sqllite/util/ui_screen_utils.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SqliteBloc(),
      child: _HomeScreenStateFul(),
    );
  }

}

class _HomeScreenStateFul extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }

}

class _HomeScreenState extends State<_HomeScreenStateFul> {

  TextEditingController _firstNameController;
  TextEditingController _lastNameController;
  TextEditingController _ageController;
  TextEditingController _phoneNumberController;
  TextEditingController _emailController;

  UserDataModel _userData;

  @override
  void initState() {
    super.initState();
    _firstNameController = new TextEditingController();
    _lastNameController = new TextEditingController();
    _ageController = new TextEditingController();
    _phoneNumberController = new TextEditingController();
    _emailController = new TextEditingController();
    _userData = new UserDataModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.1,
                    bottom: MediaQuery.of(context).size.width * 0.05,
                  ),
                    alignment: AlignmentDirectional.topCenter,
                    child: Text(
                      "User Details",
                      style: TextStyle(
                        fontFamily: "QuicksandBold",
                        fontSize: MediaQuery.of(context).size.width * 0.055,
                        color: Colors.black87,
                      ),
                    )
                ),
                Expanded(
                  child: BlocBuilder<SqliteBloc, SqliteState>(
                      builder: (BuildContext context, SqliteState sqliteState) {

                        if(sqliteState.state == DB_RESP_EVENT.LOADING) {

                          return Container(
                            alignment: AlignmentDirectional.center,
                            child: CircularProgressIndicator(),
                          );

                        } else {

                          _processData(sqliteState.data);

                          return Container(
                            margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.04,
                              right: MediaQuery.of(context).size.width * 0.04,
                              bottom: MediaQuery.of(context).size.width * 0.04,
                            ),
                            child: ListView(
                              children: <Widget>[

                                _buildTitle("First Name"),
                                _buildEditText(_firstNameController, TextInputType.text, "Sri Kathiravan", (newValue) {
                                  _userData.firstName = newValue;
                                  SqliteBloc.getInstance().add(new SqliteEvent(DB_EVENT.SAVE_LOCAL, _userData));
                                }),

                                _buildTitle("Last Name"),
                                _buildEditText(_lastNameController, TextInputType.text, "Irulappan", (newValue) {
                                  _userData.lastName = newValue;
                                  SqliteBloc.getInstance().add(new SqliteEvent(DB_EVENT.SAVE_LOCAL, _userData));
                                }),

                                _buildTitle("Age"),
                                _buildEditText(_ageController, TextInputType.numberWithOptions(decimal: false), "23", (newValue) {
                                  if(newValue.isNotEmpty) {
                                    _userData.age = int.parse(newValue);
                                  } else {
                                    _userData.age = 0;
                                  }
                                  SqliteBloc.getInstance().add(new SqliteEvent(DB_EVENT.SAVE_LOCAL, _userData));
                                }),

                                _buildTitle("Gender"),
                                _buildGenderCheckbox(),

                                _buildTitle("Phone Number"),
                                _buildEditText(_phoneNumberController, TextInputType.numberWithOptions(decimal: false), "9566463349", (newValue) {
                                  _userData.phoneNumber = newValue;
                                  SqliteBloc.getInstance().add(new SqliteEvent(DB_EVENT.SAVE_LOCAL, _userData));
                                }),

                                _buildTitle("Email Id"),
                                _buildEditText(_emailController, TextInputType.emailAddress, "srikathiravan.i@gmail.com", (newValue) {
                                  _userData.emailId = newValue;
                                  SqliteBloc.getInstance().add(new SqliteEvent(DB_EVENT.SAVE_LOCAL, _userData));
                                }),

                                Container(
                                  height: MediaQuery.of(context).size.width * 0.04,
                                ),


                              ],
                            ),
                          );

                        }

                      }
                  ),
                )
              ],
            ),
          )
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _getActionBottomSheet(context, (isChanged) {

            });
          },
        backgroundColor: Colors.blueAccent,
        child: Icon(
          Icons.more_horiz,
          color: Colors.white,
        ),
      ),
    );
  }

  _buildTitle(String title) {
    return Container(
        alignment: AlignmentDirectional.topStart,
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.02),
        child: Text(
          "$title",
          style: TextStyle(
            fontFamily: "QuicksandBold",
            fontSize: MediaQuery.of(context).size.width * 0.045,
            color: Colors.black87,
          ),
        )
    );
  }

  _buildEditText(TextEditingController controller, TextInputType inputType, String hint, Function(String) onSubmit) {

    return Container(
        alignment: AlignmentDirectional.topStart,
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.04),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width * 0.02)),
          color: Color(0xFFF5F4F4),
        ),
        child: Container(
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * 0.02,
              bottom: MediaQuery.of(context).size.width * 0.02,
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05,
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: inputType,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration.collapsed(
              hintText: "e.g $hint",
              hintStyle: TextStyle(
                fontFamily: "QuicksandBold",
                fontSize:
                MediaQuery.of(context).size.width * 0.04,
                color: Colors.grey[300],
              ),
            ),
            style: TextStyle(
              fontFamily: "QuicksandBold",
              fontSize:
              MediaQuery.of(context).size.width * 0.04,
              color: Colors.black87,
            ),
            onChanged: (newStr) {
              onSubmit(newStr);
            },

          ),
        ));

  }

  _processData(UserDataModel data) {

    if(data != null) {
      _userData = data;
      if(data.firstName != null && data.firstName.isNotEmpty) {
        _firstNameController = new TextEditingController(text: "${data.firstName}",);
        _firstNameController.selection = TextSelection.fromPosition(TextPosition(offset: data.firstName.length),);
      } else {
        _firstNameController = new TextEditingController(text: "");
      }
      if(data.lastName != null && data.lastName.isNotEmpty) {
        _lastNameController = new TextEditingController(text: "${data.lastName}");
        _lastNameController.selection = TextSelection.fromPosition(TextPosition(offset: data.lastName.length),);
      } else {
        _lastNameController = new TextEditingController(text: "");
      }
      if(data.age != null) {
        _ageController = new TextEditingController(text: "${data.age}");
        _ageController.selection = TextSelection.fromPosition(TextPosition(offset: ("${data.age}").length),);
      } else {
        _ageController = new TextEditingController(text: "");
      }
      if(data.phoneNumber != null && data.phoneNumber.isNotEmpty) {
        _phoneNumberController = new TextEditingController(text: "${data.phoneNumber}");
        _phoneNumberController.selection = TextSelection.fromPosition(TextPosition(offset: data.phoneNumber.length),);
      } else {
        _phoneNumberController = new TextEditingController(text: "");
      }
      if(data.emailId != null && data.emailId.isNotEmpty) {
        _emailController = new TextEditingController(text: "${data.emailId}");
        _emailController.selection = TextSelection.fromPosition(TextPosition(offset: data.emailId.length),);
      } else {
        _emailController = new TextEditingController(text: "");
      }
    } else {

      _userData = new UserDataModel();

      _firstNameController = new TextEditingController(text: "");
      _lastNameController = new TextEditingController(text: "");
      _ageController = new TextEditingController(text: "");
      _phoneNumberController = new TextEditingController(text: "");
      _emailController = new TextEditingController(text: "");
    }

  }

  _buildGenderCheckbox() {

    return Container(
        alignment: AlignmentDirectional.topStart,
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.04),
        child: Container(
          alignment: AlignmentDirectional.topStart,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.01,
                ),
                child: Checkbox(
                    value: (_userData.gender == "Male") ? true : false,
                    onChanged: (newValue) {
                      if(_userData.gender != "Male") {
                        setState(() {
                          _userData.gender = "Male";
                        });
                      }
                    }
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.01,
                ),
                child: Text(
                  "Male",
                  style: TextStyle(
                    fontFamily: "QuicksandBold",
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Checkbox(
                    value: (_userData.gender == "Female") ? true : false,
                    onChanged: (newValue) {
                      if(_userData.gender != "Female") {
                        setState(() {
                          _userData.gender = "Female";
                        });
                      }
                    }
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.01,
                ),
                child: Text(
                  "Female",
                  style: TextStyle(
                    fontFamily: "QuicksandBold",
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        )
    );

  }

  void _getActionBottomSheet(context, Function(bool) isChanged) {


    showModalBottomSheet(
        backgroundColor: Colors.white,
        elevation: 2,
        isDismissible: true,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05),
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                MediaQuery.of(context).size.width * 0.03),
                            topRight: Radius.circular(
                                MediaQuery.of(context).size.width * 0.03)
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),
                          Text(
                            "Operations on User Details",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "QuicksandBold",
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                fontSize: MediaQuery.of(context).size.width * 0.045),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),

                          _buildActionButton("Insert", "Add new record to database", Icons.save, Colors.blueAccent, () {
                            validateForm(DB_EVENT.INSERT);
                            Navigator.pop(context);
                          }),

                          _buildSplitLine(),

                          _buildActionButton("Read", "Read record from database", Icons.receipt, Colors.green, () {
                            _getPhNoBottomSheet(context, DB_EVENT.READ, (isChanged) {});
                          }),

                          _buildSplitLine(),

                          _buildActionButton("Update", "update record in database", Icons.update, Colors.orange, () {
                            validateForm(DB_EVENT.UPDATE);
                            Navigator.pop(context);
                          }),

                          _buildSplitLine(),

                          _buildActionButton("Delete", "Delete record to database", Icons.receipt, Colors.red, () {
                            _getPhNoBottomSheet(context, DB_EVENT.DELETE, (isChanged) {});
                          }),

                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  void _getPhNoBottomSheet(context, DB_EVENT event, Function(bool) isChanged) {

    TextEditingController editphoneNumber = new TextEditingController();

    showModalBottomSheet(
        backgroundColor: Colors.white,
        elevation: 2,
        isDismissible: true,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05),
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                MediaQuery.of(context).size.width * 0.03),
                            topRight: Radius.circular(
                                MediaQuery.of(context).size.width * 0.03)
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),
                          Text(
                              (event == DB_EVENT.READ) ? "Read from SQLite" : "Delete user details",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "QuicksandBold",
                                fontWeight: FontWeight.w600,
                                color: Colors.blueAccent,
                                fontSize: MediaQuery.of(context).size.width * 0.045),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),
                          Text(
                            "Enter Phone Number",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: "QuicksandBold",
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                fontSize: MediaQuery.of(context).size.width * 0.035),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),


                          Container(
                              alignment: AlignmentDirectional.topStart,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                color: Color(0xFFF5F4F4),
                              ),
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 5,
                                    bottom: 5,
                                    left: 20,
                                    right: 20),
                                child: TextField(
                                  controller: editphoneNumber,
                                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                                  decoration: InputDecoration.collapsed(
                                    hintText: "Phone Number",
                                    hintStyle: TextStyle(
                                      fontFamily: "QuicksandBold",
                                      fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                      color: Colors.grey[300],
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontFamily: "QuicksandBold",
                                    fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                    color: Colors.black45,
                                  ),
                                ),
                              )
                          ),

                          Expanded(
                            child: Container(
                              alignment: AlignmentDirectional.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    height: MediaQuery.of(context).size.height * 0.045,
                                    width: MediaQuery.of(context).size.height * 0.15,
                                    child: RaisedButton.icon(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        color: Colors.white,
                                        textColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context).size.height * 0.2),
                                          side: BorderSide(color: Colors.blue, width: 2),
                                        ),
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.blue,
                                          size: MediaQuery.of(context).size.width * 0.035,
                                        ),
                                        label: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              fontFamily: "QuicksandBold",
                                              color: Colors.blue,
                                              fontSize: MediaQuery.of(context).size.width * 0.035),
                                        )
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.05,
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height * 0.045,
                                    width: MediaQuery.of(context).size.height * 0.15,
                                    child: RaisedButton.icon(
                                        color: Colors.blue,
                                        textColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                MediaQuery.of(context).size.height *
                                                    0.12),
                                            side: BorderSide(color: Colors.blue)),
                                        onPressed: () {
                                          if(editphoneNumber.text != null && editphoneNumber.text.isNotEmpty && editphoneNumber.text.length == 10) {
                                            SqliteBloc.getInstance().add(new SqliteEvent(event, new UserDataModel(phoneNumber: editphoneNumber.text)));
                                            Navigator.pop(context);
                                          } else {
                                            UiScreenUtils.showToast("Please enter valid phone number (10 digits)");
                                          }

                                        },
                                        icon: Icon(
                                          Icons.done,
                                          color: Colors.white,
                                          size: MediaQuery.of(context).size.width * 0.035,
                                        ),
                                        label: Text(
                                          "Done",
                                          style: TextStyle(
                                              fontFamily: "QuicksandBold",
                                              color: Colors.white,
                                              fontSize: MediaQuery.of(context).size.width * 0.035),
                                        )
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  _buildActionButton(String name, String subTittle, IconData icon, Color color, Function() onClick) {

    return InkWell(
      onTap: () {
        setState(() {
          onClick();
        });
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.width * 0.03,
          top: MediaQuery.of(context).size.width * 0.03,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.09,
              height: MediaQuery.of(context).size.width * 0.09,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.02),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: MediaQuery.of(context).size.width * 0.045,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      "$name",
                      style: TextStyle(
                        fontFamily: "QuicksandSemiBold",
                        fontSize:
                        MediaQuery.of(context).size.width * 0.04,
                      ),
                    ),
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.03),
                  ),
                  Container(
                    child: Text(
                      "$subTittle",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "QuicksandSemiBold",
                        color: Colors.black54,
                        fontSize:
                        MediaQuery.of(context).size.width * 0.035,
                      ),
                    ),
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.03,
                      top: MediaQuery.of(context).size.width * 0.01,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[600],
              size: MediaQuery.of(context).size.width * 0.03,
            ),
          ],
        ),
      ),
    );

  }

  _buildSplitLine() {
    return Container(
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
      ),
      height: 0.5,
      color: Colors.blueGrey[100],
    );
  }

  validateForm(DB_EVENT event) {

    if(_firstNameController.text == null || _firstNameController.text.isEmpty) {
      UiScreenUtils.showToast("Please enter valid first name");
    } else if(_lastNameController.text == null || _lastNameController.text.isEmpty) {
      UiScreenUtils.showToast("Please enter valid last name");
    } else if(_ageController.text == null || _ageController.text.isEmpty) {
      UiScreenUtils.showToast("Please enter valid age");
    } else if(_phoneNumberController.text == null || _phoneNumberController.text.isEmpty) {
      UiScreenUtils.showToast("Please enter valid phone number");
    } else if(_emailController.text == null || _emailController.text.isEmpty) {
      UiScreenUtils.showToast("Please enter valid email id");
    } else {
      UserDataModel newData = new UserDataModel();
      newData.firstName = _firstNameController.text;
      newData.lastName = _lastNameController.text;
      newData.age = int.parse(_ageController.text);
      newData.phoneNumber = _phoneNumberController.text;
      newData.emailId = _emailController.text;
      newData.gender = _userData.gender;
      if(event == DB_EVENT.INSERT) {
        SqliteBloc.getInstance().add(new SqliteEvent(DB_EVENT.INSERT, newData));
      } else {
        SqliteBloc.getInstance().add(new SqliteEvent(DB_EVENT.UPDATE, newData));
      }

    }

  }

}