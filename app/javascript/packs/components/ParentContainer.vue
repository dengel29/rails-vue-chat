<template>
  <div style="display:grid; grid-template-columns: 20vw 1fr; grid-gap: 20px;">
    <user-list :users="users" @buttonClicked="chatSelected" :current-user="currentUser"></user-list>   
      <chat-box 
        v-if="chats.length > 0 && selectedChat.id != 0"
        :selectedChat="selectedChat" 
        @buttonClicked="messageSent" 
        :current-user="currentUser"
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
        }
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
            console.log(data)
            if (data.chat_room_id != this.selectedChat.chatroom.id) {
              // add a border around the chat where data.chat_participant_id === this.users(user => user.id === data.chat_participant_id)
              this.addBorder(data.chat_participant_id)
              this.chats.find(chat => chat.chatroom.id === data.chat_room_id).messages.push(data)
            } else {
              this.selectedChat.messages.push(data)
            }
          } 
          // we might be doing the same thing with the notifications channel
          // else if (data.type === 'chatroom_receipt') {
          //   console.log(data, "got the chatroom")
          //   this.chats = this.chats.push(data)

          //   this.selectedChat = data
          // }
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
              console.log(data, "from the host to the invited")
              this.addBorder(data.host.id)
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
          let userElement = Array.from(document.querySelectorAll('[data-user-id')).find(el => el.dataset.userId === String(data.user.id))
          if (userElement && data.online) {
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
          } else if (userElement && !data.online) {
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
    props: ["users", "currentUser"],
    mounted: function() {
      this.$cable.subscribe({
        channel: 'UserListChannel'
      });
      this.$cable.subscribe({
        channel: 'NotificationsChannel'
      })
      this.currentUserId = this.currentUser.id
    },
    methods: {
      chatSelected(data) {
        // begins a subscription to a chatroom when one is clicked
        if (this.selectedChat.users) {
          this.toggleBackground(this.selectedChat.users[0].id, "off")
        }
        this.toggleBackground(data.targetUserId, "on")
        if (this.chats.length > 0 && this.chats.some(chat => chat.users[0].id === data.targetUserId)) {
          this.selectedChat = this.chats.find(chat => chat.users[0].id === data.targetUserId)
        } else {

          this.$cable.subscribe({
            channel: 'ChatChannel',
            host_id: this.currentUserId,
            target_user_id: data.targetUserId
          })
        }
      },
      messageSent(data) {    
        // creates a message on the server, using senderId and chatroomId
        this.$cable.perform({
          channel: 'ChatChannel',
          action: 'create_message',
          data: data
        })
      },
      addBorder(id) {
        let userElement = this.findUserElement(id)
        userElement.style.border = '2px solid orange'
      },
      toggleBackground(id, toggle) {
        let userElement = this.findUserElement(id)
        if (toggle === "on") {
          userElement.style.background = "darkslateblue";
          userElement.style.color = "white"
        } else {
          userElement.style.background = "white";
          userElement.style.color = "black"
        }
      },
      findUserElement(id) {
        return Array.from(document.querySelectorAll('[data-user-id')).find(el => el.dataset.userId === String(id))
      }
     },
  }
</script>

<style scoped>

</style>

