<template>
  <div class="user-list__container">
    <div class="user-list__inner">
      <h1>{{currentUser.username}} in the chats</h1>
      <ul>
        <li v-for="user in users" :key="user.id" :data-user-id="user.id" @click="handleClick($event)">
          {{user.username}}
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      currentUserId: null,
    }
  },
  props: ["users", "currentUser"],
  methods: {
    handleClick: function(e) {
      if (!Array.from(e.target.classList).includes('disabled')) {
        let targetUserId = Number(e.target.dataset.userId)
        this.$emit("buttonClicked", {
          targetUserId: targetUserId
        })
      } else {
        console.log('cant print doing work')
      }

    }

  },
  mounted() {
    this.currentUserId = this.currentUser.id
  }
}
</script>

<style scoped>
  .user-list__container {
    border-right: 5px solid darkslateblue
  }
  .user-list__inner {
   overflow-y: scroll;
    height: 100vh;
  }
  h1 {
      margin-top: 0;
    font-size: 1.6em;
    position: sticky;
    top: 0;
    background: darkslateblue;
    z-index: 2;
    color: white;
    text-align: right;
    padding-right: 10px;
  }

  ul {
    list-style: none;
    text-align:center;
    margin-block-start: 0;
    margin-block-end: 0;
    padding-inline-start:0;
    width:100%;

  }
  li {
    cursor:pointer;
    width:90%;
    margin: 0.4em 0.4em;
    border-radius:4px;
    border: 2px solid darkslategray;
    padding: 2px 2px;
    position:relative
  }

  li:hover {
    color: rgb(218, 199, 199);
    background-color: rgba(18, 31, 31, 0.454)
  }

  li:active {
    color: white;
    background-color: darkslategray;
    border:2px solid white;
  }

  .disabled {
    cursor:not-allowed
  }
</style>
