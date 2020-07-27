const functions = require('firebase-functions');
const admin=require('firebase-admin');
admin.initializeApp();
const  database=admin.firestore();
exports.timerupdate= functions.pubsub.schedule('0 */4 * * *').onRun((context)=>{
    const now= admin.firestore.Timestamp.now();
    const query= database.collection('events').where('eventDateTime','<',now).where('eventLive','==',true);
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
    console.log("eventDateTime Checked");
    return true;
});