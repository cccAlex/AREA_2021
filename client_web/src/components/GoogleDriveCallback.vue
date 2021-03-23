<template>
    <div>
    </div>
</template>

<script>

export default {
    name: 'GoogleDriveCallback',
    mounted() {
        const { state, code } = this.$route.query;

        this.$store.dispatch('area/signWithGoogleDrive', { state, code })
            .then(() => {
                if (state == 'first') {
                    var firstService = {
                        name: null,
                        serviceName: 'Google Drive',
                        serviceParams: {},
                        params: {},
                        isLogged: true,
                    }
                    this.$store.dispatch("area/setFirstService", firstService);
                } if (state == 'second') {
                    var secondService = {
                        name: null,
                        serviceName: 'Google Drive',
                        serviceParams: {},
                        params: {},
                        isLogged: true,
                    }
                    this.$store.dispatch("area/setSecondService", secondService);
                }
                this.$router.push({ name: 'TheHome', params: {success: 'success', service: 'Google Drive', state: state}});
            })
            .catch(() => this.$router.push({ name: 'TheHome', params: {error: 'connection to google drive failed', service: 'google drive', state: state}}));
    },
};
</script>
