<template>
    <div 
      :data-chat-id="selectedChat.chatroom.id"
      ref="chatcontainer"
      class="chat-box__container">
      <div class="messages__container">
        <div class="messages__inner-wrapper" :data-me="currentUser.username" :data-them="selectedChat.users[0].username">
          <div class="messages__inner" ref="messagesinner"><div
              v-for="message in selectedChat.chatroom.messages" 
              :key="message.id" :data-message-id="message.id" 
              :data-user-id="message.chat_participant_id"
              v-bind:class="[message.chat_participant_id === Number(currentUser.id) ? myMessage : '']"
              class="message">
              <div class="message-content__wrapper">{{message.content}}</div></div></div>
        </div>
      </div>
      <div class="input__container">
        <form action="" class="input__inner" v-on:submit.prevent="onSubmit">
          <textarea type="text" name="message-input" id="message-input" ref="chatinput" @keyup.enter="onSubmit"></textarea>
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
      let messageData = {
        message: this.$refs.chatinput.value,
        sender_id: Number(this.currentUser.id),
        chatroom_id: Number(this.$refs.chatcontainer.dataset.chatId)
      }
      this.$refs.chatinput.value = ''
      this.$refs.chatinput.focus
      this.$emit("buttonClicked", messageData)
    },
    scrollToElement() {
     this.$nextTick(function () {
      if (this.$refs.messagesinner.hasChildNodes()) {
        this.$refs.messagesinner.lastElementChild.scrollIntoView()
      }
    })
    }
  },
  mounted() {
    this.scrollToElement();
  },
  updated() {
    this.scrollToElement();
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
    max-height:100vh
  }

  .messages__container {
    height: 70%;
    display: flex;
    flex-direction: column;
  }

  .messages__inner {
    max-width:30em;
    width:50%;
    max-height: 80%;
    border: 1px solid black;
    padding: 14px;
    overflow-y: scroll;
    .message {
      text-align:left;
      padding-bottom: .2em;
      margin-bottom:.1em;
      padding-top: .2em;
      padding-left: .4em;
      border-left: 2px solid darkorange;
    }

    .message text {
      max-width: 50%;
    }

    .mine {
      text-align:right;
      padding-right: .4em;
      padding-left: initial;
      border-left: initial;
      margin-left:10%;
      border-right: 2px solid darkslateblue;

      .message-content__wrapper {
        margin-left: 10%;
      }
    }
  }

  #message-input {
    border: 3px solid grey
  }

  .messages__inner-wrapper {
    width: 100vw;
    margin-top: auto;
    display: flex;
    height: 75%;
  }
  .messages__inner-wrapper::before {
    align-self:center;
    content: attr(data-them);
    width:3em;
    border: 2px solid darkorange;
    padding: 7px;
    border-radius: 4px;
    margin-right:.2em
  }

  .messages__inner-wrapper::after {
    align-self:center;
    content: attr(data-me);
    width:3em;
    border: 2px solid darkslateblue;
    padding: 7px;
    border-radius: 4px;
    margin-left: .2em
  }

  .messages__inner:empty:after {
    display:flex;
    place-content: center;
    margin-top:30%;
    font-style:italic;
    content: "no chat history \A \A \A let's get chatting";
    white-space: pre-wrap;
  }


  .input__container {
    height:20%;
    width:75vw;
  }

  .input__inner {
    display:flex;
    flex-direction:column;
    width:100%;
    align-items:center;
    justify-content: space-between;
    
    textarea {
      padding-top: 1em;
      padding-bottom: 1em;
      width:85%;
      height:50%;
      border: 2px solid grey !important
    }

    textarea:focus {
      border: 2px solid darkslateblue !important
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
