<template>
    <div>
    </div>
</template>

<script>

export default {
    name: 'GoogleCallback',
    mounted() {
        const { state, code } = this.$route.query;

        this.$store.dispatch('user/signWithGoogle', { state, code })
            .then(({ redirectURL }) => {
                this.$router.push(redirectURL);
            })
            .catch((err) => {
                this.$router.push({ name: 'SignIn', params: { err } });
            });
    },
};
</script>
