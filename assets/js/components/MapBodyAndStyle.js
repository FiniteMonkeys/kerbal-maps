import React from "react"
import MapBody from "./MapBody.js"
import MapPack from "./MapPack.js"
import MapStyle from "./MapStyle.js"

class MapBodyAndStyle extends React.Component {
  constructor (props) {
    super(props)

    this.state = {
      selectedPack: "(stock)",
      selectedBody: "kerbin",
      selectedStyle: "sat"
    }

    this.changeSelectedPack = this.changeSelectedPack.bind(this)
    this.changeSelectedBody = this.changeSelectedBody.bind(this)
    this.changeSelectedStyle = this.changeSelectedStyle.bind(this)
  }

  changeSelectedPack (value) {
    this.setState(previousState => ({
      selectedPack: value
    }))
    if (this.props.onPackChange !== undefined) {
      this.props.onPackChange(value)
    }
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
        <MapPack selectedValue={this.state.selectedPack} onValueChange={this.changeSelectedPack} />
        <MapBody selectedValue={this.state.selectedBody} onValueChange={this.changeSelectedBody} />
        <MapStyle selectedValue={this.state.selectedStyle} onValueChange={this.changeSelectedStyle} />
      </form>
    )
  }
}

export default MapBodyAndStyle
