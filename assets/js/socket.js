import {Socket} from "phoenix"

let socket = null;
if (window.userToken) {
  socket = new Socket("/socket", {params: {token: window.userToken}})
  socket.connect()
}

export { socket }
