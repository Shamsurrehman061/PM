import "package:cloud_firestore/cloud_firestore.dart";

FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference users = FirebaseFirestore.instance.collection('users');

setUserDetails(uid, {name = "", profile = "", email = "", phone = ""}) async {
  //name=name==null?"":name;
  //profile=profile==null?"":profile;
  email = email == null ? "" : email;
  phone = phone == null ? "" : phone;

  DocumentSnapshot doc = await users.doc(uid).get();
  var existingData = doc.data() as  Map<String,dynamic>;

  if (existingData != null) {
    print('Existing data is not null');
    existingData["id"] = existingData["id"] == null ? uid : existingData["id"];
    existingData["approved"] =
        existingData["approved"] == null ? false : existingData["approved"];
    existingData["name"] = existingData["name"] ?? "";
    existingData["profile"] = existingData["profile"] ?? "";
    existingData["phone"] = phone;
    existingData["email"] = email;
    existingData["officeAddress"] = existingData["officeAddress"] == null
        ? ""
        : existingData["officeAddress"];
    existingData["registrationDocumentBackPic"] == null
        ? ""
        : existingData["registrationDocumentBackPic"];
    existingData["registrationDocumentFrontPic"] == null
        ? ""
        : existingData["registrationDocumentFrontPic"];
    existingData["registrationNumber"] == null
        ? ""
        : existingData["registrationNumber"];
    existingData["businessName"] == null ? "" : existingData["businessName"];
    existingData["businessOwner"] == null ? "" : existingData["businessOwner"];
    existingData["idCardFrontPic"] == null
        ? ""
        : existingData["idCardFrontPic"];
    existingData["idCardBackPic"] == null ? "" : existingData["idCardBackPic"];
  } else {
    print('Existing data is null');
    existingData = {};
    existingData["id"] = uid;
    existingData["approved"] = false;
    //existingData["name"]=name; // erase the name from firebase document
    //existingData["profile"]=profile; // erase the name from firebase document
    existingData["phone"] = phone;
    existingData["email"] = email;
    existingData["officeAddress"] = "";
    existingData["registrationDocumentBackPic"] = "";
    existingData["registrationDocumentFrontPic"] = "";
    existingData["registrationNumber"] = "";
    existingData["businessName"] = "";
    existingData["businessOwner"] = "";
    existingData["idCardFrontPic"] = "";
    existingData["idCardBackPic"] = "";
  }

  await users.doc(uid).update(existingData);
  return null;
}
