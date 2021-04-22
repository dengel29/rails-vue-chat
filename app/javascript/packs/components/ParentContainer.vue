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
        },
        lastSelectedChatId: null
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
        },
        rejected() {},
        received(data) {
          // chat channel just does message receipt, at this point. 
          // chatroom receipt is handled by the notifications channel
          
          if (data.type === 'message_receipt') {
            if (data.chat_room_id != this.selectedChat.chatroom.id) {
              // add a border around the chat to indicate a message has been received
              this.addBorder(data.chat_participant_id)
              
              // pushing messages into non-focused chat
              if (this.chats.length > 0 ) {
                this.chats.find(chat => chat.chatroom.id === data.chat_room_id).chatroom.messages.push(data)
              }
            } else {
              this.chats.find(chat => chat.chatroom.id === this.selectedChat.chatroom.id).chatroom.messages.push(data)
            }
          } 
          // chatroom_receipt is sent when a user clicks, sends down the chatroom with all messages
          else if (data.type === 'chatroom_receipt') {
            // guards against duplicating chats when chatreceipt sent out to chatroom more than once
            if (data.users.some(user => user.id === this.lastSelectedChatId) && !this.chats.some(chat => chat.chatroom.id === data.chatroom.id)) {
              this.chats.push(data)
              this.selectedChat = data
            } 
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

          // chatroom_info is sent down when another user selects your chat, to notify you they want to talk
          // DOES NOT send down messages, messages only sent down when a chat is clicked
          if (data.type === 'chatroom_info') {
            if (data.users.some(user => user.id === this.lastSelectedChatId)) {
              this.selectedChat = this.chats.find(chat => chat.chatroom.id === data.id )
            } else {
              let targetUserId = data.users.find(user => user.id != this.currentUserId).id
              this.addBorder(targetUserId)
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
          let userElement = Array.from(document.querySelectorAll('ul [data-user-id')).find(el => el.dataset.userId === String(data.user.id))
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
          this.toggleBackground(this.selectedChat.users.find(user => user.id != this.currentUser.id).id, "off")
        }
        this.toggleBackground(data.targetUserId, "on")
    
        this.lastSelectedChatId = data.targetUserId

        this.subscribeAndPullDownChat(data.targetUserId)
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
          userElement.style.color = "white";
          userElement.style.border = "2px solid darkslategray";
        } else {
          userElement.style.background = "white";
          userElement.style.color = "black"
        }
      },
      findUserElement(id) {
        return Array.from(document.querySelectorAll('[data-user-id')).find(el => el.dataset.userId === String(id))
      },
      subscribeAndPullDownChat(id) {
        // this method finds the chat if it's in your chat, or gets the chat + messages if it isnt yet
        if (this.chats.some(chat => chat.users.some(user => user.id === id))) {
          // just change selected chat to that chat 
          this.selectedChat = this.chats.find(chat => chat.users.some(user => user.id === id))
        } else {
           this.$cable.subscribe({
            channel: 'ChatChannel',
            host_id: this.currentUserId,
            target_user_id: id
        })
            this.$cable.perform({
            channel: 'ChatChannel',
            action: 'get_chatroom'
          })
        }
      }
     },
  }
</script>

<style scoped>

</style>

