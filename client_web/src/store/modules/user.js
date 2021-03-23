import axios from '@/plugins/axios';

const namespaced = true;

const state = () => ({
  _id: 0,
  email: '',
  username: '',
  token: '',
});

const getters = {
  getBearerToken: ({ token }) => !token ? null : `Bearer ${token}`,
  getEmail: ({email}) => {return email},
};

const actions = {
  setUser: ({ commit }, user) => commit('setUser', user),
  signUp: ({ commit }, user) => {
    return new Promise((resolve, reject) =>
      axios.post('/signUp', user)
        .then(({ data: { status, data } }) => {
          if (!status) return reject(data);

          commit('setUser', data);
          resolve(data);
        })
        .catch((err) => reject(err.message))
    );
  },
  signIn: ({ commit }, user) => {
    return new Promise((resolve, reject) =>
      axios.post('/signIn', user)
        .then(({ data: { status, data } }) => {
          if (!status) return reject(data);

          commit('setUser', data);
          resolve(data);
        })
        .catch((err) => reject(err.message))
    );
  },
  signOut: ({ commit }) => commit('setUser', state()),
  // eslint-disable-next-line no-unused-vars
  getGoogleAuthURL: (props, redirectURL = '/') => {
    return new Promise((resolve, reject) =>
      axios.get('/getGoogleAuthURL', { params: { redirectURL } })
        .then(({ data: { status, data } }) => {
          if (!status) return reject(data);

          resolve(data.url);
        })
        .catch((err) => reject(err.message))
    );
  },
  signWithGoogle: ({ commit }, query) => {
    return new Promise((resolve, reject) =>
      axios.post('/signWithGoogle', query)
        .then(({ data: { status, data } }) => {
          if (!status) return reject(new Error(data));
          commit('setUser', data);
          resolve(data);
        })
        .catch((err) => reject(err))
    );
  },
};

const mutations = {
  setUser: (state, user) => {
    state._id = user._id;
    state.username = user.username;
    state.email = user.email;
    state.token = user.token;
  },
};

export default { namespaced, state, getters, actions, mutations };
