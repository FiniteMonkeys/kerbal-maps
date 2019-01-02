import React from "react"
import MapBody from "./MapBody.js"
import MapStyle from "./MapStyle.js"

class MapBodyAndStyle extends React.Component {
  render() {
    return (
      <form action="#">
        <MapBody />
        <MapStyle />
      </form>
    )
  }
}

export default MapBodyAndStyle
