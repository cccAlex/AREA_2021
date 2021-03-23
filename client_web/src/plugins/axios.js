import axios from 'axios';

const instance = axios.create({
  baseURL: process.env.NODE_ENV === 'production' ? process.env.VUE_APP_API_BASE_URL :
    process.env.VUE_APP_API_BASE_URL_LOCAL,
});

export default instance;
