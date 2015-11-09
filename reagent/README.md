# Body Mass Index calculator, using ClojureScript + Reagent

[ClojureScript](https://github.com/clojure/clojurescript) is a lisp dialect, a
functional language that compiles to Javascript.
[Reagent](https://reagent-project.github.io/) is a ClojureScript wrapper around
[React](https://facebook.github.io/react/).

This version uses the [Tenzling](https://github.com/martinklepsch/tenzing)
template.

First install [leiningen](http://leiningen.org/#install) and
[boot](https://github.com/boot-clj/boot#install), then:

```
git clone https://github.com/magopian/bmi-calculator-polyglot
cd bmi-calculator-polyglot/reagent
boot dev
open http://localhost:3000
```

Modifying the files (`resources/index.html`, `src/cljs/bmi_reagent/app.js`)
will auto-reload them in the browser.


## Bonus

When the files are recompiled, you'll either hear a successful "ding" sound, or
a voice saying "two warnings", or even a failure "bong" sound. You don't even
need to look at the browser or your console to know if/when the files compiled
successfully.
