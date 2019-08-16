import React from "react"

class MapPack extends React.Component {
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
        <label htmlFor="select-map-pack">Planet Pack</label>
        <select id="select-map-pack"
                name="select-map-pack"
                value={selectedValue}
                className="form-control"
                onChange={this.changeValue}>
          <option value="(stock)">(stock)</option>
        </select>
      </div>
    )
  }
}

export default MapPack
