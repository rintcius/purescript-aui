/* global exports */
"use strict";

function mkSignal(initial) {
  var subs = [];
  var val = initial;
  var sig = {
    subscribe: function(sub) {
      subs.push(sub);
      sub(val);
    },
    get: function() { return val; },
    set: function(newval) {
      val = newval;
      subs.forEach(function(sub) { sub(newval); });
    }
  };
  return sig;
};

exports.mkDatGui = function() {
  return new dat.GUI();
};

function mkVar(label, value) {
  var Var = function() {
    this[label] = value;
  };
  return new Var();
}

function mkMap(map, toString) {
  var Mapping = function() {
    for (var i = 0; i < map.length; i++) {
      var el = map[i];
      this[toString(el)] = i;
    }
  };
  return new Mapping();
}

exports.addSelectToGui = function(label) {
  return function(selected) {
    return function(rest) {
      return function(toString) {
        return function(gui) {
          return function() {
            var all = rest.slice();
            all.unshift(selected);
            var map = mkMap(all, toString);
            var v = mkVar(label, 0);
            var sig = mkSignal(selected);
            var controller = gui.add(v, label, map);
            controller.onChange(function(newValue) {
              sig.set(all[newValue]);
            });
            return sig;
          }
        }
      }
    }
  }
}

exports.addButtonToGui = function(label) {
  return function(up) {
    return function(down) {
      return function(gui) {
        return function() {
          var v = mkVar(label, function() { up });
          var sig = mkSignal(up);
          var controller = gui.add(v, label);
          controller.onChange(function(newValue) {
            sig.set(down);
            // dat.gui doesn't have an event for up - calling directly
            sig.set(up);
          });
          return sig;
        }
      }
    }
  }
}

exports.addIntToGui = function(label) {
  return function(value) {
    return function(min) {
      return function(max) {
        return function(gui) {
          return function() {
            var v = mkVar(label, value);
            var sig = mkSignal(value);
            var controller = gui.add(v, label, min, max, 1);
            controller.onChange(function(newValue) {
              sig.set(newValue);
            });
            return sig;
          }
        }
      }
    }
  }
}

exports.addToGui = function(label) {
  return function(value) {
    return function(gui) {
      return function() {
        var v = mkVar(label, value);
        var sig = mkSignal(value);
        var controller = gui.add(v, label);
        controller.onChange(function(newValue) {
          sig.set(newValue);
        });
        return sig;
      }
    }
  }
}

exports.addOutputToGui = function(label) {
  return function(sig) {
    return function(gui) {
      return function() {
        var v = mkVar(label, sig.get());
        sig.subscribe(function(val) { v[label] = val; });
        var controller = gui.add(v, label).listen();
        controller.onChange(function(newValue) {
          sig.set(newValue);
        });
        return sig;
      }
    }
  }
}
