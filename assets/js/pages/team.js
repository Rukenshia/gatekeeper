const app = new Vue({
    el: '#app',
    data: window.vueData,
    methods: {
        addMember(user) {
            axios.post(`/api/teams/${this.team.id}/members`, { user_id: user.id })
                .then(() => {
                    this.team.members.push(user);
                    this.users.splice(this.users.indexOf(user), 1);


                    snackbar.show({
                        message: `Successfully added ${user.name} to the team`,
                    });
                });
        },
        removeMember(user) {
            axios.delete(`/api/teams/${this.team.id}/members/${user.id}`)
                .then(() => {
                    this.team.members = this.team.members.filter(m => m.id !== user.id);
                    this.users.push(user);

                    snackbar.show({
                        message: `Successfully removed ${user.name} from the team`,
                    });
                });
        },
    },
});
