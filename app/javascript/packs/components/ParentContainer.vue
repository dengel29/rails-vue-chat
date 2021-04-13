<template>
  <div style="display:grid; grid-template-columns: 20vw 1fr; grid-gap: 20px;">
    <user-list :users="users"></user-list>
    <chat-box></chat-box>
  </div>
</template>

<script>
  export default {
    data: function(){
      return {
        
      }
    },
    props: ["users"],
  }
</script>

<style scoped>

</style>

