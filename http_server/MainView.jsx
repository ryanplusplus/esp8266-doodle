const React = require('react');
const ReactDom = require('react-dom');
const Button = require('react-bootstrap/lib/Button');

// const socket = io();

class ComponentOrganizationView extends React.Component {
  constructor(props) {
    super(props);

    this.buttonClicked = this.buttonClicked.bind(this);
  }

  componentDidMount() {
    console.log("Mounted");
  }

  render() {
    return (
      <div>
        <ReactDom>
          <Button bsStyle="primary" onClick={this.buttonClicked} disabled={this.buttonClicked()}>Create</Button>
        </ReactDom>
      </div>
    )
  }
}

module.exports = ComponentOrganizationView;
