// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
import { socket } from "./socket.js"
window.socket = socket

// Credits
import { renderCredits } from "./credits.js"
renderCredits()

import React from "react"
import ReactDOM from "react-dom"

window.changeSelectedBody = (value) => {
  // alert(`changing selected body to "${value}"`)
}

window.changeSelectedStyle = (value) => {
  // alert(`changing selected style to "${value}"`)
}

import MapBodyAndStyle from "./components/MapBodyAndStyle.js"
ReactDOM.render(<MapBodyAndStyle onBodyChange={window.changeSelectedBody} onStyleChange={window.changeSelectedStyle} />, document.getElementById("map-body-and-style"))

// enable tooltips
$(function () {
  $('[data-toggle="tooltip"]').tooltip()
})
