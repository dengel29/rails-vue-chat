<template>
  <div class="user-list__container">
    <div class="user-list__inner">
      <!-- <transition name="fade">
        <div class="loading-overlay" v-show="isLoading"> 
          <div></div>
        </div>
      </transition> -->
      <transition name="fade">
      <h1 v-if="!isLoading">{{currentUser.username}} in the chats</h1>
      <h1 class="loading-title" v-if="isLoading">Finding chat...</h1>
      </transition>
      <ul :class="[isLoading ? disabledClass : '']">
        <li 
          v-for="user in users" 
          :key="user.id" 
          :data-user-id="user.id"
          :class="[isLoading ? disabledClass : '']" 
          @click="handleClick($event)">
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
      disabledClass: 'disabled',
    }
  },
  props: ["users", "currentUser", "isLoading"],
  methods: {
    handleClick: function(e) {
      let targetUserId = Number(e.target.dataset.userId)
      this.$emit("buttonClicked", {
        targetUserId: targetUserId
      })
    }
  },
  created() {
    this.isLoading = this.isLoading
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
    position:relative;
  }
  /* .loading-overlay {
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 1);
    opacity: 0.5;
    position:absolute;
    z-index: 2; 
  } */
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
    background-color: rgb(18, 31, 31)
  }

  li:active {
    color: white;
    background-color: darkslategray;
    border:2px solid white;
  }

  ul.disabled {
    cursor: wait;
  }

  li.disabled {
    /* background: darkslategray; */
    color:grey;
    pointer-events: none;
  }

  .fade-enter-active,
  .fade-leave-active {
    transition: opacity 3s ease-in-out;
  }

  .fade-enter-from,
  .fade-leave-to {
    opacity: 0;
  }
</style>
