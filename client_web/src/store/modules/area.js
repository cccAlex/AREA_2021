import axios from '@/plugins/axios';

const namespaced = true;

const state = () => ({
  firstService: {
    name: null,
    serviceName: null,
    serviceParams: {},
    params: {},
    isLogged: false,
  },
  secondService: {
    name: null,
    serviceName: null,
    serviceParams: {},
    params: {},
    isLogged: false,
  }
});

const getters = {
  getFirstService: ({firstService}) => { return firstService },
  getSecondService: ({secondService}) => { return secondService },
};

const actions = {
  setFirstService: ({ commit }, data) => commit('setFirstService', data),
  setSecondService: ({ commit }, data) => commit('setSecondService', data),
  signWithSpotify: ({ rootGetters }, query) => {
    return new Promise((resolve, reject) =>
      axios.post('/spotifySignIn', query, { headers: { Authorization: rootGetters["user/getBearerToken"],},})
        .then(({ data: { status, data } }) => {
          if (!status) return reject(new Error(data));
          resolve(data);
        })
        .catch((err) => reject(err))
    );
  },
  // eslint-disable-next-line no-unused-vars
  signWithGoogleCalendar: ({ rootGetters }, query) => {
    return new Promise((resolve, reject) => {
      axios.post('/googleCalendarSignIn', query, { headers: { Authorization: rootGetters["user/getBearerToken"],},})
        .then(({ data: { status, data } }) => {
          if (!status) return reject(new Error(data));
          resolve(data);
        })
        .catch((err) => {
          reject(err)
        })
      }
    );
  },
  signWithGoogleGmail: ({ rootGetters }, query) => {
    return new Promise((resolve, reject) => {
      axios.post('/googleGmailSignIn', query, { headers: { Authorization: rootGetters["user/getBearerToken"],},})
        .then(({ data: { status, data } }) => {
          if (!status) return reject(new Error(data));
          resolve(data);
        })
        .catch((err) => {
          reject(err)
        })
      }
    );
  },
  signWithGoogleDrive: ({ rootGetters }, query) => {
    return new Promise((resolve, reject) => {
      axios.post('/googleDriveSignIn', query, { headers: { Authorization: rootGetters["user/getBearerToken"],},})
        .then(({ data: { status, data } }) => {
          if (!status) return reject(new Error(data));
          resolve(data);
        })
        .catch((err) => {
          reject(err)
        })
      }
    );
  },
  signWithYoutube: ({ rootGetters }, query) => {
    return new Promise((resolve, reject) => {
      axios.post('/youtubeSignIn', query, { headers: { Authorization: rootGetters["user/getBearerToken"],},})
        .then(({ data: { status, data } }) => {
          if (!status) return reject(new Error(data));
          resolve(data);
        })
        .catch((err) => {
          reject(err)
        })
      }
    );
  },
};

const mutations = {
  setFirstService: (state, data) => {
    state.firstService = data
  },
  setSecondService: (state, data) => {
    state.secondService = data
  }
};

export default { namespaced, state, getters, actions, mutations };
