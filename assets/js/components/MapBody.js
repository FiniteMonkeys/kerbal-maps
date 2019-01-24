import React from "react"

class MapBody extends React.Component {
  constructor (props) {
    super(props)
    this.changeValue = this.changeValue.bind(this)
  }

  changeValue (event) {
    this.props.onValueChange(event.target.value)
  }

  render () {
    const selectedValue = this.props.selectedValue
    return (
      <div className="form-group">
        <label htmlFor="select-map-body">Body</label>
        <select id="select-map-body"
                name="select-map-body"
                value={selectedValue}
                className="form-control"
                onChange={this.changeValue}>
          <option value="moho">Moho</option>
          <option value="eve">Eve</option>
          <option value="gilly">Gilly</option>
          <option value="kerbin">Kerbin</option>
          <option value="mun">Mun</option>
          <option value="minmus">Minmus</option>
          <option value="duna">Duna</option>
          <option value="ike">Ike</option>
          <option value="dres">Dres</option>
          <option value="jool" disabled={true}>Jool</option>
          <option value="laythe">Laythe</option>
          <option value="vall">Vall</option>
          <option value="tylo">Tylo</option>
          <option value="bop">Bop</option>
          <option value="pol">Pol</option>
          <option value="eeloo">Eeloo</option>
        </select>
      </div>
    )
  }
}

export default MapBody
