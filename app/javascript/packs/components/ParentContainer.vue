<template>
  <div style="display:grid; grid-template-columns: 20vw 1fr; grid-gap: 20px;">
    <user-list :users="users" @buttonClicked="chatSelected"></user-list>
    <chat-box :selectedChat="selectedChat"></chat-box>
  </div>
</template>

<script>
  export default {
    data: function(){
      return {
        selectedChat: {
          username: 'select a chat'
        }
      }
    },
    channels: {
      ChatChannel: {
        connected() {
          console.log("connected to the chat channel")
        },
        rejected() {},
        received(data) {
          console.log(data)
        },
        disconnected() {}
      },
      UserListChannel: {
        connected() {
          console.log("connected to meat channel")
        },
        rejected() {},
        received(data) {
          let userElement = Array.from(document.querySelectorAll('[data-user-id')).find(el => el.dataset.userId === String(data.user.id))
          if (data.online) {
            let element = document.getElementById(`${data.user.id}-offline-dot`);
            if (element) {
              element.remove()
            }
            let div = document.createElement('div')
            div.style.height = "50%";
            div.id = `${data.user.id}-online-dot`
            div.style.width = "10px";
            div.style.borderRadius = "50%"
            div.style.border = "1px solid green"
            div.style.background = "green"
            div.style.position = "absolute"
            userElement.insertAdjacentElement('afterbegin', div)
          } else if (!data.online) {
            let element = document.getElementById(`${data.user.id}-online-dot`);
            if (element) {
              element.remove()
            }
            let div = document.createElement('div')
            div.id = `${data.user.id}-offline-dot`
            div.style.height = "50%";
            div.style.width = "10px";
            div.style.borderRadius = "50%"
            div.style.border = "1px solid red"
            div.style.background = "red"
            div.style.position = "absolute"
            userElement.insertAdjacentElement('afterbegin', div)
          }
        },
        disconnected() {}
      }
    },
    props: ["users"],
    mounted: function() {
      this.$cable.subscribe({
        channel: 'UserListChannel'
      });
      let currentUserId = Array.from(document.querySelectorAll('meta')).find(el => el.name === 'current-user').dataset.id
      this.currentUserId = currentUserId
      this.currentUser = this.users.find(user => user.id === Number(currentUserId))
    },
    methods: {
      chatSelected(data) {
        console.log(data)
        let selectedUser = this.users.find( user => user.id === data.targetUserId)
        console.log(selectedUser)
        this.selectedChat = selectedUser
        this.$cable.subscribe({
          channel: 'ChatChannel',
          host_id: this.currentUserId,
          target_user_id: data.targetUserId
        })
      }
    }
  }
</script>

<style scoped>

</style>

