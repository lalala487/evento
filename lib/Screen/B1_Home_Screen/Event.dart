import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Event{
  String id;
  String category;
  String about;
  String event_image;
  String event_date;
  String title;
  DateTime dtFrom;
  DateTime dtTo;
  String timeType;
  String date;
  String date1;
  String icon;
  String groupName;
  List<dynamic> speaker;
  List<dynamic> q_a;
  List<dynamic> tiket;
  Map<dynamic,dynamic> contact;
  double latitude;
  double longitude;
  List<dynamic> ticket_category;
  Event()
  {
    dtTo = null;
    speaker = null;
    q_a = new List();
    tiket = new List();
    contact = new Map();
    contact["address"] = "";
    contact["email"] = "";
    contact["phone"] = "";
    contact["skype"] = "";
    contact["web"] = "";
    latitude = 0;
    longitude = 0;
    groupName = null;
    icon = null;
  }

  readFromList(DocumentSnapshot data)
  {
    id = data.documentID;
    event_image = data['event_image'].toString();
    if (data['icon'] != null)
    {
      icon = data['icon'];
    }
    about = data['about'].toString();
    category = data['category'].toString();
    title = data['title'].toString();
    dtFrom = data['time']['from'].toDate();
    dtFrom = dtFrom.toLocal();



    timeType = data['timetype'].toString();
    //e.dtFrom.timeZoneName;
    final f = new DateFormat('EEEE d y MMMM h:mm a');
    //String date = DateFormat.yMEd().add_jms().format(e.dtFrom);
    date = f.format(dtFrom);
    if (data['time']['todate'] is Timestamp ) {
      dtTo = data['time']['todate'].toDate();
      dtTo = dtTo.toLocal();
      date1 = f.format(dtTo);
    }
    if (data['speaker'] != null)
    {
      speaker = data['speaker'];
    }
    if (data['qa'] != null)
    {
      q_a = data['qa'];
    }

    if (data['ticket'] != null)
    {
      tiket = data['ticket'];
    }
    if (data['contact'] != null)
    {
      contact = data['contact'];
    }
    if (data['group'] != null)
    {
      groupName = data['group'];
    }


    if (contact['latitude'] != null)
    {
      try {
        latitude = double.parse(contact['latitude']);
        longitude = double.parse(contact['longitude']);
      }catch(e)
      {

      }
    }
    ticket_category = data['ticket_category'];
  }
}