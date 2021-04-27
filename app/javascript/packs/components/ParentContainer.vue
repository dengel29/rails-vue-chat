<template>
  <div style="display:grid; grid-template-columns: 20vw 1fr; grid-gap: 20px;">
    <user-list 
      :users="users" 
      :key="userListComponentKey"
      @buttonClicked="chatSelected" 
      :current-user="currentUser"></user-list>   
      <chat-box 
        v-if="chats.length > 0 && selectedChat.id != 0"
        :selectedChat="selectedChat" 
        :current-user="currentUser"
        @buttonClicked="messageSent" 
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
        userListComponentKey: 0,
        lastSelectedChatId: null,
        loadingUserId: null
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
            console.log('received a whole ass chat')
            console.log(data)
            // guards against duplicating chats when chatreceipt sent out to chatroom more than once
            if (!this.chats.some(chat => chat.chatroom.id == data.chatroom.id)) {
              this.chats.push(data)
            } 
            if (data.users.some(user => user.id === this.lastSelectedChatId)) {
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
          if (data.type === 'chatroom_info') {x
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
          // add a user to the list if they have been added after a user is already signed in
          if (!this.users.some(user => user.id == data.user.id) && data.online) {
            this.users.push(data.user)
            this.userListComponentKey += 1
          }
          // no action for when a user "signs out", although we could do that for checking data.offline
        },
        disconnected() {}
      }
    },
    props: ["users", "currentUser"],
    created: function() {
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
        // let userElement = this.findUserElement(data.targetUserId)
        if (this.selectedChat.users && this.lastSelectedChatId) {
          this.toggleBackground(this.lastSelectedChatId, "off")
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
        let chatFound = this.chats.find(chat => chat.users.some(user => user.id === id))
        if (chatFound) {
          // just change selected chat to that chat 
          this.selectedChat = chatFound
        } else {
          this.$cable.subscribe({
            channel: 'ChatChannel',
            host_id: this.currentUserId,
            target_user_id: id
          })
        }
      }
     },
  }
</script>

<style scoped>

</style>

