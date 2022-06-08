"use strict";

const weights = {
  library: 2,
  class: 2,
  typedef: 3,
  method: 4,
  accessor: 4,
  operator: 4,
  property: 4,
  constructor: 4
};

const score = (result, num) => {
  num -= result.overriddenDepth * 10;
  var weightFactor = weights[result.type] || 4;
  return { e: result, score: (num / weightFactor) >> 0 };
};

module.exports = (q, results) => {
  let allMatches = []; // list of matches

  for (let element of results) {
    // TODO: prefer matches in the current library
    // TODO: help prefer a named constructor
    let lowerName = element.name.toLowerCase();
    let lowerQualifiedName = element.qualifiedName.toLowerCase();
    let lowerQ = q.toLowerCase();
    let previousMatchCount = allMatches.length;

    if (element.name === q || element.qualifiedName === q) {
      // exact match, maximum score
      allMatches.push(score(element, 2000));
    } else if (element.name === "dart:" + q) {
      // exact match for a dart: library
      allMatches.push(score(element, 2000));
    } else if (lowerName === "dart:" + lowerQ) {
      // case-insensitive match for a dart: library
      allMatches.push(score(element, 1800));
    } else if (lowerName === lowerQ || lowerQualifiedName === lowerQ) {
      // case-insensitive exact match
      allMatches.push(score(element, 1700));
    }

    if (
      element.name.indexOf(q) === 0 ||
      element.qualifiedName.indexOf(q) === 0
    ) {
      // starts with
      allMatches.push(score(element, 750));
    } else if (
      lowerName.indexOf(lowerQ) === 0 ||
      lowerQualifiedName.indexOf(lowerQ) === 0
    ) {
      // case-insensitive starts with
      allMatches.push(score(element, 650));
    } else if (
      element.name.indexOf(q) >= 0 ||
      element.qualifiedName.indexOf(q) >= 0
    ) {
      // contains
      allMatches.push(score(element, 500));
    } else if (
      lowerName.indexOf(lowerQ) >= 0 ||
      lowerQualifiedName.indexOf(lowerQ) >= 0
    ) {
      // case insensitive contains
      allMatches.push(score(element, 400));
    }
  }

  allMatches.sort(function(a, b) {
    var x = b.score - a.score;
    if (x === 0) {
      // tie-breaker: shorter name wins
      return a.e.name.length - b.e.name.length;
    } else {
      return x;
    }
  });

  var sortedMatches = [];
  for (var i = 0; i < allMatches.length; i++) {
    sortedMatches.push(allMatches[i].e);
  }

  return sortedMatches;
};
