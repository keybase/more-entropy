more-entropy
=======

The easiest way to generate pseudorandom numbers in the browser is with `window.crypto`, and in NodeJs you can use `crypto.rng`. 
But for the truly paranoid, getting even more entropy is a good idea. For example, one might seed their own key generator with a combination
of `window.crypto` and a series of coordinates collected from mouse movements or key mashes.

Even though the mouse movements of the user are not very random, it's extra noise, adding a layer of safety. Perhaps each [x,y] mouse
location is worth a bit or two of entropy.

By comparison, `more-entropy` is a *userless* generator of some extra noise. It does not require mouse or keyboard input. Instead, 
it generates entropy by counting how many operations it can perform in a unit of time. With really large numbers, the few
least significant bits can be extracted as extra entropy.

### Installation

```bash
npm install -g more-entropy
```

### Usage

```javascript
var m = require('more-entropy');

// create a generator, which can provide you with some entropy
var c = new m.Generator();

// get an array of integers with at least 100 bits of combined entropy:
c.get_entropy(100, function(vals) {
  console.log(vals); // [-4358,543,9089,...]
});

```

### What it's doing

This generator repeatedly does as many floating point operations as it can in 1ms-2ms time periods (typically many thousands), and compares this value to previous attempts.
The delta is then added to a collection with a very conservative estimate for bits of entropy.

Much like the mouse movement technique, we are collecting a lot of data and crediting it for just a little bit of entropy.

### Notes

 * entropy is calculated by changes in performance; for example, if your process could perform exactly the same amount of work in a unit of time, there would be no entropy, regardless of how much work that was.
 * this should work well even if your system is bogged down (it'll just take longer to get entropy)
 * `get_entropy` can be called as many times as you like, even concurrently; it will call back with uniquely calculated data to each request
 * return values are small integers (sometimes < 1000) and may be negative
 * entropy is collected over time, so a request for lots of bits could take a while

### One Big Assumption

 * your CPU is not shared with an attacker; a carefully timed attack on the CPU could produce entropy less than what's requested

### Options

`new m.Generator()` can be called with extra options:

```javascript
var c = new m.Generator({
  'loop_delay':        10 // how many milliseconds to pause between each operation loop. A lower value will generate entropy faster, but will also be harder on the CPU
  'work_min':           1 // millisecnds per loop; a higher value blocks the CPU more, so 1 is recommended
  'auto_stop_bits':  4096 // the generator prepares entropy for you before you request it; if it reaches this much unclaimed entropy it will stop working
  'max_bits_per_delta': 4 // a safety cap on how much entropy it can claim per value; 4 (default) is very conservative. a larger value will allow faster entropy generation
});
```
