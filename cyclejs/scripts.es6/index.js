import Cycle from '@cycle/core';
import {h, makeDOMDriver} from '@cycle/dom';
import Rx from 'rx';

function renderSlider(param, value, min, max) {
  return h('input#' + param,
           {type: 'range', min: min, max: max, value: value,
            style: "width: 100%"});
}

function calculateBMI(height, weightWithTimestamp, bmiWithTimestamp) {
  let heightMeters = height * 0.01;
  let {value: bmi, timestamp: bmiTimestamp} = bmiWithTimestamp;
  let {value: weight, timestamp: weightTimestamp} = weightWithTimestamp;
  if (bmiTimestamp > weightTimestamp) {
    weight = Math.round(bmi * heightMeters * heightMeters);
  } else {
    bmi = Math.round(weight / (heightMeters * heightMeters));
  }
  return diagnose({height, weight, bmi});
}

function diagnose(state) {
  if (state.bmi < 18.5) {
    state.diagnostic = "underweight";
    state.color = "orange";
  } else if (state.bmi < 25) {
    state.diagnostic = "normal";
    state.color = "inherit";
  } else if (state.bmi < 30) {
    state.diagnostic = "overweight";
    state.color = "orange";
  } else {
    state.diagnostic = "obese";
    state.color = "red";
  }
  return state;
}

function intent(DOM) { // Interpret DOM events as user’s intended actions.
  return {
    changeHeight$: DOM.select('#height').events('input')
      .map(ev => ev.target.value),
    changeWeight$: DOM.select('#weight').events('input')
      // We need to timestamp the weight and bmi to know which is the one that
      // is being changed (and so the other one needs to be computed from it).
      .map(ev => ev.target.value)
      .timestamp(),
    changeBMI$: DOM.select('#bmi').events('input')
      .map(ev => ev.target.value)
      .timestamp()
  };
}

function model(actions) { // Manage state.
  return Rx.Observable.combineLatest(
    actions.changeHeight$.startWith(180),
    actions.changeWeight$.startWith({value: 80, timestamp: 0}),
    actions.changeBMI$.startWith({value: 0, timestamp: 0}),
    calculateBMI
  );
}

function view(state$) { // Visually represent state from the model.
  return state$.map(({diagnostic, color, height, weight, bmi}) =>
    h('div', [
      h('div', ["Height: " + height + "cm",
                renderSlider('height', height, 140, 210)]),
      h('div', ["Weight: " + weight + "kg",
                renderSlider('weight', weight, 40, 140)]),
      h('div', ["BMI: " + bmi,
                h('span', {style: "color: " + color}, [" " + diagnostic]),
                renderSlider('bmi', bmi, 10, 50)])]
    )
  );
}

function main({DOM}) {
  return { DOM: view(model(intent(DOM))) };
}

Cycle.run(main, {
  DOM: makeDOMDriver('#app')
});
