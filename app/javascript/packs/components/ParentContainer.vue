<template>
  <div style="display:grid; grid-template-columns: 20vw 1fr; grid-gap: 20px;">
    <user-list :users="users" @buttonClicked="chatSelected"></user-list>
      
      <chat-box 
        v-if="chats.length > 0"
        :selectedChat="selectedChat" 
        @buttonClicked="messageSent" 
        :currentUser="currentUser"
        >
      </chat-box>
    
    
  </div>
</template>

<script>
  export default {
    data: function(){
      return {
        chats: [],
        selectedChat: {
          id: 0,
          chatroom: {
            id: 0
          }
        },
        currentUser: null
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
          // every time we're connected to a new chat channel (when clicking a chat), the user who
          // clicked is sent the chat room info with type "chatroom_recipt"
          this.$cable.perform({
            channel: 'ChatChannel',
            action: 'get_chat_room'
          })
        },
        rejected() {},
        received(data) {
          // data received could be either a message or a chatroom
          if (data.type === 'message_receipt') {
            // data.chat_participant_id === this.currentUserId
            this.selectedChat.messages.push(data)
            
          } else if (data.type === 'chatroom_receipt') {
            console.log(data, "got the chatroom")
            this.chats = this.chats.push(data)

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
          // notifications can be sent to those initiating chat and those on receiving end of chat
          // notifications have a type, and this will control flow to different actions

          // chatroom_info is sent down when a chat is selected, contains chatroom info
          if (data.type === 'chatroom_info') {
            
            // TODO
            // put leaf next to name of user who has initiated chat
            
            // if the recipient of this notification is the chat initiator (or host), set their selectedChat 
            // to the one in the data
              
            if (this.currentUserId === data.host.id) {
              this.chats.push(data)
              this.selectedChat = data
            } else {
              this.chats.push(data)
            }
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
      this.currentUserId = Number(currentUserId)
      this.currentUser = this.users.find(user => user.id === Number(currentUserId))
    },
    methods: {
      chatSelected(data) {
        // begins a subscription to a chatroom when one is clicked
        this.$cable.subscribe({
          channel: 'ChatChannel',
          host_id: this.currentUserId,
          target_user_id: data.targetUserId
        })
      },
      messageSent(data) {    
        // creates a message on the server, using senderId and chatroomId
        this.$cable.perform({
          channel: 'ChatChannel',
          action: 'create_message',
          data: data
        })
      },
      // appendMessage(data) {
      //   console.log("gonna append that message")
      // }
    }
  }
</script>

<style scoped>

</style>

