<template>
  <div>
    <h1>we're in the chats</h1>
    <ul>
      <li v-for="user in users" :key="user.id">
        {{user.email}}
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
    }
  },
  props: ["users"],
  methods: {
    createUser: function () {
    },
  }
}
</script>

<style scoped>

</style>
