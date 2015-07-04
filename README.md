# Osprey compiler – in Osprey!

First and foremost, `ospc` is an attempt at rewriting the [Osprey compiler][ospcsharp] in Osprey, which will push the languages quite some distance towards being truly self-hosting.

The secondary goal of `ospc` is to expose APIs for lexing, parsing, analysing and compiling Osprey code without having to invoke a command-line application. Indeed, the APIs will be available for any Osprey program to use. It is imagined that these APIs might be useful in creating a variety of programs that interact with Osprey source code, such as a [REPL][repl], an [IDE][ide], refactoring tools, and more. This is an ambitious undertaking to say the least.

This is very much a work in progress. At the time of writing, only lexing and parsing is implemented, and the unit tests are hideously incomplete (more will come soon, promise!).

## Documentation

All documentation <s>is</s> will be in the wiki. Hence why this readme file ends rather abruptly.

  [ospcsharp]: https://github.com/osprey-lang/osprey "Osprey compiler (in C#)"
  [repl]: https://en.wikipedia.org/wiki/Read–eval–print_loop "Read–eval–print loop"
  [ide]: https://en.wikipedia.org/wiki/Integrated_development_environment "Integrated development environment"
