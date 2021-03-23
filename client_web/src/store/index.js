import Vue from 'vue';
import Vuex from 'vuex';
import createdPersistedState from 'vuex-persistedstate';
import SecureLS from 'secure-ls';

import user from './modules/user.js';
import area from './modules/area.js';

Vue.use(Vuex);

const ls = new SecureLS({
  isCompression: false,
  encryptionSecret: process.env.VUE_APP_VUEX_LS_KEY || 'my-ultimate-secret-key',
});

const store = new Vuex.Store({
  strict: process.env.NODE_ENV !== 'production',
  plugins: [
    createdPersistedState({
      storage: {
        getItem: (key) => ls.get(key),
        setItem: (key, value) => ls.set(key, value),
        removeItem: (key) => ls.remove(key),
      },
    }),
  ],
  modules: { user, area },
});

export default store;
