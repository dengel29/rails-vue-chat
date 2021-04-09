import consumer from "./consumer";

if (
  Array.from(document.querySelectorAll("meta")).some(
    (el) => el.name == "current-user"
  )
) {
  consumer.subscriptions.create("ChatChannel", {
    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
    },
  });
}
