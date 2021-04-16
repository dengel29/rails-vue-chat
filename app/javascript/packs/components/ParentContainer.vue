<template>
  <div style="display:grid; grid-template-columns: 20vw 1fr; grid-gap: 20px;">
    <user-list :users="users" @buttonClicked="chatSelected"></user-list>
    <chat-box :selectedChat="selectedChat" @buttonClicked="messageSent" :currentUser="currentUser"></chat-box>
  </div>
</template>

<script>
  export default {
    data: function(){
      return {
        chats: [],
        selectedChat: {
          chatId: null,
          chat_room: {
            id: 0
          },
          users: [
            {
              username: 'select a chat'
            }
          ],
          id: 0
        },
        currentUser: {
          username: 'no one'}
      }
    },
    computed: {
      // TODO
      // selectedChat() {
      //   chats.find(chat => chat.id === )
      // }
    },
    channels: {
      ChatChannel: {
        connected() {
          console.log("connected to the chat channel")
          this.$cable.perform({
            channel: 'ChatChannel',
            action: 'get_chat_room'
          })
        },
        rejected() {},
        received(data) {
          if (data.type === 'message_receipt') {
            console.log(data)
            appendMessage(data)
          } else if (data.type === 'chatroom_receipt') {
            // console.log(data, "got the chatroom")
            this.chats.push(data)
            this.selectedChat = data
          }
          
        },
        disconnected() {}
      },
      NotificationsChannel: {
        connected() {
          console.log("connected to notificationschannel")
        },
        rejected() {},
        received(data) {
          if (data.type === 'chatroom_info') {
            // TODO
            // put leaf next to name of user who has initiated chat
            console.log(data, "got the chatroom")
            let host = this.users.find(user => user.id === data.host.id)
          }
        },
        disconnected(){}
      },
      UserListChannel: {
        connected() {
          console.log("connected to userlist channel")
        },
        rejected() {},
        received(data) {
          console.log("received data from the userlist channel")
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
      this.$cable.subscribe({
        channel: 'NotificationsChannel'
      })
      let currentUserId = Array.from(document.querySelectorAll('meta')).find(el => el.name === 'current-user').dataset.id
      this.currentUserId = currentUserId
      this.currentUser = this.users.find(user => user.id === Number(currentUserId))
    },
    methods: {
      chatSelected(data) {
        // let selectedUser = this.users.find( user => user.id === data.targetUserId)
        this.$cable.subscribe({
          channel: 'ChatChannel',
          host_id: this.currentUserId,
          target_user_id: data.targetUserId
        })
      },
      messageSent(data) {    
        // create a message on the server, using senderId and chatroomId
        this.$cable.perform({
          channel: 'ChatChannel',
          action: 'create_message',
          data: data
        })
      },
      appendMessage(data) {
        console.log("gonna append that message")

      }
    }
  }
</script>

<style scoped>

</style>

