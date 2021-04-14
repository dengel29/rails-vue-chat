<template>
  <div class="chat-box__container">
    <div class="messages__container">
      <h1>{{selectedChat.username}}</h1>
    </div>
    <div class="input__container">
      <input type="text" name="message-input" id="">
      <button>Send</button>
    </div>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
    }
  },
  channels: {
    // UserListChannel: {
    //   connected() {
    //     console.log("connected to meat channel")
    //   },
    //   rejected() {},
    //   received(data) {},
    //   disconnected() {}
    // }
  },
  props: ["selectedChat"],
  methods: {
    sendMessage: function (e) {
    },
  },
  mounted() {
    console.log(this.selectedChat, "coming from the chatbox")
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
    align-items:center;
    justify-content: space-between;
    padding-left: .4em;
    padding-right: 1em;
    input[type="text"] {
      padding-top: 1em;
      padding-bottom: 1em;
      width:85%
    }
  }


  
</style>
