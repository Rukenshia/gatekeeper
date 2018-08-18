import 'regenerator-runtime/runtime';

const app = new Vue({
  el: '#app',
  data: {
    team: {
      id: null,
      members: [],
    },
    users: [],
  },
  async mounted() {
    this.team = {
      ...this.team,
      ...window.vueData.team,
    };

    const { data } = await axios.get(`/api/teams/${this.team.id}/members`);

    this.team.members = data.map(m => ({ ...m.user, role: m.role }));

    const users = await axios.get('/api/users');

    this.users = users.data.map(u => ({ ...u, isMember: this.team.members.find(m => m.id === u.id) }));
  },
  methods: {
    addMember(user) {
      axios.post(`/api/teams/${this.team.id}/members`, { user_id: user.id })
        .then(res => {
          user.isMember = true;
          user.role = res.data.role;
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
          user.isMember = false;
          user.role = undefined;

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
