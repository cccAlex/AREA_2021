const express = require('express');
const router = express.Router();

const checkToken = require('../middleware/checkToken');

const signUp = require('../controller/authenticate/signUp');
const signIn = require('../controller/authenticate/signIn');

router.post('/signUp', signUp);
router.post('/signIn', signIn);

const getGoogleAuthURL = require('../controller/authenticate/getGoogleAuthURL');
const getFacebookAuthURL = require('../controller/authenticate/getFacebookAuthURL');
const confirmUser = require('../controller/authenticate/confirmUser');
const resendConfirmationEmail = require('../controller/authenticate/resendConfirmationEmail');
const signWithGoogle = require('../controller/authenticate/signWithGoogle');
const getFacebookClientID = require('../controller/authenticate/getFacebookClientID');
const signWithFacebook = require('../controller/authenticate/signWithFacebook');

router.get('/getGoogleAuthURL', getGoogleAuthURL);
router.post('/confirmUser', confirmUser);
router.post('/resendConfirmationEmail', checkToken, resendConfirmationEmail);
router.post('/signWithGoogle', signWithGoogle);
router.get('/getFacebookClientID', getFacebookClientID);
router.post('/signWithFacebook', signWithFacebook);
router.get('/getFacebookAuthURL', getFacebookAuthURL);

const getUser = require('../controller/user/getUser');
router.get('/user', checkToken, getUser);

const getServices = require('../controller/services/getServices');
const getService = require('../controller/services/getService');
const removeService = require('../controller/services/removeService');
router.get('/services', checkToken, getServices);
router.get('/service', checkToken, getService);
router.post('/removeService', checkToken, removeService);

const getRefreshTime = require('../controller/area/getRefreshTime');
const addArea = require('../controller/area/addArea');
const getArea = require('../controller/area/getArea');
const removeArea = require('../controller/area/removeArea');
const runArea = require('../controller/area/runArea');
const stopArea = require('../controller/area/stopArea');
router.get('/getRefreshTime', checkToken, getRefreshTime);
router.post('/addArea', checkToken, addArea);
router.get('/area', checkToken, getArea);
router.post('/removeArea', checkToken, removeArea);
router.post('/runArea', checkToken, runArea);
router.post('/stopArea', checkToken, stopArea);

const spotify = require('../controller/services/spotify');
router.get('/getSpotifyAuthURL', checkToken, spotify.getSpotifyAuthURL);
router.post('/spotifySignIn', checkToken, spotify.spotifySignIn);

const googleCalendar = require('../controller/services/googleCalendar');
router.get('/getGoogleCalendarAuthURL', checkToken, googleCalendar.getGoogleCalendarAuthURL);
router.post('/googleCalendarSignIn', checkToken, googleCalendar.googleCalendarSignIn);

const googleDrive = require('../controller/services/googleDrive');
router.get('/getGoogleDriveAuthURL', checkToken, googleDrive.getGoogleDriveAuthURL);
router.post('/googleDriveSignIn', checkToken, googleDrive.googleDriveSignIn);

const youtube = require('../controller/services/youtube');
router.get('/getYoutubeAuthURL', checkToken, youtube.getYoutubeAuthURL);
router.post('/youtubeSignIn', checkToken, youtube.youtubeSignIn);

module.exports = router;