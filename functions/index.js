const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.createMsg = functions.firestore
    .document('chat/{msgId}')
    .onCreate((snap, context) => {
        admin.firestore().collection('users').doc(snap.data().userId).get().then(userDoc => {
            admin.messaging().sendToTopic('chat', {
                notification: {
                    title: userDoc.data().name,
                    body: snap.data().text,
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK'
                }
            });
        });
    });
