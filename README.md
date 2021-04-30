# Rails Vue Actioncable

web-based chat app built on Rails, ActionCable and Vue.

## Features

- email sign/in
- Persistent message storage;
- Message notification

## How it works

A few words on decisions I made and why I made them.

### Rails + Vue integration

There are (too) many ways to implement Vue in Rails apps. Rails provides many useful features, so I didn't want to purely use it as an API. After some research, I chose the method of allowing drop-in components, wherever needed. If you look in main.js, the Vue project attaches to the element with `[data-behavior="vue"]`, which you can find in the `application.html.erb`, which wraps the entire app.

The effect is that I can put components into layouts or partials, and feed them page-specific data pulled from the database. You can see that in action on the main page, in `views/chats/index.html.erb`

### ActionCableVue

An npm package that provides the connected/rejected/received/subscribe/unsubscribe methods and hooks to integrate with ActionCable using a similar API. This was faster than figuring out the best way to pull ActionCable's "consumer" API into the Vue project myself, and has proven reliable.

### Authentication

Devise. Don't fix what isn't broken

## Run it locally

Rails 6.1.3.1

Ruby 2.7.0

Bundler 2.1.2

Yarn 1.22.10

Simply pull down the code, `bundle install` and `yarn install` . No secret_key or master.key needed as far as I know, but please message if needed.

## New feature (4/30)

- Users that are newly registered and created will appear in the userlist for other users
- Simple loading state to improve UX of loading chatrooms

## Fixes

The last version contained one major bug due to last minute insufficiently tested changes.

- Double subscription - A single chat would be doubly-subscribed to 1 chat if the server does not respond before a second request is made. This would cause multiple chats to be stored in client-side state, which cascaded into other client-side problems. This was fixed _not_ by debouncing the click handler, but instead do the following:
  1. Ensure the `get_chatroom` ChatChannel action is performed only after the client is successfully subscribed. This was accomplished by moving the `get_chatroom` call from the client side into the `after_subscribe` callback provided by ActionCable.
  2. Properly handle the loading state, which informs the user of the pending process + disables the other user-chat buttons until a response is received.

## Known bugs

- Occasionally when a chat is begun, one user closes the browser window, and returns to chat with the same user, they do not rejoin the same socket connection that was originally created. More testing needs to be done to determine the cause so an appropriate solution can be decided.

## Improvements I would still like to make

- Naming - I would go back and change the ChatRoom migration to a single word on the server side for naming consistency.
- Sounds - sounds for messages while a user is away
- More testing coverage - besides testing the client-server ability to connect over websockets, I didn't test individual channels. Given more time, I would spend more time on testing coverage.
