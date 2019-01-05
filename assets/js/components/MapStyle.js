import React from "react"

class MapStyle extends React.Component {
  constructor () {
    super()

    this.state = {
      selectedStyle: "sat"
    }

    this.changeSelectedStyle = this.changeSelectedStyle.bind(this)
  }

  changeSelectedStyle (event) {
    var target = event.target
    this.setState(previousState => ({
      selectedStyle: target.value
    }))
  }

  render() {
    return (
      <fieldset>
        <label htmlFor="select-map-style">Style:</label>
        <select id="select-map-style"
                name="select-map-style"
                value={this.state.selectedStyle}
                onChange={this.changeSelectedStyle}>
          <option value="biome">Biome</option>
          <option value="sat">Satellite</option>
          <option value="slope">Slope</option>
        </select>
      </fieldset>
    )
  }
}

export default MapStyle
