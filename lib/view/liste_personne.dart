import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstbd233/controller/firebase_helper.dart';
import 'package:firstbd233/model/my_user.dart';
import 'package:flutter/material.dart';
import 'package:firstbd233/constante/constant.dart';
import 'package:flutter/cupertino.dart';

class ListPersonne extends StatefulWidget {
  const ListPersonne({super.key});

  @override
  State<ListPersonne> createState() => _ListPersonneState();
}

class _ListPersonneState extends State<ListPersonne> {

  showDetails(MyUser user){
    showDialog(
        context: context,
        builder: (context){
          return CupertinoAlertDialog(
            title: Text('Détails'),
            content: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(user.avatar!),
                ),
                Text(user.fullName),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Revenir en arrière")),
            ],
          );
        });
  }




  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseHelper().cloud_users.snapshots(),
        builder: (context,snap){
          if(snap.data == null){
            return Center(child: Text("Aucun utilisateur"),);
          }else {
            List documents = snap.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
                itemBuilder: (context,index){
                MyUser users = MyUser.bdd(documents[index]);
                if(users.email != moi.email) {
                  return Card(
                    elevation: 5,
                    color: Colors.purple,
                    child: ListTile(
                      onTap: (){
                        showDetails(users);
                      },
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(users.avatar!),
                      ),
                      title: Text(users.fullName),
                      subtitle: Text(users.email),
                      trailing: IconButton(
                          icon: Icon(Icons.favorite, color: (users.favorite) ? Colors.red : Colors.grey),
                          onPressed: () {
                            setState(() {
                              users.favorite = !users.favorite;
                            });
                            Map<String,dynamic> map = {
                              "FAVORITE": users.favorite
                            };
                            FirebaseHelper().updateUser(users.uid, map);
                          },
                      ),
                    ),
                  );
                }
                }
            );
          }
        }
    );
  }
}
