<template>
  <div>
    <div>
      <h1>this is the chatbox between user1 + user2</h1>
    </div>
    <div>
      this is the text input box
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
  props: [],
  methods: {
    sendMessage: function (e) {
    },
  },
  mounted() {
  }
}
</script>

<style scoped>
  h1 {margin-top: 0}
</style>
