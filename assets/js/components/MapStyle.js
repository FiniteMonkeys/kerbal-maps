import React from "react"

class MapStyle extends React.Component {
  constructor (props) {
    super(props)
    this.changeValue = this.changeValue.bind(this)
  }

  changeValue (event) {
    this.props.onValueChange(event.target.value)
  }

  render() {
    const selectedValue = this.props.selectedValue
    return (
      <div className="form-group">
        <label htmlFor="select-map-style">Style</label>
        <select id="select-map-style"
                name="select-map-style"
                value={selectedValue}
                className="form-control"
                onChange={this.changeValue}>
          <option value="biome">Biome</option>
          <option value="sat">Satellite</option>
          <option value="slope">Slope</option>
        </select>
      </div>
    )
  }
}

export default MapStyle
