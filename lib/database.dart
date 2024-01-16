import 'package:laser_slides/models/button_model.dart';
import 'package:laser_slides/models/network_model.dart';
import 'package:laser_slides/viewmodel/network_view_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  late Database _database;

//open database
  Future<void> open() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'myDb.db');

    _database = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) {
        _createTables(db);
      },
    );
  }

//create tables
  void _createTables(Database db) {
    db.execute('''
      CREATE TABLE IF NOT EXISTS button_config(
        id INTEGER PRIMARY KEY,
        buttonName TEXT,
        buttonPressed TEXT
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS network_config(
        id INTEGER PRIMARY KEY,
        outgoingIpAddress TEXT,
        outgoingPort INTEGER,
        startPath TEXT,
        incomingPort INTEGER,
        incomingIpAddress TEXT,
        listenForIncomingMessages INTEGER
      );
    ''');
  }

//get all network data
  Future<Map<String, dynamic>> getAllNetworkData() async {
    await open();
    final List<Map<String, dynamic>> networkData =
        await _database.query('network_config');
    return {
      'network_config': networkData,
    };
  }

//update network data
  Future<int> updateNetworkData(int id, NetworkModel networkModel) async {
    await open();
    return await _database.update(
      'network_config',
      networkModel.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

//insert network data
  Future<int> insertNetworkData(NetworkModel networkModel) async {
    return await _database.rawInsert(
      'INSERT OR REPLACE INTO network_config (id, outgoingIpAddress, outgoingPort, startPath, incomingPort, incomingIpAddress, listenForIncomingMessages) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [
        networkModel.id,
        networkModel.outgoingIpAddress,
        networkModel.outgoingPort,
        networkModel.startPath,
        networkModel.incomingPort,
        networkModel.incomingIpAddress,
        networkModel.listenForIncomingMessages
      ],
    );
  }

//create network data
  Future<void> createNetwokData() async {
    await open();
    String ipv4Address = await NetworkViewModel().deviceIPV4();
    final newNetworkData = NetworkModel(
        id: 1,
        outgoingIpAddress: '',
        outgoingPort: 8000,
        startPath: '/',
        incomingIpAddress: ipv4Address,
        incomingPort: 8000,
        listenForIncomingMessages: 1);

    await insertNetworkData(newNetworkData);
  }

//get all button data
  Future<Map<String, dynamic>> getAllButtonData() async {
    await open();
    final List<Map<String, dynamic>> buttonData =
        await _database.query('button_config');
    return {
      'button_config': buttonData,
    };
  }

//update button data
  Future<int> updateButton(int id, ButtonModel updatedButton) async {
    await open();
    return await _database.update(
      'button_config',
      updatedButton.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

//insert button data
  Future<int> insertButton(ButtonModel button) async {
    return await _database.rawInsert(
      'INSERT OR REPLACE INTO button_config (id, buttonName, buttonPressed) VALUES (?, ?, ?)',
      [button.id, button.buttonName, button.buttonPressed],
    );
  }

//create button data
  Future<void> createButton() async {
    await open();
    for (int i = 1; i <= 18; i++) {
      final newButton = ButtonModel(
          id: i,
          buttonName: 'Button $i',
          buttonPressed: 'beyond/general/startcue 0 $i');
      await insertButton(newButton);
    }
  }
}
