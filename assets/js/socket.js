import {Socket} from "phoenix"

let socket = null;
if (window.userToken) {
  socket = new Socket("/socket", {params: {token: window.userToken}})
} else {
  socket = new Socket("/socket", {})
}
socket.connect()

export { socket }
