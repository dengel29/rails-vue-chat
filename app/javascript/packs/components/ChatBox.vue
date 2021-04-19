<template>
    <div 
      :data-chat-id="selectedChat.chatroom.id"
      ref="chatcontainer"
      class="chat-box__container">
      <div class="messages__container">
        <h1>Me ({{currentUser.username}}) & {{selectedChat.users[0].username}}</h1>
        <div class="messages__inner-wrapper" id="append" :data-me="currentUser.username" :data-them="selectedChat.users[0].username">
          <div class="messages__inner">  
            <div 
              v-for="message in selectedChat.messages" 
              :key="message.id" :data-message-id="message.id" 
              :data-user-id="message.chat_participant_id"
              v-bind:class="[message.chat_participant_id === Number(currentUser.id) ? myMessage : '']"
              class="message">
              {{message.content}}
            </div>
          </div>
        </div>
      </div>
      <div class="input__container">
        <form action="" class="input__inner" v-on:submit.prevent="onSubmit">
          <textarea type="text" name="message-input" id="message-input" ref="chatinput"></textarea>
          <input type="submit" value="submit">
        </form>
      </div>
    </div>
</template>

<script>
export default {
  data: function () {
    return {
      myMessage: 'mine'
    }
  },
  props: ["selectedChat", "currentUser"],
  methods: {
    onSubmit: function (e) {
      console.log(this.$refs.chatinput.value)
      let messageData = {
        message: this.$refs.chatinput.value,
        sender_id: Number(this.currentUser.id),
        chatroom_id: Number(this.$refs.chatcontainer.dataset.chatId)
      }
      this.$emit("buttonClicked", messageData)
    },
  },
  mounted() {
  }
}
</script>

<style scoped lang="scss">
  h1 {
    margin-top: 0;
    margin-right:auto;
  }

  .chat-box__container {
    display:flex;
    flex-direction: column;
  }

  .messages__container {
    height: 80%;
    display: flex;
    flex-direction: column;
  }

  .messages__inner {
    width:50%;
    max-height: 70%;
    border: 1px solid black;
    padding: 20px;
    overflow-y: scroll;

    .message {
      text-align:left;
      margin-bottom: .2em;
      margin-top: .2em;
    }

    .mine {
      text-align:right;
    }
  }

  .messages__inner-wrapper {
    width:50%;
    margin-top: auto;
    display:flex;
    justify-content: space-between;
  }
  .messages__inner-wrapper::before {
    align-self:flex-end;
    content: attr(data-them);
  }

  .messages__inner-wrapper::after {
    align-self:flex-end;
    content: attr(data-me)
  }

  .input__container {
    height: 20%;
    width:63%;
    display:flex;
    align-content: center;
  }

  .input__inner {
    display:flex;
    width:100%;
    align-items:center;
    justify-content: space-between;
    
    textarea {
      padding-top: 1em;
      padding-bottom: 1em;
      width:85%;
      height:50%;
      border: 0px 1px 0px 0px solid red
    }
    input[type="submit"] {
      background-color: darkslateblue;
      color: white;
      border-radius: 3px;
      width: 4.6em;
      height: 3em;
    }
  }
</style>
