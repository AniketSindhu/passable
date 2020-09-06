const functions = require('firebase-functions');
const admin=require('firebase-admin');
admin.initializeApp();
const  database=admin.firestore();
exports.timerupdate= functions.pubsub.schedule('0 */4 * * *').onRun((context)=>{
    const now= admin.firestore.Timestamp.now();
    const query= database.collection('events').where('eventDateTime','<',now).where('eventLive','==',true);
    const query1= database.collection('OnlineEvents').where('eventDateTime','<',now).where('eventLive','==',true);
    const task = query.get().then((snapshot)=>
        {       
            snapshot.forEach(doc=>{
                 doc.ref.update({'eventLive':false});
            });
            return true;
        }
    ).catch((error)=>{
        console.log(error);
        return error;
    });
    const task1 = query1.get().then((snapshot)=>
        {       
            snapshot.forEach(doc=>{
                 doc.ref.update({'eventLive':false});
            });
            return true;
        }
    ).catch((error)=>{
        console.log(error);
        return error;
    });
    
    console.log("eventDateTime Checked");
    return true;
});

exports.sendNotificationToTopic = functions.firestore.document('Announcements/{a_id}').onWrite(async (event) => {
    //let docID = event.after.id;
    let title = 'New announcement from '+event.after.get('eventName');
    let content = event.after.get('description');
    var message = {
        notification: {
            title: title,
            body: content,
        },
        topic: event.after.get('token'),
    };

    let response = await admin.messaging(com.aniket.passable).send(message);
    console.log(response);
});
