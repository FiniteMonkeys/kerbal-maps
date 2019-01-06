import React from "react"

class MapBody extends React.Component {
  constructor (props) {
    super(props)

    this.state = {
      selectedBody: "kerbin"
    }

    this.changeSelectedBody = this.changeSelectedBody.bind(this)
  }

  changeSelectedBody (event) {
    var target = event.target
    this.setState(previousState => ({
      selectedBody: target.value
    }))
  }

  render () {
    return (
      <fieldset>
        <label htmlFor="select-map-body">Body:</label>
        <select id="select-map-body"
                name="select-map-body"
                value={this.state.selectedBody}
                onChange={this.changeSelectedBody}>
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
      </fieldset>
    )
  }
}

export default MapBody
