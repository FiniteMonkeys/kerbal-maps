import React from "react"
import ReactDOM from "react-dom"
import Credits from "./components/Credits.js"

export function renderCredits() {
  ReactDOM.render(<Credits />, document.getElementById("credits"))
}
