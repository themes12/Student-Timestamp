import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lks/models/brew.dart';
import 'package:lks/models/user.dart';
import 'package:lks/screens/authenticate/add_id.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference brewCollection = Firestore.instance.collection('users');

  Future<void> updateUserData(String id) async {
    return await brewCollection.document(uid).setData({
      'id': id,
    });
  }

  // brew list from snap shot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      return Brew(
        uid: uid,
        id: doc.data['id'] ?? ''
      );
    }).toList();
  }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    if(snapshot.data['id'] != ""){
      return UserData(
          uid: uid,
          id: snapshot.data['id']
      );
    }else{
      return null;
    }
  }

  //get brews stream
  Stream<List<Brew>> get brew {
    return brewCollection.snapshots()
      .map(_brewListFromSnapshot);
  }

  //get users doc stream
  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots()
        .map(_userDataFromSnapshot);
  }

}