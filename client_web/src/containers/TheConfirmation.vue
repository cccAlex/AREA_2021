<template>
    <div>
        <p v-if="error">{{ error }}</p>
        <p v-else>Your account is now confirmed. Go here: link to home page</p>
    </div>
</template>

<script>
import axios from '@/plugins/axios';

export default {
    name: 'TheConfirmation',
    data() {
        return {
            error: '',
        };
    },
    mounted() {
        const { code } = this.$route.query;

        axios.post('/confirmUser', { code })
            .then(({ data: { status, data } }) => {
                if (!status)
                    this.error = data;
            })
            .catch((err) => this.error = err.message);
    },
};
</script>
