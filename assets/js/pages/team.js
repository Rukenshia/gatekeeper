const app = new Vue({
    el: '#app',
    data: {
        team: {
            id: null,
            members: [],
        },
        users: [],
    },
    mounted() {
        this.team = {
            ...this.team,
            ...window.vueData.team,
        };
        this.users = window.vueData.users;

        // process memberships
        console.log(this.team);
        this.team.memberships.forEach(ms => {
            const user = this.users.find(u => u.id === ms.user_id)

            user.membership = ms;
            this.team.members.push(user);
        });
    },
    methods: {
        addMember(user) {
            axios.post(`/api/teams/${this.team.id}/members`, { user_id: user.id })
                .then(res => {
                    user.membership = res.data;
                    this.team.members.push(user);

                    snackbar.show({
                        message: `Successfully added ${user.name} to the team`,
                    });
                });
        },
        removeMember(user) {
            axios.delete(`/api/teams/${this.team.id}/members/${user.id}`)
                .then(() => {
                    this.team.members = this.team.members.filter(m => m.id !== user.id);
                    user.membership = null;

                    snackbar.show({
                        message: `Successfully removed ${user.name} from the team`,
                    });
                });
        },
    },
    filters: {
      capitalize: function (value) {
        if (!value) {
            return '';
        }
        return value.toString().charAt(0).toUpperCase() + value.slice(1)
      },
    },
});
