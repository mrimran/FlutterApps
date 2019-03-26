const functions = require('firebase-functions');
const cors = require('cors')({ origin: true });
const Busboy = require('busboy');
const os = require('os');
const path = require('path');
const fs = require('fs');
const fbAdmin = require('firebase-admin');
const uuid = require('uuid/v4');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

const gccconfig = {
    projectId: 'flutter-easylist',
    keyFilename: 'flutter-easylist.json'
};

const gcs = require('@google-cloud/storage')(gccconfig);
fbAdmin.initializeApp({ credential: fbAdmin.credential.cert(require('./flutter-easylist.json')) });

exports.storeImage = functions.https.onRequest((req, res) => {
    return cors(req, res, () => {
        if (req.method !== 'POST') {
            return res.status(500).json({ message: 'Not allowed.' });
        }

        if (!req.headers.authorization || !req.headers.authorization.startsWith('Bearer ')) {//Bearer normally comes with JWT tokens
            return res.status(401).json({ error: 'Unauthorized.' });
        }

        let idToken;
        idToken = req.headers.authorization.split('Bearer ')[1];

        const busboy = new Busboy({ headers: req.headers });
        let uploadData;
        let oldImagePath;

        busboy.on('file', (fieldname, file, filename, encoding, mimetype) => {
            const filePath = path.join(os.tmpdir(), filename);

            uploadData = { filePath: filePath, type: mimetype, name: filename };

            file.pipe(fs.createWriteStream(filePath));
        });

        busboy.on('field', (fieldname, value) => {//for updating image
            oldImagePath = decodeURIComponent(value);
        });

        busboy.on('finish', () => {
            const bucket = gcs.bucket('flutter-easylist-35b62.appspot.com');
            const id = uuid();
            let imagePath = 'images/' + id + '_' + uploadData.name;

            if (oldImagePath) {
                imagePath = oldImagePath;//overwite old image
            }

            return fbAdmin.auth().verifyIdToken(idToken).then(decodedToken => {
                return bucket.upload(uploadData.filePath, {
                    uploadType: 'media',
                    destination: imagePath,
                    metadata: {
                        metadata: {
                            contentType: uploadData.type,
                            firebaseStorageDownloadTokens: id
                        }
                    }
                });
            }).then(() => {
                return res.status(201).json({
                    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/' + bucket.name + '/o/' + encodeURIComponent(imagePath) + '?alt=media&token=' + id,
                    imagePath: imagePath
                });
            }).catch(error => {
                return res.status(401).json({ error: 'Unauthorized.' });
            });
        });

        return busboy.end(req.rawBody);
    });
});

exports.deleteImage = functions.database.ref('/products/{productId}').onDelete(snapshot => {
    const imageData = snapshot.val();
    const imagePath = imageData.imagePath;

    const bucket = gcs.bucket('flutter-easylist-35b62.appspot.com');
    return bucket.file(imagePath).delete();
});