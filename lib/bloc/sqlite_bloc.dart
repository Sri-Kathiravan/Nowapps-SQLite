import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nowapps_sqllite/data_model/index.dart';
import 'package:nowapps_sqllite/database_ops/database_ops.dart';


class SqliteBloc extends Bloc<SqliteEvent, SqliteState> {

  static SqliteBloc _instance;

  static SqliteBloc getInstance() {
    if(_instance == null) {
      _instance = new SqliteBloc();
    }
    return _instance;
  }

  SqliteBloc() {
    _instance = this;
  }

  SqliteState _sqliteState = new SqliteState(DB_RESP_EVENT.RESPONSE, new UserDataModel());

  @override
  SqliteState get initialState => new SqliteState(DB_RESP_EVENT.RESPONSE, new UserDataModel());

  @override
  Stream<SqliteState> mapEventToState(SqliteEvent sqliteEvent) async* {

    switch(sqliteEvent.event) {

      case DB_EVENT.INSERT:
        _sqliteState.state = DB_RESP_EVENT.LOADING;
        yield _copyData(_sqliteState);
        _sqliteState.state = DB_RESP_EVENT.RESPONSE;
        DatabaseOps.getInstance().insertUserData(sqliteEvent.data);
        yield _copyData(_sqliteState);
        break;

      case DB_EVENT.READ:
        _sqliteState.state = DB_RESP_EVENT.LOADING;
        yield _copyData(_sqliteState);
        _sqliteState.state = DB_RESP_EVENT.RESPONSE;
        _sqliteState.data = await DatabaseOps.getInstance().readUserData(sqliteEvent.data.phoneNumber);
        yield _copyData(_sqliteState);
        break;

      case DB_EVENT.UPDATE:
        _sqliteState.state = DB_RESP_EVENT.LOADING;
        yield _copyData(_sqliteState);
        _sqliteState.state = DB_RESP_EVENT.RESPONSE;
        DatabaseOps.getInstance().updateUserData(sqliteEvent.data);
        yield _copyData(_sqliteState);
        break;

      case DB_EVENT.DELETE:
        _sqliteState.state = DB_RESP_EVENT.LOADING;
        yield _copyData(_sqliteState);
        _sqliteState.state = DB_RESP_EVENT.RESPONSE;
        DatabaseOps.getInstance().deleteUserData(sqliteEvent.data.phoneNumber);
        yield _copyData(_sqliteState);
        break;

      case DB_EVENT.SAVE_LOCAL:
        _sqliteState.state = DB_RESP_EVENT.RESPONSE;
        _sqliteState.data = sqliteEvent.data;
        yield _copyData(_sqliteState);
        break;
    }

  }

  SqliteState _copyData(SqliteState input) {
    SqliteState output = new SqliteState(input.state, input.data);
    return output;
  }

}

enum DB_EVENT {
  INSERT, UPDATE, DELETE, READ, SAVE_LOCAL
}

enum DB_RESP_EVENT {
  LOADING, RESPONSE
}

class SqliteEvent {
  DB_EVENT event;
  UserDataModel data;

  SqliteEvent(this.event, this.data);

}

class SqliteState {
  DB_RESP_EVENT state;
  UserDataModel data;

  SqliteState(this.state, this.data);

}