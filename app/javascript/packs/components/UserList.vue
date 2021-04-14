<template>
  <div class="user-list__container">
    <div class="user-list__inner">
      <h1>{{currentUser.username}} in the chats</h1>
      <ul>
        <li v-for="user in users" :key="user.id" :data-user-id="user.id" @click="handleClick($event)">
          {{user.username}}
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      currentUserId: null,
      currentUser: null
    }
  },
  channels: {
    ChatChannel: {
      connected() {
        console.log("connected to the chat channel")
      },
      rejected() {},
      received(data) {
        
      },
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
    // startChatWith: function (e) {
    //   this.$cable.perform({
    //     channel: 'UserListChannel',
    //     action: 'send_invitation',
    //     data: {
    //       host_id: this.currentUserId,
    //       target_user_id: e.target.dataset.userId
    //     }
    //   })
    // },
    handleClick: function(e) {
      let targetUserId = Number(e.target.dataset.userId)
      this.$emit("buttonClicked", {
        targetUserId: targetUserId
      })
    }

  },
  mounted() {
    let currentUserId = Array.from(document.querySelectorAll('meta')).find(el => el.name === 'current-user').dataset.id
    this.currentUserId = currentUserId
    this.currentUser = this.users.find(user => user.id === Number(currentUserId))
  }
}
</script>

<style scoped>
  .user-list__container {
    border-right: 5px solid darkslateblue
  }
  .user-list__inner {
    display:flex;
    flex-direction: column;
    justify-content: center;
    align-items:center;
  }
  h1 {
    margin-top: 0;
    font-size: 1.6em;
  }

  ul {
    list-style: none;
    text-align:center;
    margin-block-start: 0;
    margin-block-end: 0;
    padding-inline-start:0;
    width:100%;

  }
  li {
    cursor:pointer;
    width:90%;
    margin: 0.4em 0.4em;
    border-radius:4px;
    border: 2px solid darkslategray;
    padding: 2px 2px;
  }

  li:hover {
    color: rgb(218, 199, 199);
    background-color: rgba(18, 31, 31, 0.454)
  }

  li:active {
    color: white;
    background-color: darkslategray;
    border:2px solid white;
  }
</style>
