import Vue from 'vue';
import VueRouter from 'vue-router';

import store from '../store';
import axios from '../plugins/axios';

Vue.use(VueRouter);

const routes = [
  {
    path: '/',
    name: 'TheHome',
    component: () => import('@/containers/TheHome.vue'),
    meta: { title: 'Area', requiresAuth: true, navigation: true },
  },
  {
    path: '/signIn',
    name: 'SignIn',
    component: () => import('@/containers/SignIn.vue'),
    meta: { title: 'SignIn', requiresAuth: false, navigation: false },
  },
  {
    path: '/signUp',
    name: 'SignUp',
    component: () => import('@/containers/SignUp.vue'),
    meta: { title: 'SignUp', requiresAuth: false, navigation: false },
  },
  {
    path: '/google/callback',
    name: 'GoogleCallback',
    component: () => import('@/components/GoogleCallback.vue'),
    meta: { title: 'Callback google auth', requiresAuth: false, navigation: false },
  },
  {
    path: '/spotifyCallback',
    name: 'SpotifyCallback',
    component: () => import('@/components/SpotifyCallback.vue'),
    meta: { title: 'Callback spotify auth', requiresAuth: true, navigation: false },
  },
  {
    path: '/googleCalendar/callback',
    name: 'GoogleCalendarCallback',
    component: () => import('@/components/GoogleCalendarCallback.vue'),
    meta: { title: 'Callback google calendar auth', requiresAuth: true, navigation: false },
  },
  {
    path: '/googleDrive/callback',
    name: 'GoogleDriveCallback',
    component: () => import('@/components/GoogleDriveCallback.vue'),
    meta: { title: 'Callback google drive auth', requiresAuth: true, navigation: false },
  },
    {
    path: '/youtube/callback',
    name: 'YoutubeCallback',
    component: () => import('@/components/YoutubeCallback.vue'),
    meta: { title: 'Callback youtube auth', requiresAuth: true, navigation: false },
  },
  {
    path: '/confirm',
    name: 'TheConfirmation',
    component: () => import('@/containers/TheConfirmation.vue'),
    meta: { title: 'Confirmation' }
  },
  {
    path: '/404',
    alias: '*',
    name: 'NotFound',
    component: () => import('@/containers/NotFound.vue'),
    meta: { title: 'Page not found', requiresAuth: false, navigation: false },
  },
];

const router = new VueRouter({
  mode: 'history',
  routes,
});

const axiosCheckToken = (token) => {
  return new Promise((resolve, reject) =>
    axios.get('/user', { headers: { 'Authorization': token }, params: { me: true } })
      .then(({ data: { status, data } }) => {
        if (!status) return reject(data);
        //store.dispatch('user/setUser', data);
        resolve();
      })
      .catch(() => {
        store.dispatch('user/signOut');
        reject();
      })
  );
};

router.beforeEach((to, from, next) => {
  if (to.meta.title) document.title = to.meta.title + ' | Area';
  const token = store.getters['user/getBearerToken'];
  if (to.meta.requiresAuth) {
    if (!token) {
      return next({ name: 'SignIn', query: { redirectURL: to.fullPath } });
    }
    const confirmed = store.state.user.confirmed;
    axiosCheckToken(token)
      .then(() => {
        if (confirmed)
          next()
        else {
          next()
          //message erreur + renvoyer le mail de veérification TODO
        }
      })
      .catch(() => next({ name: 'SignIn', query: { redirectURL: to.fullPath } }));
  } else {
    if (!token) return next();

    axiosCheckToken(token)
      .then(() => next({ name: 'TheHome' }))
      .catch(() => next());
  }
});

export default router;