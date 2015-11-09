import React, { Component } from 'react';

class Slider extends Component {
  render() {
    return (
      <input type="range" value={this.props.value}
             min={this.props.min} max={this.props.max} style={{width: "100%"}}
             onChange={this.props.onChange} />
    );
  }
}

function calcBMI(height, weight, bmi) {
  const h = height / 100;  // Height in meters instead of centimeters;
  if (!bmi) {
    bmi = weight / (h * h);  // Set the BMI from the weight.
  } else {
    weight = bmi * h * h;  // Set the weight from the BMI.
  }
  const result = [height, weight, bmi];
  return result.map(x => parseInt(x, 10));
}

function getDiagnostic(bmi) {
  if (bmi < 18.5) {
    return ["orange", "underweight"];
  } else if (bmi < 25) {
    return ["inherit", "normal"];
  } else if (bmi < 30) {
    return ["orange", "overweight"];
  } else {
    return ["red", "obese"];
  }
}

export class BMIComponent extends Component {
  constructor(props) {
    super(props);
    this.state = { height: "180", weight: "80", bmi: "" };
  }

  onSliderChange(fieldId, e) {
    var data = Object.assign({}, this.state);  // Copy the state.
    data[fieldId] = e.target.value;
    if (fieldId != 'bmi') {
      data.bmi = "";
    }
    this.setState(data);
  }


  render() {
    const [height, weight, bmi] = calcBMI(this.state.height, this.state.weight,
                                        this.state.bmi);
    const [color, diagnostic] = getDiagnostic(bmi);
    return (
      <div>
        <div>
          Height: {height}cm
          <Slider id="height" value={height}
                  onChange={this.onSliderChange.bind(this, "height")}
                  min={100} max={220} />
        </div>
        <div>
          Weight: {weight}kg
          <Slider id="weight" value={weight}
                  onChange={this.onSliderChange.bind(this, "weight")}
                  min={30} max={150} />
        </div>
        <div>
          BMI: {bmi}
          <span style={{color: color}}> {diagnostic}</span>
          <Slider id="bmi" value={bmi}
                  onChange={this.onSliderChange.bind(this, "bmi")}
                  min={10} max={50} />
        </div>
      </div>
    );
  }
}
