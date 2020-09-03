import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plan_it_on/Methods/getUserId.dart';
import 'package:plan_it_on/Models/user.dart';
import 'package:random_string/random_string.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class GetPass{

  Future<String> bookPass (DocumentSnapshot post,int ticketCount,PaymentSuccessResponse response) async{
    
    String uid= await getCurrentUid();
    User user;
    final userDoc= await Firestore.instance.collection('users').document(uid).get();
    user=User.fromDocument(userDoc);

   
    if(!post.data['isPaid']){
      String passCode= randomAlphaNumeric(8);
      Firestore.instance.collection('users').document(uid).collection('eventJoined').document(post.data['eventCode']).setData({'eventCode':post.data['eventCode'],'passCode':passCode,'pay_id':null,'ticketCount':1});
      if(!post.data['isOnline']){
        Firestore.instance.collection("events").document(post.data['eventCode']).collection('guests').document(passCode).setData({'user':user.uid,'phone':user.phone,'email':user.email,'name':user.name,'passCode':passCode,'Scanned':false,'pay_id':null,'ticketCount':1});
        Firestore.instance.collection('events').document(post.data['eventCode']).updateData({'joined': FieldValue.increment(1)});
      }
      else{
        Firestore.instance.collection("OnlineEvents").document(post.data['eventCode']).collection('guests').document(passCode).setData({'user':user.uid,'phone':user.phone,'email':user.email,'name':user.name,'passCode':passCode,'Scanned':false,'pay_id':null,'ticketCount':1});
        Firestore.instance.collection('OnlineEvents').document(post.data['eventCode']).updateData({'joined': FieldValue.increment(1)});
      }
      return passCode;
    }

    
    else if(post.data['isPaid']&&post.data['partner']!=null){
      String passCode= randomAlphaNumeric(8);
      Firestore.instance.collection('users').document(uid).collection('eventJoined').document(post.data['eventCode']).setData({'eventCode':post.data['eventCode'],'passCode':passCode,'pay_id':response.paymentId,'ticketCount':ticketCount});
      Firestore.instance.collection('payments').document(response.paymentId).setData({'eventCode':post.data['eventCode'],'passCode':passCode,'pay_id':response.paymentId,'amount':post.data['ticketPrice']*ticketCount,'user':user.uid,'phone':user.phone,'email':user.email,'name':user.name});
      
      Firestore.instance.collection('partners').document(post.data['partner']).updateData({'amount_to_be_paid_total':FieldValue.increment(post.data['ticketPrice']*ticketCount*2/100),'amount_total':FieldValue.increment(post.data['ticketPrice']*ticketCount*2/100)});
      Firestore.instance.collection('partners').document(post.data['partner']).collection('eventsPartnered').document(post.data['eventCode']).updateData({'amount_to_be_paid':FieldValue.increment(post.data['ticketPrice']*ticketCount),'amount_earned':FieldValue.increment(post.data['ticketPrice']*ticketCount*2/100)});
      
      if(!post.data['isOnline']){
        Firestore.instance.collection("events").document(post.data['eventCode']).collection('guests').document(passCode).setData({'user':user.uid,'phone':user.phone,'email':user.email,'name':user.name,'passCode':passCode,'Scanned':false,'pay_id':response.paymentId,'ticketCount':ticketCount});
        Firestore.instance.collection('events').document(post.data['eventCode']).updateData({'joined': FieldValue.increment(ticketCount),'amountEarned':FieldValue.increment(post.data['ticketPrice']*ticketCount),'amount_to_be_paid':FieldValue.increment(post.data['ticketPrice']*ticketCount)});
      }
      
      else{
        Firestore.instance.collection("OnlineEvents").document(post.data['eventCode']).collection('guests').document(passCode).setData({'user':user.uid,'phone':user.phone,'email':user.email,'name':user.name,'passCode':passCode,'Scanned':false,'pay_id':response.paymentId,'ticketCount':ticketCount});
        Firestore.instance.collection('OnlineEvents').document(post.data['eventCode']).updateData({'joined': FieldValue.increment(ticketCount),'amountEarned':FieldValue.increment(post.data['ticketPrice']*ticketCount,),'amount_to_be_paid':FieldValue.increment(post.data['ticketPrice']*ticketCount)});
      }

      return passCode;
    }


    else if(post.data['isPaid']&&post.data['partner']==null){
      String passCode= randomAlphaNumeric(8);
      Firestore.instance.collection('users').document(uid).collection('eventJoined').document(post.data['eventCode']).setData({'eventCode':post.data['eventCode'],'passCode':passCode,'pay_id':response.paymentId,'ticketCount':ticketCount});
      Firestore.instance.collection('payments').document(response.paymentId).setData({'eventCode':post.data['eventCode'],'passCode':passCode,'pay_id':response.paymentId,'amount':post.data['ticketPrice']*ticketCount,'user':user.uid,'phone':user.phone,'email':user.email,'name':user.name});
      
      
      if(!post.data['isOnline']){
        Firestore.instance.collection("events").document(post.data['eventCode']).collection('guests').document(passCode).setData({'user':user.uid,'phone':user.phone,'email':user.email,'name':user.name,'passCode':passCode,'Scanned':false,'pay_id':response.paymentId,'ticketCount':ticketCount});
        Firestore.instance.collection('events').document(post.data['eventCode']).updateData({'joined': FieldValue.increment(ticketCount),'amountEarned':FieldValue.increment(post.data['ticketPrice']*ticketCount,),'amount_to_be_paid':FieldValue.increment(post.data['ticketPrice']*ticketCount)});
      }
      
      else{
        Firestore.instance.collection("OnlineEvents").document(post.data['eventCode']).collection('guests').document(passCode).setData({'user':user.uid,'phone':user.phone,'email':user.email,'name':user.name,'passCode':passCode,'Scanned':false,'pay_id':response.paymentId,'ticketCount':ticketCount});
        Firestore.instance.collection('OnlineEvents').document(post.data['eventCode']).updateData({'joined': FieldValue.increment(ticketCount),'amountEarned':FieldValue.increment(post.data['ticketPrice']*ticketCount,),'amount_to_be_paid':FieldValue.increment(post.data['ticketPrice']*ticketCount)});
      }

      return passCode;
    }
  }
}