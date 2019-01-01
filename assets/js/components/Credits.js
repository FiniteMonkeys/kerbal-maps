import React from "react"

class Credits extends React.Component {
  render() {
    return (
      <div className="credits">
        <h2>Kerbal Maps</h2>
        <p>was made possible by</p>
        <ul>
          <li>
            <a href="https://www.kerbalspaceprogram.com/">Kerbal Space Program</a>&nbsp;
            for map data, as well as being the reason for doing this in the first place
          </li>
          <li>
            <a href="https://github.com/Sigma88/Sigma-Cartographer">Sigma-Cartographer</a>&nbsp;
            for a means of extracting the map data
          </li>
          <li>
            <a href="https://leafletjs.com">Leaflet.js</a>&nbsp;
            for a way to display the map data
          </li>
          <li>
            <a href="https://fontawesome.com">Font Awesome</a>&nbsp;
            for graphics
          </li>
          <li>
            <a href="http://ksp.deringenieur.net">ksp.deringenieur.net</a>&nbsp;
            (and <a href="">kerbalmaps.com</a> before it) for the original idea
          </li>
        </ul>
        <p>kerbal maps is a <a href="http://finitemonkeys.org/">finitemonkeys</a> joint</p>
      </div>
    )
  }
}

export default Credits
