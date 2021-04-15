<template>
  <div class="chat-box__container" ref="chatcontainer" :data-chat-id="selectedChat.chat_room.id">
    <div class="messages__container">
      <h1>Me ({{currentUser.username}}) & {{selectedChat.users[0].username}}</h1>
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
    border: 1px solid darkslateblue
  }

  .input__container {
    height: 20%;
    border: 1px solid darkslategray;
    display:flex;
    align-content: center;
  }

  .input__inner {
    display:flex;
    width:100%;
    align-items:center;
    justify-content: space-between;
    padding-left: .4em;
    padding-right: 1em;
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
