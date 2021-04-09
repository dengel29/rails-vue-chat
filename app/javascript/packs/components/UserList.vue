<template>
  <div class="user-list__container">
    <div>

      <h1>we're in the chats</h1>
      <ul>
        <li v-for="user in users" :key="user.id" :data-user-id="user.id">
          {{user.email}} | <button @click="startChatWith($event)">Up vote</button>

        </li>
      </ul>
    </div>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      currentUser: null
    }
  },
  channels: {
    ChatChannel: {
      connected() {
        console.log("connected to the chat channel")
      },
      rejected() {},
      received(data) {},
      disconnected() {}
    },
    UserListChannel: {
      connected() {
        console.log("connected to meat channel")
      },
      rejected() {},
      received(data) {},
      disconnected() {}
    }
  },
  props: ["users"],
  methods: {
    startChatWith: function (e) {
      this.$cable.perform({
        channel: 'UserListChannel',
        action: 'send_invitation',
        data: {
          hostId: this.currentUserId,
          targetUserId: e.target.dataset.userId
        }
      })
    },

  },
  mounted() {
    this.$cable.subscribe({
      channel: 'ChatChannel',
      room: 'public'
    });
    this.$cable.subscribe({
      channel: 'UserListChannel'
    });
    this.hostId = Array.from(document.querySelectorAll('meta')).find(el => el.name === 'current-user')
  }
}
</script>

<style scoped>
  .user-list__container {
    border-right: 5px solid darkslateblue
  }
  h1 {margin-top: 0}
</style>
