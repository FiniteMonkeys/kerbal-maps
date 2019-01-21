import React from "react"
import MapBody from "./MapBody.js"
import MapStyle from "./MapStyle.js"

class MapBodyAndStyle extends React.Component {
  constructor (props) {
    super(props)

    this.state = {
      selectedBody: "kerbin",
      selectedStyle: "sat"
    }

    this.changeSelectedBody = this.changeSelectedBody.bind(this)
    this.changeSelectedStyle = this.changeSelectedStyle.bind(this)
  }

  changeSelectedBody (value) {
    this.setState(previousState => ({
      selectedBody: value
    }))
    if (this.props.onBodyChange !== undefined) {
      this.props.onBodyChange(value)
    }
  }

  changeSelectedStyle (value) {
    this.setState(previousState => ({
      selectedStyle: value
    }))
    if (this.props.onStyleChange !== undefined) {
      this.props.onStyleChange(value)
    }
  }

  render() {
    return (
      <form action="#">
        <MapBody selectedValue={this.state.selectedBody} onValueChange={this.changeSelectedBody} />
        <MapStyle selectedValue={this.state.selectedStyle} onValueChange={this.changeSelectedStyle} />
      </form>
    )
  }
}

export default MapBodyAndStyle
