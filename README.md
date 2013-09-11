entropy
=======

The easiest way to generate entropy in the browser is with `window.crypto`, and in NodeJs with `crypto.rng`. But for
the truly paranoid, these values can be combined with some timing calculations to add extra security.

### Installation

```bash
npm install -g more-entropy
```

### Usage

```javascript
var m = require('more-entropy');
var c = new m.Collector();
c.get_entropy(64, function(vals) {
  console.log(vals); // some small random integers, possibly negative
});
```

### The Basic Idea

```

```
