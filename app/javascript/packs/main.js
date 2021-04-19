/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'hello_vue' %> if you have styles in your component)
// to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

// import Vue from 'vue'
// import App from '../app.vue'

// document.addEventListener('DOMContentLoaded', () => {
//   const app = new Vue({
//     render: h => h(App)
//   }).$mount()
//   document.body.appendChild(app.$el)

//   console.log(app)
// })

// The above code uses Vue without the compiler, which means you cannot
// use Vue to target elements in your existing html templates. You would
// need to always use single file components.
// To be able to target elements in your existing html/erb templates,
// comment out the above code and uncomment the below
// Add <%= javascript_pack_tag 'hello_vue' %> to your layout
// Then add this markup to your html template:
//
// <div id='hello'>
//   {{message}}
//   <app></app>
// </div>

// import Vue from 'vue/dist/vue.esm'
// import App from '../app.vue'
//
// document.addEventListener('DOMContentLoaded', () => {
//   const app = new Vue({
//     el: '#hello',
//     data: {
//       message: "Can you say hello?"
//     },
//     components: { App }
//   })
// })
//
//
//
// If the project is using turbolinks, install 'vue-turbolinks':
//
// yarn add vue-turbolinks
//
// Then uncomment the code block below:
//
import TurbolinksAdapter from "vue-turbolinks";
import ActionCableVue from "actioncable-vue";
import Vue from "vue/dist/vue.esm";
import UserList from "./components/UserList";
import ChatBox from "./components/ChatBox";
import ParentContainer from "./components/ParentContainer.vue";
import axios from "axios";
import VueAxios from "vue-axios";
import App from "../app.vue";

const actionCableVueOptions = {
  debug: true,
  debugLevel: "error",
  connectionUrl: "ws://localhost:3000/cable",
  connectImmediately: true,
};

Vue.use(TurbolinksAdapter);
Vue.use(ActionCableVue, actionCableVueOptions);
Vue.use(VueAxios, axios);

Vue.component("parent-container", ParentContainer);
Vue.component("user-list", UserList);
Vue.component("chat-box", ChatBox);

document.addEventListener("turbolinks:load", () => {
  const app = new Vue({
    el: '[data-behavior="vue"]',
  });
});
